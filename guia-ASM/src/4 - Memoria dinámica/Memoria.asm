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

; int32_t strCmp(char* a, char* b)
strCmp:
	ret

; char* strClone(char* a)
strClone:
	ret

; void strDelete(char* a)
strDelete:
	ret

; void strPrint(char* a, FILE* pFile)
strPrint:
	ret

; uint32_t strLen(char* a)

;RDI -> a
strLen:
    push rbp
    mov rbp, rsp

    xor rax, rax        ; contador de longitud = 0
.loop:
    mov al, byte [rdi]  ; leemos un byte (char) desde str
    cmp al, 0           ; ¿es el terminador?
    je .fin
    inc rdi             ; avanzamos al siguiente carácter
    inc rax             ; sumamos 1 a la longitud
    jmp .loop

.fin:
    pop rbp
    ret                 ; longitud queda en RAX

