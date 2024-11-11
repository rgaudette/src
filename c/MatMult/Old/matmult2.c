#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "matlib.h"


main(int argc, char *argv[]) {
    int     flg, TotalMults, TotalAdds;
    long    nr1, nc1, nr2, nc2, iCol, iRow;
    float etime;
    Matrix  m1;
    Matrix  m2;
    Matrix  m3;
         

    /**
     ** Allocate three square arrays
     **/
    nr1 = 400;
    nc1 = 400;
    nr2 = 400;
    nc2 = 400;
    
    clock();
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

    etime = clock();
    printf("Allocation time %f\n", etime / CLOCKS_PER_SEC);
    

    /**
     ** Fill the arrays with random numbers
     **/
    clock();
    printf("Generating random numbers ...\n");     
    for(iRow=0; iRow<nr1; iRow++) {
	for(iCol=0; iCol<nc1; iCol++) {
            m1.array[iRow][iCol] = (float) (rand()) / (float) (RAND_MAX) - 0.5;

        }
    }
   for(iRow=0; iRow<nr2; iRow++) {    
       for(iCol=0; iCol<nc2; iCol++) {
            m2.array[iRow][iCol] = (float) rand() / (float) RAND_MAX - 0.5;
        }
    }
    etime = clock();
    printf("Generation time %f\n", etime / CLOCKS_PER_SEC);
    

    /**
     ** Multiply M1 * M2 = M3
     **/
    clock();
    printf("Multiplying matrices ...\n");     
    MatMult(m1, m2, m3);

    etime = clock();
    printf("Multiplication time %f\n", etime / CLOCKS_PER_SEC);

    TotalMults =  nc1 * nc2 * nr1;
    TotalAdds = (nc1-1) * nc2 * nr1;
    printf("Total Floating Point Multiplies: %d\n", TotalMults);
    printf("Total Floating Point Adds: %d\n", TotalAdds);
    printf("Total Floating Point Operations: %d\n", TotalMults + TotalAdds);
    printf("Total Flops : %f\n", (TotalMults + TotalAdds) / (etime / CLOCKS_PER_SEC));
        
    MatFree(m3);
    MatFree(m2);
    MatFree(m1);
    return 0;
}
