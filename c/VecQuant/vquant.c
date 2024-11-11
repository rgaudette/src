/*************************************************************************
**************************************************************************
**  Library: vquant
**
**  Description:
**      VQUANT contains a number of routines to generate vector codebooks
**  and perform vector quantization
**
**  Routines:
**      LBG
**      ECVQ
**      NNFullSearch
**      EntropyConstrainedNN
**      CBGenerate
**      Centroid
**      FixEmptyCells
**      GenPairVec
**      IndexEntropy
**      LagrangeAvg
**      MeanRate
**      MeanSquareError
**
**  $Author $
**
**  $Date $
**
**  $Revision: 2.2 $
**
**  $State: Exp $
**
**  $Log: vquant.c,v $
**    Revision 2.2  1995/09/13  18:41:17  root
**    LBG: Modified stopping criteria to be divided by current MSE.
**
**    Revision 2.1  1995/09/12  02:49:43  root
**    fprintf to stderr replaced printf's for better loggin.
**    exit's added where appropriate.
**
**    Revision 2.0  1995/08/30  01:33:25  root
**    Major upgrade to add code for ECVQ algorithm
**
**    Revision 1.5  1995/08/22  01:39:52  root
**    Removed matrix size printouts from VQFullSearch
**
**    Revision 1.4  1995/08/22  01:38:46  root
**    Added some comments to FullSearchVQ algorithm.
**
**    Revision 1.3  1995/08/22  00:18:23  root
**    Removed program flow print statements, code appears stable.
**
**    Revision 1.2  1995/08/18  03:19:02  root
**    Fixed a bug in cell splitting routine.  SplitBook used to use the
**    current value of the codebook eventhough it may not be the cell centroid.
**    The cell centroid is now computed and perturbed to create the split book.
**
**    Revision 1.1  1995/08/18  02:29:47  root
**    Initial revision
**
**
**************************************************************************
*************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <values.h>

#include "vquant.h"

#define DELTA 1E-6
#define MIN_REPLACE 4

void VecSort(float *vecValues, int *Indices, int nValues);


/******************************************************************************/
/**  Function:  LBG                                                          **/
/**                                                                          **/
/**  Description:                                                            **/
/**      LBG uses the Lloyd-Buzo-Gray algorithm to compute mean sqaured      **/
/**  error centroids for a given codebook size and training data set.        **/
/**                                                                          **/
/******************************************************************************/
float LBG(Matrix CodeBook, Matrix Training, float Epsilon) {

    int *Indices;
    int *lstEmptyCells, nEmptyCells;
    float   MSE, prevMSE, *vecSE;


    /**
     ** Allocate necessary structures
     **/
    Indices = (int *) calloc(Training.nCols, sizeof(int));
    if (Indices == NULL) {
        fprintf(stderr, "LBG: Unable to allocate memory for index array\n");
        exit(-1);
    }

    vecSE = (float *) calloc(Training.nCols, sizeof(float));
    if (vecSE == NULL) {
        fprintf(stderr,
                "LBG: Unable to allocate memory for sqared error array\n");
        exit(-1);
    }

    lstEmptyCells = (int *) calloc(CodeBook.nCols, sizeof(int));
    if (lstEmptyCells == NULL) {
        fprintf(stderr,
                "LBG: Unable to allocate memory for empty cell array\n");
        exit(-1);
    }

    
    /**
     ** Initializations.
     **/
    prevMSE = 0;
    nEmptyCells = 0;


    /**
     ** VQ the data with the initial code book
     **/
    MSE = NNFullSearch(CodeBook, Training, Indices, vecSE);


    /**
     **  While the mean sqare error is still decreasing by epsilon or more
     **  keep computing a new set of codes.
     **/
    while(fabs(MSE - prevMSE)/MSE > Epsilon) {
        fprintf(stderr, "     MSE = %f\n", MSE);
        prevMSE = MSE;


        /**
         **  Recompute the codebook using the centroids of the current
         **  partitioning.
         **/
        CBGenerate(CodeBook, Training, Indices, lstEmptyCells, &nEmptyCells);

        /**
         **  If there are any empty cells reassign their vectors to new codes
         **/
        if(nEmptyCells > 0) {

            /**
             **  If there are empty cells reassign them
             **/
            MSE = FixEmptyCells(CodeBook, Training, Indices, vecSE,
                                lstEmptyCells, nEmptyCells);

            /**
             **  Reset the number of empty cells
             **/
            nEmptyCells = 0;
        }


        /**
         **  Requantize the training data and compute the mean square error
         **/
        else {
            MSE = NNFullSearch(CodeBook, Training, Indices, vecSE);

        }

    }

    fprintf(stderr, "     MSE = %f\n", MSE);


    /**
     **  Free allocated arrays
     **/
    free(lstEmptyCells);
    free(vecSE);
    free(Indices);

    /**
     **  return mean square error
     **/
    return(MSE);
}

