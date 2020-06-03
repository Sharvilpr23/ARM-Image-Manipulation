		.data
msg:		.asciz "contrastImage has not been implemented\n"
		.align 2
	
		.text
		.global 
contrastImage:
		stmfd	sp!, {r4-r10,lr}
		vstmdb	sp!, {d8}

		mov	r4, r0			@ Pointer to image
		mov	r5, r1			@ rows	
		mov	r6, r2			@ cols
    
	    	ldrb	r2, [r3]	    	@ Load minimum
		ldrb	r7, [r3, #1]		@ Load maximum

		cmp	 r7, r2		    	@ maximum = minimum?
		moveq	 r0, #1
		vmoveq.f32 s0, r0
		beq	 skipScale

		sub		r1, r2, r7	@ maximum - minimum
		vmov.f32	s1, r1
		mov		r3, #256
		sub		r3, r3, #1
		vmov.f32	s0, r3
		vdiv.f32	s16, s0, s1
		vmov.f32	s17, r7		@ minimum

skipScale:
		mov		r8, #0		@ i = 0
		
loopi:		
		cmp	r8, r5			@ i >= rows?
		bge	exiti

		ldr	r10, [r4, r8, lsl #2]	@ Get right column
		mov	r9, #0			@ j = 0

loopj:	    	
		cmp	r9, r6			@ j >= cols?
		bge	exitj

		ldrb	    r0, [r10, r9]	@ Load grayscale value

calculation:		
		vmov.f32    s0, r0
		vsub.f32    s0, s0, s17		@ pixelValue - minimum
		vmul.f32    s0, s0, s16		@ scale x ( pixelValue - minimum)
		
		/* Get 0.5 */
		mov	    r0, #1
		vmov.f32    s1, r0
		mov	    r0, #2
		vmov.f32    s2, r0
		vdiv.f32    s1, s1, s2
	    
		vadd.f32    s0, s0, s2		@ scale x ( pixelValue - minimum ) + 0.5
		vmov.u32    r0, s0
		bl	    crop

		strb	    r0, [r10, r9]	@ Store the value back
		add	    r9, r9, #1		@ j++
		b	    loopj

exitj:
		add	    r8, r8, #1 		@ i++
		b	    loopi

exiti:	
		mov	    r8, #0

		vldmia	sp!, {d8}
		ldmfd	sp!, {r4-r10,lr} 
		mov	pc, lr	

		.global	contrastImage
contrastImage: 
	stmfd	sp!,{r4-r6,lr}
	
	mov	r4, r0		@ Pointer to image
	ldrb	r0, [r4]	@ Load image in r0
	
	cmp	r0, #0x32	@ Magic number = 2?
	beq	return
	cmp	r0, #0x34	@ Magic number = 4?
	beq	return

	cmp	r0, #0x33	@ Magic number = 3?
	beq	colorImage
	cmp	r0, #0x36	@ Magic number = 6?
	beq	colorImage

	b	errmsg
	
colorImage:
	mov	r0, r4
	bl	grayscaleImage	    @ Grayscale the image
 
	mov	r3, r0
	ldr	r0, [r4,#24]	    @ Pointer to grayscale image
	ldr	r1, [r4,#12]	    @ rows
	ldr	r2, [r4,#16]	    @ cols

	bl	imageOperation		
	b	return	

errmsg:		
	ldr	r0,=msg
	bl	printf
	
return:
	ldmfd	sp!,{r4-r6, lr}
	mov	pc,lr
