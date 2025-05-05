#include "ej1.h"

string_proc_list* string_proc_list_create(void){
	string_proc_list* lista_doblemente_enlazada = malloc(sizeof(string_proc_list));
	if (lista_doblemente_enlazada != NULL) {
        lista_doblemente_enlazada->first = NULL;
        lista_doblemente_enlazada->last = NULL;
    }
	return lista_doblemente_enlazada;

	
}

string_proc_node* string_proc_node_create(uint8_t type, char* hash){
	string_proc_node* nuevoNodo = malloc(sizeof(string_proc_node));

	if (nuevoNodo != NULL){
		nuevoNodo->next=NULL;
		nuevoNodo->previous=NULL;
		nuevoNodo->type=type;
		nuevoNodo->hash=hash;
	};
	return nuevoNodo;

	
}

void string_proc_list_add_node(string_proc_list* list, uint8_t type, char* hash){
    string_proc_node* nuevoNodo = string_proc_node_create(type, hash);
    if (nuevoNodo == NULL) return;

    if (list->last == NULL) {
        // Lista vacía
        list->first = nuevoNodo;
        list->last = nuevoNodo;
    } else {
        // Agregar al final
        nuevoNodo->previous = list->last;
        list->last->next = nuevoNodo;
        list->last = nuevoNodo;
    }
}


char* string_proc_list_concat(string_proc_list* list, uint8_t type, char* hash) {
    string_proc_node* actual_node = list->first;
    char* res = hash;
    while(actual_node != NULL){
        if(actual_node->type == type){
            res=str_concat(res,actual_node->hash);
        }
        actual_node = actual_node->next;
    }
    return res;
}


// typedef struct string_proc_list_t {
// 	struct string_proc_node_t* first;
// 	struct string_proc_node_t* last;
// } string_proc_list;

// /** Nodo **/
// typedef struct string_proc_node_t {
// 	struct string_proc_node_t* next;
// 	struct string_proc_node_t* previous;
// 	uint8_t type;
// 	char* hash;
// } string_proc_node;

/** AUX FUNCTIONS **/

void string_proc_list_destroy(string_proc_list* list){

	/* borro los nodos: */
	string_proc_node* current_node	= list->first;
	string_proc_node* next_node		= NULL;
	while(current_node != NULL){
		next_node = current_node->next;
		string_proc_node_destroy(current_node);
		current_node	= next_node;
	}
	/*borro la lista:*/
	list->first = NULL;
	list->last  = NULL;
	free(list);
}
void string_proc_node_destroy(string_proc_node* node){
	node->next      = NULL;
	node->previous	= NULL;
	node->hash		= NULL;
	node->type      = 0;			
	free(node);
}


char* str_concat(char* a, char* b) {
	int len1 = strlen(a);
    int len2 = strlen(b);
	int totalLength = len1 + len2;
    char *result = (char *)malloc(totalLength + 1); 
    strcpy(result, a);
    strcat(result, b);
    return result;  
}

void string_proc_list_print(string_proc_list* list, FILE* file){
        uint32_t length = 0;
        string_proc_node* current_node  = list->first;
        while(current_node != NULL){
                length++;
                current_node = current_node->next;
        }
        fprintf( file, "List length: %d\n", length );
		current_node    = list->first;
        while(current_node != NULL){
                fprintf(file, "\tnode hash: %s | type: %d\n", current_node->hash, current_node->type);
                current_node = current_node->next;
        }
}