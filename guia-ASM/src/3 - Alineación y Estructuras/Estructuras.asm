

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
NODO_OFFSET_NEXT EQU 0
NODO_OFFSET_CATEGORIA EQU 8
NODO_OFFSET_ARREGLO EQU 16
NODO_OFFSET_LONGITUD EQU 24
NODO_SIZE EQU 32
PACKED_NODO_OFFSET_NEXT EQU 0
PACKED_NODO_OFFSET_CATEGORIA EQU 8
PACKED_NODO_OFFSET_ARREGLO EQU 9
PACKED_NODO_OFFSET_LONGITUD EQU 17
PACKED_NODO_SIZE EQU 20
LISTA_OFFSET_HEAD EQU 0
LISTA_SIZE EQU 8
PACKED_LISTA_OFFSET_HEAD EQU 0
PACKED_LISTA_SIZE EQU 8

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global cantidad_total_de_elementos
global cantidad_total_de_elementos_packed

;########### DEFINICION DE FUNCIONES
;extern uint32_t cantidad_total_de_elementos(lista_t* lista);
;registros: lista[?]

;lista <--- RSI
cantidad_total_de_elementos:
    push rbp
    mov rbp, rsp

    mov rdi, [rdi]                ; RSI = lista->head
    xor eax, eax                  ; EAX = 0 (acumulador de total)

.loop:
    cmp rdi, 0
	je .fin                    ; Si sí, terminamos

    add eax, dword [rdi + NODO_OFFSET_LONGITUD] ; total += nodo->longitud
    mov rdi, [rdi + NODO_OFFSET_NEXT]           ; avanzar al siguiente nodo
    jmp .loop

.fin:
    pop rbp
    ret
;extern uint32_t cantidad_total_de_elementos_packed(packed_lista_t* lista);
;registros: lista[?]
cantidad_total_de_elementos_packed:
    push rbp
    mov rbp, rsp

    mov rdi, [rdi]                
    xor eax, eax                  

.looppacked:
    cmp rdi, 0
	je .finpacked                    

    add eax, dword [rdi + PACKED_NODO_OFFSET_LONGITUD] 
    mov rdi, [rdi + PACKED_NODO_OFFSET_NEXT]           
    jmp .looppacked

.finpacked:
    pop rbp
    ret

