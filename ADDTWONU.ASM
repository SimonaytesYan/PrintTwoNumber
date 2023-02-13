.model tiny
.code

org 100h

Start:	mov ax, 0b800h
	mov es, ax		;set es to videomem seg
	
	mov bx, 160d*20 + 160h/2
	mov ax, 160h
	mov dl, 07eh
	call OutputNum2

	ret
;----------------------------------------------
;Put number in binary form in videomem
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

Next:	mov si, 1
	dec cx
	shl si, cl			;si = 2^(cx-1)

	and si, ax
	shr si, cl;			;si = (ax%(2^cx))/2^cx
	inc cx
	add si, 48			;make char from number
	
	mov word ptr es:[bx],  si	;print 1 or 0
	mov byte ptr es:[bx+1], dl	;put color in vmem
	add bx, 2
	loop Next
	
	ret	
	endp
;----------------------------------------------


end Start
