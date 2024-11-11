// matrix.c  a simple matrix library
//
#include <stdlib.h>

#include "Matrix.h"


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
    matrix->array = (FLOAT_SIZE *) calloc(m*n, sizeof(FLOAT_SIZE));

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
    free(matrix->array);
}

int matMultiply(Matrix *x, Matrix *y, Matrix *z) {
    int iRowX, iColX, iColY, idxColY, idxZ, mX, mY, nY;
    //
    //  Check for matrix memory allocation and compattibility
    //

	//
	//  Save indirect address calculation
	//
	mX = x->m;
	mY = y->m;
	nY = y->n;
    //
    // Loop over the columns in y (specifies which column in z)
    //
    for(iColY = 0; iColY < nY; iColY++) {
		idxColY = iColY * mY;

        //
        //  Loop over the rows in x (specifies which row in z)
        //
        for(iRowX = 0; iRowX < mX; iRowX++) {
            //
            //  Initialize the z element to start accumulating the result
            //  from the vector multiply
			//
			idxZ = iRowX + iColY * mX;
            z->array[idxZ] = 0.0;

            //
            //  Vetcor multiply the specified row of x and column of y
            //
            for(iColX = 0; iColX < mY; iColX++) {
                z->array[idxZ] += 
                    x->array[iRowX + iColX * mX] *
                    y->array[iColX + idxColY];
            }
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
