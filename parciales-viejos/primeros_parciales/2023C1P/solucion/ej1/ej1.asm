global templosClasicos
global cuantosTemplosClasicos
COLUM_LARGO_OFFSET EQU 0
NOMBRE_OFFSET EQU 8
COLUM_CORTO EQU 16	
TEMPLO_SIZE EQU 24

extern malloc 

;########### SECCION DE TEXTO (PROGRAMA)
section .text
;uint32_t cuantosTemplosClasicos(templo *temploArr, size_t temploArr_len);

;rdi-> temploArr
;rsi -> temploArr_len
cuantosTemplosClasicos:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14

    mov r12, rdi
    mov r13, rsi

    xor rbx,rbx
    xor rcx,rcx 

    ;r12 -> temploArr
    ;r13 -> temploArr_len
    ;r14 -> es el dedito en el arrray
    ;rcx -> contador array
    ;rbx -> contador templos

    .ciclo:
    cmp rcx, r13 ;Si llego a temploArr_len terminé!
    jge .fin

    xor r10,r10
    imul r10,rcx, TEMPLO_SIZE ;Indice De Lista
    
    ;r14 = r12 + r10 (no quiero desreferenciar)
    mov r14, r12
    add r14, r10

    ;mov r14, [r12+r10], pero no quiero acceder a memoria.

    mov r8b, byte [r14 + COLUM_LARGO_OFFSET]; r8b = temploArr[i].colum_largo
    mov r9b, byte [r14 + COLUM_CORTO]; r9b = temploArr[i].colum_corto

    ;Ahora debo hacer la condicion colum_largo_actual == (2*colum_corto_actual+1)

    ;Armemos 2*colum_corto_actual+1 en r9

    movzx r9d, r9b        ;extiendo los ceros
    shl r9d, 1            ; multiplicar por 2 usando shift
    add r9d,1

    ;r9d = 2*colum_corto+1

    ;Paso r8b a 32bits por conveniencia.
    movzx r8d,r8b 

    ;colum_largo_actual == (2*colum_corto_actual+1)
    cmp r8d,r9d
    jne .siguienteIteracion ; si no lo es

    inc rbx

    .siguienteIteracion:
    inc rcx
    jmp .ciclo

    .fin:

    mov eax, ebx

    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret


templosClasicos:
    ;rdi-> temploArr
    ;rsi -> temploArr_len

    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp,8

    mov r12, rdi
    mov r13, rsi

    xor rbx,rbx
    xor r15,r15
    xor r14,r14

    ;debo hacer malloc, ya los parametros estan

    ;Llamo templosClasicos
    call cuantosTemplosClasicos

    ;Muevo resultado a r8d
    mov r8d, eax

    mov edi, eax

    imul edi, edi, TEMPLO_SIZE 

    call malloc


    mov r15,rax; r15 = malloc(cantidad_templos_clasicos*28)
    ;r12 -> temploArr
    ;r13 -> temploArr_len
    ;r14 -> es el dedito en el arrray
    ;rcx -> contador array
    ;r15 -> Apunta al primer elemento del array rtta
    ;rbx -> El que apunta al array respuesta (incrementandose)
    
    xor r8,r8
    xor rcx,rcx
    .cicloA:

    cmp rcx, r13 ;si contador >= lista_len
    jge .finA

    xor r10,r10

    imul r10,rcx, TEMPLO_SIZE ;Indice De Lista
    
    ;r14 = r12 + r10 (no quiero desreferenciar)
    mov r14, r12
    add r14, r10

    ;mov r14, [r12+r10], pero no quiero acceder a memoria.

    mov r8b, byte [r14 + COLUM_LARGO_OFFSET]; r8b = temploArr[i].colum_largo
    mov r9b, byte [r14 + COLUM_CORTO]; r9b = temploArr[i].colum_corto

    ;Ahora debo hacer la condicion colum_largo_actual == (2*colum_corto_actual+1)

    ;Armemos 2*colum_corto_actual+1 en r9

    movzx r9d, r9b        ; convertir r9b → r9d
    shl r9d, 1            ; multiplicar por 2 usando shift
    add r9d,1

    ;r9d = 2*colum_corto+1

    ;Paso r8b a 32bits por conveniencia.
    movzx r8d,r8b 

    ;colum_largo_actual == (2*colum_corto_actual+1)
    cmp r8d, r9d                     ; si colum_largo_actual == (2*colum_corto_actual+1)
    jne .siguienteIteracionA           ; si no es igual, ir a la siguiente iteración

    dec r9d
    shr r9d,1
    ; Cuando colum_largo_actual == (2*colum_corto_actual+1)

    imul r10, rbx, TEMPLO_SIZE                 ; r10 = rbx * 24 (índice del array, ya que cada struct es de 24 bytes)

    ; Copiar colum_largo_actual (r8b) a arrayTemplo[numeroDeTemplosClasicosAgregados]
    mov [r15 + r10 + COLUM_LARGO_OFFSET], r8b

    ; Copiar NOMBRE_OFFSET (qword) a arrayTemplo[numeroDeTemplosClasicosAgregados]
    mov rax, [r14 + NOMBRE_OFFSET]    ; rax = temploArr[i].nombre
    mov [r15 + r10 + NOMBRE_OFFSET], rax  ; Copiar nombre a arrayTemplo

    ; Copiar colum_corto_actual (r9d) a arrayTemplo[numeroDeTemplosClasicosAgregados]
    mov [r15 + r10 + COLUM_CORTO], r9d

    ; Incrementar el contador de templos clasicos
    inc rbx

    .siguienteIteracionA:
    inc rcx
    jmp .cicloA
    
    .finA:
    mov rax, r15

    add rsp,8
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret


