#include "ej1.h"

uint32_t* acumuladoPorCliente(uint8_t cantidadDePagos, pago_t* arr_pagos) {
    uint32_t* lista_armada = calloc(10, sizeof(uint32_t));  // reserva e inicializa en 0

    for (int i = 0; i < cantidadDePagos; i++) {
        pago_t pago = arr_pagos[i];
        if (pago.aprobado) {
            lista_armada[pago.cliente] += pago.monto;
        }
    }

    return lista_armada;
}



uint8_t en_blacklist(char* comercio, char** lista_comercios, uint8_t n){
    for (int i = 0; i < n; i++){
        char* comercio_actual = lista_comercios[i];
        if (strcmp(comercio_actual, comercio) == 0){
            return 1;
        }
    }
    return 0;
}



pago_t** blacklistComercios(uint8_t cantidad_pagos, pago_t* arr_pagos, char** arr_comercios, uint8_t size_comercios) {
    pago_t** lista_de_pagos_en_lista_negra = malloc(sizeof(pago_t*) * cantidad_pagos);
    uint8_t indice_lista_pagos = 0;
    for (int i = 0; i < cantidad_pagos; i++) {
        if (en_blacklist(arr_pagos[i].comercio, arr_comercios, size_comercios) == 1) {
            lista_de_pagos_en_lista_negra[indice_lista_pagos] = &arr_pagos[i];
            indice_lista_pagos++;
        }
    }
    return lista_de_pagos_en_lista_negra;
}


