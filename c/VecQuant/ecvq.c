/*************************************************************************
**************************************************************************
**  Program: ecvq
**
**  Usage:
**
**  ecvq TraingFile TrainingVariable CodeFileBase RateDistFile ...
**          nElem nCodes nTraining nRates RateStart RateStep
**
**  TrainingFile     The .mat (MATLAB Data) file containing the training data.
**
**  TrainingVariable The name of variable within TrainingFile that contians the
**                   training data.
**
**  CodeFileBase     The base filename for the codebooks.  Each rate produces a
**                   unique codebook, each codebook is placed in its own file.
**                   The files are written out in .mat format with variable name
**                   VQ.
**
**  RateDistFile     The name of the file that contains the rate-distortion table.
**
**
**
**  Description:
**     Generate Entropy Constrained Vector Quantization (ECVQ) code books
**  from a training data set in a MATLAB file.
**
**  Output:
**
**
**  $Author $
**
**  $Date $
**
**  $Revision $
**
**  $State $
**
**  $Log: ecvq.c,v $
**    Revision 1.2  1995/09/12  02:44:24  root
**    Added expression to approximate Lambda from requested rate.
**    Also changed command line parameters to accept rate start step, etc.
**    Both training data and initial code books are now read from the same source.
**    Rate-distortion file is now required (/tmp/null is no longer opened).
**    Initial random codebook is read from MATLAB file immediately following
**    training data.
**    Printf are changed to fprintf for better loggin.
**    Usage updated to match command line paramaters.
**
**    Revision 1.1  1995/08/30  03:39:22  root
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

#include "../../Matlib/matlib.h"
#include "vquant.h"
#include "mfutils.h"

#ifndef CLOCKS_PER_SEC
#define CLOCKS_PER_SEC 1E6
#endif

#define EPSILON 0.0005
void Usage();


int main(int argc, char *argv[]) {
    char    CodeFile[1024], CodeFileBase[1024], DataFile[1024], RateDistFile[1024];
    char    DataVar[32], InitCBFile[1024];
    int     flg, idxCode, idxCol, idxRow, iRate, nRates; 
    int     nElem, nCodes, nCurrCodes, nElemLeft;
    int     nTrainingVecs, flgLoadInitCB, flgSaveInitCB;
    float   Lambda, Rate, RateStart, RateStep, prevRate, meanRate;
    float   start, etime;
    float   *Entropy, *SaPMF, MeanSquareErr;
    double  temp;
    Matrix  CodeBook, Training, TempMat;
    FILE    *MatFile, *fptrData, *fptrRateDist, *fptrInitCBFile;

    int cflg;
    extern char *optarg;
    extern int optind;

    /**
     **  Initializations
     **/
    flgLoadInitCB = 0;
    flgSaveInitCB = 0;

    /**
     **  Extract the command line parameters
     **/
    while ((cflg = getopt(argc, argv, "b:d:s:f:k:i:n:N:r:s:t:v:w:")) != EOF)
      switch(cflg) {

      /**
       **  The first ECVQ codebook rate to generate
       **/
      case 'b':
          RateStart = atof(optarg);
          break;

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
       **  The number of codewords in the initial codebook, this is ignored if
       **  an initial codebook is loaded.
       **/
      case 'k':
          nCodes = atoi(optarg);
          break;

      /**
       **  Initial codebook filename.
       **/
      case 'i':
          flgLoadInitCB = 1;
          strcpy(InitCBFile, optarg);
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
       **  The number of codebooks to generate
       **/
      case 'r':
          nRates = atoi(optarg);
          break;

      /**
       **  The rate step size for the ECVQ codebooks.
       **/
      case 's':
          RateStep = atof(optarg);
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

      /**
       **  Write out the initial VQ codebook under this file name.
       **/
      case 'w':
          flgSaveInitCB = 1;
          strcpy(InitCBFile, optarg);
          break;
          
      case '?':
          Usage();
          exit(-1);
      }



    /**
     **  Load in the training Training values
     **/
    fptrData = fopen(DataFile, "r");
    if(fptrData == NULL) {
        fprintf(stderr, "ecvq: Unable to open training data file\n");
        fprintf(stderr, "Filename: %s\n", DataFile);
        exit(-1);
    }

    fprintf(stderr, "Loading in training data %s from %s\n",
	    DataVar, DataFile);
    nElemLeft = getMatVarSubset(fptrData, DataVar, &Training,
                                nElem * nTrainingVecs);
    if(nElemLeft < 1) {
        fprintf(stderr, "ecvq: Unable to read %s in %s\n",
                DataVar, DataFile);
        exit(-1);
    }

    /**
     **  Reshape the training data matrix to fix the codeword length
     **/
    MatReshape(&Training, nElem, nTrainingVecs);


    if (flgLoadInitCB) {
        
        /**
         **  Read in the initial codebook data
         **/
        flg = getMatVariable(InitCBFile, "VQ", &CodeBook);
        if (flg < 1) {
            fprintf(stderr,
                    "ecvq: Unable to load initial codebook requested\n");
            exit(-1);
        }
    }
    else {

        /**
         **  Load in initial codebook from MATLAB file, this is taken from the
         **  end of same Matlab variable as the training data.
         **/
        if(nElemLeft < nElem * nCodes) {
            fprintf(stderr,
        "ecvq: not enough data in %s:%s for both training and initial codebook\n",
                    DataFile, DataVar);
            exit(-1);
        }
        flg = MatAlloc(&CodeBook, nElem, nCodes);
        if(flg < 1) {
            fprintf(stderr,
            "ecvq: Unable to alllocate initial random codebook matrix\n");
            exit(-1);
        }

        /**
         **  Read in the elements
         **/
        for(idxRow = 0; idxRow < nElem; idxRow++) {
            for(idxCol = 0; idxCol < nCodes; idxCol++) {
                fread(&temp, sizeof(double), 1, fptrData);
                CodeBook.array[idxRow][idxCol] = temp;
            }
        }
    }

    fclose(fptrData);

    /**
     **  Allocate the entropy and smaple PMF vectors
     **/
    Entropy = (float *) calloc(CodeBook.nCols, sizeof(float));
    if (Entropy == NULL) {
        fprintf(stderr,
                "ecvq: Unable to allocate memory for index entropy array\n");
        exit(-1);
    }
    SaPMF = (float *) calloc(CodeBook.nCols, sizeof(float));
    if (SaPMF == NULL) {
        fprintf(stderr,
                "ecvq: Unable to allocate memory for sample PMF array\n");
        exit(-1);
    }


    /**
     **  Open the rate-distortion file
     **/
    fptrRateDist = fopen(RateDistFile, "w");
    if(fptrRateDist == NULL) {
        fprintf(stderr, "ecvq: Unable to open rate-distortion file\n");
        exit(-1);
    }
    fprintf(fptrRateDist,
            "Req. Rate\tAvg. Rate\tSq. Err.\tLambda\t\tFilename\n");
    fprintf(fptrRateDist,
      "======================================================================\n");


    if(!flgLoadInitCB) {

        /**
         **  Call standard VQ to get Lambda = 0 codebook.
         **/
        MeanSquareErr = LBG(CodeBook, Training, .0001);
        meanRate = log(nCodes) / log(2.0) / (float) nElem;
        fprintf(fptrRateDist, "%f\t%f\t%f\t%f\tInitial LBG\n", 
                meanRate, meanRate, MeanSquareErr/nElem, 0.0);
    }

    if(flgSaveInitCB) {

        /**
         **  Open the matlab file for saving the codebook.
         **/
        fptrInitCBFile = fopen(InitCBFile, "w+");
        if(fptrInitCBFile == NULL) {
            fprintf(stderr, "ecvq: Unable to open initial codebook file\n");
            exit(-1);
        }

        flg = putMatVariable(fptrInitCBFile, CodeBook, "VQ");
        if(flg < 1){
            fprintf(stderr, "ecvq: Unable to write out initial codebook data\n");
            exit(-1);
        }

        /**
         **  Close the initial codebook file.
         **/
        close(fptrInitCBFile);
    }
    /**
     **  Loop over values of Lambda producing shrinking rate codebooks
     **/

    for(iRate = 0; iRate < nRates; iRate++) {

        /**
         **  Estimate value of lambda from empirical formula
         **/
        Rate = (iRate * RateStep) + RateStart;
        if(nElem < 16) {
            Lambda = pow(10, -2.5 / 4.5 * (Rate) + 0.125);
        }
        else {
            Lambda = pow(10, -1.4934 * (Rate) + 0.35);
        }

        /**
         **  Compute the number of codes for the current codeword length
         **/
        fprintf(stderr, "\nGenerating codebook using lambda: %f\n", Lambda);


        /**
         **  Reset the codebook index entropy array to zero
         **/
        for(idxCode = 0; idxCode < CodeBook.nCols; idxCode++) {
            Entropy[idxCode] = 0.0;
            SaPMF[idxCode] = 0.0;
        }


        /**
         **  Run ECVQ algorithm on training data.
         **/
        prevRate = Rate;

        start = clock();
        meanRate = ECVQ(CodeBook, Training, Entropy, SaPMF, Lambda,
                    EPSILON, &MeanSquareErr);
        etime = clock() - start;

        fprintf(stderr, "Codebook mean rate %f bits / sample\n", meanRate);
        fprintf(stderr, "MSE: %f\n", MeanSquareErr);
        fprintf(stderr, "Codebook generation time %f\n",
		etime / CLOCKS_PER_SEC);


        /**
         ** Open the codebook output file.
         **/
        sprintf(CodeFile, "%s%03d.mat", CodeFileBase, iRate);
    	fprintf(fptrRateDist, "%f\t%f\t%E\t%E\t%s\n", 
                Rate, meanRate, MeanSquareErr/nElem, Lambda, CodeFile);
        fflush(fptrRateDist);

        MatFile = fopen(CodeFile, "w");


        /**
         **  Extract codes that are actually used, if the SaPMF > 0
         **  then the code is used.
         **/
        nCurrCodes = 0;
        for(idxCode = 0; idxCode < CodeBook.nCols; idxCode++) {
            if(SaPMF[idxCode] > 0.0)
              nCurrCodes++;
        }
        fprintf(stderr, "Codes used %d\n\n\n", nCurrCodes);

        flg = MatAlloc(&TempMat, nElem, nCurrCodes);
        if(flg == 0) {
            fprintf(stderr, "Unable to allocate temporary matrix\n");
            exit(-1);
        }

        idxCol = 0;
        for(idxCode = 0; idxCode < CodeBook.nCols; idxCode++) {
            if(SaPMF[idxCode] > 0.0) {
                for(idxRow = 0; idxRow < CodeBook.nRows; idxRow++) {
                    TempMat.array[idxRow][idxCol] = 
                      CodeBook.array[idxRow][idxCode];

                }
                idxCol++;
            }
        }

        putMatVariable(MatFile, TempMat, "VQ");
        MatFree(TempMat);


        /**
         **  Extract and write out the sample PMF
         **/
        flg = MatAlloc(&TempMat, 1, nCurrCodes);
        if(flg == 0) {
            fprintf(stderr, "Unable to allocate temporary matrix\n");
            exit(-1);
        }
        idxCol = 0;
        for(idxCode = 0; idxCode < CodeBook.nCols; idxCode++) {
            if(SaPMF[idxCode] > 0.0) {
                TempMat.array[0][idxCol] = SaPMF[idxCode];
                idxCol++;
            }
        }
        putMatVariable(MatFile, TempMat, "SaPMF");
        MatFree(TempMat);


        /**
         **  Extract and write out codeword entropy
         **/
        flg = MatAlloc(&TempMat, 1, nCurrCodes);
        if(flg == 0) {
            fprintf(stderr, "Unable to allocate temporary matrix\n");
            exit(-1);
        }
        idxCol = 0;
        for(idxCode = 0; idxCode < CodeBook.nCols; idxCode++) {
            if(SaPMF[idxCode] > 0.0) {
                TempMat.array[0][idxCol] = Entropy[idxCode];
                idxCol++;
            }
        }

        putMatVariable(MatFile, TempMat, "Entropy");
        MatFree(TempMat);
        

        fclose(MatFile);

    }
    /**
     **  Free the Entropy array.
     **/
    free(SaPMF);
    free(Entropy);
    
    /**
     **  Free the CodeBook Matrix
     **/
    MatFree(CodeBook);
    MatFree(Training);

    /**
     **  Close the rate-distortion file
     **/
    fclose(fptrRateDist);
    return(0);
}


void Usage() {
    fprintf(stderr, 
            "ecvq TraingFile TrainingVariable CodeFileBase RateDistFile\n");
    fprintf(stderr, "\tnElem nCodes nTraining nRates RateStart RateStep\n");
    fprintf(stderr, "TrainingFile\tThe MATLAB files containing the training data.\n");
}
