.model tiny
.code
locals __

org 100h

Start:	mov ax, 0b800h
	mov es, ax		;set es to videomem seg
	
	mov bx, 160d*20 + 160h/2 + 1
	mov ax, 0CDEFh
	mov dl, 07eh
	
	;call OutputNum16
	;call OutputNum2

	ret
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


end Start
