; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK

define arm_aapcs_vfpcc <4 x i32> @test_v4i32(i32 %x, <4 x i32> %s0, <4 x i32> %s1) {
; CHECK-LABEL: test_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    bxeq lr
; CHECK-NEXT:  .LBB0_1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <4 x i32> %s0, <4 x i32> %s1
  ret <4 x i32> %s
}

define arm_aapcs_vfpcc <8 x i16> @test_v8i16(i32 %x, <8 x i16> %s0, <8 x i16> %s1) {
; CHECK-LABEL: test_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    bxeq lr
; CHECK-NEXT:  .LBB1_1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <8 x i16> %s0, <8 x i16> %s1
  ret <8 x i16> %s
}

define arm_aapcs_vfpcc <16 x i8> @test_v16i8(i32 %x, <16 x i8> %s0, <16 x i8> %s1) {
; CHECK-LABEL: test_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    bxeq lr
; CHECK-NEXT:  .LBB2_1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <16 x i8> %s0, <16 x i8> %s1
  ret <16 x i8> %s
}

define arm_aapcs_vfpcc <2 x i64> @test_v2i64(i32 %x, <2 x i64> %s0, <2 x i64> %s1) {
; CHECK-LABEL: test_v2i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    bxeq lr
; CHECK-NEXT:  .LBB3_1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <2 x i64> %s0, <2 x i64> %s1
  ret <2 x i64> %s
}

define arm_aapcs_vfpcc <4 x float> @test_v4float(i32 %x, <4 x float> %s0, <4 x float> %s1) {
; CHECK-LABEL: test_v4float:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    bxeq lr
; CHECK-NEXT:  .LBB4_1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <4 x float> %s0, <4 x float> %s1
  ret <4 x float> %s
}

define arm_aapcs_vfpcc <8 x half> @test_v8half(i32 %x, <8 x half> %s0, <8 x half> %s1) {
; CHECK-LABEL: test_v8half:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    bxeq lr
; CHECK-NEXT:  .LBB5_1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <8 x half> %s0, <8 x half> %s1
  ret <8 x half> %s
}

define arm_aapcs_vfpcc <2 x double> @test_v2double(i32 %x, <2 x double> %s0, <2 x double> %s1) {
; CHECK-LABEL: test_v2double:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    bxeq lr
; CHECK-NEXT:  .LBB6_1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <2 x double> %s0, <2 x double> %s1
  ret <2 x double> %s
}

define arm_aapcs_vfpcc <4 x i32> @minsize_v4i32(i32 %x, <4 x i32> %s0, <4 x i32> %s1) minsize {
; CHECK-LABEL: minsize_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cbz r0, .LBB7_2
; CHECK-NEXT:  @ %bb.1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:  .LBB7_2: @ %select.end
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <4 x i32> %s0, <4 x i32> %s1
  ret <4 x i32> %s
}

define arm_aapcs_vfpcc <8 x i16> @minsize_v8i16(i32 %x, <8 x i16> %s0, <8 x i16> %s1) minsize {
; CHECK-LABEL: minsize_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cbz r0, .LBB8_2
; CHECK-NEXT:  @ %bb.1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:  .LBB8_2: @ %select.end
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <8 x i16> %s0, <8 x i16> %s1
  ret <8 x i16> %s
}

define arm_aapcs_vfpcc <16 x i8> @minsize_v16i8(i32 %x, <16 x i8> %s0, <16 x i8> %s1) minsize {
; CHECK-LABEL: minsize_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cbz r0, .LBB9_2
; CHECK-NEXT:  @ %bb.1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:  .LBB9_2: @ %select.end
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <16 x i8> %s0, <16 x i8> %s1
  ret <16 x i8> %s
}

define arm_aapcs_vfpcc <2 x i64> @minsize_v2i64(i32 %x, <2 x i64> %s0, <2 x i64> %s1) minsize {
; CHECK-LABEL: minsize_v2i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cbz r0, .LBB10_2
; CHECK-NEXT:  @ %bb.1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:  .LBB10_2: @ %select.end
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <2 x i64> %s0, <2 x i64> %s1
  ret <2 x i64> %s
}

define arm_aapcs_vfpcc <4 x float> @minsize_v4float(i32 %x, <4 x float> %s0, <4 x float> %s1) minsize {
; CHECK-LABEL: minsize_v4float:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cbz r0, .LBB11_2
; CHECK-NEXT:  @ %bb.1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:  .LBB11_2: @ %select.end
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <4 x float> %s0, <4 x float> %s1
  ret <4 x float> %s
}

define arm_aapcs_vfpcc <8 x half> @minsize_v8half(i32 %x, <8 x half> %s0, <8 x half> %s1) minsize {
; CHECK-LABEL: minsize_v8half:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cbz r0, .LBB12_2
; CHECK-NEXT:  @ %bb.1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:  .LBB12_2: @ %select.end
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <8 x half> %s0, <8 x half> %s1
  ret <8 x half> %s
}

define arm_aapcs_vfpcc <2 x double> @minsize_v2double(i32 %x, <2 x double> %s0, <2 x double> %s1) minsize {
; CHECK-LABEL: minsize_v2double:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cbz r0, .LBB13_2
; CHECK-NEXT:  @ %bb.1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:  .LBB13_2: @ %select.end
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <2 x double> %s0, <2 x double> %s1
  ret <2 x double> %s
}
