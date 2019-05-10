#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "qthread.h"


void test() {
    printf("Hello World\n");
}

static int get_next_tid() {
    if (++tid == thnum) {
        tid = 0;
    }
    for (int i = 0; i < thnum; ++i) {
        if (threads[tid].is_active == 1) break;        
        if (++tid >= thnum) tid = 0;
    }
    return tid;
}

void dispatch() {
    current = &threads[get_next_tid()];
    /*
    printf("Dispatch id = %d\n", tid);
    printf("save sp = %p\n", (char*)current->ctx[0]);
    printf("save bp = %p\n", (char*)current->ctx[1]);    
    printf("current = %p\n", current);
    */
    /*
    if (tid == 0) {
        tid = 1;
        current = &threads[tid];
    } else if (tid == 1) {
        tid = 0;
        current = &threads[tid];
    }
    */
    /*
    if (++tid == thnum) {
        tid = 0;
    }
    for (int i = 0; i < thnum; ++i) {
        if (threads[tid].is_active == 1) break;        
        if (++tid == thnum) tid = 0;
    }
    current = &threads[tid];
    */
    
    /*
    printf("next    = %p\n", current);
    printf("next sp = %p\n", (char*)current->ctx[0]);
    printf("next f  = %p\n", (char*)current->f);
    */
}

void end_thread() {
    printf("End Thread %d\n", current->tid);
    printf("thnum = %d\n", thnum);   

    current->is_active = 0;
    if (--thnum == 0) {
        printf("All thread end!\n");
//        printf("All thread end!\n");
//        exit(1);
        thfin();
    }
    current = &threads[get_next_tid()];
    thresume();
}

void create_thread(tfunc f, int idx) {
    char* sp;
    ++thnum;    
    threads[idx].f = f;
    threads[idx].tid = idx;
    threads[idx].is_active = 1;
    memset(threads[0].ctx, 0, sizeof(uint64_t) * 18);
    threads[idx].stack = malloc(0x8000);
    memset(threads[idx].stack, 0, 0x8000);
    sp = threads[idx].stack + 0x8000 - 0x100;
    ((uint64_t*)sp)[0] = (uint64_t)threads[idx].f;
    ((uint64_t*)sp)[1] = (uint64_t)end_thread;
    threads[idx].ctx[0] = (uint64_t)sp;
    
}

void create_mainthread(tfunc mainf) {    
    create_thread(mainf, 0);
    current = &threads[0];
}