/******************************************************************************/
/**  Function: ECVQ                                                          **/
/**                                                                          **/
/**  Returns:  average rate in bits/sample.                                  **/
/******************************************************************************/
float ECVQ(Matrix CodeBook, Matrix Training, float Entropy[], float SaPMF[],
           float Lambda, float Epsilon, float *MSD) {

    int    *Indices, *lstEmptyCells, nEmptyCells;
    float  Jmean, prevJmean, Rate, *vecSE;
    
    /**
     **  Allocate necessary arrays.
     **/
    Indices = (int *) calloc(Training.nCols, sizeof(int));
    if (Indices == NULL) {
        fprintf(stderr, "ECVQ: Unable to allocate memory for index array\n");
        exit(-1);
    }

    /**
     **  These arrays are only used as a place holders
     **/
    lstEmptyCells = (int *) calloc(CodeBook.nCols, sizeof(int));
    if (lstEmptyCells == NULL) {
        fprintf(stderr,
                "ECVQ: Unable to allocate memory for empty cell array\n");
        exit(-1);
    }
    vecSE = (float *) calloc(Training.nCols, sizeof(float));
    if (vecSE == NULL) {
        fprintf(stderr,
                "ECVQ: Unable to allocate memory for sqared error array\n");
        exit(-1);
    }

    /**
     **  Compute the initial partition index entropy, done by calling
     **  EntropyConstrainedNN with a lambda value of 0, using this partitioning
     **  to call IndexEntropy.
     **/
    EntropyConstrainedNN(CodeBook, Training, Indices, Entropy, 0.0);
    IndexEntropy(CodeBook, Training, Indices, Entropy, SaPMF);
    
    /**
     **  While the lagrangian is still decreasing by a significant amount keep
     **  iterating the algorithm.
     **/
    Jmean = MAXFLOAT;
    nEmptyCells = 0;

    do {

        /**
         **  Compute the contrained nearest neighboor partitioning.
         **/
        EntropyConstrainedNN(CodeBook, Training, Indices, Entropy, Lambda);
        
        /**
         **  Compute the index entropy of the new partitioning.
         **/
        IndexEntropy(CodeBook, Training, Indices, Entropy, SaPMF);

        /**
         **  Compute the codebook centroids according to above partitioning.
         **/
        CBGenerate(CodeBook, Training, Indices, lstEmptyCells, &nEmptyCells);

        /**
         **  Compute average value of Lagrangian
         **/
        prevJmean = Jmean;
        Jmean = LagrangeAvg(CodeBook, Training, Indices, Entropy, Lambda);

        fprintf(stderr, "Jmean : %f\tEmpty cells %d \n", Jmean, nEmptyCells);


    } while((prevJmean - Jmean) / Jmean >= Epsilon );
        
    /**
     **  Compute final index entropy and average bit rate
     **/
    IndexEntropy(CodeBook, Training, Indices, Entropy, SaPMF);
    Rate = MeanRate(CodeBook.nCols, Entropy, SaPMF) / (float) CodeBook.nRows;

    /**
     **  Compute mean squared error distortion.
     **/
    *(MSD) = MeanSquareError(CodeBook, Training, Indices);

    /**
     **  Free allocated structures
     **/
    free(lstEmptyCells);
    free(Indices);
    
    /**
     **  Return average bit rate for coder
     **/
    return(Rate);
}

