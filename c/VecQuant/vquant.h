/*************************************************************************
**************************************************************************
**  Header: vquant.h
**
**  Description:
**     Function declarations for the vector quantization library.
**
**  Routines:
**
**
**  $Author: root $
**
**  $Date: 1995/08/30 03:51:07 $
**
**  $Revision: 1.1 $
**
**  $State: Exp $
**
**  $Log: vquant.h,v $
**    Revision 1.1  1995/08/30  03:51:07  root
**    Initial revision
**
**
**
**************************************************************************
*************************************************************************/

#ifndef __VQUANT_INC
#define __VQUANT_INC

#include "../Matlib/matlib.h"
float LBG(Matrix CodeBook, Matrix Training, float Epsilon);
float ECVQ(Matrix CodeBook, Matrix Training, float Entropy[], float SaPMF[],
           float Lambda, float Epsilon, float *MSE);
float NNFullSearch(Matrix CodeBook, Matrix Data, int Indices[], float vecSE[]);
void  EntropyConstrainedNN(Matrix CodeBook, Matrix Data,
                           int Indices[], float CodeWordLength[], float lambda);
void  CBGenerate(Matrix CodeBook, Matrix Training, int Indices[],
                 int *lstEmptyCells, int *nEmptyCells);
void  Centroid(Matrix Set, float vCentroid[]);
float FixEmptyCells(Matrix CodeBook, Matrix Training, int Indices[], float vecSE[],
              int *lstEmptyCells, int nEmptyCells);
void  GenPairVec(Matrix SplitBook, Matrix CellSet, int *SplitIndices);
void  IndexEntropy(Matrix CodeBook, Matrix Data, int Index[],
                   float Entropy[], float SaPMF[]);
float LagrangeAvg(Matrix CodeBook, Matrix Training,
                  int Indices[], float CodeWordLength[] , float Lambda);
float MeanRate(int nCodes, float Entropy[], float SaPMF[]);
float MeanSquareError(Matrix CodeBook, Matrix Training, int Indices[]);

#define INF_ENTROPY 1E15

#endif 
