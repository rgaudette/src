#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include "mkl_cblas.h"

#include "../matrix.h"

void Usage(void);
FILE * openResultsFile(char[]);

int main(int argc, char *argv[]) {

    int m_min, m_max, iSize, m_step;
    FILE *resultsFile;
    Matrix matX, matY, matZ1;

	int iElem;
	double abs_diff, max_abs_diff, mean_abs_diff, total_abs_diff;
	Matrix matZ2;

    CBLAS_ORDER cCBRM = CblasRowMajor;
    CBLAS_ORDER cCBCM = CblasColMajor;
    CBLAS_TRANSPOSE cCBNT = CblasNoTrans;


    //
    //  Read in the command line argument
    //
    //  BLASMatrixMult results.txt min_size max_size [m_step]
    //
    if(argc < 4){
        Usage();
        exit(-1);
    }
    m_min = atoi(argv[2]);
    m_max = atoi(argv[3]);
	if(argc > 4) {
		m_step = atoi(argv[4]);
	}
	else {
		m_step = 1;
	}

    //
    //  Open output file or write to stdout if output file is -
    //
    resultsFile = openResultsFile(argv[1]);

	fprintf(resultsFile, "%%Size:\t\tMax Abs Diff:\t\tMean Abs Diff:\t\tTotal Abs Diff:\n");

    //
    //  Loop over matrix sizes
    //
    for(iSize=m_min; iSize<=m_max; iSize += m_step){
        //
        //  Allocate memory for matrices
        //
        matCreate(iSize, iSize, &matX);
        matCreate(iSize, iSize, &matY);
        matCreate(iSize, iSize, &matZ1);
        matCreate(iSize, iSize, &matZ2);
        
        //
        //  Fill matrices with random numbers
        //
        matRandUniform(&matX);
        matRandUniform(&matY);
               
        matMultiply(&matX, &matY, &matZ2);

        //
        //  Multiply matrices using C-BLAS routines from intel performance lib
        //
        
        cblas_sgemm(cCBCM, cCBNT, cCBNT, iSize, iSize, iSize, 1.0, 
            matX.array, iSize, matY.array, iSize, 
            0.0, matZ1.array, iSize);

        
        //
        //  Return the max abs value of the difference between the results
        //
        max_abs_diff = 0.0;
		total_abs_diff = 0.0;
		for(iElem = 0; iElem < matZ2.m*matZ2.n; iElem++){
			abs_diff = fabs(matZ1.array[iElem] - matZ2.array[iElem]);
			total_abs_diff += abs_diff;
			if (abs_diff > max_abs_diff) max_abs_diff = abs_diff;
        }
		mean_abs_diff = total_abs_diff / (matZ2.m*matZ2.n);
        
		//
        //  Deallocate matrices
        //
        matDestroy(&matX);
        matDestroy(&matY);
        matDestroy(&matZ1);
        matDestroy(&matZ2);
        
		//
        //  Write results
        //
        fprintf(resultsFile, "%d\t\t%e\t\t%e\t\t%e\n",
			matX.n, max_abs_diff, mean_abs_diff, total_abs_diff);
    }

    //
    //  Close output file
    //
    fclose(resultsFile);

	return 0;
}

void Usage(void){
    fprintf(stderr, "BLASCheck file m_min m_max [m_step]\n\n");
    fprintf(stderr, "file\t\tresults file, - for stdout\n");
    fprintf(stderr, "m_min\t\tthe minimum array size to examine\n");
    fprintf(stderr, "m_min\t\tthe maximum array size to examine\n");
	fprintf(stderr, "[m_step]\tthe step to increment the array size\n\n");
    fprintf(stderr,
        "BLASCheck performs matrix multiplication from size m_min to m_max\n");
    fprintf(stderr,
        "comparing the results from the C-BLAS library and a native C matrix\n");
	fprintf(stderr,
		"The max absolute difference between the resultant matrices is written\n");
	fprintf(stderr,
		"to the file specfied.\n");
}

FILE * openResultsFile(char* fileName) {
	FILE * resultsFile;

	if(strncmp("-", fileName, 1) == 0) {
        return stdout;
    }
    else {
        resultsFile = fopen(fileName, "w+");
        if(resultsFile == NULL) {
            fprintf(stderr, "Can not open %s\n", fileName);
            fprintf(stderr, "%s\n", strerror( errno ) );
            exit(-1);
        }
		return resultsFile;
	}
}
