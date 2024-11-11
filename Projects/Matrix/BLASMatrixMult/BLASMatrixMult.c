#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <sys/time.h>
#include <time.h>
#include <errno.h>
#include "mkl_cblas.h"

#include "../Matrix.h"

void Usage(void);
FILE * openResultsFile(char[]);
double evalClockResolution(void);
void tstart(void);
void tend(void);
double tval(void);

static struct timeval _tstart, _tend;
static struct timezone tz;

int main(int argc, char *argv[]) {

  int m_min, m_max, iSize, m_step;
  double trueClockRes, et, MFLOPS;
  clock_t start, finish;
  FILE *resultsFile;
  Matrix matX, matY, matZ1;

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


  //
  //  Evaluate clock resolution and write the output to the top of the file
  //  as a MATLAB comment
  //
  trueClockRes = evalClockResolution();

  fprintf(resultsFile,
          "%% 1/CLOCKS_PER_SEC: %f \tTrue resolution: %f\n%%\n%%",
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
    matCreate(iSize, iSize, &matZ1);
    //matCreate(iSize, iSize, &matZ2);
        
    //
    //  Fill matrices with random numbers
    //
    matRandUniform(&matX);
    matRandUniform(&matY);
               
    //matMultiply(&matX, &matY, &matZ2);

    //
    //  Multiply matrices using C-BLAS routines from intel performance lib
    //
    //start = clock();
    tstart();
    cblas_dgemm(cCBCM, cCBNT, cCBNT, iSize, iSize, iSize, 1.0, 
                matX.array, iSize, matY.array, iSize, 
                0.0, matZ1.array, iSize);

    cblas_dgemm(cCBCM, cCBNT, cCBNT, iSize, iSize, iSize, 1.0, 
                matZ1.array, iSize, matY.array, iSize, 
                0.0, matX.array, iSize);

    cblas_dgemm(cCBCM, cCBNT, cCBNT, iSize, iSize, iSize, 1.0, 
                matZ1.array, iSize, matX.array, iSize, 
                0.0, matY.array, iSize);

    cblas_dgemm(cCBCM, cCBNT, cCBNT, iSize, iSize, iSize, 1.0, 
                matX.array, iSize, matY.array, iSize, 
                0.0, matZ1.array, iSize);

    cblas_dgemm(cCBCM, cCBNT, cCBNT, iSize, iSize, iSize, 1.0, 
                matZ1.array, iSize, matY.array, iSize, 
                0.0, matX.array, iSize);
        
    //finish = clock();
    tend();
    
    //
    //  Return the max abs value of the difference between the results
    //
    //abs_diff = 0.0;
    //for(iElem = 0; iElem < matZ1.m*matZ2.n; iElem++){
    //    if (abs_diff < fabs(matZ1.array[iElem] - matZ2.array[iElem])){
    //        abs_diff = fabs(matZ1.array[iElem] - matZ2.array[iElem]);
    //    }
    //}
    //fprintf(stderr, "Abs diff %e\n", abs_diff);

    //
    //  Deallocate matrices
    //
    matDestroy(&matX);
    matDestroy(&matY);
    matDestroy(&matZ1);
    //matDestroy(&matZ2);
    //
    //  Write results
    //
    //et = (double)(finish - start) / CLOCKS_PER_SEC;
    et = tval();
    MFLOPS = 5.0 * (matX.m * (matX.n + (matX.n - 1.0)) * matY.n) / 1.0E6;

    fprintf(resultsFile, "%d\t\t%f\t%f\t%f\n", matX.n, MFLOPS, et, MFLOPS/et);
  }

  //
  //  Close output file
  //
  fclose(resultsFile);

  return 0;
}

void Usage(void){
  fprintf(stderr, "BLASMatrixMult file m_min m_max [m_step]\n\n");
  fprintf(stderr, "file\t\tresults file, - for stdout\n");
  fprintf(stderr, "m_min\t\tthe minimum array size to examine\n");
  fprintf(stderr, "m_max\t\tthe maximum array size to examine\n");
  fprintf(stderr, "[m_step]\tthe step to increment the array size\n\n");
  fprintf(stderr,
          "BLASMatrixMult performs matrix multiplication from size m_min to m_max\n");
  fprintf(stderr,
          "timing each one.  The performance result are written to file specified\n\n");
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
  /*  clock_t start, stop;

  start = clock();
  stop = clock();		
  while(start == stop) {
    stop = clock();
  }
  
  return ( (double) stop - start) / CLOCKS_PER_SEC;  */
  tstart();
  tend();
  return tval();
}

void tstart(void) {
  gettimeofday(&_tstart, &tz);
}

void tend(void) {
  gettimeofday(&_tend,&tz);
}

double tval(){
  double t1, t2;

  t1 =  (double)_tstart.tv_sec + (double)_tstart.tv_usec/(1000*1000);
  t2 =  (double)_tend.tv_sec + (double)_tend.tv_usec/(1000*1000);
  return t2-t1;
}
