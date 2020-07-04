	.data

	.text
	.globl allocate_grayscale
allocate_grayscale:
	stmfd	sp!,{r4-r7,lr}

	mov	r4,r0	 	@ rows
	mov	r5,r1		@ cols

	lsl	r0,r0,#2	@ rows x 4	
	bl	malloc

	mov	r7,r0		@ Store row pointer
	cmp	r0,#0
	beq	grayscale_exit

	mov	r6,#0		@ i = 0

grayscale_loop:
	cmp	r6,r4		@ i >= rows?
	bge	grayscale_exit

	mov	r0,r5		@ cols x 1
	bl	malloc

	cmp	r0,#0
	beq	grayscale_exit

	str	r0,[r7,r6,lsl #2] 	@ Store rows[i]
	add	r6,r6,#1		@ i++
	b	grayscale_loop
	
grayscale_exit:	
	mov	r0,r7
	ldmfd	sp!,{r4-r7,lr}
	mov	pc,lr

	.globl allocate_color
allocate_color:
	stmfd	sp!,{r4-r7,lr}

	mov	r4,r0	 	@ rows

	lsl	r2,r1,#1	
	add	r5,r1,r2	@ cols x 3

	lsl	r0,r0,#2	
	bl	malloc

	mov	r7,r0		@ Store row pointer
	cmp	r0,#0
	beq	color_exit

	mov	r6,#0		@ i = 0

color_loop:	
	cmp	r6,r4		@ i >=rows?
	bge	color_exit

	mov	r0,r5		@ cols x 3
	bl	malloc

	cmp	r0,#0
	beq	color_exit

	str	r0,[r7,r6,lsl #2] 	@ Store rows[i]
	add	r6,r6,#1		@ i++
	b	color_loop
	
color_exit:	
	mov	r0,r7
	ldmfd	sp!,{r4-r7,lr}
	mov	pc,lr

	.globl free_image
free_image:
	stmfd	sp!,{r4-r6,lr}

	mov	r4,r0		@ pointer to image
	mov	r5,r1	 	@ rows

	mov	r6,#0		@ i = 0

free_loop:	
	cmp	r6,r5		@ i >= rows?
	bge	free_exit

	ldr	r0,[r4,r6,lsl #2] 	@ Load rows[i]
	bl	free		@ free row[i]

	add	r6,r6,#1	@ i++
	b	free_loop

free_exit:	
	mov	r0,r4
	bl	free

	ldmfd	sp!,{r4-r6,lr}
	mov	pc,lr