/******************************************************************************/
/**  Function: NNFullSearch                                                  **/
/**                                                                          **/
/**  Returns: mean squared error distortion                                  **/
/******************************************************************************/
float NNFullSearch(Matrix CodeBook, Matrix Data, int *Indices, float *vecSE) {
    
    int   idxData, idxCode, idxElem;
        
    float   MinSquaredError, SquaredError, tmp, MeanSE;
    MeanSE = 0.0;

    /**
     ** For each Data vector search the CodeBook to find the nearest neighboor.
     **/
    for(idxData = 0; idxData < Data.nCols; idxData++){

        MinSquaredError = MAXFLOAT;    
        for(idxCode = 0; idxCode < CodeBook.nCols; idxCode++){
            /**
             **  Compute squared error with respec to the current codeword.
             **/
            SquaredError = 0.0;
            for(idxElem = 0; idxElem < CodeBook.nRows; idxElem++) {
                        tmp = CodeBook.array[idxElem][idxCode] - 
                              Data.array[idxElem][idxData];
                        SquaredError += tmp * tmp;
                }
            /**
             **  If current squared error is less than all previous squared
             **  errors replace codeword index and squared error value.
             **/
            if(SquaredError < MinSquaredError) {
                MinSquaredError = SquaredError;
                Indices[idxData] = idxCode;
            }

        }

        vecSE[idxData] = MinSquaredError;
        MeanSE += MinSquaredError;    
    }

    MeanSE = MeanSE / Data.nCols;
    return(MeanSE);
}

/******************************************************************************/
/**  Function: EntropyConstrainedNN                                          **/
/**                                                                          **/
/**  Description:                                                            **/
/**      Computes the minimum Lagrangian for each data vector in Data.  The  **/
/**  Lagragian formulation is given by,                                      **/
/**                                                                          **/
/**                     2                                                    **/
/**  min J  = |D - C(i)|   +  lambda * |C(i)|                                **/
/**   i   D                                                                  **/
/**                                                                          **/
/******************************************************************************/
void EntropyConstrainedNN(Matrix CodeBook, Matrix Training, int Indices[],
                          float CodeWordLength[], float lambda) {
    int     idxData, idxCode, idxElem;
    float   J, Jmin, SquaredError, tmp;


    /**
     **  For each Training vector search the CodeBook to find the nearest
     **  neighboor subject to a constraint of codeword length.
     **/
    for(idxData = 0; idxData < Training.nCols; idxData++){

        Jmin = MAXFLOAT;    

        for(idxCode = 0; idxCode < CodeBook.nCols; idxCode++){
            
            /**
             **  Compute squared error with respect to the current codeword.
             **/
            SquaredError = 0.0;
            for(idxElem = 0; idxElem < CodeBook.nRows; idxElem++) {
                        tmp = CodeBook.array[idxElem][idxCode] - 
                              Training.array[idxElem][idxData];
                        SquaredError += tmp * tmp;
                }

            /**
             **  Add the Lagrangian scaled codeword length
             **/
            J = SquaredError + lambda * CodeWordLength[idxCode];

            /**
             **  If current Lagrangian is less than all previous Lagrangian
             **  values replace codeword index and squared error value.
             **/
            if(J < Jmin) {
                Jmin = J;
                Indices[idxData] = idxCode;
            }
        }
    }
}

/******************************************************************************/
/**  Function:  CBGenerate                                                   **/
/**                                                                          **/
/**  Description:                                                            **/
/**      Generate a new vector codebook by finding the centroids of the      **/
/**  current training data partition.  Also a list (array) and number of     **/
/**  empty cells is returned.                                                **/
/******************************************************************************/

