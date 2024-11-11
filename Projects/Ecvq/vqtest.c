#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <time.h>
#include <math.h>

#include "../matlib/matlib.h"
#include "vquant.h"

#ifndef RAND_MAX
#define RAND_MAX 32767 
#endif

main(int argc, char *argv[]) {
    int     flg, *Indices; 
    long    nElem, nCodes, nData, nVecs, iCol, iRow;
    float   MSE, *vecSE, etime;

    Matrix  CodeBook, Data;
    

    /**
     ** Initialization parameters.
     **/
    nElem = 4;
    nCodes = 256;
    nVecs = 10000;

    /**
     **  Load in the data values
     **/
    fprintf(stderr, "Extracting %s from %s\n", argv[2], argv[1]);
    flg = getMatVarSubset(argv[1], argv[2], &Data, nElem * nVecs);

    /**
     **  Reshape the data matrix to fix the codeword length
     **/
    fprintf(stderr, "Input matrix size %dx%d\n", Data.nRows, Data.nCols);
    nData = Data.nRows * Data.nCols;
    MatReshape(&Data, nElem, nVecs);
    fprintf(stderr, "Reshaped matrix size %dx%d\n", Data.nRows, Data.nCols);

    /**
     **  Allocate the codebook matrix, index and squared error arrays.
     **/
    flg = MatAlloc(&CodeBook, nElem, nCodes);
    if(flg == 0) {
        fprintf(stderr, "Unable to allocate CodeBook\n");
        exit(-1);
    }

    Indices = (int *) calloc(nData, sizeof(int));
    if(Indices == NULL) {
        fprintf(stderr, "Unable to allocate Indices\n");
        exit(-1);
    }
        
    vecSE = (float *) calloc(nData, sizeof(float));
    if(vecSE == NULL) {
        fprintf(stderr, "Unable to allocate Sqaured Error Vector\n");
        exit(-1);
    }
    
    /**
     ** Fill the codebook array with random numbers
     **/
    srand((unsigned int) time(NULL));
    for(iCol=0; iCol<CodeBook.nCols; iCol++) {
        for(iRow=0; iRow<CodeBook.nRows; iRow++) {
            CodeBook.array[iRow][iCol] = (float) (rand()) / (float) (RAND_MAX) 
              - 0.5;
        }
    }
    
    printf("Runnning Full Search VQ algorithm ...\n");

    clock();
    MSE = VQFullSearch(CodeBook, Data, Indices, vecSE);
    etime = clock();

    printf("Codebook generation time %f\n", etime / CLOCKS_PER_SEC);

}
