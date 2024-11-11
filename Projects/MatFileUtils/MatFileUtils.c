#include <stdio.h>

#include "mat.h"

int main(int argc, char *argv[]) {
    int  nDirEntries, iDir, iRow, iCol;
    int  nDim, M, N, szElem;
    char **Directory;
    const char *Name;
    double *Array;


    MATFile *fptrMatFile;
    mxArray *mxArr;
    //
    //  Open the MATLAB file
    //
    fptrMatFile = matOpen(argv[1], "r");

    //
    //  Read in the directory of the MATLAB file
    //
    Directory = matGetDir(fptrMatFile, &nDirEntries);
    
    for(iDir=0; iDir < nDirEntries; iDir++) {
        printf("%s\n", Directory[iDir]);
    }

    //
    //  Read in the requested matlab variable
    //
    mxArr = matGetArray(fptrMatFile, argv[2]);


    //
    //  Print out the header info
    //
    Name = mxGetName(mxArr);
    printf("Name: %s\n", Name);

    nDim = mxGetNumberOfDimensions(mxArr);
    printf("Dimensions: %d\n", nDim);

    M = mxGetM(mxArr);
    printf("M: %d\n", M);

    N = mxGetN(mxArr);
    printf("N: %d\n", N);
    
    szElem = mxGetElementSize(mxArr);
    printf("Element size: %d\n", szElem);
    //
    //  Print out the array
    //
    if(szElem == 8) {
        Array = (double *) mxGetPr(mxArr);
    }
    for(iRow = 0; iRow < M; iRow++){
        for(iCol= 0; iCol < N; iCol++) {
            printf("%f\t", Array[iRow + iCol * M]);
        }
        printf("\n");
    }
    //
    //  Free up memory
    //
    
    return 0;
}