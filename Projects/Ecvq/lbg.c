/*************************************************************************
**************************************************************************
**  Program: lbg
**
**  Usage:
**    lbg <Parameters>
**
**  Training Data Parameters
**
**  -N nVecs         The number of training vectors to use.
**
**  -t Training      The training data filename.  This should be a MATLAB format
**                   format file containing the variable named by the -v option
**                   below.
**
**  -v Variable      The training data variable.  A MATLAB variable structure within
**                   the MATLAB file described above.  This should be a Nx1 matrix of
**                   random distributed according to the codebook requirements.
**
**  Codebook Rate Parameters
**
**  -m nBitsMax      The number of bits to use for the largest codebook.
**
**  -n nElem         The number of elements in each vector of the codebook.
**
**  Output Paramters
**
**  -d rdfile        The rate-distortion table file to create.
**
**  -f base          The basename of the codebooks.  The filename of the 
**                   codebooks will be generated as baseeDDD.mat where DDD
**                   is the index of the codebook.  The variable name VQ within
**                   the file contains the codebook.
**
**  Description:
**      LBG performs the Lloyd-Buzo-Gray VQ codebook generation algorithm.
**  This is also known as the k-means algorithm
**
**  Output:
**      The codebooks are written out in MATLAB file format to the filename
**  given on the command line.
**
**
**  $Author: root $
**
**  $Date: 1996/03/20 02:54:31 $
**
**  $Revision: 1.5 $
**
**  $State: Exp $
**
**  $Log: lbg.c,v $
**
**    Revision 1.5  1995/09/13  19:00:43  root
**    * Changed comand line structure, the program now takes the code vector size,
**    the maximum number of code bits and the number of training vectors to use.
**
**    * The initial code book is now extracted from the same MATLAB variable as the
**    training vectors for the 2 vector codebook size.  All other initial codebooks
**    are created by perturbing the previous smaller codebook.
**
**    * A rate distortion file along with the codebook filenames is now written out.
**
**    Revision 1.4  1995/08/30  03:48:16  root
**    No longer need allocation of indices and vecSE.
**    removed unnecessary variables.
**    added include for mfutils.
**
**    Revision 1.3  1995/08/22  02:50:59  root
**    Major automation improvements.
**    - loops over both number of vector elements and number of codewords.
**    - command line parameters added (unflaged)
**    - initial codebook is now loaded from a MATLAB file
**    - unecessary reporting removed
**    - number of Training vectors changed to 50,000
**    - Memory allocations shifted around to better fit looping structure
**    - writing out of codebook is finally implemented
**    - added short Usage blurb
**    - variable name changes, code clean up, etc.
**
**    Revision 1.2  1995/08/19  22:21:34  root
**    Matlib include updated, argv typo fixed.
**
**    Revision 1.1  1995/08/19  19:32:33  root
**    Initial revision
**
**
**
**************************************************************************
*************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <math.h>
#include <getopt.h>

#include "../../Matlib/matlib.h"
#include "vquant.h"
#include "mfutils.h"

#define DELTA 0.00001

#ifndef CLOCKS_PER_SEC
#define CLOCKS_PER_SEC 1E6
#endif

void Usage();
int SplitCells(Matrix *Split, float Delta);

int main(int argc, char *argv[]) {
    char    CodeFile[1024], CodeFileBase[1024], DataFile[1024], DataVar[32];
    char    RateDistFile[1024];
    int     flg, idxRow, idxCol, i;
    int     nCodeBits, nCodeBitsMax, nCodes;
    int     nElem, nElemLeft;
    int     nTrainingVecs;
    float   MeanSquareErr, Rate;
    float   etime;
    double  temp;

    Matrix  CodeBook, Training;
    FILE *MatFile, *fptrRateDist, *fptrData;

    int cflg;
    extern char *optarg;
    extern int optind;


    /**
     **  Extract the command line parameters
     **/
    while ((cflg = getopt(argc, argv, "d:f:m:n:N:t:v:")) != EOF)
      switch(cflg) {

      /**
       **  Rate-distortion file name.
       **/
      case 'd':
          strcpy(RateDistFile, optarg);
          break;

      /**
       **  Codebook base file name.
       **/
      case 'f':
          strcpy(CodeFileBase, optarg);
          break;

      /**
       **  The maximum number of code bits to use.
       **/
      case 'm':
          nCodeBitsMax = atoi(optarg);
          break;

      /**
       **  The vector length for the codebook.
       **/
      case 'n':
          nElem = atoi(optarg);
          break;

      /**
       **  The number of training vectors to use
       **/
      case 'N':
          nTrainingVecs = atoi(optarg);
          break;

      /**
       **  Training data file name.
       **/
      case 't':
          strcpy(DataFile, optarg);
          break;

      /**
       **  Training data variable name.
       **/
      case 'v':
          strcpy(DataVar, optarg);
          break;

          
      case '?':
          Usage();
          exit(-1);
      }

    /**
     **  Open the rate-distortion file
     **/
    fptrRateDist = fopen(RateDistFile, "w");
    if(fptrRateDist == NULL) {
        fprintf(stderr, "lbg: Unable to open rate-distortion file\n");
        exit(-1);
    }


    /**
     **  Load in the training data values
     **/
    fptrData = fopen(DataFile, "r");
    if(fptrData == NULL) {
        fprintf(stderr, "lbg: Unable to open training data file\n");
        exit(-1);
    }

    fprintf(stderr, "Loading in training data %s from %s\n",
            DataVar, DataFile);

    nElemLeft = getMatVarSubset(fptrData, DataVar, &Training,
                                nElem * nTrainingVecs);
    if(nElemLeft < 1) {
        fprintf(stderr, "lbg: Unable to read %s in %s\n",
                DataVar, DataFile);
        exit(-1);
    }

    /**
     **  Reshape the training data matrix to fix the codeword length
     **/
    MatReshape(&Training, nElem, nTrainingVecs);


    /**
     **  Load in initial codebook from MATLAB file, this is taken from the
     **  end of same Matlab variable as the training data.
     **/
    if(nElemLeft < nElem * 2) {
        fprintf(stderr,
      "lbg: not enough data in %s:%s for both training and initial codebook\n",
                DataFile, DataVar);
            exit(-1);
    }
    flg = MatAlloc(&CodeBook, nElem, 2);
    if(flg < 1) {
        fprintf(stderr, "lbg: Unable to alllocate initial codebook matrix\n");
        exit(-1);
    }

    /**
     **  Read in the elements
     **/
    for(idxRow = 0; idxRow < nElem; idxRow++) {
        for(idxCol = 0; idxCol < 2; idxCol++) {
            fread(&temp, sizeof(double), 1, fptrData);
            CodeBook.array[idxRow][idxCol] = temp;
        }
    }

    fclose(fptrData);

    /**
     **  Generate the smallest codebook first, the rest will be initialized by
     **  splitting the previous one.
     **/
    fprintf(stderr, "Runnning LBG algorithm ...\n");
    clock();
    MeanSquareErr = LBG(CodeBook, Training, .0001);
    etime = clock();
    fprintf(stderr, "Codebook generation time %f\n", etime / CLOCKS_PER_SEC);


    /**
     **  Print out rate and mean square error
     **/
    sprintf(CodeFile, "%s%02d%02d.mat", CodeFileBase, nElem, 1);
    Rate = 1.0 / nElem;
    fprintf(fptrRateDist, "%f\t%f\t%s\n", Rate, MeanSquareErr/nElem, CodeFile);
    fflush(fptrRateDist);

    /**
     **  Write out the Codebook matrix in MATLAB format
     **/
    MatFile = fopen(CodeFile, "w");
    putMatVariable(MatFile, CodeBook, "VQ");
    fclose(MatFile);

    /**
     **  Loop over all of the number of codewords.
     **/
    for(nCodeBits = 2; nCodeBits <= nCodeBitsMax; nCodeBits++) {

        /**
         **  Compute the number of codes for the current codeword length
         **/
        nCodes = 1;
        for(i = 0; i < nCodeBits; i++)
          nCodes = 2 * nCodes;

        fprintf(stderr, "Generating %d codeword codebook\n", nCodes);

        /**
         **  Split the current codebook
         **/
        flg = SplitCells(&CodeBook, DELTA);
        if(flg == 0) {
            fprintf(stderr, "lbg: Unable to split codebook\n");
            exit(-1);
        }

        /**
         **  Generate the current codebook
         **/
        fprintf(stderr, "Runnning LBG algorithm ...\n");
        clock();
        MeanSquareErr = LBG(CodeBook, Training, .0001);
        etime = clock();
        fprintf(stderr, "Codebook generation time %f\n",
                etime / CLOCKS_PER_SEC);


        /**
         **  Print out rate and mean square error
         **/
        sprintf(CodeFile, "%s%02d%02d.mat", CodeFileBase, nElem, nCodeBits);
        Rate = (float) nCodeBits / (float) nElem;
        fprintf(fptrRateDist, "%f\t%f\t%s\n", Rate,
                MeanSquareErr / nElem, CodeFile);
        fflush(fptrRateDist);


        /**
         **  Write out the Codebook matrix in MATLAB format
         **/
        MatFile = fopen(CodeFile, "w");
        putMatVariable(MatFile, CodeBook, "VQ");
        fclose(MatFile);

    }

    /**
     **  Free the Training Data Matrix
     **/
    MatFree(Training);
    MatFree(CodeBook);


    return(0);
}


