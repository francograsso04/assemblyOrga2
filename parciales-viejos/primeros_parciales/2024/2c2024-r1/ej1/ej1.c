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
bool EJERCICIO_1B_HECHO = true;

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
            if(elemento_actual == NULL || compartida == elemento_actual){
                continue;
            }
            if (fun_hash(elemento_actual) == hash_compartido) {
                // 5) Reemplaza el puntero en el mapa
                mapa[i][j] = compartida;
                elemento_actual->references--;
                // 6) Incrementa el contador de la unidad compartida
                compartida->references++;
                if(elemento_actual->references == 0){
                    free(elemento_actual);
                }
            }
        }
    }
}
/**
 * OPCIONAL: implementar en C
 */
uint32_t contarCombustibleAsignado(mapa_t mapa, uint16_t (*fun_combustible)(char*)) {
    uint32_t combustible_asignado = 0;
    const int longitud = 255;

    for (int i = 0; i < longitud; i++ ){
        for (int j = 0; j < longitud; j++){
            attackunit_t* elemento_actual = mapa[i][j];
            if (elemento_actual == NULL) continue;

            uint16_t combustible_de_elemento_actual = elemento_actual->combustible;
            uint16_t combustible_base_de_elemento_actual = fun_combustible(elemento_actual->clase);

            if (combustible_de_elemento_actual > combustible_base_de_elemento_actual){
                uint16_t diferencia_de_combustible = combustible_de_elemento_actual - combustible_base_de_elemento_actual;
                combustible_asignado += diferencia_de_combustible;
            }
        }
    }   
    return combustible_asignado;
}


/**
 * OPCIONAL: implementar en C
 */
void modificarUnidad(mapa_t mapa, uint8_t x, uint8_t y, void (*fun_modificar)(attackunit_t*)) {

}
