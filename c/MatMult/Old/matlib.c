/*#include <malloc.h>*/
#include <stdio.h>
#include <stdlib.h>
#include "matlib.h"


/**
 ** MatAlloc
 **/
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
    Mat->array = (float **) CALLOC(nRows, sizeof(float *));
    if (Mat->array == NULL) return(0);

    /**
     **  Allocate a block of memory for the matrix.
     **/
    Mat->array[0] = (float *) CALLOC(nRows * nCols, sizeof(float));
    if (Mat->array[0] == NULL) {
        free(Mat->array);
        return(0);
    }

    /**
     **  Set the pointer for each row to point to the start of each row.
     **/
    for(iRow = 1; iRow < nRows; iRow++) {
        Mat->array[iRow] = Mat->array[iRow-1] + nCols;
    }    

    return(1); 
}  


/**
 **  MatFree
 **/
void MatFree(Matrix Mat) {
    int iRow;
    
    FREE(Mat.array[0]);
    
    FREE(Mat.array);
    
    Mat.array = NULL;
}

/**
 **  MatPrint
 **/
void MatPrint(Matrix x) {

    int    iRow, iCol;

    for(iRow=0; iRow<x.nRows; iRow++) {
	for(iCol=0; iCol<x.nCols; iCol++) {
	    printf("% 5f\t", x.array[iRow][iCol]);
	}
	printf("\n");
    }
}

/**
 **
 **/
void MatMult(Matrix x, Matrix y, Matrix result) {
    int    ixRow, ixCol, iyCol;
    float   sum;
    
    /**
     ** Error checking, make sure the number of columns in X equals the number
     ** of rows in Y.
     **/
    if(x.nCols != y.nRows) {
        fprintf(stderr,
          "MatMult:  number of columns of X does not equal number of rows of Y.\n");
        exit(-1);
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
}


/**
 **
 **/
void MatAdd(Matrix x, Matrix y, Matrix result) {
    int   iRow, iCol;
    
    /**
     ** Error checking, make sure that X and Y are the same size.
     **/
    if(x.nCols != y.nCols) {
        fprintf(stderr, "MatAdd: X and Y have a different number of columns.\n");
        exit(-1);
    }
    
    if(x.nRows != y.nRows) {
        fprintf(stderr, "MatAdd: X and Y have a different number of rows.\n");
        exit(-1);
    }
    
    for(iRow=0; iRow<x.nRows; iRow++) {
        for(iCol=0; iCol<x.nCols; iCol++) {
            result.array[iRow][iCol] = x.array[iRow][iCol] + y.array[iRow][iCol];
        }
    }
}


/**
 **
 **/
int MatReshape(Matrix *Mat, int nRowsNew, int nColsNew) {

    int iRow;
    float *ptrTemp;

    /**
     **  Check to see if the number of elements agrees
     **/
    if(Mat->nRows * Mat->nCols != nRowsNew * nColsNew) {
        fprintf(stderr,
                "MatReshape: Number of elements in new array does not agree\n");
        return(-1);
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
    Mat->array = (float **) CALLOC(nRowsNew, sizeof(float *));    
    if (Mat->array == NULL) return(0);

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
    return(1);
}
