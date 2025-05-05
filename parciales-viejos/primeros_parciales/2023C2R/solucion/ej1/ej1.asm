; /** defines bool y puntero **/
%define NULL 0
%define TRUE 1
%define FALSE 0

;Lista dobl enlazada
STRING_PROC_LIST_T_FIRST EQU 0
STRING_PROC_LIST_T_LAST EQU 8
STRING_PROC_LIST_SIZE EQU 16

;Nodos de lista doblemente enlazada
STRING_PROC_NODE_NEXT EQU 0
STRING_PROC_NODE_PREVIOUS EQU 8
TYPE EQU 16
HASH  EQU 24
STRING_PROC_NODE_SIZE EQU 32

section .data

section .text

global string_proc_list_create_asm
global string_proc_node_create_asm
global string_proc_list_add_node_asm
global string_proc_list_concat_asm

; FUNCIONES auxiliares que pueden llegar a necesitar:
extern malloc
extern free
extern str_concat

string_proc_list_create_asm:

push rbp
mov rbp,rsp

mov rdi, STRING_PROC_LIST_SIZE
call malloc;Ahora en RAX hay un puntero a la memoria liberada

cmp rax, NULL
je .fin 

mov qword[rax + STRING_PROC_LIST_T_FIRST],NULL
mov qword[rax + STRING_PROC_LIST_T_LAST],NULL

.fin:

pop rbp 
ret

string_proc_node_create_asm:
;RDI (dil)-> TYPE 
;RSI -> HASH
push rbp
mov rbp, rsp
push r12
push r13

mov r12b, dil
mov r13, rsi
;r12 -> type
;r13 -> hash
mov rdi, STRING_PROC_NODE_SIZE
call malloc

cmp rax, NULL
je .finB 

mov qword[rax + STRING_PROC_NODE_NEXT],NULL
mov qword[rax + STRING_PROC_NODE_PREVIOUS],NULL

mov byte [rax + TYPE],r12b
mov qword[rax + HASH],r13

.finB:
pop r13
pop r12
pop rbp
ret

string_proc_list_add_node_asm:
    ; RDI -> LIST
    ; RSI -> TYPE
    ; RDX -> HASH
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15

    mov r12, rdi      ; LIST
    mov r13, rsi      ; TYPE
    mov r14, rdx      ; HASH

    mov rdi, r13      ; type -> rdi
    mov rsi, r14      ; hash -> rsi
    call string_proc_node_create_asm
    ; devuelve en rax el nuevo nodo o NULL

    mov r15, rax      ; nuevo nodo

    cmp r15, NULL
    je .finC_add_node ; if (nuevoNodo == NULL) return;

    mov r8, qword [r12 + STRING_PROC_LIST_T_LAST] ; r8 = list->last

    cmp r8, NULL
    je .siEsNull_add_node

    ; lista no vacía
    mov qword [r15 + STRING_PROC_NODE_PREVIOUS], r8
    mov qword [r8 + STRING_PROC_NODE_NEXT], r15
    mov qword [r12 + STRING_PROC_LIST_T_LAST], r15
    jmp .finC_add_node

.siEsNull_add_node:
    ; lista vacía
    mov qword [r12 + STRING_PROC_LIST_T_FIRST], r15
    mov qword [r12 + STRING_PROC_LIST_T_LAST], r15

.finC_add_node:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

string_proc_list_concat_asm:
   
    push rbp
    mov rbp,rsp
    push r12
    push r13
    push r14
    push r15
    push rbx
    sub rsp, 8

    mov r12, rdi
    mov r13, rsi
    mov r14, rdx 

    ;r12 -> list
    ;r13 -> type
    ;r14 -> hash

    mov r15, [r12+STRING_PROC_LIST_T_FIRST]; r15 = actual_node
    mov rbx, r14; armo rbx como rta

    .ciclo:
    cmp r15, NULL
    je .fin ;actual_node == NULL
    ;sino

    mov r8b, byte[r15+TYPE] ;actual_node->type

    cmp r8b, r13b ; actual_node->type == type
    jne .siguienteCiclo
    ;sino

    mov rdi, rbx
    mov rsi, [r15+HASH]

    call str_concat

    mov r8, rbx ;r8 = al antiguo puntero
    mov rbx, rax ; ahora rbx esta actualizado

    cmp r8, r14 ; si rbx != puntero_hash_original
    jne .noSonIguales

    .siguienteCiclo:
    mov r15, [r15+STRING_PROC_NODE_NEXT]; actualNode = actual_node->next
    jmp .ciclo

    .noSonIguales:
    mov rdi, r8
    call free
    jmp .siguienteCiclo

    .fin:
    mov rax, rbx
    add rsp, 8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp