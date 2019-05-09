#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "qthread.h"


void test() {
    printf("Hello World\n");
}

void dispatch() {
    /*
    printf("Dispatch id = %d\n", tid);
    printf("save sp = %p\n", (char*)current->ctx[0]);
    printf("save bp = %p\n", (char*)current->ctx[1]);    
    printf("current = %p\n", current);
    */
    if (tid == 0) {
        tid = 1;
        current = &threads[tid];
    } else if (tid == 1) {
        tid = 0;
        current = &threads[tid];
    }
    /*
    printf("next    = %p\n", current);
    printf("next sp = %p\n", (char*)current->ctx[0]);
    printf("next f  = %p\n", (char*)current->f);
    */
}

void create_thread(tfunc f, int idx) {
    char* sp;   
    threads[idx].f = f;
    memset(threads[0].ctx, 0, sizeof(uint64_t) * 18);
    threads[idx].stack = malloc(0x8000);
    memset(threads[idx].stack, 0, 0x8000);
    sp = threads[idx].stack + 0x8000 - 0x100;
    ((uint64_t*)sp)[0] = (uint64_t)threads[idx].f;
    threads[idx].ctx[0] = (uint64_t)sp;
    
}

void create_mainthread(tfunc mainf) {    
    create_thread(mainf, 0);
    current = &threads[0];
}
