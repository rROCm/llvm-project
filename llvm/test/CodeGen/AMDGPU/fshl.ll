; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -march=amdgcn -mcpu=tahiti -verify-machineinstrs | FileCheck %s -check-prefixes=GCN,GFX89,SI
; RUN: llc < %s -march=amdgcn -mcpu=tonga  -verify-machineinstrs | FileCheck %s -check-prefixes=GCN,GFX89,VI
; RUN: llc < %s -march=amdgcn -mcpu=gfx900 -verify-machineinstrs | FileCheck %s -check-prefixes=GCN,GFX89,GFX9
; RUN: llc < %s -march=r600 -mcpu=redwood  -verify-machineinstrs | FileCheck %s -check-prefixes=GCN,R600

declare i32 @llvm.fshl.i32(i32, i32, i32) nounwind readnone
declare <2 x i32> @llvm.fshl.v2i32(<2 x i32>, <2 x i32>, <2 x i32>) nounwind readnone
declare <4 x i32> @llvm.fshl.v4i32(<4 x i32>, <4 x i32>, <4 x i32>) nounwind readnone

define amdgpu_kernel void @fshl_i32(i32 addrspace(1)* %in, i32 %x, i32 %y, i32 %z) {
; SI-LABEL: fshl_i32:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0xb
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_and_b32 s2, s2, 31
; SI-NEXT:    s_sub_i32 s8, 32, s2
; SI-NEXT:    s_lshl_b32 s3, s0, s2
; SI-NEXT:    s_lshr_b32 s1, s1, s8
; SI-NEXT:    s_or_b32 s1, s3, s1
; SI-NEXT:    v_mov_b32_e32 v0, s1
; SI-NEXT:    v_mov_b32_e32 v1, s0
; SI-NEXT:    v_cmp_eq_u32_e64 vcc, s2, 0
; SI-NEXT:    v_cndmask_b32_e32 v0, v0, v1, vcc
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fshl_i32:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x2c
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_and_b32 s2, s2, 31
; VI-NEXT:    s_sub_i32 s3, 32, s2
; VI-NEXT:    v_mov_b32_e32 v0, s0
; VI-NEXT:    s_lshl_b32 s0, s0, s2
; VI-NEXT:    s_lshr_b32 s1, s1, s3
; VI-NEXT:    s_or_b32 s0, s0, s1
; VI-NEXT:    v_mov_b32_e32 v1, s0
; VI-NEXT:    v_cmp_eq_u32_e64 vcc, s2, 0
; VI-NEXT:    v_cndmask_b32_e32 v2, v1, v0, vcc
; VI-NEXT:    v_mov_b32_e32 v0, s4
; VI-NEXT:    v_mov_b32_e32 v1, s5
; VI-NEXT:    flat_store_dword v[0:1], v2
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: fshl_i32:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x2c
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_and_b32 s2, s2, 31
; GFX9-NEXT:    s_sub_i32 s3, 32, s2
; GFX9-NEXT:    v_mov_b32_e32 v0, s0
; GFX9-NEXT:    s_lshl_b32 s0, s0, s2
; GFX9-NEXT:    s_lshr_b32 s1, s1, s3
; GFX9-NEXT:    s_or_b32 s0, s0, s1
; GFX9-NEXT:    v_mov_b32_e32 v1, s0
; GFX9-NEXT:    v_cmp_eq_u32_e64 vcc, s2, 0
; GFX9-NEXT:    v_cndmask_b32_e32 v2, v1, v0, vcc
; GFX9-NEXT:    v_mov_b32_e32 v0, s4
; GFX9-NEXT:    v_mov_b32_e32 v1, s5
; GFX9-NEXT:    global_store_dword v[0:1], v2, off
; GFX9-NEXT:    s_endpgm
;
; R600-LABEL: fshl_i32:
; R600:       ; %bb.0: ; %entry
; R600-NEXT:    ALU 9, @4, KC0[CB0:0-32], KC1[]
; R600-NEXT:    MEM_RAT_CACHELESS STORE_RAW T0.X, T1.X, 1
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
; R600-NEXT:    ALU clause starting at 4:
; R600-NEXT:     AND_INT * T0.W, KC0[3].X, literal.x,
; R600-NEXT:    31(4.344025e-44), 0(0.000000e+00)
; R600-NEXT:     SUB_INT * T1.W, literal.x, PV.W,
; R600-NEXT:    32(4.484155e-44), 0(0.000000e+00)
; R600-NEXT:     LSHR T1.W, KC0[2].W, PV.W,
; R600-NEXT:     LSHL * T2.W, KC0[2].Z, T0.W,
; R600-NEXT:     OR_INT * T1.W, PS, PV.W,
; R600-NEXT:     CNDE_INT T0.X, T0.W, KC0[2].Z, PV.W,
; R600-NEXT:     LSHR * T1.X, KC0[2].Y, literal.x,
; R600-NEXT:    2(2.802597e-45), 0(0.000000e+00)
entry:
  %0 = call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 %z)
  store i32 %0, i32 addrspace(1)* %in
  ret void
}

