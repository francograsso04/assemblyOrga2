; /** defines bool y puntero **/
%define NULL 0
%define TRUE 1
%define FALSE 0

;Lista dobl enlazada
STRING_PROC_NODE_T_FIRST EQU 0
STRING_PROC_NODE_T_LAST EQU 8
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


pop rbp 
ret



string_proc_node_create_asm:

string_proc_list_add_node_asm:

string_proc_list_concat_asm:
