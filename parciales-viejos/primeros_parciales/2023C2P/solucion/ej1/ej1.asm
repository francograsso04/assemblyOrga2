section .text

global contar_pagos_aprobados_asm
global contar_pagos_rechazados_asm

global split_pagos_usuario_asm

extern malloc
extern free
extern strcmp


;Pongo mis offset de estructuras

;Pago_T
MONTO_PAGO_T EQU 0
APROBADO_PAGO_T EQU 1
PAGADOR EQU 8	
COBRADOR EQU 16
SIZE_PAGO_T EQU 24


;PagoSplitted
ITEM_NOMBRE EQU 0
ITEM_FUERZA EQU 1
ITEM_DURABILIDAD EQU 8	
ITEM_SIZE EQU 16

PAGO_SPLITTED_SIZE EQU 24 


;listElem_t
DATA EQU 0
NEXT EQU 8
PREV EQU 16	
LISTELEM_SIZE EQU 24

;LIST_T
FIRST EQU 0
LAST EQU 8
LIST_T_SIZE EQU 16	
;########### SECCION DE TEXTO (PROGRAMA)

; uint8_t contar_pagos_aprobados_asm(list_t* pList, char* usuario);

;RDI -> pList, es un puntero! 
;RSI -> usuario, es un puntero a un char!



; uint8_t contar_pagos_aprobados(list_t* pList, char* usuario){
;     //Debo contar los pagos aprobados
;     uint8_t pagos_aprobados_de_usuario = 0;

;     //Desreferencio.
;     listElem_t *nodo = (*pList).first;

;     while(nodo != NULL){
;         if (nodo->data->aprobado != 0 && nodo->data->pagador == usuario){
;             pagos_aprobados_de_usuario++;
;         }
;         nodo = nodo->next;
;     }
;     return pagos_aprobados_de_usuario;
; }

contar_pagos_aprobados_asm:
;RDI -> pList, es un puntero! 
;RSI -> usuario, es un puntero a un char!
    push rbp
    mov rbp, rsp

    ;No volatiles
    push rbx
    push r12
    push r13
    push r14

    mov r12, rdi
    mov r13, rsi

    xor rbx,rbx; Lo uso como contador
    xor rax,rax

    ;R12 -> puntero de pList (donde tenes el first y el last)!
    ;R13 -> Puntero a usuario!
    ;rbx -> contador!
    ;r14 va a ser nuestro puntero dedito a list.

    ;Lo que hago ahora es un ciclo hasta que nodo sea null.
    ;Sabemos que r12 es pList, luego [r12], vamos a estar adentro de pList

    ;Muevo puntero r12 a nuestra lista enlazada

    mov r14, qword[r12 + FIRST]

    ;Ahora r14, es la desreferencia de *first. Osea r14 apunta a first.
    ;En el dato de un nodo, tenemos..

    ;     typedef struct s_listElem
    ; {
    ;     pago_t *data;
    ;     struct s_listElem *next;
    ;     struct s_listElem *prev;
    ; } listElem_t;    

    ;Entonces, en el ciclo vamos a tener que ir por cada nodo, ir chequeando el data.

    .ciclo:
        cmp r14, 0; si r14 es un nodo null
        je .fin;termino
        ;sino
        
        mov r8, qword[r14 + DATA];r8 = nodo->data

        mov r10b, [r8 + APROBADO_PAGO_T]; r10 = nodo->data->aprobado

        cmp r10b,0 ;Si no esta aprobado
        je .siguienteCiclo

        mov rsi, qword[r8 + COBRADOR]; r11 = nodo->data->pagador (puntero)
        mov rdi, r13

        call strcmp ;eax == 0 (32 bits) si las cadenas son iguales y !=0 sino

        cmp eax,0
        jne .siguienteCiclo

        ;Si esta aprobado y es el mismo usuario
        inc bl
        
    .siguienteCiclo:
        mov r14, qword[r14 + NEXT]
        jmp .ciclo

    .fin:
    mov al, bl; bl = 8 bits de rbx y al = 8 bits de rax

    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

; uint8_t contar_pagos_rechazados_asm(list_t* pList, char* usuario);
contar_pagos_rechazados_asm:
    push rbp
    mov rbp, rsp

    ;No volatiles
    push rbx
    push r12
    push r13
    push r14

    mov r12, rdi
    mov r13, rsi

    xor rbx,rbx; Lo uso como contador
    xor rax,rax

    ;R12 -> puntero de pList (donde tenes el first y el last)!
    ;R13 -> Puntero a usuario!
    ;rbx -> contador!
    ;r14 va a ser nuestro puntero dedito a list.

    ;Lo que hago ahora es un ciclo hasta que nodo sea null.
    ;Sabemos que r12 es pList, luego [r12], vamos a estar adentro de pList

    ;Muevo puntero r12 a nuestra lista enlazada

    mov r14, qword[r12 + FIRST]

    ;Ahora r14, es la desreferencia de *first. Osea r14 apunta a first.
    ;En el dato de un nodo, tenemos..

    ;     typedef struct s_listElem
    ; {
    ;     pago_t *data;
    ;     struct s_listElem *next;
    ;     struct s_listElem *prev;
    ; } listElem_t;    

    ;Entonces, en el ciclo vamos a tener que ir por cada nodo, ir chequeando el data.

    .cicloA:
        cmp r14, 0; si r14 es un nodo null
        je .finA;termino
        ;sino
        
        mov r8, qword[r14 + DATA];r8 = nodo->data

        mov r10b, [r8 + APROBADO_PAGO_T]; r10 = nodo->data->aprobado

        cmp r10b,0 ;
        jne .siguienteCicloA; Si el pago esta aprobado, no me sirve.

        mov rsi, qword[r8 + COBRADOR]; r11 = nodo->data->pagador (puntero)
        mov rdi, r13

        call strcmp ;eax == 0 (32 bits) si las cadenas son iguales y !=0 sino

        cmp eax,0
        jne .siguienteCicloA

        ;Si esta aprobado y es el mismo usuario
        inc bl
        
    .siguienteCicloA:
        mov r14, qword[r14 + NEXT]
        jmp .cicloA

    .finA:
    mov al, bl; bl = 8 bits de rbx y al = 8 bits de rax

    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
    

; pagoSplitted_t* split_pagos_usuario_asm(list_t* pList, char* usuario);
split_pagos_usuario_asm:


