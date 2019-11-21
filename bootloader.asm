
[org 0x7C00]
[BITS 16]


start:
	xor ax, ax
	mov ds, ax
	
	mov ss, ax			; Setup stack [0x9c00; 0]
	mov sp, 0x9c00
	

setup_screen:
	mov ah, 0xb8 		
	mov es, ax			
	
	xor ah, ah
	mov al, 0x03
	int 0x10
	
	mov ah, 1
	mov	ch, 0x26
	int 0x10
	
make_blue:
	mov	cx, 0x07d0		; 80x25
	mov ax, 0x0020		; empty, blue-background char
	xor di, di
	rep stosw

mainloop: 			; infinite loop
	xor ax, ax
	mov ah, 0x01	; read keyboard buffer	
	int 0x16		; keyboard interrupt
	cmp al, 0x77	; if up arrow NOT WORKING
	je uparrow		
	mov bx, 1
	jmp print_buffer
uparrow:
	mov bx, 158
	
print_buffer: 
	
	mov di, [DATA.pos]	; position
	rdtsc				; timestamp to ax
	mov ah, 0x07		; set color
	
	; print to screen, increments di
	stosw
	
	; add to position +1 vertical, increments of two bytes
	add di, bx
	mov word [DATA.pos], di
	
	; wait 1 sec
	mov cx, 0x00f
	mov dx, 0x4240
	mov ah, 0x86
	int 0x15 			
	
	jmp mainloop
	
DATA:
.pos: dw 0x0



TIMES 510 - ($ - $$) db 0
DW 0xAA55
