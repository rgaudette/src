// matrix.c  a simple matrix library
//
#include <stdlib.h>
#include <ipp.h>
#include "IPPMatrix.h"


int matCreate(int m, int n, Matrix *matrix) {
    //
    //  Checking for valid parameters
    //  m,n > 0
    //

    //
    //  Populate the Matrix type
    //
    matrix->m = m;
    matrix->n = n;

#ifdef  FLOAT_8BYTE
	matrix->array = ippsMalloc_64f(m*n);
#else
	matrix->array = ippsMalloc_32f(m*n);
#endif
    //
    //  Return 1 if we can't get the memory
    //
    if(matrix->array == NULL) return MATRIX_FAIL;

    return MATRIX_SUCCEED;
}

void matDestroy(Matrix *matrix) {
    //
    //  Free the array memory
    //
    ippsFree(matrix->array);
}

int matMultiply(Matrix *x, Matrix *y, Matrix *z) {
    int iRowX, iColX, iColY, mX, mY, nY ;
    FLOAT_SIZE *xArray, *yArray, *zArray;
	FLOAT_SIZE *xRow;

	//
    //  Check for matrix memory allocation and compattibility
    //
	
	mX = x->m;
	mY = y->m;
	nY = y->n;
	xArray = x->array;
	yArray = y->array;
	zArray = z->array;
	//
	//  Allocate temporary xRow
	//
#ifdef FLOAT_8BYTE
	xRow = ippsMalloc_64f(x->n);
#else
	xRow = ippsMalloc_32f(x->n);
#endif
	//
    //  Loop over the rows in x (specifies which row in z)
    //
    for(iRowX = 0; iRowX < mX; iRowX++) {
        //
		// Assemble the row of X as a vector for IPP
		//
		for(iColX = 0; iColX < mY; iColX++) {
			xRow[iColX] = xArray[iRowX + iColX * mX];
		}

		//
		// Loop over the columns in y (specifies which column in z)
		//
		for(iColY = 0; iColY < nY; iColY++) {
#ifdef FLOAT_8BYTE
			ippsDotProd_64f(xRow, &(yArray[iColY * mY]), mY,
				&(zArray[iRowX + iColY * mX]));
#else
			ippsDotProd_32f(xRow, &(yArray[iColY * mY]), mY,
				&(zArray[iRowX + iColY * mX]));
#endif
        }
    }
    return MATRIX_SUCCEED;
}

int matRandUniform(Matrix *r){
    int iElem;

    //
    //  Check to see that the matrix has been successfully created
    //

    //
    //  Fill the array with random numbers from [0,1]
    //
    for(iElem = 0; iElem < r->m * r->n; iElem++) {
        r->array[iElem] = ((FLOAT_SIZE) rand()) / RAND_MAX;
    }
    return MATRIX_SUCCEED;
}
