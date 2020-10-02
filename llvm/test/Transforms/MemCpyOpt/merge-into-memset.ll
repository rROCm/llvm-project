; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -memcpyopt -S | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

; Don't delete the memcpy in %if.then, even though it depends on an instruction
; which will be deleted.

define void @foo(i1 %c, i8* %d, i8* %e, i8* %f) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP:%.*]] = alloca [50 x i8], align 8
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast [50 x i8]* [[TMP]] to i8*
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i8, i8* [[TMP4]], i64 1
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* nonnull [[D:%.*]], i8 0, i64 10, i1 false)
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 8 [[TMP4]], i8 0, i64 11, i1 false)
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF_THEN:%.*]], label [[EXIT:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 [[F:%.*]], i8* nonnull align 8 [[TMP4]], i64 30, i1 false)
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %tmp = alloca [50 x i8], align 8
  %tmp4 = bitcast [50 x i8]* %tmp to i8*
  %tmp1 = getelementptr inbounds i8, i8* %tmp4, i64 1
  call void @llvm.memset.p0i8.i64(i8* nonnull %d, i8 0, i64 10, i1 false)
  store i8 0, i8* %tmp4, align 8
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %tmp1, i8* nonnull %d, i64 10, i1 false)
  br i1 %c, label %if.then, label %exit

if.then:
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %f, i8* nonnull align 8 %tmp4, i64 30, i1 false)
  br label %exit

exit:
  ret void
}

declare void @llvm.memcpy.p0i8.p0i8.i64(i8*, i8*, i64, i1)
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)
