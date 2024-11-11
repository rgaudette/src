//
//  MatrixLib.cpp
//

#include "MatrixLib.h"

inline Matrix::Matrix(int nR, int nC) {
	Data = new float[nRows * nCols];
	nRows = nR;
	nCols = nC;
}

inline float Matrix::operator[](int iRow, int iCol) {
	return Data[iCol * nRows + iRow];
}
