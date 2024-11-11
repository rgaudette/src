/*************************************************************************
**************************************************************************
**  Library: matlib
**
**  Description:
**      MATLIB contains a number of routines for use with MATRIX structures.
**  The MATRIX structure is defined in matlib.h
**
**  Routines:
**    MatAlloc
**    MatFree
**    MatPrint
**    MatMult
**    MatAdd
**    MatReshape
**    MatUniform
**    MatConvolve
**    MatlabLoad
**
**
**  $Author: root $
**
**  $Date: 1995/08/30 00:57:42 $
**
**  $Revision: 1.3 $
**
**  $State: Exp $
**
**  $Log: matlib.c,v $
**    Revision 1.3  1995/08/30  00:57:42  root
**    Added appropriate return values MatMult, MatAdd, MatUniform.
**    Added define for RAND_MAX if not defined by the std includes.
**    Removed malloc.h, not necessary wit stdlib.h
**
**    Revision 1.2  1995/08/21  23:25:10  root
**    Added uniform random matrix generator based on rand();
**
**    Revision 1.1  1995/08/19  22:07:59  root
**    Initial revision
**
**
**
**************************************************************************
*************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <matrix.h>
#include <mat.h>

#include "matlib.h"


/*************************************************************************
**  Function: MatAlloc                                                  **
**                                                                      **
**  Description:                                                        **
**      MatAlloc allocates the storage for the Matrix elements and the  **
**  row pointers.                                                       **
**                                                                      **
**  Returns:                                                            **
**    1 if successful                                                   **
**    0 if unable to allocate the memory                                **
*************************************************************************/
int MatAlloc(Matrix *Mat, int nRows, int nCols) {
    int iRow;
    
    /**
     ** Set the number of rows and columns
     **/
    Mat->nRows = nRows;
    Mat->nCols = nCols;

    /**
     ** Allocate an array pointers, each element points to the beggining of
     ** a row.
     **/
    Mat->array = (MAT_FLOAT **) CALLOC(nRows, sizeof(MAT_FLOAT *));
    if (Mat->array == NULL) return 0;

    /**
     **  Allocate a block of memory for the matrix.
     **/
    Mat->array[0] = (MAT_FLOAT *) CALLOC(nRows * nCols, sizeof(MAT_FLOAT));
    if (Mat->array[0] == NULL) {
        free(Mat->array);
        return 0;
    }

    /**
     **  Set the pointer for each row to point to the start of each row.
     **/
    for(iRow = 1; iRow < nRows; iRow++) {
        Mat->array[iRow] = Mat->array[iRow-1] + nCols;
    }    

    return SUCCESS; 
}  

/*************************************************************************
**  Function: MatFree                                                   **
**                                                                      **
**  Description:                                                        **
**     MatFree frees the element and pointer memory allocated by        **
**  MatAlloc.                                                           **
**                                                                      **
*************************************************************************/
void MatFree(Matrix Mat) {
    
    FREE(Mat.array[0]);
    
    FREE(Mat.array);
    
    Mat.array = NULL;
}

/*************************************************************************
**  Function: MatPrint                                                  **
**                                                                      **
**  Description:                                                        **
**     MatPrint writes a Matrix structure on stdout.                    **
**                                                                      **
*************************************************************************/
void MatPrint(Matrix x) {

    int    iRow, iCol;

    for(iRow=0; iRow<x.nRows; iRow++) {
	for(iCol=0; iCol<x.nCols; iCol++) {
	    printf("% 5f\t", x.array[iRow][iCol]);
	}
	printf("\n");
    }
}