void CBGenerate(Matrix CodeBook, Matrix Training, int *Indices,
                int *lstEmptyCells, int *nEmptyCells) {

    int    *lstCellSet, nCellSet, idxCode, idxTraining, flg, idxRow;
    float  *vCentroid;

    Matrix CellSet;

    /**
     **  Allocations
     **/
    lstCellSet = (int *) calloc(Training.nCols, sizeof(int));
    if(lstCellSet == NULL) {
        fprintf(stderr, "CBGenerate: Unable to allocate Current Set list\n");
        exit(-1);
    }
    vCentroid = (float *) calloc(CodeBook.nRows, sizeof(int));
    if(vCentroid == NULL) {
        fprintf(stderr, "CBGenerate: Unable to allocate Centroid vector\n");
        exit(-1);
    }

    /**
     **  Initializations
     **/
    *(nEmptyCells) = 0;


    /**
     **  Find training vectors belonging to each cell, replace codebook with 
     **  centroid
     **/

    for(idxCode = 0; idxCode < CodeBook.nCols; idxCode++) {

        /**
         **  Find the traning vectors belonging to the current code vector
         **/
        nCellSet = 0;
        for(idxTraining = 0 ; idxTraining < Training.nCols; idxTraining ++) {
            if(Indices[idxTraining] == idxCode) {
                lstCellSet[nCellSet++] = idxTraining;
            }
        }
        
        /**
         **  Check to see if this is an empty cell
         **/
        if(nCellSet > 0) {
            /**
             **  Create a matrix contianing the current set of training vector.
             **/

            flg = MatAlloc(&CellSet, CodeBook.nRows, nCellSet);
            if(flg == 0) {
                fprintf(stderr, "CBGenerate: Unable to allocate temp Matrix\n");
            }

            /**
             **  Copy the training data associated with this cell into
             **  the matrix.
             **/
            for(idxTraining = 0; idxTraining < nCellSet; idxTraining++) {
                for(idxRow = 0; idxRow < CodeBook.nRows; idxRow++) {
                    CellSet.array[idxRow][idxTraining] = 
                      Training.array[idxRow][lstCellSet[idxTraining]];
                }
            }

            /**
             **  Compute the centroid of this training subset
             **/
            Centroid(CellSet, vCentroid);

            /**
             **  Copy the new code vector back into the codebook
             **/
            for(idxRow = 0; idxRow < CodeBook.nRows; idxRow++) {
                CodeBook.array[idxRow][idxCode] = vCentroid[idxRow];
            }

            /**
             **  Free temporary matrix.
             **/
            MatFree(CellSet);
        }

        /**
         **  This is an empty cell, add its index to the empty cell list and
         **  increment the empty cell counter.
         **/
        else {
            lstEmptyCells[(*(nEmptyCells))++] = idxCode;
        }
    }

    /**
     **  Free allocated arrays
     **/
    free(vCentroid);
    free(lstCellSet);
}

/******************************************************************************/
/**  Centroid - compute the centroid of a set of vectors.                    **/
/******************************************************************************/
void Centroid(Matrix Set, float *vCentroid) {
    
    int   idxRow, idxCol;
    float   sum;

    for(idxRow = 0; idxRow < Set.nRows; idxRow++) {
        sum = 0.0;
        for(idxCol = 0; idxCol < Set.nCols; idxCol++) {
            sum += Set.array[idxRow][idxCol];
        }
        vCentroid[idxRow] = sum / Set.nCols;
    }
}

/******************************************************************************/
/**  Function: FixEmptyCells                                                 **/
/**                                                                          **/
/**  Description:                                                            **/
/**    FixEmptyCells replaces empty cell code vectors in the following       **/
/**  manner,                                                                 **/
/**                                                                          **/
/**    - VQ the data with the new codebook containing empty cells            **/
/**    - sort cells by decreasing total sqared error                         **/
/**    - split cell with highest squared error by assigning it two code      **/
/**      vectors                                                             **/
/**    - the single vector is perturbed by +/- DELTA and the training data   **/
/**      associated with the large sqaured error cell is reVQ using this     **/
/**      of code vectors                                                     **/
/**    - using the new training set partition, two centroids are generated   **/
/**      these centroids become the new code vectors                         **/
/**    - using these new code vectors the training data is again VQ'd and    **/
/**      these indices and sqaured error values are updated                  **/
/**    - this process is repeated for every empty cell                       **/
/**                                                                          **/
/**  Notes:                                                                  **/
/**    Cells with large total distortion but only a few cell members are     **/
/**  skipped.  This avoids regenerating empty cells.  The minimum number of  **/
/**  cell members is controlled by the parameter MIN_REPLACE.                **/
/**                                                                          **/
/**  Returns: MSE of new codebook                                            **/
/******************************************************************************/

