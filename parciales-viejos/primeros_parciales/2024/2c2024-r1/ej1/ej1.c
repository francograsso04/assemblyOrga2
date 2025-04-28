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
 *   - contarCombustibleAsignado
 */
bool EJERCICIO_1B_HECHO = false;

/**
 * Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - modificarUnidad
 */
bool EJERCICIO_1C_HECHO = false;

/**
 * OPCIONAL: implementar en C
 */
void optimizar(mapa_t mapa,
               attackunit_t* compartida,
               uint32_t (*fun_hash)(attackunit_t*)) {
                
    uint32_t hash_compartido = fun_hash(compartida);
    const int longitud = 254;  // o el tamaño real de tu mapa

    for (int i = 0; i <= longitud; i++) {
        for (int j = 0; j < longitud; j++) {
            attackunit_t* elemento_actual = mapa[i][j];
            // 1) Si la celda está vacía, continúa
            if (elemento_actual == NULL) 
                continue;
            if (fun_hash(elemento_actual) == hash_compartido) {
                // 5) Reemplaza el puntero en el mapa
                mapa[i][j] = compartida;

                // 6) Incrementa el contador de la unidad compartida
                compartida->references++;
            }
        }
    }
}
/**
 * OPCIONAL: implementar en C
 */
uint32_t contarCombustibleAsignado(mapa_t mapa, uint16_t (*fun_combustible)(char*)) {
}

/**
 * OPCIONAL: implementar en C
 */
void modificarUnidad(mapa_t mapa, uint8_t x, uint8_t y, void (*fun_modificar)(attackunit_t*)) {
}
