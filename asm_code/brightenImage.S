
	.data
msg:	.asciz "brightenImage has not been implemented\n"
	
	.text
	.global brightenImage
brightenImage:
	stmfd	sp!,{r4-r11,lr}

	mov	r4, r0		@ Pointer to image
	mov	r0, r1
	bl	atoi
	mov	r8, r0		@ brighten value
	mov	r0, r4		
	ldr	r4,[r0,#12]	@ rows
	ldr	r5,[r0,#16]	@ cols

	ldr	r1,[r0]		@ Load magic number
	cmp	r1,#0x33	@ Magic number = 3?
	moveq	r11,#1		@ set color flag to true
	cmp	r1,#0x36	@ Magic number = 6?
	moveq	r11,#1		@ set color flag to true
	
	cmp	r11,#1		@ If color flag = true
	ldreq	r6,[r0,#20]	@ Load rgb image
	lsleq	r1,r5,#1
	addeq	r5,r5,r1

	ldrne	r6,[r0,#24]	@ Load grayscale image
	mov	r9, #0		@ i = 0

loopi:	
	cmp	r9, r4		@ i >= rows?
	bge	return

	ldr	r7,[r6, r9, lsl #2]	@ load rows[i]
	mov	r10,#0		@ j = 0

loopj:  
	cmp	r10, r5		@ j >= number of pixels
	addge	r9,r9,#1	@ i++
	bge	loopi

	ldrb	r0,[r7,r10]	@ Load 8 bits 
	add	r0,r0,r8	@ pixelValue = pixelValue + brightenValue
	bl	crop

	strb	r0,[r7,r10]	
	add	r10,r10,#1	@ j++
	b	loopj

return:
	ldmfd	sp!,{r4-r11,lr}
	mov	pc,lr

