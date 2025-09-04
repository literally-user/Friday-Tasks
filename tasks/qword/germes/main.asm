struct QQuad
  terms   dd 4 dup(?)
  find   dm this
  clear   dm this:inline
  print   dm this:inline
  error   dm this:inline
ends

macro QQuad.clear this{
  local _this
  inlineObj _this, this, pcx
  pxor xmm0, xmm0
  vmovdqu xword[_this + QQuad.terms], xmm0
}

macro QQuad.error this{
  local _this
  inlineObj _this, this, pcx
  pxor xmm0, xmm0
  vmovdqu xword[_this + QQuad.terms], xmm0
}

proc QQuad.find c, qquad:POINTER, num:QWORD
  @sarg @arg2
  virtObj .this:arg QQuad at pdx from @arg1
  @call .this->clear()
  movq xmm4, xmm0
  movq xmm1, xmm4
  movq xmm2, xmm4
  movq xmm5, [num]
  mov ecx, 0
  @@:
    vpcmpeqq xmm3, xmm4, xmm5
    pslldq xmm3, 8
    ptest xmm3, xmm3
      jnz .return
    vpcmpgtq xmm3, xmm4, xmm5
    ptest xmm3, xmm3
    jz .no_overflow
        jecxz .error
      movd xmm1, [.this.terms + pcx * 4]
      pmuldq xmm1, xmm1
      psubq xmm4, xmm1
      mov [.this.terms + pcx * 4], 0
      dec ecx
    .no_overflow:
    jecxz .no_compare_prev
      movd xmm2, [.this.terms + pcx * 4]
      .compare_prev:
        movq xmm1, xmm2
        movd xmm2, [.this.terms + (pcx - 1) * 4]
        vpcmpeqd xmm3, xmm1, xmm2
        pslldq xmm3, 12
        ptest xmm3, xmm3
          jz .no_compare_prev
        pmuldq xmm1, xmm1
        psubq xmm4, xmm1
        mov [.this.terms + pcx * 4], 0
      loop .compare_prev
    .no_compare_prev:
    movd xmm1, [.this.terms + pcx * 4]
    paddq xmm4, xmm1
    inc [.this.terms + pcx * 4]
    movd xmm1, [.this.terms + pcx * 4]
    paddq xmm4, xmm1
    cmp ecx, 3
      je @b
    inc ecx
  jmp @b
  .return: ret

  .error:
    @call .this->error()
    ret
endp

