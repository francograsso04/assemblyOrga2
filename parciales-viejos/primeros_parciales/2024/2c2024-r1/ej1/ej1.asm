extern malloc
extern free
section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

section .text
; Marca un ejercicio como aún no completado (esto hace que no corran sus tests)
FALSE EQU 0
; Marca un ejercicio como hecho
TRUE  EQU 1

; Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - optimizar
global EJERCICIO_1A_HECHO
EJERCICIO_1A_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - contarCombustibleAsignado
global EJERCICIO_1B_HECHO
EJERCICIO_1B_HECHO: db FALSE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1C como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - modificarUnidad
global EJERCICIO_1C_HECHO
EJERCICIO_1C_HECHO: db FALSE ; Cambiar por `TRUE` para correr los tests.

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
ATTACKUNIT_CLASE EQU 0
ATTACKUNIT_COMBUSTIBLE EQU 12
ATTACKUNIT_REFERENCES EQU 14
ATTACKUNIT_SIZE EQU 16

FILAS EQU 255
COLUMNAS EQU 255
global optimizar





;void optimizar(mapa_t mapa,
;                attackunit_t* compartida,
;                uint32_t (*fun_hash)(attackunit_t*)) {
;RDI, RSI, RDX, RCX
optimizar:

	;RDI -> mapa
	;RSI -> compartida
	;RDX -> fun_hash(puntero)
	push rbp
	mov rbp,rsp
	push r12
	push r13
	push r14
	push r15
	push rbx 
	sub rsp,8

	mov r12, rdi
	mov r13, rsi
	mov r14, rdx 

	;R12 -> MAPA
	;R13 -> COMPARTIDA (PUNTERO)
	;R14 -> FUNCION FUN_HASH(PUNTERO)

	;rdi = puntero_compartida
	mov rdi, r13
	;fun_hash(puntero_compartida)
	call r14

	;r15 = fun_hash(puntero_compartida)
	mov r15d, eax

	xor rbx, rbx ;contador

	;Las matrices son contiguas en memoria, entonces es solo un contador.
	;RBX SE VA A INCREMENTAR 255*255 veces y para pasar al siguiente elemento le tengo que sumar el ofset del struct
	
	.ciclo: 
		cmp rbx, (FILAS*COLUMNAS)
		jge .fin

		;R12 -> MAPA
		;R13 -> COMPARTIDA (PUNTERO)
		;R14 -> FUNCION FUN_HASH(PUNTERO)
		;R15 -> fun_hash(compartida)

		mov rdi, [r12 + rbx*8];elemento_actual

		;Si elemento actual es null, hago nueva iteracion
		cmp rdi, 0
		je .hacerNuevaIteracion

		cmp rdi, r13
		je .hacerNuevaIteracion

		;Si no es null ni igual a compartido, calculo el fun_hash de elem actual
		call r14; va a eax

		;Guardo el resultado en r8d
		mov r8d, eax; Hash de elemento Actual

		cmp r8d, r15d;
		;Si los dos hash son iguales, sigo
		jne .hacerNuevaIteracion
		;sino
		;Por ahora tengo:

		;R12 -> MAPA
		;R13 -> COMPARTIDA (PUNTERO)
		;R14 -> FUNCION FUN_HASH(PUNTERO)
		;R15 -> fun_hash(compartida)
		;r8d -> hash elemento actual

		;debo hacer 
		;1) actual->references--
		;2) compartido_actual -> references ++
		;3) mov[i][j] = compartido

		;1)
		mov r9, [r12+rbx*8] ;r9 es puntero a un struct
	
		dec byte[r9+ATTACKUNIT_REFERENCES]

		;2) 
	
		inc byte[r13 + ATTACKUNIT_REFERENCES]
		
		cmp byte[r9+ATTACKUNIT_REFERENCES],0
		je .free

		;3)
		mov [r12+rbx*8], r13

		jmp .hacerNuevaIteracion

	.free: 
		;Accedo al elemento actual
		mov rdi, [r12+8*rbx]
		call free
		mov [r12+rbx*8], r13

	.hacerNuevaIteracion:
		inc rbx
		jmp .ciclo

	.fin:
	add rsp,8
	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret

global contarCombustibleAsignado
contarCombustibleAsignado:
	; r/m64 = mapa_t           mapa
	; r/m64 = uint16_t*        fun_combustible(char*)
	ret

global modificarUnidad
modificarUnidad:
	; r/m64 = mapa_t           mapa
	; r/m8  = uint8_t          x
	; r/m8  = uint8_t          y
	; r/m64 = void*            fun_modificar(attackunit_t*)
	ret