#include <stdio.h>
#include <stdlib.h>
#include "./qthread.h"

//void thrun();
//void thwait();

void secondt() {
    printf("Second Thread\n");
    /*
    int count = 0;
    while(1) {
        printf("second [%d]\n", count++);
        thwait();
    }
    */

    int count = 0;
    for (int i = 0; i < 3; ++i, ++count) {
        printf("second [%d]\n", i);
        thwait();
    }
    printf("total count in second = %d\n", count);
//    thwait();

}

void mainthread() {
    printf("Main Thread Run\n");

    create_thread(secondt, 1);
    thwait();
    /*
    int count = 0;
    while(1) {
        printf("main   [%d]\n", count++);
        thwait();
    }
     */

    int count = 0;
    for (int i = 0; i < 20; ++i, ++count) {
        printf("main   [%d]\n", i);
        thwait();
    }
    printf("total count in second = %d\n", count);
    printf("Main Thread Rung\n");     
    //    exit(1);

}

int main(void) {    
    current = NULL;
    thnum = 0;
    tid = 0;
    create_mainthread(mainthread);
    thrun();
    printf("end of main\n");

    return 0;
}
