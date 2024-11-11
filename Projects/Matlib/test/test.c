#include <stdio.h>
#include <stdlib.h>
#include "..\matlib.h"
#include "..\..\MFUtils\mfutils.h"

int main(int argc, char *argv[]) {
    int     flg, nRows, nCols;
    Matrix X, H, Y;
    FILE *fptrOut;

    //
    //  Load in the matlab variables/file specified on the command
    //

    //flg = getMatVariable(argv[3], argv[1], &X);
    flg = MatlabLoad(argv[3], argv[1], &X);

    if(flg < 1) {
        fprintf(stderr, "mfutest: unable to find %s in %s\n", argv[1], argv[3]);
        exit(-1);
    }
    MatPrint(X);

    //flg = getMatVariable(argv[3], argv[2], &H);
    flg = MatlabLoad(argv[3], argv[2], &H);
    if(flg < 1) {
        fprintf(stderr, "mfutest: unable to find %s in %s\n", argv[2], argv[3]);
        exit(-1);
    }
    MatPrint(H);

    //
    //  Allocate the matrix for Y
    //
    if(H.nRows > 1) {
        nRows = X.nRows + H.nRows - 1;
        nCols = X.nCols;
    }
    else {
        nCols = X.nCols + H.nCols - 1;
        nRows = X.nRows;
    }

    flg = MatAlloc(&Y, nRows, nCols);


    //
    //  Convolve the matrices
    //
    flg = MatConvolve(X, H, Y);

    printf("\n\n");
    MatPrint(Y);

    //
    //  Write out the results into another matlab file
    //
    fptrOut = fopen("Result.mat", "w+");
    flg = putMatVariable(fptrOut, Y, "y");
    fclose(fptrOut);
    return 0;
}
