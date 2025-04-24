//*************************************
//Declaración de estructuras
//*************************************

// Lista de arreglos de enteros de 32 bits sin signo.
// next: Siguiente elemento de la lista o NULL si es el final
// categoria: Categoría del nodo
// arreglo: Arreglo de enteros
// longitud: Longitud del arreglo
typedef struct nodo_s {
    struct nodo_s* next;   //(0-7)
    uint8_t categoria;     //(byte 8 + 7 de offset)
    uint32_t* arreglo;     //(16-23)
    uint32_t longitud;     //(24-27 + 4 de offset)
} nodo_t; //32

typedef struct __attribute__((__packed__)) packed_nodo_s {
    struct packed_nodo_s* next; //(0-7)
    uint8_t categoria;     //(8)
    uint32_t* arreglo;     //(9-16)
    uint32_t longitud;     //(17-20)
} packed_nodo_t; //24

// Puntero al primer nodo que encabeza la lista
typedef struct lista_s {
    nodo_t* head;    //(0-7)
} lista_t; //asmdef_size:LISTA_SIZE

// Puntero al primer nodo que encabeza la lista
typedef struct __attribute__((__packed__)) packed_lista_s {
    packed_nodo_t* head;    //(0-7)
} packed_lista_t; //asmdef_size:PACKED_LISTA_SIZE