define amdgpu_kernel void @fshl_i32_imm(i32 addrspace(1)* %in, i32 %x, i32 %y) {
; SI-LABEL: fshl_i32_imm:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xb
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_mov_b32_e32 v0, s1
; SI-NEXT:    v_alignbit_b32 v0, s0, v0, 25
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fshl_i32_imm:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v0, s1
; VI-NEXT:    v_alignbit_b32 v2, s0, v0, 25
; VI-NEXT:    v_mov_b32_e32 v0, s2
; VI-NEXT:    v_mov_b32_e32 v1, s3
; VI-NEXT:    flat_store_dword v[0:1], v2
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: fshl_i32_imm:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; GFX9-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, s1
; GFX9-NEXT:    v_alignbit_b32 v2, s0, v0, 25
; GFX9-NEXT:    v_mov_b32_e32 v0, s2
; GFX9-NEXT:    v_mov_b32_e32 v1, s3
; GFX9-NEXT:    global_store_dword v[0:1], v2, off
; GFX9-NEXT:    s_endpgm
;
; R600-LABEL: fshl_i32_imm:
; R600:       ; %bb.0: ; %entry
; R600-NEXT:    ALU 3, @4, KC0[CB0:0-32], KC1[]
; R600-NEXT:    MEM_RAT_CACHELESS STORE_RAW T1.X, T0.X, 1
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
; R600-NEXT:    ALU clause starting at 4:
; R600-NEXT:     LSHR * T0.X, KC0[2].Y, literal.x,
; R600-NEXT:    2(2.802597e-45), 0(0.000000e+00)
; R600-NEXT:     BIT_ALIGN_INT * T1.X, KC0[2].Z, KC0[2].W, literal.x,
; R600-NEXT:    25(3.503246e-44), 0(0.000000e+00)
entry:
  %0 = call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 7)
  store i32 %0, i32 addrspace(1)* %in
  ret void
}

