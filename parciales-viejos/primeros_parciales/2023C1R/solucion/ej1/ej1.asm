global acumuladoPorCliente_asm
global en_blacklist_asm
global blacklistComercios_asm


MONTO_OFFSET EQU 0
COMERCIO EQU 8
CLIENTE EQU 16
APROBADO EQU 17
PAGO_SIZE EQU 24

;########### SECCION DE TEXTO (PROGRAMA)
section .text
extern malloc
extern calloc


acumuladoPorCliente_asm:
	;rdi -> cantidadPagos
	;rsi -> arr_pagos

	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	push rbx
	

	;r12 -> cantidadPagos
	;r13 -> arr_pagos

	mov r12, rdi
	mov r13, rsi

	;calloc(10, sizeof(uint32_t));
	mov rdi, 10; 10 bytes
	mov rsi, 4

	call calloc


	;r12 -> cantidadPagos
	;r13 -> arr_pagos
	;r14 -> arrayResultante
	;rbx -> contador

	xor rbx,rbx

	.ciclo:
	cmp bl, r12b
	jge .fin

	;Aca me muevo por el array (porque es un puntero por direccion)
	imul r8, rbx, PAGO_SIZE;esto es lo que me tengo que mover

	mov r9b, byte[r13+r8+APROBADO]

	cmp r9b, 0
	je .siguienteIteracion

	movzx r10, byte[r13+r8+CLIENTE]
	movzx r11d, byte[r13+r8+MONTO_OFFSET]

	
	add dword[rax+r10*4], r11d

	.siguienteIteracion:
	inc bl
	jmp .ciclo

	.fin:

	pop rbx
	pop r14
	pop r13
	pop r12
	pop rbp
	ret

en_blacklist_asm:


	ret

blacklistComercios_asm:
	ret

