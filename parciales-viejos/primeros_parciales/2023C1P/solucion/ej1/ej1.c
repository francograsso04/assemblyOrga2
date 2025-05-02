#include "ej1.h"

uint32_t cuantosTemplosClasicos_c(templo *temploArr, size_t temploArr_len){
    uint32_t cantidad_de_templos_clasicos = 0;

    for (int i = 0; i < temploArr_len; i++){
        templo templo_actual = temploArr[i];
        uint8_t colum_largo_actual = templo_actual.colum_largo;
        uint8_t colum_corto_actual = templo_actual.colum_corto;

        if(colum_largo_actual == (2*colum_corto_actual+1)){
            cantidad_de_templos_clasicos++;
        }
        
    }
    return cantidad_de_templos_clasicos;


}
  
templo* templosClasicos_c(templo *temploArr, size_t temploArr_len){
    uint32_t cantidad_templos_clasicos = cuantosTemplosClasicos_c(temploArr, temploArr_len);
    templo* arrayTemplo = malloc(cantidad_templos_clasicos * 24); //o malloc(cantidad_templos_clasicos * sizeof(TEMPLO)).
    size_t numeroDeTemplosClasicosAgregados = 0;
    for (int i = 0; i < temploArr_len; i++){
        templo templo_actual = temploArr[i];
        uint8_t colum_largo_actual = templo_actual.colum_largo;
        uint8_t colum_corto_actual = templo_actual.colum_corto;

        if(colum_largo_actual == (2*colum_corto_actual+1)){
            //lo agrego al array
            arrayTemplo[numeroDeTemplosClasicosAgregados] = temploArr[i];
            numeroDeTemplosClasicosAgregados++;
        }
        
    }
    return arrayTemplo;

}
