	.data
msg:	.asciz "Unable to allocate space for tmp image\n"
	.align 2

	.text
	.globl sharpen_pixel
sharpen_pixel:
	stmfd	sp!,{r4-r11,lr}

	mov	r3,#3
	mul	r2,r2,r3		@ 3 x j
	ldr	r3,[r0,r1,lsl #2] 	@ Load rows[i]
	add	r3,r3,r2		@ rows[i] + 3 x j

	ldrb	r5,[r3],#1	@ Load Red[i,j]
	ldrb	r6,[r3],#1	@ Load Green[i,j]
	ldrb	r7,[r3],#1	@ Load Blue[i,j]

	lsl	r8,r5,#2
	add	r5,r5,r8	@ 5 x Red[i,j]

	lsl	r8,r6,#2
	add	r6,r6,r8	@ 5 x Green[i,j]

	lsl	r8,r7,#2
	add	r7,r7,r8	@ 5 * Blue[i,j]

	/* P[i, j+1] */
	ldrb	r9,[r3],#1
	sub	r5,r5,r9
	ldrb	r9,[r3],#1
	sub	r6,r6,r9
	ldrb	r9,[r3],#1
	sub	r7,r7,r9

	/* P[i, j-1] */
	sub	r4,r4,#9
	ldrb	r9,[r3],#1	
	sub	r5,r5,r9
	ldrb	r9,[r3],#1
	sub	r6,r6,r9
	ldrb	r9,[r3],#1
	sub	r7,r7,r9

	/* P[i-1, j] */
	sub	r1,r1,#1
	ldr	r3,[r0,r1,lsl#2]
	add	r3,r3,r2
	ldrb	r9,[r3],#1	
	sub	r5,r5,r9
	ldrb	r9,[r3],#1
	sub	r6,r6,r9
	ldrb	r9,[r3],#1
	sub	r7,r7,r9

	/* P[i+1, j] */
	add	r1,r1,#2
	ldr	r3,[r0,r1,lsl#2]
	add	r3,r3,r2
	ldrb	r9,[r3],#1	
	sub	r5,r5,r9
	ldrb	r9,[r3],#1
	sub	r6,r6,r9
	ldrb	r9,[r3],#1
	sub	r7,r7,r9

	/* Crop red */
	mov	r0,r6
	bl	crop
	mov	r6,r0

	/* Crop blue */
	mov	r0,r7
	bl	crop
	mov	r7,r0

	/* Crop green */
	mov	r0,r5
	bl	crop
	mov	r1,r6
	mov	r2,r7

	ldmfd	sp!,{r4-r11,lr}
	mov	pc,lr

	.globl sharpenImage
sharpenImage:
	stmfd	sp!,{r4-r11,lr}

	sub	sp,sp,#4
	str	r0,[sp]		@ pointer to netImage

	ldr	r4,[r0,#12]	@ rows
	ldr	r5,[r0,#16]	@ cols
	ldr	r6,[r0,#20]	@ pointer to image

	mov	r0,r4
	mov	r1,r5
	bl	allocate_color

	mov	r7,r0		@ pointer to temp image

	cmp	r0,#0
	bleq	errmsg

	sub	r4,r4,#1	@ rows - 1
	sub	r5,r5,#1	@ cols - 1

	mov	r8, #1		@ i = 1

loopi: 
	cmp	r8,r4		@ i > rows?
	bge	lredges

	ldr	r10,[r7,r8,lsl #2]	@ Load temp[i]
	add	r10,r10,#3

	mov	r9,#1		@ j = 1

loopj:	
	cmp	r9,r5		@ j > cols?
	addge	r8,r8,#1	@ i++
	bge	loopi

	mov	r0,r6		@ pointer to image
	mov	r1,r8		@ rows
	mov	r2,r9		@ cols
	bl	sharpen_pixel

	strb	r0,[r10],#1
	strb	r1,[r10],#1
	strb	r2,[r10],#1

	add	r9,r9,#1	@ j++
	b	loopj
	
lredges:
	lsl	r0,r5,#1
	add	r9,r5,r0	@ 3 x (cols - 1)

	mov	r8, #1		@ i = 1

lrloop:	
	cmp	r8,r4			@ i > rows?
	bge	tbedges

	ldr	r10,[r7,r8,lsl #2] 	@ Load rows[i]
	add	r11,r10,#3

	ldrb	r0,[r11],#1
	strb	r0,[r10],#1

	ldrb	r0,[r11],#1
	strb	r0,[r10],#1

	ldrb	r0,[r11],#1
	strb	r0,[r10],#1

	sub	r10,r10,#3
	add	r10,r10,r9
	sub	r11,r10,#3

	ldrb	r0,[r11],#1
	strb	r0,[r10],#1

	ldrb	r0,[r11],#1
	strb	r0,[r10],#1

	ldrb	r0,[r11],#1
	strb	r0,[r10],#1

	add	r8,r8,#1	@ i++
	b	lrloop

tbedges:
	mov	r9, #1		@ i = 1
	sub	r0,r4,#1	@ rows - 2
	
	ldr	r10,[r7]		@ Load rows[0]
	ldr	r11,[r7,r9,lsl #2] 	@ load rows[1]
	ldr	r2,[r7,r4,lsl #2]  	@ load rows[rows-1]
	ldr	r3,[r7,r0,lsl #2] 	@ load rows[rows-2]
	
	add	r10,r10,#3
	add	r11,r11,#3
	add	r2,r2,#3
	add	r3,r3,#3

tbloop:	
	cmp	r9,r5		@ i > rows?
	bge	corners

	ldrb	r0,[r11],#1
	strb	r0,[r10],#1

	ldrb	r0,[r3],#1
	strb	r0,[r2],#1

	ldrb	r0,[r11],#1
	strb	r0,[r10],#1

	ldrb	r0,[r3],#1
	strb	r0,[r2],#1

	ldrb	r0,[r11],#1
	strb	r0,[r10],#1

	ldrb	r0,[r3],#1
	strb	r0,[r2],#1

	add	r9,r9,#1	@ j++
	b	tbloop

corners:
	/* Top Left */
	ldr 	r1,[r7]		
	ldr	r2,[r7,#4]	
	add	r2,r2,#3	
	ldrb	r0,[r2],#1
	strb	r0,[r1],#1
	ldrb	r0,[r2],#1
	strb	r0,[r1],#1
	ldrb	r0,[r2],#1
	strb	r0,[r1],#1

	/* Top Right */
	ldr	r1,[r7]
	ldr	r2,[r7,#4]
	lsl	r3,r5,#1
	add	r8,r3,r5
	add	r1,r1,r8
	sub	r8,r8,#3
	add	r2,r2,r8
	add	r8,r8,#3
	ldrb	r0,[r2],#1
	strb	r0,[r1],#1
	ldrb	r0,[r2],#1
	strb	r0,[r1],#1
	ldrb	r0,[r2],#1
	strb	r0,[r1],#1

	/* Bottom Left */
	ldr	r2,[r7,r4,lsl#2]
	sub	r0,r4,#1
	ldr	r1,[r7,r0,lsl#2]
	add	r1,r1,#3
	ldrb	r0,[r1],#1
	strb	r0,[r2],#1
	ldrb	r0,[r1],#1
	strb	r0,[r2],#1
	ldrb	r0,[r1],#1
	strb	r0,[r2],#1

	/* Bottom Right */
	sub	r1,r1,#6
	sub	r2,r2,#3
	add	r1,r1,r8
	sub	r1,r1,#6
	add	r2,r2,r8
	ldrb	r0,[r1],#1
	strb	r0,[r2],#1
	ldrb	r0,[r1],#1
	strb	r0,[r2],#1
	ldrb	r0,[r1],#1
	strb	r0,[r2],#1

	add	r1,r4,#1	@ (rows - 2) + 2
	mov	r0,r6		@ Original image
	bl	free_image

	ldr	r0,[sp]		@ Load netImage
	str	r7,[r0,#20]

	add	sp,sp,#4
	ldmfd	sp!,{r4-r11,lr}
	mov	pc,lr

errmsg:
	ldr	r0,=msg
	bl	printf

return:
	ldmfd	sp!, {r4-r11, lr}
	mov	pc, lr