float FixEmptyCells(Matrix CodeBook, Matrix Training, int *Indices,
                    float *vecSE,int *lstEmptyCells, int nEmptyCells) {

    int   *idxSorted, *SplitIndices, *lstCurrSet, SplitMap[2];
    int   flg, idxRow, idxCol;
    int   idxCell, idxData, idxEmpty, nCellSet, idxCellSorted;
    float *vecTSE, *SplitSE, *vCentroid, MSE;

    Matrix SplitBook, CellSet;

    fprintf(stderr, "    Empty cells %d\n", nEmptyCells);


    /**
     **  Allocate neccessary arrays.
     **/
    vecTSE = (float *) calloc(CodeBook.nCols, sizeof(float));
    if (vecTSE == NULL) {
        fprintf(stderr,
    "FixEmptyCells: Unable to allocate memory for cell total sqared error array\n");
        exit(-1);
    }

    idxSorted = (int *) calloc(CodeBook.nCols, sizeof(int));
    if (idxSorted == NULL) {
        fprintf(stderr,
           "FixEmptyCells: Unable to allocate memory for sorted index array\n");
        exit(-1);
    }

    lstCurrSet = (int *) calloc(Training.nCols, sizeof(int));
    if (lstCurrSet == NULL) {
        fprintf(stderr,
            "FixEmptyCells: Unable to allocate memory for cell list array\n");
        exit(-1);
    }
    vCentroid = (float *) calloc(CodeBook.nRows, sizeof(float));
    if (vCentroid == NULL) {
        fprintf(stderr,
              "FixEmptyCells: Unable to allocate memory for centroid vector\n");
        exit(-1);
    }
    
    flg = MatAlloc(&SplitBook, CodeBook.nRows, 2);
    if(flg == 0) {
        fprintf(stderr, "FixEmptyCells: Unable to allocate SplitBook matrix\n");
        exit(-1);
    }


    /**
     **  Recompute the indices and squared error using the new codebook
     **/
    MSE = NNFullSearch(CodeBook, Training, Indices, vecSE);


    /**
     **  Compute the total sqaured error for each cell
     **/
    for(idxData = 0; idxData < Training.nCols; idxData++) {
        vecTSE[Indices[idxData]] += vecSE[idxData];
    }


    /**
     **  Sort cell indicies by total squared error
     **/
    VecSort(vecTSE, idxSorted, CodeBook.nCols);
    

    /**
     **  For each empty cell split the current largest total squared error
     **  cell.
     **/
    idxCellSorted = 0;
    for(idxEmpty = 0; idxEmpty < nEmptyCells; idxEmpty++) {
                
        /**
         ** Find the training vectors in the current largest TSE cell, making
         ** sure that the cell has at least MIN_REPLACE members.
         **/
        nCellSet = 0;
        
        while(nCellSet < MIN_REPLACE) {
            nCellSet = 0;
            idxCell = idxSorted[idxCellSorted++];
            
            if(idxCellSorted > CodeBook.nCols) {
                fprintf(stderr,
         "FixEmptyCells: Exhausted training data looking for cells to split\n");
                fprintf(stderr,
         "               Use more training data or fewer codewords\n");
                exit(-1);
            }

            for(idxCol = 0 ; idxCol < Training.nCols; idxCol ++) {
                if(Indices[idxCol] == idxCell) {
                    lstCurrSet[nCellSet++] = idxCol;
                }
            }
        }

        /**
         **  Allocate index and squared error arrays for splitting the subset
         **/
        SplitIndices = (int *) calloc(nCellSet, sizeof(int));
        if(SplitIndices == NULL) {
            fprintf(stderr,
            "FixEmptyCells: Unable to allocate split index array\n");
            exit(-1);
        }

        SplitSE = (float *) calloc(nCellSet, sizeof(float));
        if(SplitSE == NULL) {
            fprintf(stderr,
            "FixEmptyCells: Unable to allocate split sqaured error array\n");
            exit(-1);
        }


        /**
         **  Create a matrix contianing the current set of training vectors.
         **/
        flg = MatAlloc(&CellSet, CodeBook.nRows, nCellSet);
        if(flg == 0) {
            fprintf(stderr,
          "FixEmptyCells: Unable to allocate current training subset matrix\n");
            exit(-1);
        }

        for(idxCol = 0; idxCol < nCellSet; idxCol++) {
            for(idxRow = 0; idxRow < CodeBook.nRows; idxRow++) {
                CellSet.array[idxRow][idxCol] = 
                  Training.array[idxRow][lstCurrSet[idxCol]];
            }
        }

        /**
         **  Compute the centroid of the current cell.
         **/
        Centroid(CellSet, vCentroid);                

        /**
         **  Copy perturbed code vector into 2 column splitting code book
         **/
        for(idxRow = 0; idxRow < CodeBook.nRows; idxRow++) {
            SplitBook.array[idxRow][0] = vCentroid[idxRow] + DELTA;
            SplitBook.array[idxRow][1] = vCentroid[idxRow] - DELTA;
        }

        /**
         **  Requantize the training subset with the perturbed code vector.
         **/
        NNFullSearch(SplitBook, CellSet, SplitIndices, SplitSE);

        /**
         **  Split the training data and recompute the centroids associated with
         **  the new partition.  Replacing the SplitBook matrix with the new 
         **  code vectors.
         **/
         GenPairVec(SplitBook, CellSet, SplitIndices);

        /**
          Where to copy new code vectors and update MSE, SE for each 
          training vecotr and cell assignments ??
          **/
        /**
         **  Copy new code vectors into codebook
         **/
        for(idxRow = 0; idxRow < CodeBook.nRows; idxRow++) {
            CodeBook.array[idxRow][idxCell] = SplitBook.array[idxRow][0];;
            CodeBook.array[idxRow][lstEmptyCells[idxEmpty]] = 
              SplitBook.array[idxRow][1];
        }
            
        /**
         ** Re-VQ the current cell data subset and reassign the indices 
         ** and update the sqaured error values
         **/
        NNFullSearch(SplitBook, CellSet, SplitIndices, SplitSE);

        SplitMap[0] = idxCell;
        SplitMap[1] = lstEmptyCells[idxEmpty];
        
        for(idxData = 0; idxData < nCellSet; idxData++) {
            Indices[lstCurrSet[idxData]] = SplitMap[SplitIndices[idxData]];
            vecSE[lstCurrSet[idxData]] = SplitSE[SplitIndices[idxData]];
        }


        /**
         ** Recompute the MSE
         **/
        MSE = 0;
        for(idxData = 0; idxData < Training.nCols; idxData++) {
            MSE += vecSE[idxData];
        }
        MSE = MSE / Training.nCols;

        /**
         **  Free arrays allocated inside empty cell indexing loop
         **/
        MatFree(CellSet);
        free(SplitSE);
        free(SplitIndices);
    }


    /**
     **  Free allocated arrays
     **/
    MatFree(SplitBook);
    free(lstCurrSet);
    free(idxSorted);
    free(vecTSE);

    return(MSE);
}

