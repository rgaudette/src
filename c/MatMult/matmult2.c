#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>
#include <sys/times.h>

#include "../matlib/matlib.h"

/* #ifndef CLOCKS_PER_SEC
#define CLOCKS_PER_SEC 1E6
#endif */

#ifndef RAND_MAX
#define RAND_MAX 2147483647
#endif


main(int argc, char *argv[]) {
    int     flg, TotalMults, TotalAdds;
    long    nr1, nc1, nr2, nc2, iCol, iRow;
    double  etime;
    Matrix  m1;
    Matrix  m2;
    Matrix  m3;
    struct timeval tv1, tv2;
    struct tms ProcTime1, ProcTime2;

    /**
     ** Allocate three square arrays
     **/
    nr1 = 216;
    nc1 = 215;
    nr2 = 215;
    nc2 = 216;

    /*
    nr1 = 800;
    nc1 = 800;
    nr2 = 800;
    nc2 = 800;
    */

    gettimeofday(&tv1, NULL);

    printf("start time %u\t%u\n", tv1.tv_sec, tv1.tv_usec);

    /**
    **  Matrix allocation
    **/
    flg = MatAlloc(&m1, nr1, nc1);
    if(flg == 0)
        printf("Unable to allocate array 1\n");
    else
        printf("Able to allocate array 1\n");
    
    flg = MatAlloc(&m2, nr2, nc2);
    if(flg == 0)
        printf("Unable to allocate array 2\n");
    else
        printf("Able to allocate array 2\n");

    flg = MatAlloc(&m3, nr1, nc2);
    if(flg == 0)
        printf("Unable to allocate array 3\n");
    else
        printf("Able to allocate array 3\n");

    gettimeofday(&tv2, NULL);
    printf("Allocation time %f\n", tv2.tv_sec - tv1.tv_sec + (tv2.tv_usec - tv1.tv_usec) * 1E-6);

    /*    printf("alloc time %ud\n", );
    etime = c2 - c1;
    time(&t2);
    etime = difftime(t2, t1);
    printf("Allocation time %f\n", etime / CLOCKS_PER_SEC); */
    

    /**
     ** Fill the arrays with random numbers
     **/
    printf("Generating random numbers ...\n");     
    gettimeofday(&tv1, NULL);
    for(iRow=0; iRow<nr1; iRow++) {
	for(iCol=0; iCol<nc1; iCol++) {
            m1.array[iRow][iCol] = (MAT_FLOAT) (rand()) / (MAT_FLOAT) (RAND_MAX) - 0.5;

        }
    }
   for(iRow=0; iRow<nr2; iRow++) {    
       for(iCol=0; iCol<nc2; iCol++) {
            m2.array[iRow][iCol] = (MAT_FLOAT) rand() / (MAT_FLOAT) RAND_MAX - 0.5;
        }
    }
    gettimeofday(&tv2, NULL);
    printf("Generation time %f\n", tv2.tv_sec - tv1.tv_sec + (tv2.tv_usec - tv1.tv_usec) * 1E-6);

    printf("Multiplying matrices ...\n");     
    times(&ProcTime1);
    gettimeofday(&tv1, NULL);

    /**
     ** Multiply M1 * M2 = M3
     **/
    MatMult(m1, m2, m3);

    /**
     **  Elapsed wall clock time
     **/
    gettimeofday(&tv2, NULL);
    printf("Multiplication time %f\n", 
           tv2.tv_sec - tv1.tv_sec + (tv2.tv_usec - tv1.tv_usec) * 1E-6);

    /**
     **  Elapsed processor clock time
     **/
    times(&ProcTime2);

    printf("User time %f\n", 1.0 * 
           (ProcTime2.tms_utime - ProcTime1.tms_utime) / CLOCKS_PER_SEC);

    printf("System time %f\n", 1.0 * 
           (ProcTime2.tms_stime - ProcTime1.tms_stime) / CLOCKS_PER_SEC);

    /**
     **  Processing stats
     **/
    TotalMults =  nc1 * nc2 * nr1;
    TotalAdds = (nc1-1) * nc2 * nr1;
    printf("Total Floating Point Multiplies: %d\n", TotalMults);
    printf("Total Floating Point Adds: %d\n", TotalAdds);
    printf("Total Floating Point Operations: %d\n", TotalMults + TotalAdds);
    printf("Total Flops (wall clock) : %f\n", (TotalMults + TotalAdds) /  (tv2.tv_sec - tv1.tv_sec + (tv2.tv_usec - tv1.tv_usec) * 1E-6));

        
    MatFree(m3);
    MatFree(m2);
    MatFree(m1);
    return 0;
}
