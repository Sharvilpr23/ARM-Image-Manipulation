	.data
msg:	.asciz "grayscaleImage has not been implemented\n"
	
	.text
	.global rgb_to_grayscale
rgb_to_grayscale: 
	stmfd	sp!, {r4-r12,lr}
    
	sub	sp, sp, #2    	
	mov	r6, r0		@ rgb image pointer
	mov	r7, r3		@ grayscale image pointer
	mov	r9, r1		@ rows
	mov	r10, r2		@ cols
	mov	r1, #255	@ minimum
	strb	r1, [sp]
	mov	r1, #0		@ maximum
	strb	r1, [sp, #1]

	mov	r5, #0		@ i = 0
	
loopi:	cmp	r5, r9		@ i >= rows?
	bge	exit

	ldr	r8, [r6, r5, lsl #2]	    @ Load rows[i] of color image
	ldr	r11, [r7, r5, lsl #2]	    @ Load rows[i] of grayscale image

	mov	r4, #0		@ j = 0

loopj:	
	cmp	r4, r10		@ j >= cols
	addge 	r5, r5, #1	@ i++
	bge	loopi
	
	/* Red Value */
	ldrb	r2, [r8], #1		    
	mov	r3, #54
	mul	r2, r2, r3	@ 54 x red ( 54 / 256 = 0.21)
	
	/* Green Value*/
	ldrb	r3, [r8], #1		   
	mov	r1, #184
	mul	r3, r1, r3	@ 184 x green ( 184 / 256 = 0.72)
	
	/* Blue Value */
	ldrb	r1, [r8], #1		    
	mov	r12, #18
	mul	r1, r12, r1	@ 18 x blue ( 18 / 256 = 0.07)

	/* Grayscale Value */
	add	r2, r3, r2	@ (54 x red + 184 x green)
	add	r2, r2, r1	@ pixelValue = ((54 x red + 184 x green) + 18 x blue) 
	lsr	r0, r2, #8	@ pixelValue / 256
	bl	crop
	
	ldr	r1, [sp]	@ Load minimum
	ldr	r2, [sp, #1]	@ Load maximum

	cmp	r0, r1		@ if pixelValue < minimum
	strlt	r0, [sp]

	cmp	r0, r2		@ if pixelValue > maximum
	strgt   r0, [sp, #1]
	
	strb	r0, [r11, r4]	@ Store back in grayscale array	    
	add	r4, r4, #1	@ j++
	b	loopj

exit:				
	mov	r0, #2
	bl	malloc
	
	ldrb	r1, [sp]
	ldrb	r2, [sp, #1]

	strb	r1, [r0]
	strb	r2, [r0, #1]	

	add	sp, sp, #2
	ldmfd	sp!, {r4-r12, lr } 
	mov	pc, lr  

	.global grayscaleImage	
grayscaleImage:
	stmfd	sp!,{r4-r8,lr}
	
	mov	r4, r0
	ldrb	r0, [r4]
	
	cmp	r0, #0x32	@ Magic number = 2?
	beq	return 
	cmp	r0, #0x34	@ Magic number = 4?
	beq	return

	cmp	r0, #0x33	@ Magic number = 3?
	beq	colorImage
	cmp	r0, #0x36	@ magic number = 6?
	beq	colorImage

	b	errmsg
	
colorImage:
	sub	r0, r0, #1
	mov	r7, r0
	
	strb	r7, [r4]	

	ldr	r0, [r4, #12]	@ rows
	ldr	r1, [r4, #16]	@ cols

	/* Allocate memory for grayscale image */
	mov	r5, r0
	mov	r6, r1	
	bl	allocate_grayscale	

	str	r0, [r4, #24]	@ Store grayscale image
	mov	r3, r0	
	
	ldr	r0, [r4, #20]	@ Load pointer to rgb image
		
	mov	r1, r5		@ rows
	mov	r2, r6		@ cols

	bl	rgb_to_grayscale
	b	return	
		
errmsg:		
	ldr	r0,=msg
	bl	printf

return:
	ldmfd	sp!,{r4-r8,lr}
	mov	pc,lr
