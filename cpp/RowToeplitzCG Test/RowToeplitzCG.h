#pragma once

#ifdef INSTRUMENT_RECONSTRUCTION
class IRPLogger;
#endif

class RowToeplitzCG
{
  public:
    RowToeplitzCG(int nRowsMax, int nImpulseMax, int nRestart = 50);
    ~RowToeplitzCG(void);

    int solveNormalEquations(const float * row,
                             int nToeplitzElements,
                             int nRows,
                             const float * b,
                             float * xEstimate,
                             int iMax,
                             float epsilon);

  private:
    int _nRestart;
    int _nRowsMax;
    int _nImpulseMax;

    float * _d;
    float * _r;
    float * _q;
    float * _temp1;
    float * _temp2;

    float * _Ad;
    float * _bNormal;

    void updateResidual(const float * row,
                        int nRowElements,
                        int nRows,
                        float * xEstimate,
                        int nCols,
                        const float * b);

    float * allocateMKLFloatArray(int nColsMax, int const cacheLineAlignment);

    // Disallow default and copy constructor, and operator=
    RowToeplitzCG(void);
    RowToeplitzCG(RowToeplitzCG const &);
    RowToeplitzCG & operator=(RowToeplitzCG const &);

#ifdef INSTRUMENT_RECONSTRUCTION
    IRPLogger * _IRPLogger;
#endif

};