#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include "matlib.h"

#ifndef CLOCKS_PER_SEC
#define CLOCKS_PER_SEC 1E6
#endif

#ifndef RAND_MAX
#define RAND_MAX 2147483647
#endif


main(int argc, char *argv[]) {
    int     flg, TotalMults, TotalAdds ,nStart, nStop, nSize;
    long    nr1, nc1, nr2, nc2, iCol, iRow;
	long	nr4, nc4, nr5, nc5;
    float etime, start;
    Matrix  m1;
    Matrix  m2;
    Matrix  m3;
    Matrix  m4;
    Matrix  m5;
    Matrix  m6;
    FILE    *fptrData = NULL;     

    if(argc < 3) {
        printf("Usage:  matmult2 nStart nStop filename\n");
        exit(0);
    }
    else {
        nStart = atoi(argv[1]);
        nStop = atoi(argv[2]);
    }
    if(argc > 3) {
        if((fptrData = fopen(argv[3], "w+" )) == NULL )
            printf("Unable to open data file\n");
    }

    /**
     ** Allocate three square arrays
     **/
    printf(" CLOCKS_PER_SEC: %f\n",  (float) CLOCKS_PER_SEC);
    for(nSize = nStart; nSize <=nStop; nSize++) {
        printf("Size %d\n", nSize);
        nr1 = nSize;
        nc1 = nSize;
        nr2 = nSize;
        nc2 = nSize;
    
	    nr4 = nSize;
        nc4 = nSize;
        nr5 = nSize;
        nc5 = nSize;
    
	    start = clock();
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
        if( flg == 0)
            printf("Unable to allocate array 3\n");
        else
            printf("Able to allocate array 3\n");

	    flg = MatAlloc(&m4, nr4, nc4);
        if(flg == 0)
            printf("Unable to allocate array 4\n");
        else
            printf("Able to allocate array 4\n");
    
        flg = MatAlloc(&m5, nr5, nc5);
        if(flg == 0)
            printf("Unable to allocate array 5\n");
        else
            printf("Able to allocate array 5\n");

        flg = MatAlloc(&m6, nr4, nc5);
        if(flg == 0)
            printf("Unable to allocate array 6\n");
        else
            printf("Able to allocate array 6\n");

        etime = clock() - start;
        printf("Allocation time %f\n", etime / CLOCKS_PER_SEC);
    

        /**
        ** Fill the arrays with random numbers
        **/
        start = clock();
        printf("Generating random numbers ...\n");     
        for(iRow=0; iRow<nr4; iRow++) {
	        for(iCol=0; iCol<nc4; iCol++) {
                m4.array[iRow][iCol] = (MAT_FLOAT) (rand()) /
                    (MAT_FLOAT) (RAND_MAX) - 0.5;

            }
        }
	    for(iRow=0; iRow<nr5; iRow++) {    
            for(iCol=0; iCol<nc5; iCol++) {
                m5.array[iRow][iCol] = (MAT_FLOAT) rand() /
                    (MAT_FLOAT) RAND_MAX - 0.5;
            }
        }
        for(iRow=0; iRow<nr1; iRow++) {
	        for(iCol=0; iCol<nc1; iCol++) {
                m1.array[iRow][iCol] = (MAT_FLOAT) (rand()) / 
                    (MAT_FLOAT) (RAND_MAX) - 0.5;

            }
        }
        for(iRow=0; iRow<nr2; iRow++) {    
            for(iCol=0; iCol<nc2; iCol++) {
                m2.array[iRow][iCol] = (MAT_FLOAT) rand() / 
                    (MAT_FLOAT) RAND_MAX - 0.5;
            }
        }
    
	    etime = clock() - start;
        printf("Generation time %f\n", etime / CLOCKS_PER_SEC);
    

        /**
        ** Multiply M1 * M2 = M3
        **/
        start = clock();
    
        MatMult(m1, m2, m3);
    
	    /**
	    ** Multiply M4 * M5 = M6
        **/
        MatMult(m4, m5, m6);
    
        etime = clock() - start;
        printf("Multiplication time %f\n", etime / CLOCKS_PER_SEC);

        TotalMults =  nc1 * nc2 * nr1;
        TotalAdds = (nc1-1) * nc2 * nr1;
        printf("Total Floating Point Multiplies: %d\n", 2 * TotalMults);
        printf("Total Floating Point Adds: %d\n", 2 * TotalAdds);
        printf("Total Floating Point Operations: %d\n", 
            2 * (TotalMults + TotalAdds));
        printf("Total Flops : %f\n", 
            2 * (TotalMults + TotalAdds) / (etime / CLOCKS_PER_SEC));
        if(fptrData != NULL)
            fprintf(fptrData, "%d\t%f\n", nSize, 
                (float) 2 * (TotalMults + TotalAdds) / (etime / CLOCKS_PER_SEC));
        MatFree(m6);
        MatFree(m5);
        MatFree(m4);
        MatFree(m3);
        MatFree(m2);
        MatFree(m1);

    }
    return 0;
}