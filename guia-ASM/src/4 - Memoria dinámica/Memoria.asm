extern malloc
extern free
extern fprintf

section .data

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

;bay
;bayt
;car

;car > bayoneta > bay
;RDI -> a, RSI -> b
; int32_t strCmp(char* a, char* b)
strCmp:
    push rbp
    mov rbp,rsp

    xor rax,rax
    ;mantengo rcx como mi contador
    xor rcx,rcx

    cicloDeComparacion:
    mov r8b, [rdi+rcx]

    cmp r8b, [rsi+rcx]
    je sonigualesSinCero
    jb esmenor
    jg esmayor
    
    sonigualesSinCero:
    cmp byte [rdi+rcx], 0
    je sonigualesConCero
    inc rcx

    jmp cicloDeComparacion 
    
    sonigualesConCero:
    mov eax, 0
    jmp fin

    esmenor:
    mov eax, 1
    jmp fin

    esmayor:
    mov eax, -1

    fin:
    pop rbp
	ret

; char* strClone(char* a)
;RDI -> a

    ;Mi idea es, vamos a usar malloc.
    ;Malloc es una funcion tq: void *malloc(size_t size)
    ;En la que, le pasas un size en bytes y luego, develve un puntero en donde se reservo la memoria.
    ;Luego en esa posicion en donde se reservo malloc, con un bucle voy agregando la palabra char por char.

    ;En este caso, teniendo el puntero a un char, mediante la funcion ya hecha strLen, calculo el len (cada letra es un byte).
    ;Hago malloc, luego en el registro rax voy a tener la direccion donde se libero memoria.
    ;Mediante un bucle voy agregando char por char.
    ;Rax obvio que queda como puntero a la primera letra, luego habra otro registro que va procesando la direccion de escritura. 
strClone:
    ;alineacion
    push rbp
    mov rbp,rsp

    ;Hago uso de no volatiles, ya que hago uso de otras funciones y no se si se van a modificar
    ;Necesito que no que modifiquen (porfa dios)
    push r12
    push r13


    ;Tenemos rdi que es el puntero a la primera letra a la string.
    ;Calculamos su len con rdi al puntero.
    mov r12, rdi

    call strLen
    inc rax

    ;Una vez obtenido la longitud en bytes del string, ¿que hago? -> HAGO MALLOC

    ;Muevo la long de la palabra en rdi para hacer malloc
    mov rdi, rax

    call malloc

    ;Ahora en rax tenemos el puntero a la nueva posicion de memoria
    
    ;Tenemos entonces (hasta ahora)
    ;rax es la posicion inicial de la nueva memoria
    ;r12 es el puntero a la palabra
    ;rcx es mi contador (empieza de 0)
    ;r8 es mi registro que guarda los byts y hace otro mov

    ;rdi es la long de la palabra. NO! NO ME SIRVE MAS RDI PORQUE ES VOLATIL Y LLAME A MALLOC (PUEDE HABER CAMBIADO)


    xor rcx,rcx
    ;OBS: Tuve un problema al principio pq puse el comparador para ir al fin
    ;al principio, y hacia memory leak

    ;Entonces hice malloc pero me iba sin escribir nada en ese byte.
    ;Entonces primero escribo y dsp me voy a fin.

    .ciclo:
    xor r8,r8
    ;Si te pasan el caracter vacio, reservas 1 byte en malloc pero nunca lo rellenas, te vas directo a fin.
    ;Esto genera memory leak

    ;cmp byte [r12+rcx],0
    ;je .fin
    mov r8b, byte [r12+rcx]
    mov [rax+rcx],r8b
    cmp byte [r12+rcx],0
    je .fin
    inc rcx
    jmp .ciclo


    .fin:
    pop r13
    pop r12
    pop rbp

    ret



; void strDelete(char* a)
strDelete:
    push rbp
    mov rbp, rsp          

    call free

    pop rbp
	ret

; void strPrint(char* a, FILE* pFile)

;RDI -> a, RSI -> pFile
;Son los dos punteros,entonces es 64 bits
strPrint:
    ;alineacion
    push rbp
    mov rbp, rsp
    
    ;Tenemos que usar la funcion exportada que se llama fprintf, que toma como parametros:
    ;1-Toma el puntero al file y luego el puntero al char.
    ; Aca esta al reves, osea debemos cambiar rdi por rsi y rsi por rdi.
    xor r8,r8

    mov r8,rdi
    mov rdi, rsi
    mov rsi, r8

    call fprintf

    pop rbp
	ret

; uint32_t strLen(char* a)

;RDI -> a
;El error que tenia es que u
strLen:
    ;alineacion
    push rbp
    mov rbp, rsp

    ;reseteo a rax en 0
    xor rax, rax        ; contador de longitud = 0
    xor r8,r8
.loop:
    mov r8b, byte [rdi]  ; leemos un byte (char) desde str
    cmp r8b, 0           ; ¿es el fin del string'?
    je .fin
    inc rdi             ; avanzamos al siguiente carácter
    inc rax             ; sumamos 1 a la longitud
    jmp .loop

.fin:
    pop rbp
    ret                 ; longitud queda en RAX