define amdgpu_kernel void @fshl_v2i32(<2 x i32> addrspace(1)* %in, <2 x i32> %x, <2 x i32> %y, <2 x i32> %z) {
; SI-LABEL: fshl_v2i32:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0xb
; SI-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0xd
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xf
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_mov_b32_e32 v1, s3
; SI-NEXT:    v_mov_b32_e32 v2, s2
; SI-NEXT:    s_and_b32 s1, s1, 31
; SI-NEXT:    s_sub_i32 s11, 32, s1
; SI-NEXT:    s_and_b32 s0, s0, 31
; SI-NEXT:    s_lshl_b32 s10, s3, s1
; SI-NEXT:    s_lshr_b32 s9, s9, s11
; SI-NEXT:    s_sub_i32 s3, 32, s0
; SI-NEXT:    s_or_b32 s9, s10, s9
; SI-NEXT:    v_cmp_eq_u32_e64 vcc, s1, 0
; SI-NEXT:    s_lshl_b32 s1, s2, s0
; SI-NEXT:    s_lshr_b32 s3, s8, s3
; SI-NEXT:    v_mov_b32_e32 v0, s9
; SI-NEXT:    s_or_b32 s1, s1, s3
; SI-NEXT:    v_cndmask_b32_e32 v1, v0, v1, vcc
; SI-NEXT:    v_mov_b32_e32 v0, s1
; SI-NEXT:    v_cmp_eq_u32_e64 vcc, s0, 0
; SI-NEXT:    v_cndmask_b32_e32 v0, v0, v2, vcc
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fshl_v2i32:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x2c
; VI-NEXT:    s_load_dwordx2 s[6:7], s[0:1], 0x34
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x3c
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s5
; VI-NEXT:    v_mov_b32_e32 v2, s4
; VI-NEXT:    s_and_b32 s1, s1, 31
; VI-NEXT:    s_sub_i32 s9, 32, s1
; VI-NEXT:    s_and_b32 s0, s0, 31
; VI-NEXT:    s_lshl_b32 s8, s5, s1
; VI-NEXT:    s_lshr_b32 s7, s7, s9
; VI-NEXT:    s_sub_i32 s5, 32, s0
; VI-NEXT:    s_or_b32 s7, s8, s7
; VI-NEXT:    v_cmp_eq_u32_e64 vcc, s1, 0
; VI-NEXT:    s_lshl_b32 s1, s4, s0
; VI-NEXT:    s_lshr_b32 s5, s6, s5
; VI-NEXT:    v_mov_b32_e32 v0, s7
; VI-NEXT:    s_or_b32 s1, s1, s5
; VI-NEXT:    v_cndmask_b32_e32 v1, v0, v1, vcc
; VI-NEXT:    v_mov_b32_e32 v0, s1
; VI-NEXT:    v_cmp_eq_u32_e64 vcc, s0, 0
; VI-NEXT:    v_cndmask_b32_e32 v0, v0, v2, vcc
; VI-NEXT:    v_mov_b32_e32 v2, s2
; VI-NEXT:    v_mov_b32_e32 v3, s3
; VI-NEXT:    flat_store_dwordx2 v[2:3], v[0:1]
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: fshl_v2i32:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; GFX9-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x2c
; GFX9-NEXT:    s_load_dwordx2 s[6:7], s[0:1], 0x34
; GFX9-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x3c
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v1, s5
; GFX9-NEXT:    v_mov_b32_e32 v2, s4
; GFX9-NEXT:    s_and_b32 s1, s1, 31
; GFX9-NEXT:    s_sub_i32 s9, 32, s1
; GFX9-NEXT:    s_and_b32 s0, s0, 31
; GFX9-NEXT:    s_lshl_b32 s8, s5, s1
; GFX9-NEXT:    s_lshr_b32 s7, s7, s9
; GFX9-NEXT:    s_sub_i32 s5, 32, s0
; GFX9-NEXT:    s_or_b32 s7, s8, s7
; GFX9-NEXT:    v_cmp_eq_u32_e64 vcc, s1, 0
; GFX9-NEXT:    s_lshl_b32 s1, s4, s0
; GFX9-NEXT:    s_lshr_b32 s5, s6, s5
; GFX9-NEXT:    v_mov_b32_e32 v0, s7
; GFX9-NEXT:    s_or_b32 s1, s1, s5
; GFX9-NEXT:    v_cndmask_b32_e32 v1, v0, v1, vcc
; GFX9-NEXT:    v_mov_b32_e32 v0, s1
; GFX9-NEXT:    v_cmp_eq_u32_e64 vcc, s0, 0
; GFX9-NEXT:    v_cndmask_b32_e32 v0, v0, v2, vcc
; GFX9-NEXT:    v_mov_b32_e32 v2, s2
; GFX9-NEXT:    v_mov_b32_e32 v3, s3
; GFX9-NEXT:    global_store_dwordx2 v[2:3], v[0:1], off
; GFX9-NEXT:    s_endpgm
;
; R600-LABEL: fshl_v2i32:
; R600:       ; %bb.0: ; %entry
; R600-NEXT:    ALU 18, @4, KC0[CB0:0-32], KC1[]
; R600-NEXT:    MEM_RAT_CACHELESS STORE_RAW T1.XY, T0.X, 1
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
; R600-NEXT:    ALU clause starting at 4:
; R600-NEXT:     AND_INT T0.W, KC0[4].X, literal.x,
; R600-NEXT:     AND_INT * T1.W, KC0[3].W, literal.x,
; R600-NEXT:    31(4.344025e-44), 0(0.000000e+00)
; R600-NEXT:     SUB_INT * T2.W, literal.x, PV.W,
; R600-NEXT:    32(4.484155e-44), 0(0.000000e+00)
; R600-NEXT:     LSHR T0.Z, KC0[3].Z, PV.W,
; R600-NEXT:     LSHL T2.W, KC0[3].X, T0.W, BS:VEC_021/SCL_122
; R600-NEXT:     SUB_INT * T3.W, literal.x, T1.W,
; R600-NEXT:    32(4.484155e-44), 0(0.000000e+00)
; R600-NEXT:     LSHR T0.Y, KC0[3].Y, PS,
; R600-NEXT:     LSHL T1.Z, KC0[2].W, T1.W,
; R600-NEXT:     OR_INT T2.W, PV.W, PV.Z,
; R600-NEXT:     SETE_INT * T0.W, T0.W, 0.0,
; R600-NEXT:     CNDE_INT T1.Y, PS, PV.W, KC0[3].X,
; R600-NEXT:     OR_INT T0.W, PV.Z, PV.Y,
; R600-NEXT:     SETE_INT * T1.W, T1.W, 0.0,
; R600-NEXT:     CNDE_INT T1.X, PS, PV.W, KC0[2].W,
; R600-NEXT:     LSHR * T0.X, KC0[2].Y, literal.x,
; R600-NEXT:    2(2.802597e-45), 0(0.000000e+00)
entry:
  %0 = call <2 x i32> @llvm.fshl.v2i32(<2 x i32> %x, <2 x i32> %y, <2 x i32> %z)
  store <2 x i32> %0, <2 x i32> addrspace(1)* %in
  ret void
}

