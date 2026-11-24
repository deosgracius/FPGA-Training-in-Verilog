; Deo Mwala - Final Project test program
; Part 1: give the registers used by the instruction listing known values
start:
	ld	r2, #10
	ld	r4, #100
	ld	r5, #3
	ld	r7, #0
	ld	r8, #5
	ld	r10, #$F0F0F0F0
	ld	r12, #$12345678
	ld	r14, #$FF00FF00
	ld	r15, #$0F0F0F0F
	ld	r17, #$FFFFFFFF
	ld	r19, #$AAAAAAAA
	ld	r20, #$0F0F0F0F
	ld	r22, #$55555555
	ld	r24, #$80000000
	ld	r25, #1
	ld	r27, #$80000040
	ld	r29, #3
	ld	r30, #4
; Part 2: the example instruction listing, every instruction and addressing mode
	ld	r1, #$ABCDEF12
	ld  	r1, $200
	st	r1, $200
    	add	r31, r8, r10
	add	r1, r2, #1
	sub	r3, r4, r5 		; r3=r4-r5
	sub	r6, r7, #1 		; r6=r7-1
	not	r9, r10  		; r9=~r10
	xor	r11, r12, #$DEADBEEF
	xor	r13, r14, r15
	and	r16, r17, #1
	and	r18, r19, r20
	or	r21, r22, #$AAAAAAAA
	or	r23, r24, r25
	sr	r26, r27, #1 		; r26=r27>>1
	sr	r26, r27, r5 		; r26=r27>>r5
	sl	r28, r29, #1 		; r28=r29<<1
	sl	r28, r29, r30 		; r28=r29<<r30
; Part 3: hazards, store and load through the RAM, then the branches
	ld	r20, #9		; r20 is written, then read right away by the next two
	sl	r21, r25, r20	; r21 = r25 << r20 = 1 << 9 (second source just written)
	add	r22, r21, r20	; r22 = r21 + r20 (both sources just written)
	ld	r3, #$FF
	not	r3, r3		; r3 = ~r3, read right after it was written
	st	r31, $5		; RAM[5] = r31
	ld	r0, $5		; r0 = RAM[5]
	add	r0, r0, #0	; r0 read right after the load; sets Z=0 since r0 is not zero
	bnz	#skip1		; taken
	ld	r9, #$BAD	; must be skipped
	ld	r10, #$BAD	; must be skipped
skip1:
	sub	r6, r6, r6	; r6=0, sets Z=1
	bz	#skip2		; taken
	ld	r9, #$BAD	; must be skipped
	ld	r12, #$BAD	; must be skipped
skip2:
	bnz	#bad		; not taken, Z is still 1
	bra	#skip3		; always taken
bad:
	ld	r9, #$BAD	; must be skipped
	ld	r14, #$BAD	; must be skipped
skip3:
	ld	r7, #halt	; branch target in a register
	bra	r7		; register mode branch, r7 just written
	ld	r9, #$BAD	; must be skipped
	ld	r15, #$BAD	; must be skipped
halt:
	bra	#halt		; stay here
