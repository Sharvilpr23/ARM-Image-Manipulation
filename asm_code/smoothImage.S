	.data
msg:	.asciz "smoothImage has not been implemented\n"
	.align 2
	
	.text
	.globl smooth_pixel
smooth_pixel:
	stmfd	sp!,{r4-r11,lr}

	mov	r8,r0		@ pointer to netImage

	sub	r1,r1,#1	@ rows - 1
	sub	r2,r2,#1	@ cols - 1

	lsl	r3,r2,#1
	add	r3,r2,r3

	ldr	r4,[r8,r1,lsl #2]
	add	r4,r4,r3
	
	ldrb	r0,[r4],#1		@ j - 1
	mov	r5,r0
	ldrb	r0,[r4],#1
	mov	r6,r0
	ldrb	r0,[r4],#1
	mov	r7,r0

	ldrb	r0,[r4],#1		@ 2 x j
	add	r5,r5,r0,lsl #1
	ldrb	r0,[r4],#1
	add	r6,r6,r0,lsl #1
	ldrb	r0,[r4],#1
	add	r7,r7,r0, lsl #1

	ldrb	r0,[r4],#1		@ j + 1
	add	r5,r5,r0
	ldrb	r0,[r4],#1
	add	r6,r6,r0
	ldrb	r0,[r4],#1
	add	r7,r7,r0

	add	r1,r1,#1

	/* (i)th row */
	ldr	r4,[r8,r1,lsl #2]
	add	r4,r4,r3

	ldrb	r0,[r4],#1		@ 2 x (j - 1)
	add	r5,r5,r0,lsl #1	
	ldrb	r0,[r4],#1	
	add	r6,r6,r0,lsl #1
	ldrb	r0,[r4],#1	
	add	r7,r7,r0,lsl #1

	ldrb	r0,[r4],#1		@ 4 x j
	add	r5,r5,r0,lsl #2
	ldrb	r0,[r4],#1
	add	r6,r6,r0,lsl #2
	ldrb	r0,[r4],#1
	add	r7,r7,r0,lsl #2

	ldrb	r0,[r4],#1		@ 2 x (j + 1)
	add	r5,r5,r0,lsl #1
	ldrb	r0,[r4],#1
	add	r6,r6,r0,lsl #1
	ldrb	r0,[r4],#1
	add	r7,r7,r0,lsl #1
	add	r1,r1,#1

	/* (i + 1)th row */
	ldr	r4,[r8,r1,lsl #2]
	add	r4,r4,r3

	ldrb	r0,[r4],#1		@ j - 1
	add	r5,r5,r0
	ldrb	r0,[r4],#1
	add	r6,r6,r0
	ldrb	r0,[r4],#1
	add	r7,r7,r0

	ldrb	r0,[r4],#1		@ 2 x j
	add	r5,r5,r0, lsl #1
	ldrb	r0,[r4],#1
	add	r6,r6,r0, lsl #1
	ldrb	r0,[r4],#1
	add	r7,r7,r0, lsl #1

	ldrb	r0,[r4],#1		@ j + 1
	add	r5,r5,r0
	ldrb	r0,[r4],#1
	add	r6,r6,r0
	ldrb	r0,[r4],#1
	add	r7,r7,r0

	lsr	r5,r5,#4	@ 16 x red	
	lsr	r6,r6,#4	@ 16 x green
	lsr	r7,r7,#4	@ 16 x blue

	/* Crop Red */
	mov	r0,r7
	bl	crop
	mov	r7,r0

	/* Crop Green */
	mov	r0,r6
	bl	crop

	/* Crop Blue */
	mov	r0,r5
	bl	crop

	mov	r1,r6
	mov	r2,r7
	
	ldmfd	sp!,{r4-r11,lr}
	mov	pc,lr

	.globl lrEdges
lrEdges:
	stmfd	sp!,{r4-r11,lr}

	lsl	r10,r3,#1
	add	r10,r10,r3

	mov	r4,#1		@ i = 1

lrloop:	
	cmp	r4,r2		@ i >= rows?
	bge	lrexit

	/* Left */
	/* (i)th row */
	ldr	r5,[r0,r4,lsl#2]
	ldrb	r12,[r5],#1
	mov	r7,r12
	lsl	r7,r7,#2

	ldrb	r12,[r5],#1	
	mov	r8,r12
	lsl	r8,r8,#2

	ldrb	r12,[r5],#1	
	mov	r9,r12
	lsl	r9,r9,#2

	ldrb	r12,[r5],#1
	add	r7,r7,r12,lsl #1 

	ldrb	r12,[r5],#1
	add	r8,r8,r12,lsl #1 

	ldrb	r12,[r5],#1
	add	r9,r9,r12,lsl #1 

	add	r2,r2,#1

	ldr	r5,[r0,r4,lsl #2] 
	ldrb	r12,[r5],#1
	add	r7,r7,r12,lsl #1

	ldrb	r12,[r5],#1
	add	r8,r8,r12,lsl #1

	ldrb	r12,[r5],#1
	add	r9,r9,r12,lsl #1

	ldrb	r12,[r5],#1
	add	r7,r7,r12

	ldrb	r12,[r5],#1
	add	r8,r8,r12

	ldrb	r12,[r5],#1
	add	r9,r9,r12

	sub	r2,r2,#2

	ldr	r5,[r0,r4,lsl #2] 
	ldrb	r12,[r5],#1
	add	r7,r7,r12,lsl #1

	ldrb	r12,[r5],#1
	add	r8,r8,r12,lsl #1

	ldrb	r12,[r5],#1
	add	r9,r9,r12,lsl #1

	ldrb	r12,[r5],#1
	add	r7,r7,r12

	ldrb	r12,[r5],#1
	add	r8,r8,r12

	ldrb	r12,[r5],#1
	add	r9,r9,r12

	add	r2,r2,#1

	ldr	r5,[r1,r4,lsl #2]
	ldr	r6,=0x56

	mul	r7,r6,r7	@ Red
	lsr	r7,#10

	mul	r8,r6,r8	@ Green
	lsr	r8,#10

	mul	r9,r6,r9	@ Blue
	lsr	r9,#10

	strb	r7,[r5],#1	@ Red
	strb	r8,[r5],#1	@ Green
	strb	r9,[r5],#1	@ Blue

	/* Right */
	ldr	r5,[r0,r4,lsl #2]
	sub	r6,r10,#6
	add	r5,r5,r6

	ldrb	r12,[r5],#1
	mov	r7,r12
	lsl	r7,r7,#1

	ldrb	r12,[r5],#1
	mov	r8,r12
	lsl	r8,r8,#1

	ldrb	r12,[r5],#1
	mov	r9,r12
	lsl	r9,r8,#1

	ldrb	r12,[r5],#1
	add	r7,r7,r12, lsl #2

	ldrb	r12,[r5],#1
	add	r8,r8,r12, lsl #2

	ldrb	r12,[r5],#1
	add	r9,r9,r12, lsl #2

	add	r2,r2,#1

	ldr	r5,[r0,r4,lsl #2]
	add	r5,r5,r6

	ldrb	r12,[r5],#1
	add	r7,r7,r12

	ldrb	r12,[r5],#1
	add	r8,r8,r12

	ldrb	r12,[r5],#1
	add	r9,r9,r12

	ldrb	r12,[r5],#1
	add	r7,r7,r12,lsl #1 	

	ldrb	r12,[r5],#1
	add	r8,r8,r12,lsl #1 	

	ldrb	r12,[r5],#1
	add	r9,r9,r12,lsl #1 	

	sub	r2,r2,#2

	ldr	r5,[r0,r4,lsl #2]
	add	r5,r5,r6

	ldrb	r12,[r5],#1
	add	r7,r7,r12

	ldrb	r12,[r5],#1
	add	r8,r8,r12

	ldrb	r12,[r5],#1
	add	r9,r9,r12

	ldrb	r12,[r5],#1
	add	r7,r7,r12,lsl #1 	

	ldrb	r12,[r5],#1
	add	r8,r8,r12,lsl #1 	

	ldrb	r12,[r5],#1
	add	r9,r9,r12,lsl #1 	

	add	r2,r2,#1

	ldr	r6,=0x56

	mul	r7,r6,r7		@ Red
	lsr	r7,#10			

	mul	r8,r6,r8		@ Green
	lsr	r8,#10

	mul	r9,r6,r9		@ Blue
	lsr	r9,#10

	ldr	r5,[r1,r4,lsl #2]

	sub	r12,r10,#3
	add	r5,r5,r12

	strb	r7,[r5],#1		@ Red
	strb	r8,[r5],#1		@ Green
	strb	r9,[r5],#1		@ Blue

	add	r4,r4,#1		@ i++
	b	lrloop

lrexit:
	ldmfd	sp!,{r4-r11,lr}
	
	.globl tbEdges
tbEdges:
	stmfd	sp!,{r4-r11,lr}

	mov	r4,#1		@ i = 1

tbloop:	
	cmp	r4,r3		@ i >= rows?
	bge	tbexit

	/* Top */
	ldr	r5,[r0]
	lsl	r11,r4,#1

	add	r11,r4,r11
	sub	r10,r11,#3
	add	r5,r5,r10

	ldrb	r12,[r5],#1
	mov	r7,r12
	lsl	r7,r7,#2

	ldrb	r12,[r5],#1
	mov	r8,r12
	lsl	r8,r8,#2

	ldrb	r12,[r5],#1
	mov	r9,r12
	lsl	r9,r9,#2

	ldrb	r12,[r5],#1
	add	r7,r7,r12,lsl #2

	ldrb	r12,[r5],#1
	add	r8,r8,r12,lsl #2

	ldrb	r12,[r5],#1
	add	r9,r9,r12,lsl #2

	ldrb	r12,[r5],#1
	add	r7,r7,r12,lsl #1

	ldrb	r12,[r5],#1
	add	r8,r8,r12,lsl #1

	ldrb	r12,[r5],#1
	add	r9,r9,r12,lsl #1

	ldr	r5,[r0,#4]
	add	r5,r5,r10

	ldrb	r12,[r5],#1
	add	r7,r7,r12

	ldrb	r12,[r5],#1	
	add	r8,r8,r12

	ldrb	r12,[r5],#1	
	add	r9,r9,r12

	ldrb	r12,[r5],#1
	add	r7,r7,r12,lsl #1

	ldrb	r12,[r5],#1
	add	r8,r8,r12,lsl #1

	ldrb	r12,[r5],#1
	add	r9,r9,r12,lsl #1

	ldrb	r12,[r5],#1
	add	r7,r7,r12

	ldrb	r12,[r5],#1	
	add	r8,r8,r12

	ldrb	r12,[r5],#1	
	add	r9,r9,r12

	ldr	r6,=0x56

	mul	r7,r6,r7		@ Red
	lsr	r7,#10

	mul	r8,r6,r8		@ Green
	lsr	r8,#10

	mul	r9,r6,r9		@ Blue
	lsr	r9,#10

	ldr	r5,[r1]
	add	r5,r5,r11

	strb	r7,[r5],#1		@ red
	strb	r8,[r5],#1		@ green
	strb	r9,[r5],#1		@ blue

	/* Bottom */
	sub	r2,r2,#1
	ldr	r5,[r0,r2,lsl #2]
	add	r5,r5,r10

	ldrb	r12,[r5],#1
	mov	r7,r12
	lsl	r7,r7,#2

	ldrb	r12,[r5],#1
	mov	r8,r12
	lsl	r8,r8,#2

	ldrb	r12,[r5],#1
	mov	r9,r12
	lsl	r9,r9,#2

	ldrb	r12,[r5],#1
	add	r7,r7,r12,lsl #2

	ldrb	r12,[r5],#1
	add	r8,r8,r12,lsl #2

	ldrb	r12,[r5],#1
	add	r9,r9,r12,lsl #2

	ldrb	r12,[r5],#1
	add	r7,r7,r12,lsl #1

	ldrb	r12,[r5],#1
	add	r8,r8,r12,lsl #1

	ldrb	r12,[r5],#1
	add	r9,r9,r12,lsl #1

	sub	r2,r2,#1

	ldr	r5,[r0,r2,lsl #2]
	add	r5,r5,r10

	ldrb	r12,[r5],#1
	add	r7,r7,r12

	ldrb	r12,[r5],#1	
	add	r8,r8,r12

	ldrb	r12,[r5],#1	
	add	r9,r9,r12

	ldrb	r12,[r5],#1
	add	r7,r7,r12,lsl #1

	ldrb	r12,[r5],#1
	add	r8,r8,r12,lsl #1

	ldrb	r12,[r5],#1
	add	r9,r9,r12,lsl #1

	ldrb	r12,[r5],#1
	add	r7,r7,r12

	ldrb	r12,[r5],#1	
	add	r8,r8,r12

	ldrb	r12,[r5],#1	
	add	r9,r9,r12

	ldr	r6,=0x56

	mul	r7,r6,r7	@ Red
	lsr	r7,#10

	mul	r8,r6,r8	@ Green
	lsr	r8,#10

	mul	r9,r6,r9	@ Blue
	lsr	r9,#10

	add	r2,r2,#1

	ldr	r5,[r1,r2,lsl #2]
	add	r5,r5,r11

	strb	r7,[r5],#1	@ Red
	strb	r8,[r5],#1	@ Green
	strb	r9,[r5],#1	@ Blue

	add	r2,r2,#1
	add	r4,r4,#1	@ i++
	b	tbloop

tbexit:
	ldmfd	sp!,{r4-r11,lr}
	mov	pc,lr

	.globl corners
corners:
	stmfd	sp!,{r4-r11,lr}

	mov	r8,r0		@ pointer to netImage

	lsl	r9,r3,#1
	add	r9,r3,r9
	
	/* Top Left */
	ldr	r3,[r8] 
	ldrb	r0,[r3],#1
	mov	r5,r0
	lsl	r5,r5,#2

	ldrb	r0,[r3],#1
	mov	r6,r0
	lsl	r6,r6,#2

	ldrb	r0,[r3],#1
	mov	r7,r0
	lsl	r7,r7,#2

	ldrb	r0,[r3],#1
	add	r5,r5,r0,lsl #1

	ldrb	r0,[r3],#1
	add	r6,r6,r0,lsl #1

	ldrb	r0,[r3],#1
	add	r7,r7,r0,lsl #1

	ldr	r3,[r8,#4]
	ldrb	r0,[r3],#1
	add	r5,r5,r0,lsl #1

	ldrb	r0,[r3],#1
	add	r6,r6,r0,lsl #1

	ldrb	r0,[r3],#1
	add	r7,r7,r0,lsl #1

	ldrb	r0,[r3],#1
	add	r5,r5,r0

	ldrb	r0,[r3],#1
	add	r6,r6,r0

	ldrb	r0,[r3],#1
	add	r7,r7,r0

	/* Red */
	ldr 	r3,=0x1C71C71D  
	umull   r10,r3,r5,r3
	mov	r5,r3

	/* Green */
	ldr 	r3,=0x1C71C71D 
	umull   r10,r3,r6,r3
	mov	r6,r3

	/* Blue */
	ldr 	r3,=0x1C71C71D 
	umull   r10,r3,r7,r3
	mov	r7,r3

	ldr	r3,[r1]

	strb	r5,[r3],#1	@ Red
	strb	r6,[r3],#1	@ Green
	strb	r7,[r3],#1	@ Blue

	/* Top Right */
	ldr	r3,[r8]
	sub	r0,r9,#6
	add	r3,r3,r0

	ldrb	r0,[r3],#1
	mov	r5,r0
	lsl	r5,r5,#1

	ldrb	r0,[r3],#1
	mov	r6,r0
	lsl	r6,r6,#1

	ldrb	r0,[r3],#1
	mov	r7,r0
	lsl	r7,r7,#1

	ldrb	r0,[r3],#1
	add	r5,r5,r0,lsl #2

	ldrb	r0,[r3],#1
	add	r6,r6,r0,lsl #2

	ldrb	r0,[r3],#1
	add	r7,r7,r0,lsl #2

	ldr	r3,[r8,#4]
	sub	r0,r9,#6
	add	r3,r3,r0

	ldrb	r0,[r3],#1
	add	r5,r5,r0

	ldrb	r0,[r3],#1
	add	r6,r6,r0

	ldrb	r0,[r3],#1
	add	r7,r7,r0

	ldrb	r0,[r3],#1	@ 2 * row[1][col-1]
	add	r5,r5,r0,lsl #1

	ldrb	r0,[r3],#1
	add	r6,r6,r0,lsl #1

	ldrb	r0,[r3],#1
	add	r7,r7,r0,lsl #1

	/* Red */
	ldr 	r3,=0x1C71C71D 
	umull   r10,r3,r5,r3
	mov	r5,r3

	/* Green */
	ldr 	r3,=0x1C71C71D
	umull   r10,r3,r6,r3
	mov	r6,r3

	/* Blue */
	ldr 	r3,=0x1C71C71D
	umull   r10,r3,r7,r3
	mov	r7,r3

	ldr	r3,[r1]
	sub	r0,r9,#3
	add	r3,r3,r0

	strb	r5,[r3],#1	@ Red
	strb	r6,[r3],#1	@ Green
	strb	r7,[r3],#1	@ Blue

	/* Bottom Left */
	sub	r2,r2,#2
	ldr	r3,[r8,r2,lsl #2] 
	ldrb	r0,[r3],#1
	mov	r5,r0
	lsl	r5,r5,#1

	ldrb	r0,[r3],#1
	mov	r6,r0
	lsl	r6,r6,#1

	ldrb	r0,[r3],#1
	mov	r7,r0
	lsl	r7,r7,#1

	ldrb	r0,[r3],#1
	add	r5,r5,r0

	ldrb	r0,[r3],#1
	add	r6,r6,r0

	ldrb	r0,[r3],#1
	add	r7,r7,r0

	add	r2,r2,#1

	ldr	r3,[r8,r2,lsl #2]
	ldrb	r0,[r3],#1
	add	r5,r5,r0,lsl #2

	ldrb	r0,[r3],#1
	add	r6,r6,r0,lsl #2

	ldrb	r0,[r3],#1
	add	r7,r7,r0,lsl #2

	ldrb	r0,[r3],#1	@ + 2 * [rows-1][1]
	add	r5,r5,r0,lsl #1

	ldrb	r0,[r3],#1
	add	r6,r6,r0,lsl #1

	ldrb	r0,[r3],#1
	add	r7,r7,r7,lsl #1

	/* Red */
	ldr 	r3,=0x1C71C71D
	umull   r10,r3,r5,r3
	mov	r5,r3

	/* Green */
	ldr 	r3,=0x1C71C71D 
	umull   r10,r3,r6,r3
	mov	r6,r3

	/* Blue */
	ldr 	r3,=0x1C71C71D 
	umull   r10,r3,r7,r3
	mov	r7,r3

	ldr	r3,[r1,r2,lsl #2]

	strb	r5,[r3],#1	@ Red
	strb	r6,[r3],#1	@ Green
	strb	r7,[r3],#1	@ Blue

	/* Bottom Right */
	sub	r2,r2,#1
	ldr	r3,[r8,r2,lsl #2]
	sub	r0,r9,#6
	add	r3,r3,r0

	ldrb	r0,[r3],#1
	mov	r5,r0

	ldrb	r0,[r3],#1
	mov	r6,r0

	ldrb	r0,[r3],#1
	mov	r7,r0

	ldrb	r0,[r3],#1
	add	r5,r5,r0,lsl #1

	ldrb	r0,[r3],#1
	add	r6,r6,r0,lsl #1

	ldrb	r0,[r3],#1
	add	r7,r7,r0,lsl #1

	add	r2,r2,#1

	ldr	r3,[r8,r2,lsl #2]
	sub	r0,r9,#6
	add	r3,r3,r0

	ldrb	r0,[r3],#1	
	add	r5,r5,r0,lsl #1

	ldrb	r0,[r3],#1	
	add	r6,r6,r0,lsl #1

	ldrb	r0,[r3],#1	
	add	r7,r7,r0,lsl #1

	ldrb	r0,[r3],#1
	add	r5,r5,r0,lsl #2

	ldrb	r0,[r3],#1	
	add	r6,r6,r0,lsl #2

	ldrb	r0,[r3],#1	
	add	r7,r7,r0,lsl #2

	/* Red */
	ldr 	r3,=0x1C71C71D
	umull   r10,r3,r5,r3
	mov	r5,r3

	/* Green */
	ldr 	r3,=0x1C71C71D
	umull   r10,r3,r6,r3
	mov	r6,r3

	/* Blue */
	ldr 	r3,=0x1C71C71D 
	umull   r10,r3,r7,r3
	mov	r7,r3

	ldr	r3,[r1,r2,lsl #2]
	sub	r0,r9,#3
	add	r3,r3,r0

	strb	r5,[r3],#1	@ Red
	strb	r6,[r3],#1	@ Green
	strb	r7,[r3],#1	@ Blue
	
	ldmfd	sp!,{r4-r11,lr}
	mov	pc,lr

	.global smoothImage
smoothImage:
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
	ldreq	r0,=msg	
	bleq	printf

	sub	r4,r4,#1	@ rows - 1
	sub	r5,r5,#1	@ cols - 1
	mov	r8, #1		@ i = 0

loopi:
	cmp	r8,r4		@ i >= rows?
	bge	continue

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
	bl	smooth_pixel

	strb	r0,[r10],#1	@ red
	strb	r1,[r10],#1	@ green
	strb	r2,[r10],#1	@ blue

	add	r9,r9,#1	@ j++
	b	loopj
	
continue:
	add	r4,r4,#1	@ rows + 1
	add	r5,r5,#1	@ cols + 1

	mov	r0,r6
	mov	r1,r7
	mov	r2,r4
	mov	r3,r5
	bl	corners

	mov	r0,r6
	mov	r1,r7
	mov	r2,r4
	mov	r3,r5
	bl	lrEdges
	
	mov	r1,r4
	mov	r0,r6
	bl	free_image

	ldr	r0,[sp]
	str	r7,[r0,#20]

	add	sp,sp,#4

	ldmfd	sp!,{r4-r11,lr}
	mov	pc,lr
