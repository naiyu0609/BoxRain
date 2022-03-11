include macro.h

.model large
.data 
Start_word db 'Press ENTER to start or ESC to exit',10,13,'$'
Score_H dw 0
thing_row dw 0
thing_col dw 0
thing_size dw 30
thing_col_right dw 0
thing_col_left dw 0
thing_row_top dw 0
thing_row_down dw 0
bullet_row dw 0
bullet_col dw 0
bullet_size dw 10
bullet_col_right dw 0
bullet_col_left dw 0
bullet_row_top dw 0
bullet_row_down dw 0
count dw 0
color db 0
lose dw 0
speed dw 1
End_word db 'Press ENTER to restart or ESC to exit',10,13,'Your Score:$'
.stack
.code
pnt_thing proc 			;�L���
 intit_set:
	mov cx,thing_col
	mov dx,thing_row
	mov count,0	
	mov di,thing_size
 Print:
	WrPixel cx,dx,color
	dec di
	inc cx
	cmp di,0
	ja Print
 next_row:	
	inc count
	mov di,count
	cmp di,thing_size
	ja over
	mov cx,thing_col
	mov di,thing_size
	inc dx
	jmp Print
 over:
	mov cx,thing_col
	mov dx,thing_row
	ret
pnt_thing 	endp

pnt_bullet proc 			;�L������
 intit_set:
	mov cx,bullet_col
	mov dx,bullet_row
	mov count,0	
	mov di,bullet_size
 Print:
	WrPixel cx,dx,color
	dec di
	inc cx
	cmp di,0
	ja Print
 next_row:	
	inc count
	mov di,count
	cmp di,bullet_size
	ja over
	mov cx,bullet_col
	mov di,bullet_size
	inc dx
	jmp Print
 over:
	mov cx,bullet_col
	mov dx,bullet_row
	ret
pnt_bullet 	endp

Delay proc	
	mov  cx,1
 L1:
	push cx
	mov cx,65535
 L2:
	loop L2
	pop cx
	loop L1
	ret
Delay	endp
	
valueToASCII proc    
	mov cx,0
	mov bl,10
 Hex2Asc:
	div bl
	mov dl,ah
	add dl,30h
	push dx
	inc cx	
	mov ah,0
	cmp al,0
	jne Hex2Asc
 addSpace:
	cmp cx,3
	je keepPnt
	mov dl,' '
	push dx
	inc cx
	jmp addSpace	
 keepPnt:
	pop ax
	PrintChar al
	loop keepPnt
	ret
valueToASCII endp	

main proc 
	mov	ax,@data
        mov	ds,ax

	PrintStr Start_word	;�g�}�l��r
L1:	GetChar			;Ū��L
	cmp al,0Dh		;�P�_���S�����UENTER
	je L2
	cmp al,1bh		;�P�_���S�����UESC
	je quit
	jmp L1

L2:	mov lose,0
	mov Score_H,0
	mov speed,1
	SetMode 12h		;�C���}�l
	SetColor 00h
	MUS_RESET
	MUS_range_x 609,0	;�]�mx��ɽd��
	MUS_range_y 429,0	;�]�my��ɽd��
	SET_MUS 300,300		;�]�m�_�l��m
	MUS_HIND		;���ô��
	jmp tran0

tran0:	SetCursor 0,0		;�g���ƪ�
	mov ax,Score_H
	call valueToASCII
	SetCursor 1,0
	mov ax,lose		;�g��������
	call valueToASCII
	SetCursor 8,0
	mov ax,speed		;�g�����t��
	call valueToASCII

bullet0:	cmp lose,5		;�P�_�����O�_��5��
		je quit			;�Y5���N�����C��
		mov bullet_row,0	;��l������
		in ax,40h		;�H����16bit
		mov dx,0
		mov bx,600		;�d�򭭨�b0~600
		div bx
		mov bullet_col,dx
		mov bullet_col_left,dx		;�O�������������
		mov bullet_col_right,dx
		add bullet_col_right,10		;�O���������k���
		mov bullet_row_top,0		;�O���������W���
		mov bullet_row_down,10		;�O���������U���
bullet_start:	mov color,0h
		call pnt_bullet		;�M���챼�����C��
		mov cx,speed		;�t�קQ�Υ[y�y�б���
		add bullet_row,cx
		add bullet_row_top,cx	;�O���������W���
		add bullet_row_down,cx	;�O���������U���
		mov color,0Eh
		call pnt_bullet		;�}�l�e������

