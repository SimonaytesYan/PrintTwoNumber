.model tiny
.code
locals __

org 100h

Start:	mov ax, 0b800h
	mov es, ax		;set es to videomem seg
	
	call GetNum

	mov bx, 160d*17 + 160h/2 + 1
	mov cl, 07eh
	push ax			;save ax
	call OutputNum10
	pop ax
	
	mov dl, 07eh
	mov bx, 160d*18 + 160h/2 + 1
	call OutputNum16

	mov bx, 160d*19 + 160h/2
	call OutputNum2
	ret
;-------------------------------------------
;Get number from cmd
;
;Expects:	label named buffer
;
;Entry:		None
;
;Output:	ax - number
;
;Destroys:	cx, dx, ax
;
;-------------------------------------------
GetNum	proc
	
	lea dx, buffer
	mov ah, 0ah
	int 21h			;get number from cml
	
	xor cx, cx
	mov cl, buffer[1]	;get length of number

	xor ax, ax
	mov dx, 10d
	mov si, 2h
	
	__Next:	mul dl			;ax = ax*10
		mov dh, si + buffer	;put in dh next simbol
		sub dh, 48d		;convert simbol to number
		add al, dh		;ax += dh
		
		inc si
		loop __Next
	ret
	endp

;-------------------------------------------

;-------------------------------------------
;Put number in dec form in videomem
;
;Expects:	es->Videomem
;
;Entry:		bx - offset in videomem
;		ax - number for output
;		cl - color atr for output
;
;Output:	None
;
;Destroys:	si, di, dx, ax, bx
;
;-------------------------------------------
OutputNum10	proc
	xor si, si
	mov di, 10d

	Next:	xor dx, dx
		div di				;ax = ax/10 
						;dl = ax%10
		
		add dl, 48d			;make symbol from num
		
		mov byte ptr es:[bx-1], dl	;put symbol in vmem
		mov byte ptr es:[bx],   cl	;put color in vmem
		
		xor ah, ah
		sub bx, 2
		inc si

		cmp si, 5
		jl Next
	ret
	endp

;----------------------------------------------
;Put number in hex form in videomem
;
;Expects:	es->VideoMem
;
;Entry:		bx - offset in videomem
;		ax - number to output
;		dl - color atr to output
;
;Output:	None
;
;Destroys:	si, bx, cx
;
;----------------------------------------------
OutputNum16	proc
	xor cx, cx
	__Next:					;do
		mov si, 000fh
	
		shl cl, 2			;cl = cl*4
	
		shl si, cl
		and si, ax
		shr si, cl
		add si, 48d			;number to symbol
	
		shr cl, 2			;cl = cl/4
	
		cmp si, 58
		jl Is_0_9
		add si, 7			; if(si > 58) si +=7
	Is_0_9:
	
		mov word ptr es:[bx-1], si	;put symb in vmem
		mov byte ptr es:[bx], dl	;put color in vmem
		sub bx, 2			;bx -= 2
	
		inc cx				;cx++
		cmp cx, 4h			;while(cx < 4)
		jl __Next
		
	ret
	endp
;----------------------------------------------

;----------------------------------------------
;Put number in binary form in videomem
;
;Expects:	es->VideoMem
;
;Entry: 	bx - offset in videomem
;		ax - number to output
;		dl - color atr to output
;
;Output: 	None
;
;Destroys:	bx,cx,si
;----------------------------------------------
OutputNum2	proc
	
	mov cx, 10h		;set number of bits in number

	__Next:	mov si, 1
		dec cx
		shl si, cl			;si = 2^(cx-1)

		and si, ax
		shr si, cl;			;si = (ax%(2^cx))/2^cx
		inc cx
		add si, 48			;make char from number
	
		mov word ptr es:[bx],  si	;print 1 or 0
		mov byte ptr es:[bx+1], dl	;put color in vmem
		add bx, 2
		loop __Next
	
	ret	
	endp
;----------------------------------------------

.data 
	buffer db 5, ?, 5 dup(' ')

end Start
