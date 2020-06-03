
	.data
msg:	.asciz "negateImage has not been implemented\n"
	
	.text
	.global negateImage
negateImage:	
	stmfd	sp!,{r4-r11, lr}
	mov	r8, r0		@ store pointer to image
	ldr	r4, [r0, #12]	@ rows
	ldr	r5, [r0, #16]	@ columns
	
	ldr	r1, [r0]	@ Load Magic number
	cmp	r1, #0x33	@ Magic number = 3?
	moveq	r11, #1		@ Set color flag to true
	cmp	r1, #0x36	@ Magic number = 6?
	moveq	r11, #1		@ Set color flag to true

	cmp	r11, #1		@ If color flag is set
	ldreq	r6, [r8, #20]	@ Store the rgb pixel image
	lsleq	r0, r5, #1	
	addeq	r5, r5, r0	@ 3 * cols = 2 * cols + cols
	ldrne	r6, [r8, #24]	@ Store unsigned char **grayscale image
	mov	r9, #0		@ i = 0
	mov 	r11, #255	@ Maximum pixel value

loopi:
	cmp	r9, r4		@ if i >= rows
	bge	return	
	
	ldr	r7, [r6, r9, lsl #2]	@ Load pointer to row[i]
	mov	r10, #0		@ j = 0

loopj:
	cmp 	r10, r5		@ if j >= number of pixels
	addge	r9, r9, #1	@ i++
	bge	loopi

	ldrb	r0, [r7, r10]	@ Load a byte
	sub	r0, r11, r0	@ pixelValue = 255 - pixelValue
	bl 	crop

	strb	r0, [r7, r10]	@ Store new pixelValue
	add 	r10, r10, #1	@ j++
	b 	loopj
		
errmsg:
	ldr	r0,=msg
	bl	printf

return:
	ldmfd	sp!,{r4-r11, lr}
	mov	pc,lr