L3:	MUS_GET03			;�w��ƹ�
	mov ax,thing_col
	mov bx,thing_row
	cmp ax,cx
	je L4
	jmp L5
L4:	cmp bx,dx
	je L6
L5:	mov thing_col,cx		;�x�s������W�y��
	mov thing_row,dx
	mov color,0Eh
	call pnt_thing			;�e���
	call Delay
	mov color,0h
	call pnt_thing			;�M�������C��
L6:	mov thing_col_left,cx		;�O����������
	mov thing_col_right,cx
	add thing_col_right,30		;�O������k���
	mov thing_row_top,dx		;�O������W���
	mov thing_row_down,dx	
	add thing_row_down,30		;�O������U���

	SetCursor 0,0		;�g���ƪ�
	mov ax,Score_H
	call valueToASCII
	SetCursor 1,0
	mov ax,lose		;�g��������
	call valueToASCII
	SetCursor 2,0			;�g��������
	mov ax,thing_col_left
	call valueToASCII
	SetCursor 3,0			;�g����k���
	mov ax,thing_col_right
	call valueToASCII
	SetCursor 4,0			;�g����W���
	mov ax,thing_row_top
	call valueToASCII
	SetCursor 5,0			;�g����U���
	mov ax,thing_row_down
	call valueToASCII
	call Delay
	SetCursor 6,0			;�g������x�y��
	mov ax,bullet_col_left
	call valueToASCII
	SetCursor 7,0			;�g������y�y��
	mov ax,bullet_col_right
	call valueToASCII
	SetCursor 8,0			;�g������x�y��
	mov ax,bullet_row_top
	call valueToASCII
	SetCursor 9,0			;�g������y�y��
	mov ax,bullet_row_down
	call valueToASCII
	SetCursor 10,0			;�g�������t��
	mov ax,speed
	call valueToASCII

	mov ah,06h		;�P�_�O�_��ESC���e����
	mov dl,0ffh
	int 21h
	cmp al,1bh
	je quit

	mov ax,thing_col_right		;�P�_�O�_�b�k��ɥk��
	cmp ax,bullet_col_right
	jae L7				;�p�G�O ���U�h�P�_
	jmp L8				;�p�G���O ���P�_�O�_�쩳
L7:	mov ax,thing_col_left		;�P�_�O�_�b����ɥ���
	cmp ax,bullet_col_left	
	jbe L9				;�p�G�O ���U�h�P�_
	jmp L8				;�p�G���O ���P�_�O�_�쩳
L9:	mov ax,thing_row_top		;�P�_�O�_�b�W��ɤU��
	cmp ax,bullet_row_top
	jbe L10				;�p�G�O ���U�h�P�_
	jmp L8				;�p�G���O ���P�_�O�_�쩳
L10:	mov ax,thing_row_down		;�P�_�O�_�b�U��ɤW��
	cmp ax,bullet_row_down
	jae tran			;�p�G�O ���[��
L8:	cmp bullet_row,470		;�w�]������470
	jb bullet_start			;�p�G�٨S�쩳�N���^�~��e
	jmp L11				;�p�G�쩳 �����������e������
tran:	inc Score_H			;�[��
	inc speed			;�[�������t��
	SetCursor 10,0			;�g�������t��
	mov ax,speed
	call valueToASCII
	SetCursor 0,0			;�g����
	mov ax,Score_H
	call valueToASCII
	mov color,0h
	call pnt_bullet				;�M���챼�����C��
	jmp bullet0				;���s��������
L11:	mov color,0h
	call pnt_bullet				;�M���챼�����C��
	inc lose				;�[��������
	SetCursor 1,0				;�g��������
	mov ax,lose
	call valueToASCII
	jmp bullet0				;���s��������


quit:	SetMode 03h		;�������� ���^��r�Ҧ�
	PrintStr End_word	;�g������r
	mov ax,Score_H		;�g�̫�o��
	call valueToASCII
quit1:	GetChar			;�P�_�O�_�n�A���@��		
	cmp al,0Dh
	je L2
	cmp al,1bh
	je quit2
	jmp quit1
quit2:	mov	ax,4c00h
        int	21h
main endp
end main