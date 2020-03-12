//===-- AMDGPUConditionalDiscard.cpp
//-----------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Modifications Copyright (c) 2020 Advanced Micro Devices, Inc. All rights reserved.
// Notified per clause 4(b) of the license.
//
//===----------------------------------------------------------------------===//
//
/// \file
/// This pass transforms conditional discard of the form:
///
///     if (condition)
///       discard (false);
///
/// into:
///
///     discard (!condition);
///
///
/// More specifically,
///
/// ...
/// block:
///   %cond = icmp eq i32 %a, %b
///   br i1 %cond, label %kill_block, label %cont_block
///
/// kill_block:
///   call void @llvm.amdgcn.kill(i1 false)
///   br label %other
/// ...
///
/// gets transformed into:
///
/// ...
/// block:
///   %cond = icmp eq i32 %a, %b
///   %nonkill = not i1 %cond
///   call void @llvm.amdgcn.kill(i1 %nonkill)
///   br label %cont_block
/// ...
///
/// The transformation is useful, because removing basic blocks simplifies CFG
/// and limits the number of phi nodes used.
/// The pass should ideally be placed after code sinking, because some sinking
/// opportunities get lost after the transformation due to the basic block
/// removal.
///
/// Additionally this pass can be used to transform kill intrinsics optimized
/// as above to demote operations.
/// This provides a workaround for applications which perform a non-uniform
/// "kill" and later compute (implicit) derivatives.
/// Note that in Vulkan, such applications should be fixed to use demote
/// (OpDemoteToHelperInvocationEXT) instead of kill (OpKill).
///

#include "AMDGPU.h"
#include "AMDGPUSubtarget.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InstVisitor.h"
#include "llvm/InitializePasses.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"

#define DEBUG_TYPE "amdgpu-conditional-discard"

using namespace llvm;
using namespace llvm::AMDGPU;

// Enable conditional discard to demote transformations
static cl::opt<bool> EnableTransformDiscardToDemote(
  "amdgpu-transform-discard-to-demote",
  cl::desc("Enable transformation of optimized discards to demotes"),
  cl::init(false),
  cl::Hidden);

namespace {

class AMDGPUConditionalDiscard : public FunctionPass {
private:
  SmallVector<BasicBlock *, 4> KillBlocksToRemove;

  const LoopInfo *LI;

public:
  static char ID;

  AMDGPUConditionalDiscard() : FunctionPass(ID) {}

  bool runOnFunction(Function &F) override;

  void getAnalysisUsage(AnalysisUsage &AU) const override {
     AU.addRequiredTransitive<LoopInfoWrapperPass>();
  }

  StringRef getPassName() const override { return "AMDGPUConditionalDiscard"; }

  void optimizeBlock(BasicBlock &BB, bool ConvertToDemote);
};

} // namespace

char AMDGPUConditionalDiscard::ID = 0;

char &llvm::AMDGPUConditionalDiscardID = AMDGPUConditionalDiscard::ID;

// Look for a basic block that has only a single predecessor and its
// first instruction is a call to amdgcn_kill, with "false" as argument.
// Transform the branch condition of the block's predecessor and mark
// the block for removal. Clone the call to amdgcn_kill to the predecessor.
void AMDGPUConditionalDiscard::optimizeBlock(BasicBlock &BB, bool ConvertToDemote) {

  if (auto *KillCand = dyn_cast<CallInst>(&BB.front())) {
    auto *Callee = KillCand->getCalledFunction();
    if (!Callee || Callee->getIntrinsicID() != Intrinsic::amdgcn_kill) {
      return;
    }

    ConstantInt *Val = dyn_cast<ConstantInt>(KillCand->getOperand(0));
    if (!Val || !Val->isZero())
      return;

    auto *PredBlock = BB.getSinglePredecessor();
    if (!PredBlock)
      return;

    // Skip if the kill is in a loop.
    if (LI->getLoopFor(PredBlock)) {
      LLVM_DEBUG(dbgs() << "Cannot optimize " << BB.getName() << " due to loop\n");
      return;
    }

    auto *PredTerminator = PredBlock->getTerminator();
    auto *PredBranchInst = dyn_cast<BranchInst>(PredTerminator);

    if (!PredBranchInst || !PredBranchInst->isConditional())
      return;

    BasicBlock *LiveBlock = nullptr;
    auto *Cond = PredBranchInst->getCondition();

    if (PredBranchInst->getSuccessor(0) == &BB) {
      // The old kill block could only be reached if
      // the condition was true - negate the condition.
      Cond = BinaryOperator::CreateNot(Cond, "", PredTerminator);
      LiveBlock = PredBranchInst->getSuccessor(1);
    } else {
      LiveBlock = PredBranchInst->getSuccessor(0);
    }

    auto *NewKill = cast<CallInst>(KillCand->clone());

    if (ConvertToDemote) {
      NewKill->setCalledFunction(Intrinsic::getDeclaration(
          KillCand->getModule(), Intrinsic::amdgcn_wqm_demote));
    }

    NewKill->setArgOperand(0, Cond);
    NewKill->insertBefore(PredTerminator);

    KillBlocksToRemove.push_back(&BB);

    // Change the branch to an unconditional one, targeting the live block.
    auto *NewBranchInst = BranchInst::Create(LiveBlock, PredBranchInst);
    NewBranchInst->copyMetadata(*PredBranchInst);
    PredBranchInst->eraseFromParent();
  }
}

bool AMDGPUConditionalDiscard::runOnFunction(Function &F) {
  if (F.getCallingConv() != CallingConv::AMDGPU_PS)
    return false;

  if (skipFunction(F)) {
    return false;
  }

  LI = &getAnalysis<LoopInfoWrapperPass>().getLoopInfo();

  for (auto &BB : F)
    optimizeBlock(BB, EnableTransformDiscardToDemote);

  for (auto *BB : KillBlocksToRemove) {
    for (auto *Succ : successors(BB)) {
      for (PHINode &PN : Succ->phis())
        PN.removeIncomingValue(BB);
    }
    BB->eraseFromParent();
  }
  bool Ret = !KillBlocksToRemove.empty();
  KillBlocksToRemove.clear();

  return Ret;
}

INITIALIZE_PASS_BEGIN(AMDGPUConditionalDiscard, DEBUG_TYPE,
                "AMDGPUConditionalDiscard", false, false)
INITIALIZE_PASS_DEPENDENCY(LoopInfoWrapperPass)
INITIALIZE_PASS_END(AMDGPUConditionalDiscard, DEBUG_TYPE,
                "AMDGPUConditionalDiscard", false, false)

FunctionPass *llvm::createAMDGPUConditionalDiscardPass() {
  return new AMDGPUConditionalDiscard();
}
