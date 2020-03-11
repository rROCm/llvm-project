; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple thumbv8m.main-arm-unknown-eabi -mattr=+vfp4d16sp < %s | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-VFPV4
; RUN: llc -mtriple thumbv8.1m.main-arm-unknown-eabi -mattr=+fullfp16 < %s | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-FP16

target triple = "thumbv8.1m.main-arm-unknown-eabi"

define float @add(float %a, float %b) {
; CHECK-LABEL: add:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov s0, r1
; CHECK-NEXT:    vmov s2, r0
; CHECK-NEXT:    vadd.f32 s0, s2, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
entry:
  %add = fadd float %a, %b
  ret float %add
}

define i32 @addf16(i32 %a.coerce, i32 %b.coerce) {
; CHECK-VFPV4-LABEL: addf16:
; CHECK-VFPV4:       @ %bb.0: @ %entry
; CHECK-VFPV4-NEXT:    vmov s2, r1
; CHECK-VFPV4-NEXT:    vmov s0, r0
; CHECK-VFPV4-NEXT:    vcvtb.f32.f16 s2, s2
; CHECK-VFPV4-NEXT:    vcvtb.f32.f16 s0, s0
; CHECK-VFPV4-NEXT:    vadd.f32 s0, s0, s2
; CHECK-VFPV4-NEXT:    vcvtb.f16.f32 s0, s0
; CHECK-VFPV4-NEXT:    vmov r0, s0
; CHECK-VFPV4-NEXT:    uxth r0, r0
; CHECK-VFPV4-NEXT:    bx lr
;
; CHECK-FP16-LABEL: addf16:
; CHECK-FP16:       @ %bb.0: @ %entry
; CHECK-FP16-NEXT:    vmov.f16 s0, r1
; CHECK-FP16-NEXT:    vmov.f16 s2, r0
; CHECK-FP16-NEXT:    vadd.f16 s0, s2, s0
; CHECK-FP16-NEXT:    vmov.f16 r0, s0
; CHECK-FP16-NEXT:    bx lr
entry:
  %tmp.0.extract.trunc = trunc i32 %a.coerce to i16
  %0 = bitcast i16 %tmp.0.extract.trunc to half
  %tmp1.0.extract.trunc = trunc i32 %b.coerce to i16
  %1 = bitcast i16 %tmp1.0.extract.trunc to half
  %add = fadd half %0, %1
  %2 = bitcast half %add to i16
  %tmp4.0.insert.ext = zext i16 %2 to i32
  ret i32 %tmp4.0.insert.ext
}
