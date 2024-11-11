//
//  CMat:  Matrix storage and operator class
//
#include <iostream.h>
#include <stdlib.h>

#include "CMat.h"

//
//  Null matrix constructor
//
CMat::CMat() {
    nRows = 0;
    nCols = 0;
    array = NULL;
}

//
//  Allocating constructor
//
CMat::CMat(int nr, int nc) {
    
    //
    // Set the number of rows and columns
    //
    nRows = nc;
    nCols = nr;

    //
    // Allocate an array pointers, each element points to the beggining of
    // a row.
    //
    array = new CMAT_FLOAT *[nRows];
    
    //
    //  Allocate a block of memory for the matrix.
    //
    array[0] = new CMAT_FLOAT [nRows * nCols];
    
    //
    //  Set the pointer for each row to point to the start of each row.
    //
    int iRow;
    for(iRow = 1; iRow < nRows; iRow++) {
        array[iRow] = array[iRow-1] + nCols;
    }    
    int iCol;
    for(iCol = 0; iCol < nCols; iCol++){
        for(iRow = 0; iRow < nRows; iRow++){
            array[iRow][iCol] = 0;
        }
    }
}

CMat::~CMat() {
    delete[] array[0];
    delete[] array;
}

void CMat::Reallocate(int nr, int nc) {

    //
    //  Delete any current data
    //
    delete[] array[0];
    delete[] array;
    
    //
    // Set the number of rows and columns
    //
    nRows = nc;
    nCols = nr;

    //
    // Allocate an array pointers, each element points to the beggining of
    // a row.
    //
    array = new CMAT_FLOAT *[nRows];
    
    //
    //  Allocate a block of memory for the matrix.
    //
    array[0] = new CMAT_FLOAT [nRows * nCols];
    
    //
    //  Set the pointer for each row to point to the start of each row.
    //
    int iRow;
    for(iRow = 1; iRow < nRows; iRow++) {
        array[iRow] = array[iRow-1] + nCols;
    }    
}

//
//  Add a scalar to the matrix.
//
void CMat::Add(CMAT_FLOAT s2) {

    //
    //  Add the scalar
    //
    int iRow, iCol;
    for(iCol = 0; iCol < nCols; iCol++){
        for(iRow = 0; iRow < nRows; iRow++){
            array[iRow][iCol] = array[iRow][iCol] + s2;
        }
    }
}

//
//  Single parameter matrix addition.  Result is placed in this object.
//
void CMat::Add(const CMat& s2) {
    //
    //  Check to see if the matrices are compatible
    //
    if(nRows != s2.nRows){
        cerr << "Number of rows are not compatible" << endl;
        return;
    }
    if(nCols != s2.nCols){
        cerr << "Number of columns are not compatible" << endl;
        return;
    }

    //
    //  Add the two matrices
    //
    int iRow, iCol;
    for(iCol = 0; iCol < nCols; iCol++){
        for(iRow = 0; iRow < nRows; iRow++){
            array[iRow][iCol] = array[iRow][iCol] + s2.array[iRow][iCol];
        }
    }
}

//
//  Two parameter matrix addition.  Result is placed in this object.
//
void CMat::Add(const CMat& s1, const CMat& s2) {
    
    //
    //  Check to see if the matrices are compatible
    //
    if(s1.nRows != s2.nRows){
        cerr << "Number of rows are not compatible" << endl;
        return;
    }
    if(s1.nCols != s2.nCols){
        cerr << "Number of columns are not compatible" << endl;
        return;
    }

    //
    //  (Re)allocate this object if necessary
    //
    if((nCols != s1.nCols) && (nRows != s1.nRows)) {
        Reallocate(s1.nRows, s1.nCols);
    }

    //
    //  Add the two matrices
    //
    int iRow, iCol;
    for(iCol = 0; iCol < nCols; iCol++){
        for(iRow = 0; iRow < nRows; iRow++){
            array[iRow][iCol] = s1.array[iRow][iCol] + s2.array[iRow][iCol];
        }
    }
}

//
//  Scalar subtraction from the matrix
//
void CMat::Subtract(CMAT_FLOAT s2) {

    //
    //  Subtract the scalar
    //
    int iRow, iCol;
    for(iCol = 0; iCol < nCols; iCol++){
        for(iRow = 0; iRow < nRows; iRow++){
            array[iRow][iCol] = array[iRow][iCol] - s2;
        }
    }
}

//
//  Single parameter matrix subtraction.  Result is placed in this object.
//
void CMat::Subtract(const CMat& s2) {
    //
    //  Check to see if the matrices are compatible
    //
    if(nRows != s2.nRows){
        cerr << "Number of rows are not compatible" << endl;
        return;
    }
    if(nCols != s2.nCols){
        cerr << "Number of columns are not compatible" << endl;
        return;
    }

    //
    //  Subtract the two matrices
    //
    int iRow, iCol;
    for(iCol = 0; iCol < nCols; iCol++){
        for(iRow = 0; iRow < nRows; iRow++){
            array[iRow][iCol] = array[iRow][iCol] - s2.array[iRow][iCol];
        }
    }
}

//
//  Two parameter matrix subtraction.  Result is placed in this object.
//
void CMat::Subtract(const CMat& s1, const CMat& s2) {
    
    //
    //  Check to see if the matrices are compatible
    //
    if(s1.nRows != s2.nRows){
        cerr << "Number of rows are not compatible" << endl;
        return;
    }
    if(s1.nCols != s2.nCols){
        cerr << "Number of columns are not compatible" << endl;
        return;
    }

    //
    //  (Re)allocate this object if necessary
    //
    if((nCols != s1.nCols) && (nRows != s1.nRows)) {
        Reallocate(s1.nRows, s1.nCols);
    }

    //
    //  Subtract the two matrices
    //
    int iRow, iCol;
    for(iCol = 0; iCol < nCols; iCol++){
        for(iRow = 0; iRow < nRows; iRow++){
            array[iRow][iCol] = s1.array[iRow][iCol] - s2.array[iRow][iCol];
        }
    }
}


//
//  Write the matrix out to the display
//
void CMat::Show() {
    int iRow, iCol;
    for(iCol = 0; iCol < nCols; iCol++){
        for(iRow = 0; iRow < nRows; iRow++){
            cout << array[iRow][iCol] << '\t';
        }
        cout << endl;
    }
    cout << endl;
}

//
//  Operator to get or assign single values of a matrix
//
inline CMAT_FLOAT *CMat::operator[](int ir) {
    return array[ir];
}

void CMat::RandUniform()
{
    int iRow, iCol;
    for(iCol = 0; iCol < nCols; iCol++){
        for(iRow = 0; iRow < nRows; iRow++){
            array[iRow][iCol] = ((CMAT_FLOAT) rand()) / RAND_MAX;
        }
    }
}