define amdgpu_kernel void @fshl_v2i32_imm(<2 x i32> addrspace(1)* %in, <2 x i32> %x, <2 x i32> %y) {
; SI-LABEL: fshl_v2i32_imm:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0xb
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xd
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_mov_b32_e32 v0, s1
; SI-NEXT:    v_alignbit_b32 v1, s3, v0, 23
; SI-NEXT:    v_mov_b32_e32 v0, s0
; SI-NEXT:    v_alignbit_b32 v0, s2, v0, 25
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fshl_v2i32_imm:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x2c
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v0, s1
; VI-NEXT:    v_mov_b32_e32 v2, s0
; VI-NEXT:    v_alignbit_b32 v1, s5, v0, 23
; VI-NEXT:    v_alignbit_b32 v0, s4, v2, 25
; VI-NEXT:    v_mov_b32_e32 v2, s2
; VI-NEXT:    v_mov_b32_e32 v3, s3
; VI-NEXT:    flat_store_dwordx2 v[2:3], v[0:1]
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: fshl_v2i32_imm:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; GFX9-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x2c
; GFX9-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, s1
; GFX9-NEXT:    v_mov_b32_e32 v2, s0
; GFX9-NEXT:    v_alignbit_b32 v1, s5, v0, 23
; GFX9-NEXT:    v_alignbit_b32 v0, s4, v2, 25
; GFX9-NEXT:    v_mov_b32_e32 v2, s2
; GFX9-NEXT:    v_mov_b32_e32 v3, s3
; GFX9-NEXT:    global_store_dwordx2 v[2:3], v[0:1], off
; GFX9-NEXT:    s_endpgm
;
; R600-LABEL: fshl_v2i32_imm:
; R600:       ; %bb.0: ; %entry
; R600-NEXT:    ALU 5, @4, KC0[CB0:0-32], KC1[]
; R600-NEXT:    MEM_RAT_CACHELESS STORE_RAW T0.XY, T1.X, 1
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
; R600-NEXT:    ALU clause starting at 4:
; R600-NEXT:     BIT_ALIGN_INT * T0.Y, KC0[3].X, KC0[3].Z, literal.x,
; R600-NEXT:    23(3.222986e-44), 0(0.000000e+00)
; R600-NEXT:     BIT_ALIGN_INT * T0.X, KC0[2].W, KC0[3].Y, literal.x,
; R600-NEXT:    25(3.503246e-44), 0(0.000000e+00)
; R600-NEXT:     LSHR * T1.X, KC0[2].Y, literal.x,
; R600-NEXT:    2(2.802597e-45), 0(0.000000e+00)
entry:
  %0 = call <2 x i32> @llvm.fshl.v2i32(<2 x i32> %x, <2 x i32> %y, <2 x i32> <i32 7, i32 9>)
  store <2 x i32> %0, <2 x i32> addrspace(1)* %in
  ret void
}

