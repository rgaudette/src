// matrix.h  a simple matrix library
//
#define FLOAT_SIZE double
#define MATRIX_SUCCEED 0
#define MATRIX_FAIL 1

typedef struct Matrix {
    int m, n;
    FLOAT_SIZE *array;
} Matrix;

int matCreate(int m, int n, Matrix *matrix);

void matDestroy(Matrix *matrix);

int matMultiply(Matrix *x, Matrix *y, Matrix *z);

int matRandUniform(Matrix *r);
    
