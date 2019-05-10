#ifndef _QTHREAD_H_
#define _QTHREAD_H_
#include <stdint.h>

#define T_NUM 3

typedef void (*tfunc)();

typedef struct _q_thread {
    uint64_t ctx[18];
    char* stack;
    tfunc f;
    uint32_t tid;        
    uint8_t is_active;
} q_thread;

q_thread threads[T_NUM];

void create_thread(tfunc f, int idx);
void create_mainthread(tfunc mainf);


void thrun();
void thwait();
void thresume();
void thfin();

q_thread *current;
int tid;
int thnum;

#endif