define amdgpu_kernel void @fshl_v4i32(<4 x i32> addrspace(1)* %in, <4 x i32> %x, <4 x i32> %y, <4 x i32> %z) {
; SI-LABEL: fshl_v4i32:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx4 s[8:11], s[0:1], 0xd
; SI-NEXT:    s_load_dwordx4 s[12:15], s[0:1], 0x11
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x15
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_mov_b32_e32 v1, s11
; SI-NEXT:    v_mov_b32_e32 v4, s8
; SI-NEXT:    s_and_b32 s3, s3, 31
; SI-NEXT:    s_sub_i32 s17, 32, s3
; SI-NEXT:    s_and_b32 s2, s2, 31
; SI-NEXT:    s_lshl_b32 s16, s11, s3
; SI-NEXT:    s_lshr_b32 s15, s15, s17
; SI-NEXT:    s_sub_i32 s11, 32, s2
; SI-NEXT:    s_or_b32 s15, s16, s15
; SI-NEXT:    v_cmp_eq_u32_e64 vcc, s3, 0
; SI-NEXT:    s_lshl_b32 s3, s10, s2
; SI-NEXT:    s_lshr_b32 s11, s14, s11
; SI-NEXT:    v_mov_b32_e32 v0, s15
; SI-NEXT:    s_or_b32 s3, s3, s11
; SI-NEXT:    s_and_b32 s1, s1, 31
; SI-NEXT:    v_cndmask_b32_e32 v3, v0, v1, vcc
; SI-NEXT:    v_mov_b32_e32 v0, s3
; SI-NEXT:    s_sub_i32 s3, 32, s1
; SI-NEXT:    v_cmp_eq_u32_e64 vcc, s2, 0
; SI-NEXT:    s_lshl_b32 s2, s9, s1
; SI-NEXT:    s_lshr_b32 s3, s13, s3
; SI-NEXT:    v_mov_b32_e32 v1, s10
; SI-NEXT:    s_or_b32 s2, s2, s3
; SI-NEXT:    s_and_b32 s0, s0, 31
; SI-NEXT:    v_cndmask_b32_e32 v2, v0, v1, vcc
; SI-NEXT:    v_mov_b32_e32 v0, s2
; SI-NEXT:    s_sub_i32 s2, 32, s0
; SI-NEXT:    v_cmp_eq_u32_e64 vcc, s1, 0
; SI-NEXT:    s_lshl_b32 s1, s8, s0
; SI-NEXT:    s_lshr_b32 s2, s12, s2
; SI-NEXT:    v_mov_b32_e32 v1, s9
; SI-NEXT:    s_or_b32 s1, s1, s2
; SI-NEXT:    v_cndmask_b32_e32 v1, v0, v1, vcc
; SI-NEXT:    v_mov_b32_e32 v0, s1
; SI-NEXT:    v_cmp_eq_u32_e64 vcc, s0, 0
; SI-NEXT:    v_cndmask_b32_e32 v0, v0, v4, vcc
; SI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fshl_v4i32:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx2 s[12:13], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x34
; VI-NEXT:    s_load_dwordx4 s[8:11], s[0:1], 0x44
; VI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x54
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s7
; VI-NEXT:    v_mov_b32_e32 v4, s4
; VI-NEXT:    s_and_b32 s3, s3, 31
; VI-NEXT:    s_sub_i32 s15, 32, s3
; VI-NEXT:    s_and_b32 s2, s2, 31
; VI-NEXT:    s_lshl_b32 s14, s7, s3
; VI-NEXT:    s_lshr_b32 s11, s11, s15
; VI-NEXT:    s_sub_i32 s7, 32, s2
; VI-NEXT:    s_or_b32 s11, s14, s11
; VI-NEXT:    v_cmp_eq_u32_e64 vcc, s3, 0
; VI-NEXT:    s_lshl_b32 s3, s6, s2
; VI-NEXT:    s_lshr_b32 s7, s10, s7
; VI-NEXT:    v_mov_b32_e32 v0, s11
; VI-NEXT:    s_or_b32 s3, s3, s7
; VI-NEXT:    s_and_b32 s1, s1, 31
; VI-NEXT:    v_cndmask_b32_e32 v3, v0, v1, vcc
; VI-NEXT:    v_mov_b32_e32 v0, s3
; VI-NEXT:    s_sub_i32 s3, 32, s1
; VI-NEXT:    v_cmp_eq_u32_e64 vcc, s2, 0
; VI-NEXT:    s_lshl_b32 s2, s5, s1
; VI-NEXT:    s_lshr_b32 s3, s9, s3
; VI-NEXT:    v_mov_b32_e32 v1, s6
; VI-NEXT:    s_or_b32 s2, s2, s3
; VI-NEXT:    s_and_b32 s0, s0, 31
; VI-NEXT:    v_cndmask_b32_e32 v2, v0, v1, vcc
; VI-NEXT:    v_mov_b32_e32 v0, s2
; VI-NEXT:    s_sub_i32 s2, 32, s0
; VI-NEXT:    v_cmp_eq_u32_e64 vcc, s1, 0
; VI-NEXT:    s_lshl_b32 s1, s4, s0
; VI-NEXT:    s_lshr_b32 s2, s8, s2
; VI-NEXT:    v_mov_b32_e32 v1, s5
; VI-NEXT:    s_or_b32 s1, s1, s2
; VI-NEXT:    v_cndmask_b32_e32 v1, v0, v1, vcc
; VI-NEXT:    v_mov_b32_e32 v0, s1
; VI-NEXT:    v_cmp_eq_u32_e64 vcc, s0, 0
; VI-NEXT:    v_cndmask_b32_e32 v0, v0, v4, vcc
; VI-NEXT:    v_mov_b32_e32 v4, s12
; VI-NEXT:    v_mov_b32_e32 v5, s13
; VI-NEXT:    flat_store_dwordx4 v[4:5], v[0:3]
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: fshl_v4i32:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_load_dwordx2 s[12:13], s[0:1], 0x24
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x34
; GFX9-NEXT:    s_load_dwordx4 s[8:11], s[0:1], 0x44
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x54
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v1, s7
; GFX9-NEXT:    v_mov_b32_e32 v4, s4
; GFX9-NEXT:    s_and_b32 s3, s3, 31
; GFX9-NEXT:    s_sub_i32 s15, 32, s3
; GFX9-NEXT:    s_and_b32 s2, s2, 31
; GFX9-NEXT:    s_lshl_b32 s14, s7, s3
; GFX9-NEXT:    s_lshr_b32 s11, s11, s15
; GFX9-NEXT:    s_sub_i32 s7, 32, s2
; GFX9-NEXT:    s_or_b32 s11, s14, s11
; GFX9-NEXT:    v_cmp_eq_u32_e64 vcc, s3, 0
; GFX9-NEXT:    s_lshl_b32 s3, s6, s2
; GFX9-NEXT:    s_lshr_b32 s7, s10, s7
; GFX9-NEXT:    v_mov_b32_e32 v0, s11
; GFX9-NEXT:    s_or_b32 s3, s3, s7
; GFX9-NEXT:    s_and_b32 s1, s1, 31
; GFX9-NEXT:    v_cndmask_b32_e32 v3, v0, v1, vcc
; GFX9-NEXT:    v_mov_b32_e32 v0, s3
; GFX9-NEXT:    s_sub_i32 s3, 32, s1
; GFX9-NEXT:    v_cmp_eq_u32_e64 vcc, s2, 0
; GFX9-NEXT:    s_lshl_b32 s2, s5, s1
; GFX9-NEXT:    s_lshr_b32 s3, s9, s3
; GFX9-NEXT:    v_mov_b32_e32 v1, s6
; GFX9-NEXT:    s_or_b32 s2, s2, s3
; GFX9-NEXT:    s_and_b32 s0, s0, 31
; GFX9-NEXT:    v_cndmask_b32_e32 v2, v0, v1, vcc
; GFX9-NEXT:    v_mov_b32_e32 v0, s2
; GFX9-NEXT:    s_sub_i32 s2, 32, s0
; GFX9-NEXT:    v_cmp_eq_u32_e64 vcc, s1, 0
; GFX9-NEXT:    s_lshl_b32 s1, s4, s0
; GFX9-NEXT:    s_lshr_b32 s2, s8, s2
; GFX9-NEXT:    v_mov_b32_e32 v1, s5
; GFX9-NEXT:    s_or_b32 s1, s1, s2
; GFX9-NEXT:    v_cndmask_b32_e32 v1, v0, v1, vcc
; GFX9-NEXT:    v_mov_b32_e32 v0, s1
; GFX9-NEXT:    v_cmp_eq_u32_e64 vcc, s0, 0
; GFX9-NEXT:    v_cndmask_b32_e32 v0, v0, v4, vcc
; GFX9-NEXT:    v_mov_b32_e32 v4, s12
; GFX9-NEXT:    v_mov_b32_e32 v5, s13
; GFX9-NEXT:    global_store_dwordx4 v[4:5], v[0:3], off
; GFX9-NEXT:    s_endpgm
;
; R600-LABEL: fshl_v4i32:
; R600:       ; %bb.0: ; %entry
; R600-NEXT:    ALU 34, @4, KC0[CB0:0-32], KC1[]
; R600-NEXT:    MEM_RAT_CACHELESS STORE_RAW T2.XYZW, T0.X, 1
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
; R600-NEXT:    ALU clause starting at 4:
; R600-NEXT:     AND_INT T0.W, KC0[5].Y, literal.x,
; R600-NEXT:     AND_INT * T1.W, KC0[6].X, literal.x,
; R600-NEXT:    31(4.344025e-44), 0(0.000000e+00)
; R600-NEXT:     SUB_INT * T2.W, literal.x, PV.W,
; R600-NEXT:    32(4.484155e-44), 0(0.000000e+00)
; R600-NEXT:     LSHR T0.Z, KC0[4].Y, PV.W,
; R600-NEXT:     SUB_INT T2.W, literal.x, T1.W,
; R600-NEXT:     AND_INT * T3.W, KC0[5].W, literal.y,
; R600-NEXT:    32(4.484155e-44), 31(4.344025e-44)
; R600-NEXT:     AND_INT T0.Y, KC0[5].Z, literal.x,
; R600-NEXT:     SUB_INT T1.Z, literal.y, PS,
; R600-NEXT:     LSHR * T2.W, KC0[5].X, PV.W,
; R600-NEXT:    31(4.344025e-44), 32(4.484155e-44)
; R600-NEXT:     LSHL * T4.W, KC0[4].X, T1.W,
; R600-NEXT:     OR_INT T0.X, PV.W, T2.W,
; R600-NEXT:     SETE_INT T1.Y, T1.W, 0.0,
; R600-NEXT:     LSHR T1.Z, KC0[4].W, T1.Z,
; R600-NEXT:     LSHL T1.W, KC0[3].W, T3.W, BS:VEC_021/SCL_122
; R600-NEXT:     SUB_INT * T2.W, literal.x, T0.Y,
; R600-NEXT:    32(4.484155e-44), 0(0.000000e+00)
; R600-NEXT:     LSHR T1.X, KC0[4].Z, PS,
; R600-NEXT:     LSHL T2.Y, KC0[3].Z, T0.Y,
; R600-NEXT:     OR_INT T1.Z, PV.W, PV.Z,
; R600-NEXT:     SETE_INT * T1.W, T3.W, 0.0,
; R600-NEXT:     CNDE_INT * T2.W, T1.Y, T0.X, KC0[4].X,
; R600-NEXT:     LSHL T1.Y, KC0[3].Y, T0.W,
; R600-NEXT:     CNDE_INT T2.Z, T1.W, T1.Z, KC0[3].W,
; R600-NEXT:     OR_INT T1.W, T2.Y, T1.X,
; R600-NEXT:     SETE_INT * T3.W, T0.Y, 0.0,
; R600-NEXT:     CNDE_INT T2.Y, PS, PV.W, KC0[3].Z,
; R600-NEXT:     OR_INT T1.W, PV.Y, T0.Z,
; R600-NEXT:     SETE_INT * T0.W, T0.W, 0.0,
; R600-NEXT:     CNDE_INT T2.X, PS, PV.W, KC0[3].Y,
; R600-NEXT:     LSHR * T0.X, KC0[2].Y, literal.x,
; R600-NEXT:    2(2.802597e-45), 0(0.000000e+00)
entry:
  %0 = call <4 x i32> @llvm.fshl.v4i32(<4 x i32> %x, <4 x i32> %y, <4 x i32> %z)
  store <4 x i32> %0, <4 x i32> addrspace(1)* %in
  ret void
}

