//
//  MatrixLib.h
//

#ifndef _MATRIXLIB_INC
#define _MATRIXLIB_INC


class Matrix {
    int nRows;
    int nCols;
	float *Data;

  public:
    Matrix(int nRows, int nCols);
	float operator[] (int iRow, int iCol);
};

//
//  Constructors
//
#endif