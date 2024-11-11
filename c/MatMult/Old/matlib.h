#define _MATLIB_INC


#define CALLOC calloc
#define FREE   free

typedef struct matrix {
    int    nRows;
    int    nCols;
    float   **array;
} Matrix;

int     MatAlloc(Matrix *Mat, int nRows, int nCols);
void    MatFree(Matrix x);
void    MatPrint(Matrix x);
void    MatMult(Matrix x, Matrix y, Matrix result);
void    MatAdd(Matrix x, Matrix y, Matrix result);
int     MatReshape(Matrix *Mat, int nRowsNew, int nColsNew);
