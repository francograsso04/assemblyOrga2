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
EJERCICIO_1B_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

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



; uint32_t contarCombustibleAsignado(mapa_t mapa, uint16_t (*fun_combustible)(char*)) {
;     uint32_t combustible_asignado = 0;
;     const int longitud = 255;

;     for (int i = 0; i < longitud; i++ ){
;         for (int j = 0; j < longitud; j++){
;             attackunit_t* elemento_actual = mapa[i][j];
;             if (elemento_actual == NULL) continue;

;             uint16_t combustible_de_elemento_actual = elemento_actual->combustible;
;             uint16_t combustible_base_de_elemento_actual = fun_combustible(elemento_actual->clase);

;             if (combustible_de_elemento_actual > combustible_base_de_elemento_actual){
;                 uint16_t diferencia_de_combustible = combustible_de_elemento_actual - combustible_base_de_elemento_actual;
;                 combustible_asignado += diferencia_de_combustible;
;             }
;         }
;     }   
;     return combustible_asignado;
; }
contarCombustibleAsignado:
;RDI -> mapa
;RSI -> FUNCION QUE RECIBE CHAR
; uint32_t contarCombustibleAsignado(mapa_t mapa, uint16_t (*fun_combustible)(char*)) {
	push rbp
	mov rbp,rsp
	push r12
	push r13
	push rbx
	push r14
	push r15
	sub rsp,8

	mov r12, rdi
	mov r13, rsi

	xor rbx,rbx
	xor r14,r14
	.ciclo:
		cmp rbx, (FILAS*COLUMNAS)
		jge .fin 

		;R12 -> MAPA
		;R13 -> funcion
		;RBX -> contador

		;M[i][j]
		mov r8, [r12 + rbx*8]

		;si es null continue
		cmp r8,0
		je .reinicioCiclo 
		
		mov r15w, [r8 + ATTACKUNIT_COMBUSTIBLE]; r15 = combustible_elem_actual

		;EL PUNTERO PARA LA FUNCION ESTA EN R8+ATTACKUNIT!!!!
		;Me costo darme cuenta, pero esos char[11] son 11 bytes en memoria, 
		;si tenes la direccion del primer elemento, directamente acordate que
		;se itera cada posicion por cada char, hasta llegar al padding
		mov rdi, r8 + ATTACKUNIT_CLASE

		;LA FUNCION RECIBE UN PUNTERO A CHAR

		call r13 

		;el resultado esta en ax

		cmp r15w, ax
		jg .casoDiferencia

		;sino 
		jmp .reinicioCiclo 

	.casoDiferencia:
		;Estoy con
		; r15w es el combustible_actual en 16 bits
		; ax es el combustible_ base en 16 bits

		movzx r15d, r15w     ; Extiende r15w a r15d (32 bits)
		movzx eax, ax        ; Extiende ax a eax (32 bits)

		xor r10, r10
		add r10d, r15d
		sub r10d, eax 
		add r14d, r10d

		
	.reinicioCiclo:
		inc rbx
		jmp .ciclo

	.fin:
	mov eax, r14d

	add rsp,8
	pop r15
	pop r14
	pop rbx 
	pop r13
	pop r12
	pop rbp 



	ret

global modificarUnidad
modificarUnidad:
	; r/m64 = mapa_t           mapa
	; r/m8  = uint8_t          x
	; r/m8  = uint8_t          y
	; r/m64 = void*            fun_modificar(attackunit_t*)
	ret