/******************************************************************************/
/**  Function: GenPairVec                                                    **/
/**                                                                          **/
/**  Description:                                                            **/
/******************************************************************************/

void GenPairVec(Matrix SplitBook, Matrix CellSet, int *SplitIndices) {

    int idxGroup, nSub, idxSub, *lstSub, idxRow, flg;
    float *vCentroid;
    Matrix SubSet;


    vCentroid = (float *) calloc(SplitBook.nRows, sizeof(float));
    if (vCentroid == NULL) {
        fprintf(stderr,
                "GenPairVec: Unable to allocate memory for centroid vector\n");
        exit(-1);
    }
    

    /**
     **  Generate a new pair of code vectors from the partition of
     **  CellSet matrix
     **/
    for(idxGroup = 0; idxGroup < 2; idxGroup++) {

        /**
         **  Allocate memory for the list of subset indices
         **/
        lstSub = (int *) calloc(CellSet.nCols, sizeof(int));
        if(lstSub == NULL) {
            fprintf(stderr, "GenPairVec: Unable to allocate subset list\n");
            exit(-1);
        }

        /**
         **  Find data vectors assigned to current group
         **/
        nSub = 0;
        for(idxSub = 0 ; idxSub < CellSet.nCols; idxSub++) {
            if(SplitIndices[idxSub] == idxGroup) {
                lstSub[nSub++] = idxSub;
            }
        }

        /**
         **  Allocate the matrix for the current group
         **/
        flg = MatAlloc(&SubSet, SplitBook.nRows, nSub);
        if(flg == 0) {
            fprintf(stderr,
                        "GenPairVec: Unable to allocate sub set matrix\n");
            exit(-1);
        }

        /**
         **  Copy data vectors from the current group into the matrix
         **/
        for(idxSub = 0; idxSub < nSub; idxSub++) {
            for(idxRow = 0; idxRow < SplitBook.nRows; idxRow++) {
                SubSet.array[idxRow][idxSub] = 
                  CellSet.array[idxRow][lstSub[idxSub]];
            }
        }

        /**
         **  Compute the centroid of the current group
         **/
        Centroid(SubSet, vCentroid);                


        /**
         **  Also copy new vectors into 2 element split codebook for
         **  recomputation of sqared error
         **/
        for(idxRow = 0; idxRow < SplitBook.nRows; idxRow++) {
            SplitBook.array[idxRow][idxGroup] = vCentroid[idxRow];
        }
        
        /**
         **  Free arrays allocated in this loop
         **/
        MatFree(SubSet);
        free(lstSub);
        
    }

    /**
     **  Free arrays allocated for the function
     **/
    free(vCentroid);
}

