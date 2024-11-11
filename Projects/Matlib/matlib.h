/*************************************************************************
**************************************************************************
**  Header: matlib.h
**
**  Description:
**     Function declarations for the Matrix library and defines for memory
**  allocation.
**
**  Routines:
**
**
**  $Author: root $
**
**  $Date: 1995/08/19 22:05:44 $
**
**  $Revision: 1.1 $
**
**  $State: Exp $
**
**  $Log: matlib.h,v $
**    Revision 1.1  1995/08/19  22:05:44  root
**    Initial revision
**
**
**
**************************************************************************
*************************************************************************/

#ifndef _MATLIB_INC
#define _MATLIB_INC

#define MAT_FLOAT double

#define CALLOC calloc
#define FREE   free

#define SUCCESS 1

#ifndef RAND_MAX
#define RAND_MAX 2147483647
#endif

#ifdef  __cplusplus
extern "C" {
#endif

typedef struct matrix {
    int    nRows;
    int    nCols;
    MAT_FLOAT   **array;
} Matrix;

int     MatAlloc(Matrix *Mat, int nRows, int nCols);
void    MatFree(Matrix x);
void    MatPrint(Matrix x);
int     MatMult(Matrix x, Matrix y, Matrix result);
int     MatAdd(Matrix x, Matrix y, Matrix result);
int     MatReshape(Matrix *Mat, int nRowsNew, int nColsNew);
int     MatConvolve(Matrix X, Matrix H, Matrix Y);
int     MatlabLoad(const char *Filename, const char *Varname, Matrix *Mat);

#ifdef  __cplusplus
}
#endif

#endif /**  #ifndef _MATLIB_INC **/
