; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp -verify-machineinstrs -tail-predication=enabled -o - %s | FileCheck %s

define arm_aapcs_vfpcc void @arm_var_f32_mve(float* %pSrc, i32 %blockSize, float* nocapture %pResult) {
; CHECK-LABEL: arm_var_f32_mve:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    mov r3, r1
; CHECK-NEXT:    cmp r1, #4
; CHECK-NEXT:    it ge
; CHECK-NEXT:    movge r3, #4
; CHECK-NEXT:    mov.w r12, #1
; CHECK-NEXT:    subs r3, r1, r3
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    adds r3, #3
; CHECK-NEXT:    add.w lr, r12, r3, lsr #2
; CHECK-NEXT:    mov r3, r1
; CHECK-NEXT:    mov r12, r0
; CHECK-NEXT:    mov r4, lr
; CHECK-NEXT:    dlstp.32 lr, r3
; CHECK-NEXT:  .LBB0_1: @ %do.body.i
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q1, [r12], #16
; CHECK-NEXT:    vadd.f32 q0, q0, q1
; CHECK-NEXT:    letp lr, .LBB0_1
; CHECK-NEXT:  @ %bb.2: @ %arm_mean_f32_mve.exit
; CHECK-NEXT:    vmov s4, r1
; CHECK-NEXT:    vadd.f32 s0, s3, s3
; CHECK-NEXT:    mov r3, r1
; CHECK-NEXT:    vcvt.f32.u32 s4, s4
; CHECK-NEXT:    dls lr, r4
; CHECK-NEXT:    vdiv.f32 s0, s0, s4
; CHECK-NEXT:    vmov r12, s0
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:  .LBB0_3: @ %do.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vctp.32 r3
; CHECK-NEXT:    subs r3, #4
; CHECK-NEXT:    vpsttt
; CHECK-NEXT:    vldrwt.u32 q1, [r0], #16
; CHECK-NEXT:    vsubt.f32 q1, q1, r12
; CHECK-NEXT:    vfmat.f32 q0, q1, q1
; CHECK-NEXT:    le lr, .LBB0_3
; CHECK-NEXT:  @ %bb.4: @ %do.end
; CHECK-NEXT:    subs r0, r1, #1
; CHECK-NEXT:    vadd.f32 s0, s3, s3
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vcvt.f32.u32 s2, s2
; CHECK-NEXT:    vdiv.f32 s0, s0, s2
; CHECK-NEXT:    vstr s0, [r2]
; CHECK-NEXT:    pop {r4, pc}
entry:
  br label %do.body.i

do.body.i:                                        ; preds = %entry, %do.body.i
  %blkCnt.0.i = phi i32 [ %sub.i, %do.body.i ], [ %blockSize, %entry ]
  %sumVec.0.i = phi <4 x float> [ %3, %do.body.i ], [ zeroinitializer, %entry ]
  %pSrc.addr.0.i = phi float* [ %add.ptr.i, %do.body.i ], [ %pSrc, %entry ]
  %0 = tail call <4 x i1> @llvm.arm.mve.vctp32(i32 %blkCnt.0.i)
  %1 = bitcast float* %pSrc.addr.0.i to <4 x float>*
  %2 = tail call fast <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %1, i32 4, <4 x i1> %0, <4 x float> zeroinitializer)
  %3 = tail call fast <4 x float> @llvm.arm.mve.add.predicated.v4f32.v4i1(<4 x float> %sumVec.0.i, <4 x float> %2, <4 x i1> %0, <4 x float> %sumVec.0.i)
  %sub.i = add nsw i32 %blkCnt.0.i, -4
  %add.ptr.i = getelementptr inbounds float, float* %pSrc.addr.0.i, i32 4
  %cmp.i = icmp sgt i32 %blkCnt.0.i, 4
  br i1 %cmp.i, label %do.body.i, label %arm_mean_f32_mve.exit

arm_mean_f32_mve.exit:                            ; preds = %do.body.i
  %4 = extractelement <4 x float> %3, i32 3
  %add2.i.i = fadd fast float %4, %4
  %conv.i = uitofp i32 %blockSize to float
  %div.i = fdiv fast float %add2.i.i, %conv.i
  %.splatinsert = insertelement <4 x float> undef, float %div.i, i32 0
  %.splat = shufflevector <4 x float> %.splatinsert, <4 x float> undef, <4 x i32> zeroinitializer
  br label %do.body

do.body:                                          ; preds = %do.body, %arm_mean_f32_mve.exit
  %blkCnt.0 = phi i32 [ %blockSize, %arm_mean_f32_mve.exit ], [ %sub, %do.body ]
  %sumVec.0 = phi <4 x float> [ zeroinitializer, %arm_mean_f32_mve.exit ], [ %9, %do.body ]
  %pSrc.addr.0 = phi float* [ %pSrc, %arm_mean_f32_mve.exit ], [ %add.ptr, %do.body ]
  %5 = tail call <4 x i1> @llvm.arm.mve.vctp32(i32 %blkCnt.0)
  %6 = bitcast float* %pSrc.addr.0 to <4 x float>*
  %7 = tail call fast <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %6, i32 4, <4 x i1> %5, <4 x float> zeroinitializer)
  %8 = tail call fast <4 x float> @llvm.arm.mve.sub.predicated.v4f32.v4i1(<4 x float> %7, <4 x float> %.splat, <4 x i1> %5, <4 x float> undef)
  %9 = tail call fast <4 x float> @llvm.arm.mve.fma.predicated.v4f32.v4i1(<4 x float> %8, <4 x float> %8, <4 x float> %sumVec.0, <4 x i1> %5)
  %sub = add nsw i32 %blkCnt.0, -4
  %add.ptr = getelementptr inbounds float, float* %pSrc.addr.0, i32 4
  %cmp1 = icmp sgt i32 %blkCnt.0, 4
  br i1 %cmp1, label %do.body, label %do.end

do.end:                                           ; preds = %do.body
  %10 = extractelement <4 x float> %9, i32 3
  %add2.i = fadd fast float %10, %10
  %sub2 = add i32 %blockSize, -1
  %conv = uitofp i32 %sub2 to float
  %div = fdiv fast float %add2.i, %conv
  br label %cleanup

cleanup:                                          ; preds = %entry, %do.end
  store float %div, float* %pResult, align 4
  ret void
}

declare <4 x float> @llvm.arm.mve.sub.predicated.v4f32.v4i1(<4 x float>, <4 x float>, <4 x i1>, <4 x float>)

declare <4 x float> @llvm.arm.mve.fma.predicated.v4f32.v4i1(<4 x float>, <4 x float>, <4 x float>, <4 x i1>)

declare <4 x i1> @llvm.arm.mve.vctp32(i32)

declare <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>*, i32 immarg, <4 x i1>, <4 x float>)

declare <4 x float> @llvm.arm.mve.add.predicated.v4f32.v4i1(<4 x float>, <4 x float>, <4 x i1>, <4 x float>)