/*************************************************************************
**  Function: MatMult                                                   **
**                                                                      **
**  Description:                                                        **
**     MatMult performs a matrix multiplication on two Matrix           **
**  structures.                                                         **
**                                                                      **
**  Returns:                                                            **
**    1 if successful                                                   **
**   -1 if the matrices are not compatible                              **
**                                                                      **
*************************************************************************/
int MatMult(Matrix x, Matrix y, Matrix result) {
    int    ixRow, ixCol, iyCol;
    MAT_FLOAT   sum;
    
    /**
     ** Error checking, make sure the number of columns in X equals the number
     ** of rows in Y.
     **/
    if(x.nCols != y.nRows) {
        return -1;
    }
    
    for(ixRow=0; ixRow<x.nRows; ixRow++) {
        for(iyCol=0; iyCol<y.nCols; iyCol++) {
            sum = 0.0;
            for(ixCol=0; ixCol<x.nCols; ixCol++) {
                sum += x.array[ixRow][ixCol] * y.array[ixCol][iyCol];
            }                

            result.array[ixRow][iyCol] = sum;
        }
    }

    return SUCCESS;
}

/*************************************************************************
**  Function: MatAdd                                                    **
**                                                                      **
**  Description:                                                        **
**     MatAdd performs an element by element addition on two Matrix     **
**  structures.                                                         **
**                                                                      **
**  Returns:                                                            **
**    1 if successful                                                   **
**   -1 if the matrices are not compatible                              **
**                                                                      **
*************************************************************************/
int MatAdd(Matrix x, Matrix y, Matrix result) {
    int   iRow, iCol;
    
    /**
     ** Error checking, make sure that X and Y are the same size.
     **/
    if(x.nCols != y.nCols)
      return -1;

    if(x.nRows != y.nRows)
      return -1;

    /**
     **  Add the matrices element by element, along rows first since they are
     **  contigous in memory.
     **/
    for(iRow=0; iRow<x.nRows; iRow++) {
        for(iCol=0; iCol<x.nCols; iCol++) {
            result.array[iRow][iCol] = x.array[iRow][iCol] + y.array[iRow][iCol];
        }
    }

    return SUCCESS;
}

/*************************************************************************
**  Function: MatReshape                                                **
**                                                                      **
**  Description:                                                        **
**     MatReshape reshapes the given Matrix.  Since the Matrix is       **
**  in row order the rows in the matrix of the new size are filled from **
**  the row vectored elements of the original matrix.                   **
**                                                                      **
*************************************************************************/
int MatReshape(Matrix *Mat, int nRowsNew, int nColsNew) {
    int iRow;
    MAT_FLOAT *ptrTemp;

    /**
     **  Check to see if the number of elements agrees
     **/
    if(Mat->nRows * Mat->nCols != nRowsNew * nColsNew) {
        fprintf(stderr,
                "MatReshape: Number of elements in new array does not agree\n");
        return 0;
    }

    /**
     **  Create a temporary pointer to the data vector
     **/
    ptrTemp = Mat->array[0];

    /**
     ** Free the array of pointers to the rows for the old matrix. Reset the size
     ** of the matrix.
     **/
    free(Mat->array);
    Mat->nRows = nRowsNew;
    Mat->nCols = nColsNew;

    /**
     ** Allocate the new array of row pointers
     **/
    Mat->array = (MAT_FLOAT **) CALLOC(nRowsNew, sizeof(MAT_FLOAT *));    
    if (Mat->array == NULL) return 0;

    /**
     ** Set the array elements to point to the correct data array rows
     **/
    Mat->array[0] = ptrTemp;
    for(iRow = 1; iRow < nRowsNew; iRow++) {
        Mat->array[iRow] = Mat->array[iRow-1] + nColsNew;
    }    

    /**
     ** Every thing OK return 1.
     **/
    return SUCCESS;
}

/*************************************************************************
**  Function: MatUniform                                                **
**                                                                      **
**  Description:                                                        **
**      MatUniform generates a Matrix with uniformly distributed        **
**  elements over the interval [0,1].  The library function rand is     **
**  used to generate the random number, thus the srand function may     **
**  be used to set the seed value.                                      **
**                                                                      **
*************************************************************************/
int MatUniform(Matrix Uniform) {
    int iRow, iCol;

    /**
     **  Fill the matrix with random numbers.
     **/
    for(iRow=0; iRow < Uniform.nRows; iRow++) {
        for(iCol=0; iCol < Uniform.nCols; iCol++) {
            Uniform.array[iRow][iCol] = (MAT_FLOAT) (rand()) / (MAT_FLOAT) (RAND_MAX);
        }
    }

    return SUCCESS;
}