void Usage() {
    fprintf(stderr, "lbg TraingFile TrainingVariable CodeFileBase RateDistFile\n");
    fprintf(stderr, "    nElem nBitsMax nTraining\n\n");
}


int SplitCells(Matrix *Split, float Delta) {
    int idxCol, idxRow;
    float **DataBlock;
    Matrix Temp;

    /**
     **  Allocate a temporary matrix to hold the split cells
     **/
    if(!MatAlloc(&Temp, Split->nRows, Split->nCols*2)) {
        fprintf(stderr, "SplitCells: Unable to allocate temporary matrix.\n");
        return(0);
    }

    /**
     **  Copy the perturbed columns into the temporary matrix
     **/
    for(idxCol = 0; idxCol < Split->nCols; idxCol++) {
        for(idxRow = 0; idxRow < Split->nRows; idxRow++) {
            Temp.array[idxRow][2*idxCol] = Split->array[idxRow][idxCol] + Delta;
            Temp.array[idxRow][2*idxCol+1] = Split->array[idxRow][idxCol] - Delta;
        }
    }

    /**
     **  Swap the data blocks between the Matrix structures
     **/
    DataBlock = Temp.array;
    idxCol = Temp.nCols;
    idxRow = Temp.nRows;
    Temp.array = Split->array;
    Temp.nRows = Split->nRows;
    Temp.nCols = Split->nCols;
    Split->array  = DataBlock;
    Split->nRows = idxRow;
    Split->nCols = idxCol;

    /**
     **  Free the temporary matrix that actually now hold the old matrix.
     **/
    MatFree(Temp);

    return(1);
}
