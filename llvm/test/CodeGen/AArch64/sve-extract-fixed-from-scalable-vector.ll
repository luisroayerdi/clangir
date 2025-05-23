; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s -o - | FileCheck %s

; Extracting a legal fixed-length vector from an illegal subvector

define <4 x i32> @extract_v4i32_nxv16i32_12(<vscale x 16 x i32> %arg) {
; CHECK-LABEL: extract_v4i32_nxv16i32_12:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-4
; CHECK-NEXT:    .cfi_escape 0x0f, 0x0c, 0x8f, 0x00, 0x11, 0x10, 0x22, 0x11, 0x20, 0x92, 0x2e, 0x00, 0x1e, 0x22 // sp + 16 + 32 * VG
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    str z3, [sp, #3, mul vl]
; CHECK-NEXT:    str z2, [sp, #2, mul vl]
; CHECK-NEXT:    str z1, [sp, #1, mul vl]
; CHECK-NEXT:    str z0, [sp]
; CHECK-NEXT:    ldr q0, [sp, #48]
; CHECK-NEXT:    addvl sp, sp, #4
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %ext = call <4 x i32> @llvm.vector.extract.v4i32.nxv16i32(<vscale x 16 x i32> %arg, i64 12)
  ret <4 x i32> %ext
}

define <8 x i16> @extract_v8i16_nxv32i16_8(<vscale x 32 x i16> %arg) {
; CHECK-LABEL: extract_v8i16_nxv32i16_8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-2
; CHECK-NEXT:    .cfi_escape 0x0f, 0x0c, 0x8f, 0x00, 0x11, 0x10, 0x22, 0x11, 0x10, 0x92, 0x2e, 0x00, 0x1e, 0x22 // sp + 16 + 16 * VG
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    str z1, [sp, #1, mul vl]
; CHECK-NEXT:    str z0, [sp]
; CHECK-NEXT:    ldr q0, [sp, #16]
; CHECK-NEXT:    addvl sp, sp, #2
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %ext = call <8 x i16> @llvm.vector.extract.v8i16.nxv32i16(<vscale x 32 x i16> %arg, i64 8)
  ret <8 x i16> %ext
}

define <4 x i16> @extract_v4i16_nxv32i16_8(<vscale x 32 x i16> %arg) {
; CHECK-LABEL: extract_v4i16_nxv32i16_8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-4
; CHECK-NEXT:    .cfi_escape 0x0f, 0x0c, 0x8f, 0x00, 0x11, 0x10, 0x22, 0x11, 0x20, 0x92, 0x2e, 0x00, 0x1e, 0x22 // sp + 16 + 32 * VG
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    str z3, [sp, #3, mul vl]
; CHECK-NEXT:    str z2, [sp, #2, mul vl]
; CHECK-NEXT:    str z1, [sp, #1, mul vl]
; CHECK-NEXT:    str z0, [sp]
; CHECK-NEXT:    ldr d0, [sp, #32]
; CHECK-NEXT:    addvl sp, sp, #4
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %ext = call <4 x i16> @llvm.vector.extract.v4i16.nxv32i16(<vscale x 32 x i16> %arg, i64 16)
  ret <4 x i16> %ext
}

; The result type gets promoted, leading to us extracting 2 elements from a nxv32i16.
; Hence we don't end up in SplitVecOp_EXTRACT_SUBVECTOR, but in SplitVecOp_EXTRACT_VECTOR_ELT instead.
define <2 x i16> @extract_v2i16_nxv32i16_8(<vscale x 32 x i16> %arg) {
; CHECK-LABEL: extract_v2i16_nxv32i16_8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-8
; CHECK-NEXT:    .cfi_escape 0x0f, 0x0d, 0x8f, 0x00, 0x11, 0x10, 0x22, 0x11, 0xc0, 0x00, 0x92, 0x2e, 0x00, 0x1e, 0x22 // sp + 16 + 64 * VG
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    mov x8, sp
; CHECK-NEXT:    str z3, [sp, #3, mul vl]
; CHECK-NEXT:    str z2, [sp, #2, mul vl]
; CHECK-NEXT:    add x8, x8, #32
; CHECK-NEXT:    str z1, [sp, #1, mul vl]
; CHECK-NEXT:    str z0, [sp]
; CHECK-NEXT:    str z3, [sp, #7, mul vl]
; CHECK-NEXT:    str z2, [sp, #6, mul vl]
; CHECK-NEXT:    str z1, [sp, #5, mul vl]
; CHECK-NEXT:    str z0, [sp, #4, mul vl]
; CHECK-NEXT:    ld1 { v0.h }[0], [x8]
; CHECK-NEXT:    addvl x8, sp, #4
; CHECK-NEXT:    add x8, x8, #34
; CHECK-NEXT:    ld1 { v0.h }[2], [x8]
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $q0
; CHECK-NEXT:    addvl sp, sp, #8
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %ext = call <2 x i16> @llvm.vector.extract.v2i16.nxv32i16(<vscale x 32 x i16> %arg, i64 16)
  ret <2 x i16> %ext
}

define <2 x i64> @extract_v2i64_nxv8i64_8(<vscale x 8 x i64> %arg) {
; CHECK-LABEL: extract_v2i64_nxv8i64_8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-4
; CHECK-NEXT:    .cfi_escape 0x0f, 0x0c, 0x8f, 0x00, 0x11, 0x10, 0x22, 0x11, 0x20, 0x92, 0x2e, 0x00, 0x1e, 0x22 // sp + 16 + 32 * VG
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    cnth x8
; CHECK-NEXT:    mov w9, #8 // =0x8
; CHECK-NEXT:    str z3, [sp, #3, mul vl]
; CHECK-NEXT:    sub x8, x8, #2
; CHECK-NEXT:    str z2, [sp, #2, mul vl]
; CHECK-NEXT:    cmp x8, #8
; CHECK-NEXT:    str z1, [sp, #1, mul vl]
; CHECK-NEXT:    csel x8, x8, x9, lo
; CHECK-NEXT:    str z0, [sp]
; CHECK-NEXT:    mov x9, sp
; CHECK-NEXT:    lsl x8, x8, #3
; CHECK-NEXT:    ldr q0, [x9, x8]
; CHECK-NEXT:    addvl sp, sp, #4
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %ext = call <2 x i64> @llvm.vector.extract.v2i64.nxv8i64(<vscale x 8 x i64> %arg, i64 8)
  ret <2 x i64> %ext
}

define <4 x float> @extract_v4f32_nxv16f32_12(<vscale x 16 x float> %arg) {
; CHECK-LABEL: extract_v4f32_nxv16f32_12:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-4
; CHECK-NEXT:    .cfi_escape 0x0f, 0x0c, 0x8f, 0x00, 0x11, 0x10, 0x22, 0x11, 0x20, 0x92, 0x2e, 0x00, 0x1e, 0x22 // sp + 16 + 32 * VG
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    str z3, [sp, #3, mul vl]
; CHECK-NEXT:    str z2, [sp, #2, mul vl]
; CHECK-NEXT:    str z1, [sp, #1, mul vl]
; CHECK-NEXT:    str z0, [sp]
; CHECK-NEXT:    ldr q0, [sp, #48]
; CHECK-NEXT:    addvl sp, sp, #4
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %ext = call <4 x float> @llvm.vector.extract.v4f32.nxv16f32(<vscale x 16 x float> %arg, i64 12)
  ret <4 x float> %ext
}

define <2 x float> @extract_v2f32_nxv16f32_2(<vscale x 16 x float> %arg) {
; CHECK-LABEL: extract_v2f32_nxv16f32_2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ext z0.b, z0.b, z0.b, #8
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %ext = call <2 x float> @llvm.vector.extract.v2f32.nxv16f32(<vscale x 16 x float> %arg, i64 2)
  ret <2 x float> %ext
}

define <4 x i1> @extract_v4i1_nxv32i1_0(<vscale x 32 x i1> %arg) {
; CHECK-LABEL: extract_v4i1_nxv32i1_0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov z1.b, p0/z, #1 // =0x1
; CHECK-NEXT:    umov w8, v1.b[1]
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    umov w9, v1.b[2]
; CHECK-NEXT:    mov v0.h[1], w8
; CHECK-NEXT:    umov w8, v1.b[3]
; CHECK-NEXT:    mov v0.h[2], w9
; CHECK-NEXT:    mov v0.h[3], w8
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $q0
; CHECK-NEXT:    ret
  %ext = call <4 x i1> @llvm.vector.extract.v4i1.nxv32i1(<vscale x 32 x i1> %arg, i64 0)
  ret <4 x i1> %ext
}

; The result type gets promoted, leading to us extracting 4 elements from a nxv32i16.
; Hence we don't end up in SplitVecOp_EXTRACT_SUBVECTOR, but in SplitVecOp_EXTRACT_VECTOR_ELT instead.
define <4 x i1> @extract_v4i1_nxv32i1_16(<vscale x 32 x i1> %arg) {
; CHECK-LABEL: extract_v4i1_nxv32i1_16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-8
; CHECK-NEXT:    .cfi_escape 0x0f, 0x0d, 0x8f, 0x00, 0x11, 0x10, 0x22, 0x11, 0xc0, 0x00, 0x92, 0x2e, 0x00, 0x1e, 0x22 // sp + 16 + 64 * VG
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    mov z0.b, p1/z, #1 // =0x1
; CHECK-NEXT:    mov z1.b, p0/z, #1 // =0x1
; CHECK-NEXT:    mov x8, sp
; CHECK-NEXT:    add x8, x8, #16
; CHECK-NEXT:    str z0, [sp, #1, mul vl]
; CHECK-NEXT:    str z1, [sp]
; CHECK-NEXT:    str z0, [sp, #3, mul vl]
; CHECK-NEXT:    str z1, [sp, #2, mul vl]
; CHECK-NEXT:    str z0, [sp, #5, mul vl]
; CHECK-NEXT:    str z1, [sp, #4, mul vl]
; CHECK-NEXT:    str z0, [sp, #7, mul vl]
; CHECK-NEXT:    str z1, [sp, #6, mul vl]
; CHECK-NEXT:    ld1 { v0.b }[0], [x8]
; CHECK-NEXT:    addvl x8, sp, #2
; CHECK-NEXT:    add x8, x8, #17
; CHECK-NEXT:    ld1 { v0.b }[2], [x8]
; CHECK-NEXT:    addvl x8, sp, #4
; CHECK-NEXT:    add x8, x8, #18
; CHECK-NEXT:    ld1 { v0.b }[4], [x8]
; CHECK-NEXT:    addvl x8, sp, #6
; CHECK-NEXT:    add x8, x8, #19
; CHECK-NEXT:    ld1 { v0.b }[6], [x8]
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $q0
; CHECK-NEXT:    addvl sp, sp, #8
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %ext = call <4 x i1> @llvm.vector.extract.v4i1.nxv32i1(<vscale x 32 x i1> %arg, i64 16)
  ret <4 x i1> %ext
}

define <4 x i1> @extract_v4i1_v32i1_16(<32 x i1> %arg) {
; CHECK-LABEL: extract_v4i1_v32i1_16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr w8, [sp, #64]
; CHECK-NEXT:    ldr w9, [sp, #72]
; CHECK-NEXT:    fmov s0, w8
; CHECK-NEXT:    ldr w8, [sp, #80]
; CHECK-NEXT:    mov v0.h[1], w9
; CHECK-NEXT:    mov v0.h[2], w8
; CHECK-NEXT:    ldr w8, [sp, #88]
; CHECK-NEXT:    mov v0.h[3], w8
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $q0
; CHECK-NEXT:    ret
  %ext = call <4 x i1> @llvm.vector.extract.v4i1.v32i1(<32 x i1> %arg, i64 16)
  ret <4 x i1> %ext
}

; The result type gets promoted, leading to us extracting 4 elements from a nxv32i3.
; Hence we don't end up in SplitVecOp_EXTRACT_SUBVECTOR, but in SplitVecOp_EXTRACT_VECTOR_ELT instead.
define <4 x i3> @extract_v4i3_nxv32i3_16(<vscale x 32 x i3> %arg) {
; CHECK-LABEL: extract_v4i3_nxv32i3_16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-8
; CHECK-NEXT:    .cfi_escape 0x0f, 0x0d, 0x8f, 0x00, 0x11, 0x10, 0x22, 0x11, 0xc0, 0x00, 0x92, 0x2e, 0x00, 0x1e, 0x22 // sp + 16 + 64 * VG
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    mov x8, sp
; CHECK-NEXT:    str z1, [sp, #1, mul vl]
; CHECK-NEXT:    str z0, [sp]
; CHECK-NEXT:    add x8, x8, #16
; CHECK-NEXT:    str z1, [sp, #3, mul vl]
; CHECK-NEXT:    str z0, [sp, #2, mul vl]
; CHECK-NEXT:    str z1, [sp, #5, mul vl]
; CHECK-NEXT:    str z0, [sp, #4, mul vl]
; CHECK-NEXT:    str z1, [sp, #7, mul vl]
; CHECK-NEXT:    str z0, [sp, #6, mul vl]
; CHECK-NEXT:    ld1 { v0.b }[0], [x8]
; CHECK-NEXT:    addvl x8, sp, #2
; CHECK-NEXT:    add x8, x8, #17
; CHECK-NEXT:    ld1 { v0.b }[2], [x8]
; CHECK-NEXT:    addvl x8, sp, #4
; CHECK-NEXT:    add x8, x8, #18
; CHECK-NEXT:    ld1 { v0.b }[4], [x8]
; CHECK-NEXT:    addvl x8, sp, #6
; CHECK-NEXT:    add x8, x8, #19
; CHECK-NEXT:    ld1 { v0.b }[6], [x8]
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $q0
; CHECK-NEXT:    addvl sp, sp, #8
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %ext = call <4 x i3> @llvm.vector.extract.v4i3.nxv32i3(<vscale x 32 x i3> %arg, i64 16)
  ret <4 x i3> %ext
}

; Extracting an illegal fixed-length vector from an illegal subvector

define <2 x i32> @extract_v2i32_nxv16i32_2(<vscale x 16 x i32> %arg) {
; CHECK-LABEL: extract_v2i32_nxv16i32_2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ext z0.b, z0.b, z0.b, #8
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %ext = call <2 x i32> @llvm.vector.extract.v2i32.nxv16i32(<vscale x 16 x i32> %arg, i64 2)
  ret <2 x i32> %ext
}

define <4 x i64> @extract_v4i64_nxv8i64_0(<vscale x 8 x i64> %arg) {
; CHECK-LABEL: extract_v4i64_nxv8i64_0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-2
; CHECK-NEXT:    .cfi_escape 0x0f, 0x0c, 0x8f, 0x00, 0x11, 0x10, 0x22, 0x11, 0x10, 0x92, 0x2e, 0x00, 0x1e, 0x22 // sp + 16 + 16 * VG
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    str z1, [sp, #1, mul vl]
; CHECK-NEXT:    str z0, [sp]
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ldr q1, [sp, #16]
; CHECK-NEXT:    addvl sp, sp, #2
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %ext = call <4 x i64> @llvm.vector.extract.v4i64.nxv8i64(<vscale x 8 x i64> %arg, i64 0)
  ret <4 x i64> %ext
}

define <4 x half> @extract_v4f16_nxv2f16_0(<vscale x 2 x half> %arg) {
; CHECK-LABEL: extract_v4f16_nxv2f16_0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uzp1 z0.h, z0.h, z0.h
; CHECK-NEXT:    uzp1 z0.h, z0.h, z0.h
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %ext = call <4 x half> @llvm.vector.extract.v4f16.nxv2f16(<vscale x 2 x half> %arg, i64 0)
  ret <4 x half> %ext
}

define <4 x half> @extract_v4f16_nxv2f16_4(<vscale x 2 x half> %arg) {
; CHECK-LABEL: extract_v4f16_nxv2f16_4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uzp1 z0.h, z0.h, z0.h
; CHECK-NEXT:    uzp1 z0.h, z0.h, z0.h
; CHECK-NEXT:    ext z0.b, z0.b, z0.b, #8
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %ext = call <4 x half> @llvm.vector.extract.v4f16.nxv2f16(<vscale x 2 x half> %arg, i64 4)
  ret <4 x half> %ext
}

define <2 x half> @extract_v2f16_nxv4f16_2(<vscale x 4 x half> %arg) {
; CHECK-LABEL: extract_v2f16_nxv4f16_2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov z1.s, z0.s[3]
; CHECK-NEXT:    mov z0.s, z0.s[2]
; CHECK-NEXT:    mov v0.h[1], v1.h[0]
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %ext = call <2 x half> @llvm.vector.extract.v2f16.nxv4f16(<vscale x 4 x half> %arg, i64 2)
  ret <2 x half> %ext
}

define <2 x half> @extract_v2f16_nxv4f16_6(<vscale x 4 x half> %arg) {
; CHECK-LABEL: extract_v2f16_nxv4f16_6:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov z1.s, z0.s[7]
; CHECK-NEXT:    mov z0.s, z0.s[6]
; CHECK-NEXT:    mov v0.h[1], v1.h[0]
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %ext = call <2 x half> @llvm.vector.extract.v2f16.nxv4f16(<vscale x 4 x half> %arg, i64 6)
  ret <2 x half> %ext
}

declare <4 x float> @llvm.vector.extract.v4f32.nxv16f32(<vscale x 16 x float>, i64)
declare <2 x float> @llvm.vector.extract.v2f32.nxv16f32(<vscale x 16 x float>, i64)
declare <4 x half> @llvm.vector.extract.v4f16.nxv2f16(<vscale x 2 x half>, i64);
declare <2 x half> @llvm.vector.extract.v2f16.nxv4f16(<vscale x 4 x half>, i64);
declare <2 x i64> @llvm.vector.extract.v2i64.nxv8i64(<vscale x 8 x i64>, i64)
declare <4 x i64> @llvm.vector.extract.v4i64.nxv8i64(<vscale x 8 x i64>, i64)
declare <4 x i32> @llvm.vector.extract.v4i32.nxv16i32(<vscale x 16 x i32>, i64)
declare <2 x i32> @llvm.vector.extract.v2i32.nxv16i32(<vscale x 16 x i32>, i64)
declare <8 x i16> @llvm.vector.extract.v8i16.nxv32i16(<vscale x 32 x i16>, i64)
declare <4 x i16> @llvm.vector.extract.v4i16.nxv32i16(<vscale x 32 x i16>, i64)
declare <2 x i16> @llvm.vector.extract.v2i16.nxv32i16(<vscale x 32 x i16>, i64)
declare <4 x i1> @llvm.vector.extract.v4i1.nxv32i1(<vscale x 32 x i1>, i64)
declare <4 x i1> @llvm.vector.extract.v4i1.v32i1(<32 x i1>, i64)
declare <4 x i3> @llvm.vector.extract.v4i3.nxv32i3(<vscale x 32 x i3>, i64)