/*************************************************************************
**  Function: MatConvolve                                               **
**                                                                      **
**  Description:                                                        **
**      MatConvolve convolves a matrix and a vector.  If H is a row     **
**  vector each row of X is convolved with H.  If H is a column vector  **
**  each column of X is convolved with H.  The output matrix Y should   **
**  be of sufficient size to accept the full convolution output.        **
**                                                                      **
*************************************************************************/
int MatConvolve(Matrix X, Matrix H, Matrix Y) {
    int iRow, iCol, nMin, nMax, k, n;

    //
    //  Check dimensions of vector H.
    //
    if ((H.nRows > 1) && (H.nCols > 1))
        return 0;

    //
    //  Row-wise convolution
    //
    if (H.nCols > 1) {
        for(iRow = 0; iRow < X.nRows; iRow++) {
            for(k = 0; k < X.nCols + H.nCols - 1; k++) {
                nMin = max((k - H.nCols + 1), 0);
                nMax = min(k, X.nCols - 1);
                Y.array[iRow][k] = 0.0;
                for(n = nMin; n <= nMax; n++)
                    Y.array[iRow][k] = Y.array[iRow][k]
                        + H.array[0][k-n] * X.array[iRow][n];
            }
        }
    }
    
    //
    //  Column-wise convolution
    //
    else {
        for(iCol = 0; iCol < X.nCols; iCol++) {
            for(k = 0; k < X.nRows + H.nRows - 1; k++) {
                Y.array[k][iCol] = 0.0;
                nMin = max(k - H.nRows + 1, 0);
                nMax = min(k , (X.nRows - 1));
                for(n = nMin; n <= nMax; n++) {
                    Y.array[k][iCol] = Y.array[k][iCol]
                        + H.array[k-n][0] * X.array[n][iCol];
                }
            }
        }
    }
    
    return SUCCESS;
}
            
/*************************************************************************
**  Function: MatlabLoad                                                **
**                                                                      **
**  Description:                                                        **
**      MatlabLoad load a Matlab matrix present in a .m file into       **
**  Matlib matrix.                                                      **
**                                                                      **
*************************************************************************/

int MatlabLoad(const char *Filename, const char *Varname, Matrix *Mat) {
    
    int  iRow, iCol, flg;
    int  nDim, M, N, szElem;
    double *Array;
    MATFile *fptrMatFile;
    mxArray *mxArr;
    
    //
    //  Open the MATLAB file
    //
    fptrMatFile = matOpen(Filename, "r");
    if (fptrMatFile == NULL) {
        fprintf(stderr, "MatlabLoad: Unable to open %s\n",
            Filename);
        return 0;
    }
    
    //
    //  Read in the requested matlab variable
    //
    mxArr = matGetArray(fptrMatFile, Varname);
    if (mxArr == NULL) {
        fprintf(stderr, "MatlabLoad: Unable extract matrix %s\n",
            Varname);
        return 0;
    }

    matClose(fptrMatFile);

    nDim = mxGetNumberOfDimensions(mxArr);
    if(nDim != 2) {
        fprintf(stderr, 
            "MatlabLoad: can not handle greater than 2 dimensions\n");
        return 0;
    }

    M = mxGetM(mxArr);
    N = mxGetN(mxArr);
    szElem = mxGetElementSize(mxArr);

    //
    //  Alocate Matlib matrix to hold the MATLAB matrix
    //
    flg =  MatAlloc(Mat, M, N);
    if(flg != 1){
        fprintf(stderr,
            "MatlabLoad: can not allocate memory for Matlib matrix\n");
        return 0;
    }
    
    //
    //  Copy the MATLAB matrix
    //
    if(szElem == 8) {
        Array = (double *) mxGetPr(mxArr);
    }
    
    for(iRow = 0; iRow < M; iRow++){
        for(iCol= 0; iCol < N; iCol++) {
            Mat->array[iRow][iCol] = Array[iRow + iCol * M];
        }
    }

    //
    //  Free up the MATLAB structures
    //
    mxDestroyArray(mxArr);
    
    return SUCCESS;
}
