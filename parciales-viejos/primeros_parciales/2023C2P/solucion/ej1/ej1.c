#include "ej1.h"

list_t* listNew(){
  list_t* l = (list_t*) malloc(sizeof(list_t));
  l->first=NULL;
  l->last=NULL;
  return l;
}

void listAddLast(list_t* pList, pago_t* data){
    listElem_t* new_elem= (listElem_t*) malloc(sizeof(listElem_t));
    new_elem->data=data;
    new_elem->next=NULL;
    new_elem->prev=NULL;
    if(pList->first==NULL){
        pList->first=new_elem;
        pList->last=new_elem;
    } else {
        pList->last->next=new_elem;
        new_elem->prev=pList->last;
        pList->last=new_elem;
    }
}


void listDelete(list_t* pList){
    listElem_t* actual= (pList->first);
    listElem_t* next;
    while(actual != NULL){
        next=actual->next;
        free(actual);
        actual=next;
    }
    free(pList);
}

// typedef struct
// {
//     uint8_t monto;
//     uint8_t aprobado;
//     char *pagador;
//     char *cobrador;
// } pago_t;

// typedef struct
// {
//     uint8_t cant_aprobados;
//     uint8_t cant_rechazados;
//     pago_t **aprobados;
//     pago_t **rechazados;
// } pagoSplitted_t;

// /* List */

// typedef struct s_listElem
// {
//     pago_t *data;
//     struct s_listElem *next;
//     struct s_listElem *prev;
// } listElem_t;

// typedef struct s_list
// {
//     struct s_listElem *first;
//     struct s_listElem *last;
// } list_t;

uint8_t contar_pagos_aprobados(list_t* pList, char* usuario){
    //Debo contar los pagos aprobados
    uint8_t pagos_aprobados=0;

    //Desreferencio.
    listElem_t *nodo = (*pList).first;

    while(nodo != NULL){
        if (nodo->data->aprobado != 0){
            pagos_aprobados++;
        }
        nodo = nodo->next;
    }
    return pagos_aprobados;
}

uint8_t contar_pagos_rechazados(list_t* pList, char* usuario){
}

pagoSplitted_t* split_pagos_usuario(list_t* pList, char* usuario){

}