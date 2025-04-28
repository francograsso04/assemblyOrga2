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
ATTACKUNIT_COMBUSTIBLE EQU 11
ATTACKUNIT_REFERENCES EQU 13
ATTACKUNIT_SIZE EQU 16

global optimizar




; void optimizar(mapa_t mapa,
;                attackunit_t* compartida,
;                uint32_t (*fun_hash)(attackunit_t*)) {
                
;     uint32_t hash_compartido = fun_hash(compartida);
;     const int longitud = 254;  // o el tamaño real de tu mapa

;     for (int i = 0; i <= longitud; i++) {
;         for (int j = 0; j < longitud; j++) {
;             attackunit_t* elemento_actual = mapa[i][j];
;             // 1) Si la celda está vacía, continúa
;             if (elemento_actual == NULL) 
;                 continue;
;             if (fun_hash(elemento_actual) == hash_compartido) {
;                 // 5) Reemplaza el puntero en el mapa
;                 mapa[i][j] = compartida;

;                 // 6) Incrementa el contador de la unidad compartida
;                 compartida->references++;
;             }
;         }
;     }
; }

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



	ciclo_fila:

		ciclo_columna:








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