/******************************************************************************/
/**  Function: IndexEntropy                                                  **/
/**                                                                          **/
/**  Description:                                                            **/
/**      IndexEntropy first counts the number of occurances for each index.  **/
/**  It then computes the sample PMF and from this computes the entropy for  **/
/**  each index.                                                             **/
/**                                                                          **/
/**  Returns:                                                                **/
/**      The index entropy and the index sample probability mass functions   **/
/**  are returned in the array Entropy which should already be allocated.    **/
/******************************************************************************/

void IndexEntropy(Matrix CodeBook, Matrix Data, int Index[], 
                  float Entropy[], float SaPMF[]) {

    int *Counter, idxData, idxCell;

    /**
     **  Allocate memory for index counter.
     **/
    Counter = (int *) calloc(CodeBook.nCols, sizeof(int));
    if (Counter == NULL) {
        fprintf(stderr,
                "IndexEntropy: Unable to allocate memory for index counter\n");
        exit(-1);
    }


    /**
     **  Count the number of times each index occurs
     **/
    for(idxData = 0; idxData < Data.nCols; idxData++)
      Counter[Index[idxData]]++;

    /**
     **  Compute the sample PMF and index Entropy
     **/
    for(idxCell = 0; idxCell < CodeBook.nCols; idxCell++) {

        if(Counter[idxCell] > 0) {
            SaPMF[idxCell] = ((float) Counter[idxCell]) / ((float) Data.nCols);
            Entropy[idxCell] = -1.0 * log(SaPMF[idxCell]) / log(2.0);
        }
        else {
            SaPMF[idxCell] = 0.0;
            /**
             **  Although this is technically infinity in the limit, do not use an
             **  extremely large number so as to cause overflow.
             **/
            Entropy[idxCell] = INF_ENTROPY;
        }
    }

    free(Counter);
}

/******************************************************************************/
/**  Function: LagrangeAvg                                                   **/
/**                                                                          **/
/**  Description:                                                            **/
/**      Compute the average value of the Lagrangian                         **/
/******************************************************************************/
float LagrangeAvg(Matrix CodeBook, Matrix Training,
                  int Indices[], float CodeWordLength[] , float Lambda) {

    int    idxData, idxElem;
    float  Jtotal, SquaredError, tmp;

    Jtotal = 0.0;
    /**
     **  For each Data vector compute the value of the Lgrangian multiplier
     **/
    for(idxData = 0; idxData < Training.nCols; idxData++){

        /**
         **  Compute squared error with respect to the current codeword.
         **/
        SquaredError = 0.0;
        for(idxElem = 0; idxElem < CodeBook.nRows; idxElem++) {
            tmp = CodeBook.array[idxElem][Indices[idxData]] - 
              Training.array[idxElem][idxData];
            SquaredError += tmp * tmp;
        }

        /**
         **  Add the Lagrangian scaled codeword length
         **/
        Jtotal += SquaredError + Lambda * CodeWordLength[Indices[idxData]];
    }

    return(Jtotal / Training.nCols);
}

/******************************************************************************/
/**  Function: MeanRate                                                      **/
/**                                                                          **/
/**  Description:                                                            **/
/**                                                                          **/
/******************************************************************************/

float MeanRate(int nCodes, float Entropy[], float SaPMF[]) {

    int    idx;
    float  sum = 0.0;
    
    for(idx = 0; idx < nCodes; idx++) {
        sum += Entropy[idx] * SaPMF[idx];
    }
    return(sum);
}

/******************************************************************************/
/**  Function: MeanSquareErrror                                              **/
/**                                                                          **/
/******************************************************************************/

float MeanSquareError(Matrix CodeBook, Matrix Data, int Indices[]) {

    int idxData, idxElem;
    float SquaredError, tmp;

    SquaredError = 0.0;

    for(idxData = 0; idxData < Data.nCols; idxData++){
        for(idxElem = 0; idxElem < CodeBook.nRows; idxElem++) {
            tmp = CodeBook.array[idxElem][Indices[idxData]] - 
              Data.array[idxElem][idxData];
            SquaredError += tmp * tmp;
        }
    }

    return(SquaredError / Data.nCols);
}
