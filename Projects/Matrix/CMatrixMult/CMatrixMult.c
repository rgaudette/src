#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include <errno.h>

#include "../Matrix.h"

void Usage(void);
FILE * openResultsFile(char[]);
double evalClockResolution(void);

int main(int argc, char *argv[]) {

    int m_min, m_max, m_step, iSize;
    double trueClockRes, et, MFLOPS;
    clock_t start, finish;
    FILE *resultsFile;
    Matrix matX, matY, matZ;
    
    //
    //  Read in the command line arguments
    //
    //  CMatrixMult results.txt min_size max_size [m_step]
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

	//
	//  Evaluate clock resolution and write the output to the top of the file
	//  as a MATLAB comment
	//
	trueClockRes = evalClockResolution();
    fprintf(resultsFile,
            "%% Number of bytes per float: %d\n", sizeof(FLOAT_SIZE));
	fprintf(resultsFile,
		"%% 1/CLOCKS_PER_SEC: %f \tTrue resolution: %f\n%%\n",
		1.0/CLOCKS_PER_SEC, trueClockRes);

	fprintf(resultsFile, "%%Size:\t\tMFLOPS:\t\tTime (sec):\tMFLOPS/Sec:\n");

    //
    //  Loop over matrix sizes
    //
    for(iSize=m_min; iSize<=m_max; iSize += m_step){
        //
        //  Allocate memory for matrices
        //
        matCreate(iSize, iSize, &matX);
        matCreate(iSize, iSize, &matY);
        matCreate(iSize, iSize, &matZ);

        //
        //  Fill matrices with random numbers
        //
        matRandUniform(&matX);
        matRandUniform(&matY);
        
        //
        //  Multiply matrices
        //
        start = clock();
        
		matMultiply(&matX, &matY, &matZ);
        matMultiply(&matZ, &matY, &matX);
		matMultiply(&matZ, &matX, &matY);
		matMultiply(&matX, &matY, &matZ);
		matMultiply(&matZ, &matY, &matX);
		
		finish = clock();
        
		//
        //  Deallocate matrices
        //
        matDestroy(&matX);
        matDestroy(&matY);
        matDestroy(&matZ);

        //
        //  Write results
        //
        et = (double)(finish - start) / CLOCKS_PER_SEC;
        MFLOPS = 5.0 * (matX.m * (matX.n + (matX.n - 1.0)) * matY.n) / 1.0E6;

        fprintf(resultsFile,
                "%d\t\t%f\t%f\t%f\n", matX.n, MFLOPS, et, MFLOPS/et);
    }

    //
    //  Close output file
    //
    fclose(resultsFile);
	return 0;
}

void Usage(void){
    fprintf(stderr, "CMatrixMult file m_min m_max [m_step]\n\n");
    fprintf(stderr, "file\t\tresults file, - for stdout\n");
    fprintf(stderr, "m_min\t\tthe minimum array size to examine\n");
    fprintf(stderr, "m_min\t\tthe maximum array size to examine\n");
	fprintf(stderr, "[m_step]\tthe step to increment the array size\n\n");
    fprintf(stderr,
        "CMatrixMult performs matrix multiplication from size m_min to m_max\n");
    fprintf(stderr,
        "timing each one.  The performance result are written to file\n");
    fprintf(stderr,
        "specified\n\n");
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

double evalClockResolution() {
	clock_t start, stop;

    start = clock();
	stop = clock();		
	while(start == stop) {
		stop = clock();
	}

	return ( (double) stop - start) / CLOCKS_PER_SEC; 

}
