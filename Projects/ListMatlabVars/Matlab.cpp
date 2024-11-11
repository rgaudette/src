#include <iostream.h>
#include <math.h>
#include "Matlab.h"

//
//	Default matlab header object constructor
//
MatHeader::MatHeader() {
    int M;

    //
    //	Handle type variable
    //
    //  type = M*1000 + O*100 + P*10 + T
    //  M - machine type (big endian, little endian)
    //  O - unused
    //  P - precision 0 - double precision, 1 - single precision, 2 - 32 bit integer
    //                3 - 16 bit signed integer, 4 - 16 but unsigned integer,
    //                5 - 8 bit unsigned integer
    //  T - text flag 0 - numeric data, 1 - text data, 2 - sparse matrix
    //
    //  See page 30  Matlab 4.0 External Interface Guide

#ifdef _ALPHA_
		M = 0;
#endif

#ifdef _WIN32
		M = 0;
#endif

#ifdef _SPARC_
		M = 1;
#endif

#ifdef _SGI_
		M = 1;
#endif

        type = M*1000;
        nRows = 0;
        nCols = 0;
        flgImag = 0;
}


//
//  MatHeader display function
//
void MatHeader::Display() {
    int M, P, T;
    
    //
    //  Display the type variable
    //
    cout << "Type:\t" << type << '\n';
    M = floor(type / 1000);
    P = (type - M * 1000) / 10;
    T = type - M * 1000 - P * 10;
    cout << "M:\t" << M << "\tP:\t" << P << "\tT:" << T  << '\n';

    //
    //  Display the dimension of the matrix
    //
    cout << nRows << " x " << nCols << '\n';

    //
    //  Imaginary flag
    //
    cout << "Imaginary flag:\t" << flgImag << '\n';
}


//
//  MatVariable display function

void MatVariable::Display()
{
    MatHeader::Display();

}

