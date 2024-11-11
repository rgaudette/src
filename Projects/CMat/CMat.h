//
//  CMat:  Matrix storage and operator class
//
#define CMAT_FLOAT float

class CMat {
private:
    int     nCols, nRows;
    CMAT_FLOAT   **array;
    
public:
    CMat();
    CMat(int nr, int nc);
    ~CMat();
    void CMat::Reallocate(int nr, int nc);

    //
    //  Matrix arithmetic operations
    //
    void Add(CMAT_FLOAT op2);
    void Add(const CMat& op2);
    void Add(const CMat& op1, const CMat& op2);
    void Subtract(CMAT_FLOAT op2);
    void Subtract(const CMat& op2);
    void Subtract(const CMat& op1, const CMat& op2);
    //void Multiply(const CMat& op2);
    //void Multiply(const CMat& op1, const CMat& op2);
    //void Scale(CMAT_FLOAT op1);

    //
    //  Utility operations
    //
    void Show();
    void RandUniform();

    //
    //  Overloaded operators
    //
    CMAT_FLOAT *operator[](int ir);
};

