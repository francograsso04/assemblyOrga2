#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ej1.h"

/**
 * Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - es_indice_ordenado
 */
bool EJERCICIO_1A_HECHO = true;

/**
 * Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - indice_a_inventario
 */
bool EJERCICIO_1B_HECHO = false;

/**
 * OPCIONAL: implementar en C
 */

// inventario es lista de punteros.
// indice es un array de indices (que supuestamente estan ordenados con el comparador)
// tamaño es es tamaño de inventario e indice_a_inventario
// comparador es una funcion.


bool es_indice_ordenado(item_t** inventario, uint16_t* indice, uint16_t tamanio, comparador_t comparador) {
	for (int i = 0; i < tamanio-1; i++){
		item_t* a = inventario[indice[i]];
		item_t* b = inventario[indice[i + 1]];
		if (!comparador(a, b)) {
    		return false;
			}
		
	}
	return true ;
}

/**
 * OPCIONAL: implementar en C
 */
item_t** indice_a_inventario(item_t** inventario, uint16_t* indice, uint16_t tamanio) {
	// ¿Cuánta memoria hay que pedir para el resultado?
	item_t** resultado;
	return resultado;
}
