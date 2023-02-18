.model tiny
.code
locals __

org 100h

Start:	mov ax, 0b800h
	mov es, ax		;set es to videomem seg
	
	call GetNum		;scanf("%d", ax)
	push ax

	mov ah, 02h
	mov dl, 0ah
	int 21h			;printf("\n");

	call GetNum		;scanf("%d", ax)
	pop bx
	add ax, bx
	
	mov ch, 0ah								;green on black
	mov bx, 160d*4 + 160d/2 + 13*2d
	lea si, abplus
	mov bp, 3
	call OutputStr							;printf("a+b");

	mov bx, 160d*6 + 160d/2 - 8d
	lea si, decimal
	mov bp, 3
	call OutputStr							;printf("dec");
	
	mov bx, 160d*7 + 160d/2 - 8d
	lea si, hex
	mov bp, 3
	call OutputStr							;printf("hex");
	
	mov bx, 160d*8 + 160d/2 - 8d
	lea si, bin
	mov bp, 3
	call OutputStr							;printf("bin");
	
	push ax

	mov bx, 160*5 + 160d/2 - 2d
	mov ch, 3h								;height
	mov cl, 10h								;weight
	mov dh, 0ah								;green on black
	call DrawFrame

	pop ax

	push ax										;save ax
	mov  bx, 160d*6 + 160d/2 + 16*2d;
	mov  ch, 7ah								;green on gray
	call OutputNum10
	pop ax
	
	mov dh, 6ah								;green on brown
	mov bx, 160d*7 + 160d/2 + 16*2d;
	call OutputNum16

	mov dh, 7ah								;green on gray
	mov bx, 160d*8 + 160d/2
	call OutputNum2


	ret

;------------------------------------------------
;Put text form var in vmem
;
;Expects: es->videomem
;
;Inputs: bx - offset
;		 ch - color atribut
;		 si - pointer to variable with text
;		 bp - length of string in var
;
;Output: None
;
;Destroys: si, bx, bp, cl
;------------------------------------------------

OutputStr	proc

	add bp, si
	__next:										;
		mov cl, [si]							;
		mov word ptr es:[bx], cx				;
		add bx, 2								;
		inc si									;

		cmp si, bp   							;
		jne __next								;

	ret
	endp
;------------------------------------------------

include SMALLIB.ASM

.data 
	abplus  db "a+b"
	hex     db "hex"
	decimal db "dec"
	bin		db "bin"

end Start
