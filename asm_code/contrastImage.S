	.data
msg:	.asciz "contrastImage has not been implemented\n"
	
	.text
	.globl contrast_pixel
contrast_pixel:
	stmfd		sp!,{lr}

	sub		r0,r0,r1	@ pixelValue - minimum
	vmov		s1,r0
	vcvt.f32.u32	s1,s1
	vmul.f32	s0,s1,s0	@ scale x (pixelValue - minimum)

	mov		r2,#1
	mov		r3,#2
	vmov		s2,r2
	vmov		s3,r3
	vcvt.f32.u32	s2,s2
	vcvt.f32.u32	s3,s3
	vdiv.f32	s2,s2,s3	@ 0.5
	vadd.f32	s0,s0,s2	@ scale x (pixelValue - minimum) + 0.5
	vcvt.u32.f32	s0,s0
	vmov		r0,s0
	bl		crop

	ldmfd		sp!,{lr}
	mov		pc,lr

	.globl scale
scale:
	mov		r2,#255
	vmov		s1,r2
	vcvt.f32.u32 	s1,s1
	sub		r0,r1,r0	@ maximum - minimum
	vmov		s0,r0
	vcvt.f32.u32 	s0,s0
	vdiv.f32	s0,s1,s0	@ 255 / (maximum - minimum)
	mov		pc,lr

	.globl contrastImage
contrastImage:	
	stmfd	sp!,{r4-r11,lr}
	vpush	{d8}

	mov	r8,r0		@ pointer to netImage
	bl	grayscaleImage

	mov		r11,r0		@ minimum

	cmp		r0,r1		@ minimum = maximum?
	/* If True */
	moveq		r2,#1		@ scaling factor = 1
	vmoveq		s16,r2
	vcvteq.f32.u32  s16,s16
	/* If False */
	blne		scale
	vmovne.f32	s16,s0
	
	ldr	r4,[r8,#12]	@ rows
	ldr	r5,[r8,#16]	@ cols
	ldr	r6,[r8,#24]	@ pointer to image

	mov	r9, #0		@ i = 0

loopi:	
	cmp	r9, r4			@ i >= rows?
	bge	return
	
	ldr	r7,[r6, r9, lsl #2]	@ Load rows[i]
	mov	r10,#0			@ j = 0

loopj:  
	cmp	r10, r5		@ j >= cols?
	addge	r9,r9,#1	@ i++
	bge	loopi

	ldrb	r0,[r7,r10]	@ Load a byte of memory 
	mov	r1,r11		@ Load minimum
	vmov.f32 s0,s16		@ Load scaling factor
	bl	contrast_pixel

	strb	r0,[r7,r10]
	add	r10,r10,#1	@ j++
	b	loopj

return:	
	vpop	{d8}
	ldmfd	sp!,{r4-r11,lr}
	mov	pc,lr
	

	
