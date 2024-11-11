// matrix.h  a simple matrix library
//
//#define FLOAT_8BYTE 1


#ifdef FLOAT_8BYTE
#define FLOAT_SIZE Ipp64f
#else
#define FLOAT_SIZE Ipp32f
#endif

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
    
