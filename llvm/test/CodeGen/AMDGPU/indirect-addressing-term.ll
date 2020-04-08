; Modifications Copyright (c) 2020 Advanced Micro Devices, Inc. All rights reserved.
; Notified per clause 4(b) of the license.
; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -O0 -amdgpu-scalarize-global-loads=false -march=amdgcn -mcpu=gfx900 -mattr=-flat-for-global -verify-machineinstrs -stop-after=regallocfast < %s | FileCheck -check-prefixes=GCN %s

; Verify that we consider the xor at the end of the waterfall loop emitted for
; divergent indirect addressing as a terminator.

declare i32 @llvm.amdgcn.workitem.id.x() #1

; There should be no spill code inserted between the xor and the real terminator
define amdgpu_kernel void @extract_w_offset_vgpr(i32 addrspace(1)* %out) {
  ; GCN-LABEL: name: extract_w_offset_vgpr
  ; GCN: bb.0.entry:
  ; GCN:   successors: %bb.1(0x80000000)
  ; GCN:   liveins: $vgpr0, $sgpr0_sgpr1
  ; GCN:   renamable $sgpr0_sgpr1 = S_LOAD_DWORDX2_IMM killed renamable $sgpr0_sgpr1, 36, 0, 0 :: (dereferenceable invariant load 8 from %ir.out.kernarg.offset.cast, align 4, addrspace 4)
  ; GCN:   renamable $sgpr2 = COPY renamable $sgpr1
  ; GCN:   renamable $sgpr0 = COPY renamable $sgpr0, implicit killed $sgpr0_sgpr1
  ; GCN:   renamable $sgpr1 = S_MOV_B32 61440
  ; GCN:   renamable $sgpr4 = S_MOV_B32 -1
  ; GCN:   undef renamable $sgpr8 = COPY killed renamable $sgpr0, implicit-def $sgpr8_sgpr9_sgpr10_sgpr11
  ; GCN:   renamable $sgpr9 = COPY killed renamable $sgpr2
  ; GCN:   renamable $sgpr10 = COPY killed renamable $sgpr4
  ; GCN:   renamable $sgpr11 = COPY killed renamable $sgpr1
  ; GCN:   renamable $sgpr0 = S_MOV_B32 16
  ; GCN:   renamable $sgpr1 = S_MOV_B32 15
  ; GCN:   renamable $sgpr2 = S_MOV_B32 14
  ; GCN:   renamable $sgpr4 = S_MOV_B32 13
  ; GCN:   renamable $sgpr5 = S_MOV_B32 12
  ; GCN:   renamable $sgpr6 = S_MOV_B32 11
  ; GCN:   renamable $sgpr7 = S_MOV_B32 10
  ; GCN:   renamable $sgpr12 = S_MOV_B32 9
  ; GCN:   renamable $sgpr13 = S_MOV_B32 8
  ; GCN:   renamable $sgpr14 = S_MOV_B32 7
  ; GCN:   renamable $sgpr15 = S_MOV_B32 6
  ; GCN:   renamable $sgpr16 = S_MOV_B32 5
  ; GCN:   renamable $sgpr17 = S_MOV_B32 3
  ; GCN:   renamable $sgpr18 = S_MOV_B32 2
  ; GCN:   renamable $sgpr19 = S_MOV_B32 1
  ; GCN:   renamable $sgpr20 = S_MOV_B32 0
  ; GCN:   renamable $vgpr1 = COPY killed renamable $sgpr20
  ; GCN:   renamable $vgpr2 = COPY killed renamable $sgpr19
  ; GCN:   renamable $vgpr3 = COPY killed renamable $sgpr18
  ; GCN:   renamable $vgpr4 = COPY killed renamable $sgpr17
  ; GCN:   renamable $vgpr5 = COPY killed renamable $sgpr16
  ; GCN:   renamable $vgpr6 = COPY killed renamable $sgpr15
  ; GCN:   renamable $vgpr7 = COPY killed renamable $sgpr14
  ; GCN:   renamable $vgpr8 = COPY killed renamable $sgpr13
  ; GCN:   renamable $vgpr9 = COPY killed renamable $sgpr12
  ; GCN:   renamable $vgpr10 = COPY killed renamable $sgpr7
  ; GCN:   renamable $vgpr11 = COPY killed renamable $sgpr6
  ; GCN:   renamable $vgpr12 = COPY killed renamable $sgpr5
  ; GCN:   renamable $vgpr13 = COPY killed renamable $sgpr4
  ; GCN:   renamable $vgpr14 = COPY killed renamable $sgpr2
  ; GCN:   renamable $vgpr15 = COPY killed renamable $sgpr1
  ; GCN:   renamable $vgpr16 = COPY killed renamable $sgpr0
  ; GCN:   undef renamable $vgpr17 = COPY killed renamable $vgpr1, implicit-def $vgpr17_vgpr18_vgpr19_vgpr20_vgpr21_vgpr22_vgpr23_vgpr24_vgpr25_vgpr26_vgpr27_vgpr28_vgpr29_vgpr30_vgpr31_vgpr32
  ; GCN:   renamable $vgpr18 = COPY killed renamable $vgpr2
  ; GCN:   renamable $vgpr19 = COPY killed renamable $vgpr3
  ; GCN:   renamable $vgpr20 = COPY killed renamable $vgpr4
  ; GCN:   renamable $vgpr21 = COPY killed renamable $vgpr5
  ; GCN:   renamable $vgpr22 = COPY killed renamable $vgpr6
  ; GCN:   renamable $vgpr23 = COPY killed renamable $vgpr7
  ; GCN:   renamable $vgpr24 = COPY killed renamable $vgpr8
  ; GCN:   renamable $vgpr25 = COPY killed renamable $vgpr9
  ; GCN:   renamable $vgpr26 = COPY killed renamable $vgpr10
  ; GCN:   renamable $vgpr27 = COPY killed renamable $vgpr11
  ; GCN:   renamable $vgpr28 = COPY killed renamable $vgpr12
  ; GCN:   renamable $vgpr29 = COPY killed renamable $vgpr13
  ; GCN:   renamable $vgpr30 = COPY killed renamable $vgpr14
  ; GCN:   renamable $vgpr31 = COPY killed renamable $vgpr15
  ; GCN:   renamable $vgpr32 = COPY killed renamable $vgpr16
  ; GCN:   renamable $sgpr22_sgpr23 = S_MOV_B64 $exec
  ; GCN:   renamable $vgpr1 = IMPLICIT_DEF
  ; GCN:   renamable $sgpr24_sgpr25 = IMPLICIT_DEF
  ; GCN:   SI_SPILL_V32_SAVE killed $vgpr0, %stack.0, $sgpr96_sgpr97_sgpr98_sgpr99, $sgpr3, 0, implicit $exec :: (store 4 into %stack.0, addrspace 5)
  ; GCN:   SI_SPILL_S128_SAVE killed $sgpr8_sgpr9_sgpr10_sgpr11, %stack.1, implicit $exec, implicit $sgpr96_sgpr97_sgpr98_sgpr99, implicit $sgpr3 :: (store 16 into %stack.1, align 4, addrspace 5)
  ; GCN:   SI_SPILL_V512_SAVE killed $vgpr17_vgpr18_vgpr19_vgpr20_vgpr21_vgpr22_vgpr23_vgpr24_vgpr25_vgpr26_vgpr27_vgpr28_vgpr29_vgpr30_vgpr31_vgpr32, %stack.2, $sgpr96_sgpr97_sgpr98_sgpr99, $sgpr3, 0, implicit $exec :: (store 64 into %stack.2, align 4, addrspace 5)
  ; GCN:   SI_SPILL_S64_SAVE killed $sgpr22_sgpr23, %stack.3, implicit $exec, implicit $sgpr96_sgpr97_sgpr98_sgpr99, implicit $sgpr3 :: (store 8 into %stack.3, align 4, addrspace 5)
  ; GCN:   SI_SPILL_V32_SAVE killed $vgpr1, %stack.4, $sgpr96_sgpr97_sgpr98_sgpr99, $sgpr3, 0, implicit $exec :: (store 4 into %stack.4, addrspace 5)
  ; GCN:   SI_SPILL_S64_SAVE killed $sgpr24_sgpr25, %stack.5, implicit $exec, implicit $sgpr96_sgpr97_sgpr98_sgpr99, implicit $sgpr3 :: (store 8 into %stack.5, align 4, addrspace 5)
  ; GCN: bb.1:
  ; GCN:   successors: %bb.1(0x40000000), %bb.3(0x40000000)
  ; GCN:   $sgpr0_sgpr1 = SI_SPILL_S64_RESTORE %stack.5, implicit $exec, implicit $sgpr96_sgpr97_sgpr98_sgpr99, implicit $sgpr3 :: (load 8 from %stack.5, align 4, addrspace 5)
  ; GCN:   $vgpr0 = SI_SPILL_V32_RESTORE %stack.4, $sgpr96_sgpr97_sgpr98_sgpr99, $sgpr3, 0, implicit $exec :: (load 4 from %stack.4, addrspace 5)
  ; GCN:   $vgpr1 = SI_SPILL_V32_RESTORE %stack.0, $sgpr96_sgpr97_sgpr98_sgpr99, $sgpr3, 0, implicit $exec :: (load 4 from %stack.0, addrspace 5)
  ; GCN:   renamable $sgpr2 = V_READFIRSTLANE_B32 $vgpr1, implicit $exec
  ; GCN:   renamable $sgpr4_sgpr5 = V_CMP_EQ_U32_e64 $sgpr2, killed $vgpr1, implicit $exec
  ; GCN:   renamable $sgpr4_sgpr5 = S_AND_SAVEEXEC_B64 killed renamable $sgpr4_sgpr5, implicit-def $exec, implicit-def $scc, implicit $exec
  ; GCN:   S_SET_GPR_IDX_ON killed renamable $sgpr2, 1, implicit-def $m0, implicit undef $m0
  ; GCN:   $vgpr2_vgpr3_vgpr4_vgpr5_vgpr6_vgpr7_vgpr8_vgpr9_vgpr10_vgpr11_vgpr12_vgpr13_vgpr14_vgpr15_vgpr16_vgpr17 = SI_SPILL_V512_RESTORE %stack.2, $sgpr96_sgpr97_sgpr98_sgpr99, $sgpr3, 0, implicit $exec :: (load 64 from %stack.2, align 4, addrspace 5)
  ; GCN:   renamable $vgpr18 = V_MOV_B32_e32 undef $vgpr3, implicit $exec, implicit killed $vgpr2_vgpr3_vgpr4_vgpr5_vgpr6_vgpr7_vgpr8_vgpr9_vgpr10_vgpr11_vgpr12_vgpr13_vgpr14_vgpr15_vgpr16_vgpr17, implicit $m0
  ; GCN:   S_SET_GPR_IDX_OFF
  ; GCN:   renamable $vgpr19 = COPY renamable $vgpr18
  ; GCN:   renamable $sgpr6_sgpr7 = COPY renamable $sgpr4_sgpr5
  ; GCN:   SI_SPILL_S64_SAVE killed $sgpr6_sgpr7, %stack.5, implicit $exec, implicit $sgpr96_sgpr97_sgpr98_sgpr99, implicit $sgpr3 :: (store 8 into %stack.5, align 4, addrspace 5)
  ; GCN:   SI_SPILL_S64_SAVE killed $sgpr0_sgpr1, %stack.6, implicit $exec, implicit $sgpr96_sgpr97_sgpr98_sgpr99, implicit $sgpr3 :: (store 8 into %stack.6, align 4, addrspace 5)
  ; GCN:   SI_SPILL_V32_SAVE killed $vgpr19, %stack.4, $sgpr96_sgpr97_sgpr98_sgpr99, $sgpr3, 0, implicit $exec :: (store 4 into %stack.4, addrspace 5)
  ; GCN:   SI_SPILL_V32_SAVE killed $vgpr0, %stack.7, $sgpr96_sgpr97_sgpr98_sgpr99, $sgpr3, 0, implicit $exec :: (store 4 into %stack.7, addrspace 5)
  ; GCN:   SI_SPILL_V32_SAVE killed $vgpr18, %stack.8, $sgpr96_sgpr97_sgpr98_sgpr99, $sgpr3, 0, implicit $exec :: (store 4 into %stack.8, addrspace 5)
  ; GCN:   $exec = S_XOR_B64_term $exec, killed renamable $sgpr4_sgpr5, implicit-def $scc
  ; GCN:   S_CBRANCH_EXECNZ %bb.1, implicit $exec
  ; GCN: bb.3:
  ; GCN:   successors: %bb.2(0x80000000)
  ; GCN:   $sgpr0_sgpr1 = SI_SPILL_S64_RESTORE %stack.3, implicit $exec, implicit $sgpr96_sgpr97_sgpr98_sgpr99, implicit $sgpr3 :: (load 8 from %stack.3, align 4, addrspace 5)
  ; GCN:   $exec = S_MOV_B64 killed renamable $sgpr0_sgpr1
  ; GCN: bb.2:
  ; GCN:   $vgpr0 = SI_SPILL_V32_RESTORE %stack.8, $sgpr96_sgpr97_sgpr98_sgpr99, $sgpr3, 0, implicit $exec :: (load 4 from %stack.8, addrspace 5)
  ; GCN:   $sgpr4_sgpr5_sgpr6_sgpr7 = SI_SPILL_S128_RESTORE %stack.1, implicit $exec, implicit $sgpr96_sgpr97_sgpr98_sgpr99, implicit $sgpr3 :: (load 16 from %stack.1, align 4, addrspace 5)
  ; GCN:   BUFFER_STORE_DWORD_OFFSET renamable $vgpr0, renamable $sgpr4_sgpr5_sgpr6_sgpr7, 0, 0, 0, 0, 0, 0, 0, implicit $exec :: (store 4 into %ir.out.load, addrspace 1)
  ; GCN:   S_ENDPGM 0
entry:
  %id = call i32 @llvm.amdgcn.workitem.id.x() #1
  %index = add i32 %id, 1
  %value = extractelement <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16>, i32 %index
  store i32 %value, i32 addrspace(1)* %out
  ret void
}
