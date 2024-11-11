#define _REENTRANT
#include <pthread.h>

#define NUM_THREADS 4
#define NUM_LOOPS 1000000
#define PROC_A 1
#define PROC_B 2
#define PROC_C 4
#define PROC_D 8

pthread_t tid[NUM_THREADS];

int flgA = 0, flgB = 0, flgC = 0, flgD = 0;
int flgWhoFirst;

int fctLoopA(int nLoops);
int fctLoopB(int nLoops);
int fctLoopC(int nLoops);
int fctLoopD(int nLoops);

main(int argc, char *argv[]) {
  int i;
  pthread_attr_t attr;


  /*
  **  Create an attribute structure with system scheduling
  **  so that each will be scheduled by the system.
  */
  pthread_attr_init(&attr);
  pthread_attr_setscope(&attr, PTHREAD_SCOPE_SYSTEM);

  /*
  **  Create (and execute) each thread
  */            
  pthread_create(&tid[0], &attr, fctLoopA, NUM_LOOPS);
  pthread_create(&tid[1], &attr, fctLoopB, NUM_LOOPS);
  pthread_create(&tid[2], &attr, fctLoopC, NUM_LOOPS);
  pthread_create(&tid[3], &attr, fctLoopD, NUM_LOOPS);

  pthread_join(tid[0], NULL);
  pthread_join(tid[1], NULL);
  pthread_join(tid[2], NULL);
  pthread_join(tid[3], NULL);

}

int fctLoopA(int nLoops) {

  int iLoop;

  printf("In fctLoopA\n");

  for(iLoop = 0; iLoop < nLoops; iLoop++) {
    flgA = 0;
    flgWhoFirst = 0;

    flgA = 1;
    if(flgB == 0 && flgC == 0 && flgD == 0){
      flgWhoFirst |= PROC_A;

      if(flgWhoFirst != PROC_A) {
        printf("Sequential inconsistency found\n");
        printf("Loop index: %d\n", iLoop);
        printf("flgWhoFirst: %d\n", flgWhoFirst);
      }
    }
  }
  printf("Leaving fctLoopA\n");
}

int fctLoopB(int nLoops) {

  int iLoop;

  printf("In fctLoopB\n");

  for(iLoop = 0; iLoop < nLoops; iLoop++) {
    flgB = 0;
    flgWhoFirst = 0;
    flgB = 1;
    if(flgA == 0 && flgC == 0 && flgD == 0){
      flgWhoFirst |= PROC_B;

      if(flgWhoFirst != PROC_B) {
        printf("Sequential inconsistency found\n");
        printf("Loop index: %d\n", iLoop);
        printf("flgWhoFirst: %d\n", flgWhoFirst);
      }
    }
  }
  printf("Leaving fctLoopB\n");
}

int fctLoopC(int nLoops) {

  int iLoop;

  printf("In fctLoopC\n");

  for(iLoop = 0; iLoop < nLoops; iLoop++) {
    flgC = 0;
    flgWhoFirst = 0;
    flgC = 1;
    if(flgA == 0 && flgB == 0 && flgD == 0){
      flgWhoFirst |= PROC_C;

      if(flgWhoFirst != PROC_C) {
        printf("Sequential inconsistency found\n");
        printf("Loop index: %d\n", iLoop);
        printf("flgWhoFirst: %d\n", flgWhoFirst);
      }
    }
  }
  printf("Leaving fctLoopC\n");
}
  
int fctLoopD(int nLoops) {

  int iLoop;

  printf("In fctLoopD\n");

  for(iLoop = 0; iLoop < nLoops; iLoop++) {
    flgD = 0;
    flgWhoFirst = 0;
    flgD = 1;
    if(flgA == 0 && flgB == 0 && flgC == 0){
      flgWhoFirst |= PROC_D;

      if(flgWhoFirst != PROC_D) {
        printf("Sequential inconsistency found\n");
        printf("Loop index: %d\n", iLoop);
        printf("flgWhoFirst: %d\n", flgWhoFirst);
      }
    }
  }
  printf("Leaving fctLoopD\n");
}