define amdgpu_kernel void @fshl_v4i32_imm(<4 x i32> addrspace(1)* %in, <4 x i32> %x, <4 x i32> %y) {
; SI-LABEL: fshl_v4i32_imm:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx4 s[8:11], s[0:1], 0xd
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x11
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_mov_b32_e32 v0, s3
; SI-NEXT:    v_alignbit_b32 v3, s11, v0, 31
; SI-NEXT:    v_mov_b32_e32 v0, s2
; SI-NEXT:    v_alignbit_b32 v2, s10, v0, 23
; SI-NEXT:    v_mov_b32_e32 v0, s1
; SI-NEXT:    v_alignbit_b32 v1, s9, v0, 25
; SI-NEXT:    v_mov_b32_e32 v0, s0
; SI-NEXT:    v_alignbit_b32 v0, s8, v0, 31
; SI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fshl_v4i32_imm:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x34
; VI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x44
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v4, s8
; VI-NEXT:    v_mov_b32_e32 v5, s9
; VI-NEXT:    v_mov_b32_e32 v0, s3
; VI-NEXT:    v_mov_b32_e32 v1, s2
; VI-NEXT:    v_alignbit_b32 v3, s7, v0, 31
; VI-NEXT:    v_mov_b32_e32 v0, s1
; VI-NEXT:    v_alignbit_b32 v2, s6, v1, 23
; VI-NEXT:    v_alignbit_b32 v1, s5, v0, 25
; VI-NEXT:    v_mov_b32_e32 v0, s0
; VI-NEXT:    v_alignbit_b32 v0, s4, v0, 31
; VI-NEXT:    flat_store_dwordx4 v[4:5], v[0:3]
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: fshl_v4i32_imm:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0x24
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x34
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x44
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v4, s8
; GFX9-NEXT:    v_mov_b32_e32 v5, s9
; GFX9-NEXT:    v_mov_b32_e32 v0, s3
; GFX9-NEXT:    v_mov_b32_e32 v1, s2
; GFX9-NEXT:    v_alignbit_b32 v3, s7, v0, 31
; GFX9-NEXT:    v_mov_b32_e32 v0, s1
; GFX9-NEXT:    v_alignbit_b32 v2, s6, v1, 23
; GFX9-NEXT:    v_alignbit_b32 v1, s5, v0, 25
; GFX9-NEXT:    v_mov_b32_e32 v0, s0
; GFX9-NEXT:    v_alignbit_b32 v0, s4, v0, 31
; GFX9-NEXT:    global_store_dwordx4 v[4:5], v[0:3], off
; GFX9-NEXT:    s_endpgm
;
; R600-LABEL: fshl_v4i32_imm:
; R600:       ; %bb.0: ; %entry
; R600-NEXT:    ALU 9, @4, KC0[CB0:0-32], KC1[]
; R600-NEXT:    MEM_RAT_CACHELESS STORE_RAW T0.XYZW, T1.X, 1
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
; R600-NEXT:    ALU clause starting at 4:
; R600-NEXT:     BIT_ALIGN_INT * T0.W, KC0[4].X, KC0[5].X, literal.x,
; R600-NEXT:    31(4.344025e-44), 0(0.000000e+00)
; R600-NEXT:     BIT_ALIGN_INT * T0.Z, KC0[3].W, KC0[4].W, literal.x,
; R600-NEXT:    23(3.222986e-44), 0(0.000000e+00)
; R600-NEXT:     BIT_ALIGN_INT * T0.Y, KC0[3].Z, KC0[4].Z, literal.x,
; R600-NEXT:    25(3.503246e-44), 0(0.000000e+00)
; R600-NEXT:     BIT_ALIGN_INT * T0.X, KC0[3].Y, KC0[4].Y, literal.x,
; R600-NEXT:    31(4.344025e-44), 0(0.000000e+00)
; R600-NEXT:     LSHR * T1.X, KC0[2].Y, literal.x,
; R600-NEXT:    2(2.802597e-45), 0(0.000000e+00)
entry:
  %0 = call <4 x i32> @llvm.fshl.v4i32(<4 x i32> %x, <4 x i32> %y, <4 x i32> <i32 1, i32 7, i32 9, i32 33>)
  store <4 x i32> %0, <4 x i32> addrspace(1)* %in
  ret void
}
