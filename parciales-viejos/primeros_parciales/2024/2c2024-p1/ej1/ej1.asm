extern malloc

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
;   - es_indice_ordenado
global EJERCICIO_1A_HECHO
EJERCICIO_1A_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - indice_a_inventario
global EJERCICIO_1B_HECHO
EJERCICIO_1B_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
ITEM_NOMBRE EQU 0
ITEM_FUERZA EQU 19
ITEM_DURABILIDAD EQU 24	
ITEM_SIZE EQU 28

;; La funcion debe verificar si una vista del inventario está correctamente 
;; ordenada de acuerdo a un criterio (comparador)

;; bool es_indice_ordenado(item_t** inventario, uint16_t* indice, uint16_t tamanio, comparador_t comparador);

;; Dónde:
;; - `inventario`: Un array de punteros a ítems que representa el inventario a
;;   procesar.
;; - `indice`: El arreglo de índices en el inventario que representa la vista.
;; - `tamanio`: El tamaño del inventario (y de la vista).
;; - `comparador`: La función de comparación que a utilizar para verificar el
;;   orden.
;; 
;; Tenga en consideración:
;; - `tamanio` es un valor de 16 bits. La parte alta del registro en dónde viene
;;   como parámetro podría tener basura.
;; - `comparador` es una dirección de memoria a la que se debe saltar (vía `jmp` o
;;   `call`) para comenzar la ejecución de la subrutina en cuestión.
;; - Los tamaños de los arrays `inventario` e `indice` son ambos `tamanio`.
;; - `false` es el valor `0` y `true` es todo valor distinto de `0`.
;; - Importa que los ítems estén ordenados según el comparador. No hay necesidad
;;   de verificar que el orden sea estable.

global es_indice_ordenado

;RDI, RSI, RDX, RCX, R8 y R9 
;bool es_indice_ordenado(item_t** inventario, uint16_t* indice, uint16_t tamanio, comparador_t comparador)
;RDI -> inventario 
;RSI ->indice
;RDX -> tamanio (solo usa dx)
;RCX -> comparador (es un puntero a funcion)




;bool es_indice_ordenado(item_t** inventario, uint16_t* indice, uint16_t tamanio, comparador_t comparador) {
; 	for (int i = 0; i < tamanio-1; i++){
; 		item_t* a = inventario[indice[i]];
; 		item_t* b = inventario[indice[i + 1]];
; 		if (!comparador(a, b)) {
;     		return false;
; 			}
		
; 	}
; 	return true ;
; }



es_indice_ordenado:
;RDI -> inventario 
;RSI ->indice
;RDX -> tamanio (solo usa dx)
;RCX -> comparador (es un puntero a funcion)

    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
	push r15
	
	;Guardo mis parametros en registros no volatiles para saber que no van a cambiar al hacer calls.
	mov r12, rdi 
	mov r13, rsi 
	mov r14, rdx
	mov r15, rcx
	xor rbx,rbx 

	;Resto 1 al tamaño
	sub r14,1

	; R12 -> INVENTARIO**
	; R13 -> INDICE*
	; R14 -> TAMAÑO
	; R15 -> COMPARADOR
	; RBX -> CONTADOR

	ciclo:

		;fijarse si anda este cmp
		cmp rbx,r14
		jge fin_verdadero ;Si rbx >= r14, salta a "fin_verdadero"

		;al contador lo multiplico por 2
		imul r10, rbx, 2

		;Lo que debo hacer aqui, es agarrar los indices:  a = indice[rbx] e b = indice[rbx+1] y comparar inventario[a] con inventario[b]
		mov r8w, [r13 + r10]
		mov r9w, [r13 + r10 + 2]

		movzx r8, r8w              ;zero-extend r8w a r8 (64 bits)
		movzx r9, r9w

		mov rdi, [r12 + r8*8]
		mov rsi, [r12 + r9*8]

		;Llamo al comparador
		call    r15                 ; llamo comparador(a, b)

    	cmp    rax, 0            ; ¿resultado == 0?
    	je      fin_false         ; si es 0, anda a fin false

    	inc     rbx                 ; i++
    	jmp     ciclo

	fin_verdadero:
    mov     rax, 1              ; true
    jmp     fin

	fin_false:
    xor     rax, rax            ; false (0)

	fin:
    ; Restaurar los registros callee-saved
	pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

;; Dado un inventario y una vista, crear un nuevo inventario que mantenga el
;; orden descrito por la misma.

;; La memoria a solicitar para el nuevo inventario debe poder ser liberada
;; utilizando `free(ptr)`.

;; item_t** indice_a_inventario(item_t** inventario, uint16_t* indice, uint16_t tamanio);

;; Donde:
;; - `inventario` un array de punteros a ítems que representa el inventario a
;;   procesar.
;; - `indice` es el arreglo de índices en el inventario que representa la vista
;;   que vamos a usar para reorganizar el inventario.
;; - `tamanio` es el tamaño del inventario.
;; 
;; Tenga en consideración:
;; - Tanto los elementos de `inventario` como los del resultado son punteros a
;;   `ítems`. Se pide *copiar* estos punteros, **no se deben crear ni clonar
;;   ítems**

global indice_a_inventario

; item_t** indice_a_inventario(item_t** inventario, uint16_t* indice, uint16_t tamanio) {
;     // Reservamos memoria para 'tamanio' punteros a 'item_t'
;     item_t **ptr = malloc(tamanio * sizeof(item_t*)); 

;     // Verificamos que la memoria se haya reservado correctamente
;     if (ptr == NULL) {
;         return NULL; // Si no se pudo reservar la memoria, devolvemos NULL
;     }

;     // Copiamos los punteros de inventario a ptr según los índices
;     for (int i = 0; i < tamanio; i++) {
;         ptr[i] = inventario[indice[i]];
;     }

;     return ptr;
; }
indice_a_inventario:

	;RDI -> inventario 
	;RSI ->indice
	;RDX -> tamanio (solo usa dx)

	push rbp
	mov rbp,rsp
	push r12
	push r13
	push r14
	push r15
	push rbx

	mov r12, rdi
	mov r13, rsi
	mov r14, rdx
	xor r15,r15


	xor rdi,rdi
	mov rdi, rdx 
	imul rdi, 8

	call malloc
	;Ahora en rax tengo la pos de memoria de la memoria libre!
	;deberia ir agregando a cada posicion de la nueva memoria inventario[indice[i]]


	;Tengo
	;R12 ->Inventario
	;R13 -> Indice
	;R14 -> tamaño
	;R15 -> contador
	ciclo_2:
		cmp r15, r14
		jge fin_2 ;Si r15 >= r14 
		
		imul r10, r15, 2 
		;Necesito obtener r8 = indice[i]
		mov r8w, [r13 + r10]
		movzx r8, r8w   

		;Ahora necesito r11 = inventario[r8]
		 
		 mov r11, [r12+r8*8]; esto es inventario[indice[i]]

		 ;Ahora a r11 lo debo guardar en: contador*8
		 mov [rax + r15*8], r11
		 inc r15
		 jmp ciclo_2

	fin_2:

	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	
	ret
