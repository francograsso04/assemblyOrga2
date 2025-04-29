extern sumar_c
extern restar_c
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS

global alternate_sum_4
global alternate_sum_4_using_c
global alternate_sum_4_using_c_alternative
global alternate_sum_8
global product_2_f
global product_9_f

;########### DEFINICION DE FUNCIONES
; uint32_t alternate_sum_4(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4:
  sub EDI, ESI
  add EDI, EDX
  sub EDI, ECX

  mov EAX, EDI
  ret

; uint32_t alternate_sum_4_using_c(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4_using_c:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  push R12
  push R13	; preservo no volatiles, al ser 2 la pila queda alineada

  mov R12D, EDX ; guardo los parámetros x3 y x4 ya que están en registros volátiles
  mov R13D, ECX ; y tienen que sobrevivir al llamado a función

  call restar_c 
  ;recibe los parámetros por EDI y ESI, de acuerdo a la convención, y resulta que ya tenemos los valores en esos registros
  
  mov EDI, EAX ;tomamos el resultado del llamado anterior y lo pasamos como primer parámetro
  mov ESI, R12D
  call sumar_c

  mov EDI, EAX
  mov ESI, R13D
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  pop R13 ;restauramos los registros no volátiles
  pop R12
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret




alternate_sum_4_using_c_alternative:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  sub RSP, 16 ; muevo el tope de la pila 8 bytes para guardar x4, y 8 bytes para que quede alineada

  mov [RBP-8], RCX ; guardo x4 en la pila

  push RDX  ;preservo x3 en la pila, desalineandola
  sub RSP, 8 ;alineo
  call restar_c 
  add RSP, 8 ;restauro tope
  pop RDX ;recupero x3
  
  mov EDI, EAX
  mov ESI, EDX
  call sumar_c

  mov EDI, EAX
  mov ESI, [RBP - 8] ;leo x4 de la pila
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  add RSP, 16 ;restauro tope de pila
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret

;rdi: Primer parámetro

;rsi: Segundo parámetro

;rdx: Tercer parámetro

;rcx: Cuarto parámetro

;r8: Quinto parámetro

;r9: Sexto parámetro

; uint32_t alternate_sum_8(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4, uint32_t x5, uint32_t x6, uint32_t x7, uint32_t x8);
; registros y pila: x1[?], x2[?], x3[?], x4[?], x5[?], x6[?], x7[?], x8[?]
alternate_sum_8:
    ; Prologo
    push    rbp                 ; Guardamos el valor actual de rbp (marco de pila)
    mov     rbp, rsp            ; Establecemos rbp como el nuevo puntero de base de la pila

    ; Primer bloque de operaciones
    call    restar_c            ; Llamamos a restar_c
    mov     rdi, eax            ; Guardamos el resultado de eax (resta) en rdi
    mov     rsi, rdx            ; Guardamos el siguiente parámetro en rsi
    call    sumar_c             ; Llamamos a sumar_c

    ; Segundo bloque de operaciones
    mov     rdi, eax            ; Guardamos el resultado de eax (suma) en rdi
    mov     rsi, rcx            ; Guardamos el siguiente parámetro en rsi
    call    restar_c            ; Llamamos a restar_c

    ; Tercer bloque de operaciones
    mov     rdi, eax            ; Guardamos el resultado de eax (resta) en rdi
    mov     rsi, r8             ; Guardamos el siguiente parámetro en rsi
    call    sumar_c             ; Llamamos a sumar_c

    ; Cuarto bloque de operaciones
    mov     rdi, eax            ; Guardamos el resultado de eax (suma) en rdi
    mov     rsi, r9             ; Guardamos el siguiente parámetro en rsi
    call    restar_c            ; Llamamos a restar_c

    ; Quinto bloque de operaciones
    mov     rdi, eax            ; Guardamos el resultado de eax (resta) en rdi
    mov     rsi, DWORD [rbp + 16]     ; Cargamos el séptimo parámetro desde la pila en rsi
    call    sumar_c             ; Llamamos a sumar_c

    ; Sexto bloque de operaciones
    mov     rdi, eax            ; Guardamos el resultado de eax (suma) en rdi
    mov     rsi, DWORD [rbp + 24]     ; Cargamos el octavo parámetro desde la pila en rsi
    call    restar_c            ; Llamamos a restar_c

    ; Epilogo
    pop     rbp                 ; Restauramos el valor original de rbp
    ret                         ; Retornamos de la función


; SUGERENCIA: investigar uso de instrucciones para convertir enteros a floats y viceversa
;void product_2_f(uint32_t * destination, uint32_t x1, float f1);
;registros: destination[?], x1[?], f1[?]
product_2_f:
    push    rbp                ; Guardar el valor de rbp (registro de base)
    mov     rbp, rsp           ; Establecer el puntero de base para la pila

    ; Parametros: 
    ; rdi = destination (puntero al resultado)
    ; rsi = x1 (entero)
    ; rdx = f1 (flotante)
    
    ; Convertir x1 a flotante (en xmm0)
    movd    xmm0, rsi          ; Mover x1 (entero) a xmm0 como flotante
    
    ; Multiplicar x1 (en xmm0) por f1 (en xmm1)
    movss   xmm1, DWORD PTR [rdx]  ; Cargar f1 (flotante) en xmm1
    mulss   xmm0, xmm1          ; Multiplicamos xmm0 (x1) por xmm1 (f1), el resultado queda en xmm0
    
    ; Convertir el resultado de xmm0 (flotante) a entero (en eax)
    cvttss2si eax, xmm0         ; Convertir el flotante a entero y almacenarlo en eax
    
    ; Guardar el resultado en destination (puntero)
    mov     [rdi], eax          ; Almacenar el resultado en la dirección apuntada por rdi (destination)

    pop     rbp                 ; Restaurar rbp
    ret                         ; Retornar de la función

