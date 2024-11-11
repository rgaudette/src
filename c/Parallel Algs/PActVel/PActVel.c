#include <stdio.h>
#include <stdlib.h>

#include <mpi.h>
#include <Matlib.h>
#include <mfutils.h>

#include "PActVel.h"


int main(int argc, char *argv[]) {

    int result, nProc, myRank;

    //
    //  Error checking for the command line
    //
    if (argc < 5) {
        perror("Incorrect number of command line arguments\n");
        exit(-1);
    }

  
    //
    //  Intialize MPI
    //
    if (result = MPI_Init(&argc, &argv)) {
        printf("MPI_Init returned %d\n", result);
    }

    //
    //  Find out the number of processes running and my rank
    //
    MPI_Comm_size(MPI_COMM_WORLD, &nProc);
    printf("%d processes running\n", nProc);

    MPI_Comm_rank(MPI_COMM_WORLD, &myRank);
    printf("My rank is %d\n", myRank);

    
    //
    //  Switch on rank to call appropriate function to handle convolution
    //
    switch (myRank) {
    
    case TWT_RANK:
        result = DoTemporalWT(argc, argv);
        break;
    
    case HZWT_RANK:
        result = DoHorizontalWT();
        break;
    
    case VTWT_RANK:
        result = DoVerticalWT();
        break;

    }

    //
    //  Close the MPI session
    //
    MPI_Finalize();

    return 0;
}

int DoTemporalWT(int argc, char *argv[]){
    int result, nRows, nMirror, iCol, iRow, SignalEnd;

    Matrix Data, szArray, Filter;
    Matrix Mirrored, TempDWT, HorizDWT, VertDWT;
    FILE *fptrMatfile;

    //
    //  Load in the data set from the MATLAB data file
    //
    result = MatlabLoad(argv[1], argv[2], &Data);
    if(result != SUCCESS) {
        fprintf(stderr, 
            "DoTemporalWT: Unable to get %s from %s\n", argv[2], argv[1]);
        return -1;
    }

    //
    //  Load in the data array size from the MATLAB file
    //
    result = MatlabLoad(argv[1], argv[3], &szArray);
    if(result != SUCCESS) {
        fprintf(stderr, "Unable to get %s from %s\n", argv[3], argv[1]);
        return -1;
    }
    
    //
    //  Load in the filters from the MATLAB filter file
    //
    result = MatlabLoad(argv[4], argv[5], &Filter);
    if(result != SUCCESS) {
        fprintf(stderr, "Unable to get %s from %s\n", argv[4], argv[5]);
        return -1;
    }
        
    //
    //  Pass data structure, array size and filters to horizontal WT
    //
    result = mpiSendMatrix(Data, HZWT_RANK);
    if(result < SUCCESS) {
        fprintf(stderr, "DoTemporalWT:  Unable to send Data Matrix\n");
        return 0;
    }
    result = mpiSendMatrix(szArray, HZWT_RANK);
    if(result < SUCCESS) {
        fprintf(stderr, "DoTemporalWT:  Unable to send szArray Matrix\n");
        return 0;
    }
    result = mpiSendMatrix(Filter, HZWT_RANK);
    if(result < SUCCESS) {
        fprintf(stderr, "DoTemporalWT:  Unable to send Filter Matrix\n");
        return 0;
    }
    
    //
    //  Pass data structure array size and filters to vertical WT
    //
    result = mpiSendMatrix(Data, VTWT_RANK);
    if(result < SUCCESS) {
        fprintf(stderr, "DoTemporalWT:  Unable to send Data Matrix\n");
        return 0;
    }
    result = mpiSendMatrix(szArray, VTWT_RANK);
    if(result < SUCCESS) {
        fprintf(stderr, "DoTemporalWT:  Unable to send szArray Matrix\n");
        return 0;
    }
    result = mpiSendMatrix(Filter, VTWT_RANK);
    if(result < SUCCESS) {
        fprintf(stderr, "DoTemporalWT:  Unable to send Filter Matrix\n");
        return 0;
    }

    //////////////////////////////////////////////////////////////////////
    //  Compute the temporal WT                                         //
    //////////////////////////////////////////////////////////////////////

    //
    //  Allocate a new matrix to hold the mirrored ends of the signal
    //  - each column will contain a different lead
    //
    nMirror = Filter.nRows / 2;
    printf("nMirror %d\n", nMirror);
    nRows = Data.nCols + 2 * nMirror;
    
    result = MatAlloc(&Mirrored, nRows, Data.nRows);
    if(result < SUCCESS) {
        fprintf(stderr, 
            "DoTemporalWT: Unable to allocate mirrored Matrix data\n");
        return 0;
    }
    printf("Mirrored: %d x %d\n", Mirrored.nRows, Mirrored.nCols);

    //
    //  Copy each row of the original data matrix into the 
    //
    for(iCol = 0; iCol < Data.nCols; iCol++) {
        for(iRow = 0; iRow < Data.nRows; iRow++) {
            Mirrored.array[iCol+nMirror][iRow]=
                Data.array[iRow][iCol];
        }
    }

    //
    //  Mirror the ends of the signals
    //
    SignalEnd = Data.nCols + nMirror;

    for(iCol = 0; iCol < Mirrored.nCols; iCol++) {
        for(iRow = 0; iRow < nMirror; iRow++) {
            Mirrored.array[nMirror - 1 - iRow][iCol] = 
                Mirrored.array[nMirror + iRow][iCol];
        }
        for(iRow = 0; iRow < nMirror; iRow++) {
            Mirrored.array[SignalEnd + iRow][iCol] = 
                Mirrored.array[SignalEnd - 1 + iRow][iCol];
        }
    }

    //
    //  Allocate a matrix for the result
    //
    result = MatAlloc(&TempDWT, 
        Mirrored.nRows + Filter.nRows - 1, Mirrored.nCols);
    if(result < SUCCESS) {
        fprintf(stderr, 
            "DoTemporalWT: Unable to allocate TempDWT Matrix data\n");
        return 0;
    }
    printf("TempDWT: %d x %d\n", TempDWT.nRows, TempDWT.nCols);

    //
    //  Convolve the columns with detail filter
    //
    result = MatConvolve(Mirrored, Filter, TempDWT);
    if(result < SUCCESS) {
        fprintf(stderr, 
            "DoTemporalWT: Unable to convolve data\n");
        return 0;
    }
    
    //
    //  Receive the result from the Horizontal WT
    //
    result = mpiRecvMatrix(&HorizDWT, HZWT_RANK);
    if(result < SUCCESS) {
        fprintf(stderr, 
            "DoTemporalWT: Unable to receive horizontal DWT Matrix\n");
        return 0;
    }

    //
    //  Receive the result from the Horizontal WT
    //
    result = mpiRecvMatrix(&VertDWT, VTWT_RANK);
    if(result < SUCCESS) {
        fprintf(stderr,
            "DoTemporalWT: Unable to receive vertical DWT Matrix\n");
        return 0;
    }

    //
    //  Open the result file
    //
    fptrMatfile = fopen("result.mat", "wb");
    if(fptrMatfile == NULL) {
        fprintf(stderr, "Unable to open output file\n");
        return 0;
    }
    
    //
    //  Save temporal DWT matrix
    //
    result = putMatVariable(fptrMatfile, TempDWT, "TempDWT");
    if(result < SUCCESS) {
        fprintf(stderr, 
            "DoTemporalWT: Unable write TempDWT to matfile\n");
        return 0;
    }

    //
    //  Save the horizontal DWT matrix
    //
    result = putMatVariable(fptrMatfile, HorizDWT, "HorizDWT");
    if(result < SUCCESS) {
        fprintf(stderr, 
            "DoTemporalWT: Unable write HorizDWT to matfile\n");
        return 0;
    }
    
    //
    //  Save the Vertical DWT matrix
    //
    result = putMatVariable(fptrMatfile, VertDWT, "VertDWT");
    if(result < SUCCESS) {
        fprintf(stderr, 
            "DoTemporalWT: Unable write VertDWT to matfile\n");
        return 0;
    }
    
    //
    //  Close the MATLAB file
    //
    fclose(fptrMatfile);

    return SUCCESS;
}

int DoHorizontalWT() {
    
    int result, nMirror, nArrRows, nArrCols, nRows;
    int iRow, iCol, iTemp, iArrCol, iArrRow, SignalEnd;

    Matrix Data, szArray, Filter, Mirrored, HorizDWT;

    //
    //  Get the Data  and Filter Matrices from the root process
    //
    result = mpiRecvMatrix(&Data, TWT_RANK);
    if(result < SUCCESS) {
        fprintf(stderr, "DoHorizontalWT:  Unable to receive Data Matrix\n");
        return 0;
    }

    result = mpiRecvMatrix(&szArray, TWT_RANK);
    if(result < SUCCESS) {
        fprintf(stderr, "DoHorizontalWT:  Unable to receive Data Matrix\n");
        return 0;
    }

    result = mpiRecvMatrix(&Filter, TWT_RANK);
    if(result < SUCCESS) {
        fprintf(stderr, "DoHorizontalWT:  Unable to receive Filter Matrix\n");
        return 0;
    }
    
#ifdef MYDEBUG
    fprintf(stderr,
        "DoHorizontalWT: received Data, szArray and Filter matrices\n");
#endif
    
    //////////////////////////////////////////////////////////////////////
    //  Compute the horizontal WT                                       //
    //////////////////////////////////////////////////////////////////////

    //
    //  Allocate a new matrix to hold the mirrored ends of the signal
    //  - each column will a different row of the array
    //
    nMirror = Filter.nRows / 2;
    printf("nMirror %d\n", nMirror);
    nArrRows = (int) szArray.array[0][0];
    nArrCols = (int) szArray.array[0][1];
    nRows = nArrCols + 2 * nMirror;
    
    result = MatAlloc(&Mirrored, nRows, nArrCols*Data.nCols);
    if(result < SUCCESS) {
        fprintf(stderr, 
            "DoTemporalWT: Unable to allocate mirrored Matrix data\n");
        return 0;
    }
    printf("Mirrored: %d x %d\n", Mirrored.nRows, Mirrored.nCols);

    //
    //  Copy each row of the original data matrix into the 
    //
    for(iTemp = 0; iTemp < Data.nCols; iTemp++) {
        for(iArrRow = 0; iArrRow < nArrRows; iArrRow++) {    
            for(iArrCol=0; iArrCol < nArrCols; iArrCol++) {
                Mirrored.array[iArrCol + nMirror][iArrRow + iTemp * nArrRows]=
                    Data.array[iArrRow + iArrCol * nArrRows][iTemp];
            }
        }
    }

    //
    //  Mirror the ends of the signals
    //
    SignalEnd = nArrCols + nMirror;

    for(iCol = 0; iCol < Mirrored.nCols; iCol++) {
        for(iRow = 0; iRow < nMirror; iRow++) {
            Mirrored.array[nMirror - 1 - iRow][iCol] = 
                Mirrored.array[nMirror + iRow][iCol];
        }
        for(iRow = 0; iRow < nMirror; iRow++) {
            Mirrored.array[SignalEnd + iRow][iCol] = 
                Mirrored.array[SignalEnd - 1 + iRow][iCol];
        }
    }

    //
    //  Allocate a matrix for the result
    //
    result = MatAlloc(&HorizDWT, 
        Mirrored.nRows + Filter.nRows - 1, Mirrored.nCols);
    if(result < SUCCESS) {
        fprintf(stderr, 
            "DoHorizontalWT: Unable to allocate HorizontalDWT Matrix data\n");
        return 0;
    }
    printf("HorizontalDWT: %d x %d\n", HorizDWT.nRows, HorizDWT.nCols);

    //
    //  Convolve the columns with detail filter
    //
    result = MatConvolve(Mirrored, Filter, HorizDWT);
    if(result < SUCCESS) {
        fprintf(stderr, 
            "DoHorizontalWT: Unable to convolve data\n");
        return 0;
    }

    //
    //  Send the result back to the root process
    //
    result = mpiSendMatrix(HorizDWT, TWT_RANK);
    if(result < SUCCESS) {
        fprintf(stderr, "DoHorizontalWT:  Unable to return result matrix\n");
        return 0;
    }
    return SUCCESS;
}


int DoVerticalWT() {
    
    int result, nMirror, nArrRows, nArrCols, nRows;
    int iRow, iCol, iTemp, iArrCol, iArrRow, SignalEnd;

    Matrix Data, szArray, Filter, Mirrored, VertDWT;

    //
    //  Get the Data  and Filter Matrices from the root process
    //
    result = mpiRecvMatrix(&Data, TWT_RANK);
    if(result < SUCCESS) {
        fprintf(stderr, "DoVerticalWT:  Unable to receive Data Matrix\n");
        return 0;
    }

    result = mpiRecvMatrix(&szArray, TWT_RANK);
    if(result < SUCCESS) {
        fprintf(stderr, "DoVerticallWT:  Unable to receive Data Matrix\n");
        return 0;
    }

    result = mpiRecvMatrix(&Filter, TWT_RANK);
    if(result < SUCCESS) {
        fprintf(stderr, "DoVerticalWT:  Unable to receive Filter Matrix\n");
        return 0;
    }
    
#ifdef MYDEBUG
    fprintf(stderr,
        "DoVerticalWT: received Data, szArray and Filter matrices\n");
#endif
    
    //////////////////////////////////////////////////////////////////////
    //  Compute the vertical WT                                       //
    //////////////////////////////////////////////////////////////////////

    //
    //  Allocate a new matrix to hold the mirrored ends of the signal
    //  - each column will a different row of the array
    //
    nMirror = Filter.nRows / 2;
    printf("nMirror %d\n", nMirror);
    nArrRows = (int) szArray.array[0][0];
    nArrCols = (int) szArray.array[0][1];
    nRows = nArrCols + 2 * nMirror;
    
    result = MatAlloc(&Mirrored, nRows, nArrCols*Data.nCols);
    if(result < SUCCESS) {
        fprintf(stderr, 
            "DoVerticalWT: Unable to allocate mirrored Matrix data\n");
        return 0;
    }
    printf("Mirrored: %d x %d\n", Mirrored.nRows, Mirrored.nCols);

    //
    //  Copy each row of the original data matrix into the 
    //
    for(iTemp = 0; iTemp < Data.nCols; iTemp++) {
        for(iArrCol=0; iArrCol < nArrCols; iArrCol++) {
            for(iArrRow = 0; iArrRow < nArrRows; iArrRow++) {    
                Mirrored.array[iArrRow + nMirror][iArrCol + iTemp * nArrCols]=
                    Data.array[iArrRow + iArrCol * nArrRows][iTemp];
            }
        }
    }

    //
    //  Mirror the ends of the signals
    //
    SignalEnd = nArrCols + nMirror;

    for(iCol = 0; iCol < Mirrored.nCols; iCol++) {
        for(iRow = 0; iRow < nMirror; iRow++) {
            Mirrored.array[nMirror - 1 - iRow][iCol] = 
                Mirrored.array[nMirror + iRow][iCol];
        }
        for(iRow = 0; iRow < nMirror; iRow++) {
            Mirrored.array[SignalEnd + iRow][iCol] = 
                Mirrored.array[SignalEnd - 1 + iRow][iCol];
        }
    }


    //
    //  Allocate a matrix for the result
    //
    result = MatAlloc(&VertDWT, 
        Mirrored.nRows + Filter.nRows - 1, Mirrored.nCols);
    if(result < SUCCESS) {
        fprintf(stderr, 
            "DoHorizontalWT: Unable to allocate HorizontalDWT Matrix data\n");
        return 0;
    }
    printf("VerticalDWT: %d x %d\n", VertDWT.nRows, VertDWT.nCols);

    //
    //  Convolve the columns with detail filter
    //
    result = MatConvolve(Mirrored, Filter, VertDWT);
    if(result < SUCCESS) {
        fprintf(stderr, 
            "DoVerticalWT: Unable to convolve data\n");
        return 0;
    }

    //
    //  Send the result back to the root process
    //
    result = mpiSendMatrix(VertDWT, TWT_RANK);
    if(result < SUCCESS) {
        fprintf(stderr, "DoVerticalWT:  Unable to return result matrix\n");
        return 0;
    }
    return SUCCESS;
}

int mpiSendMatrix(Matrix Data, int rank) {
    int result;
    //
    //  Send the number of rows in the matrix
    //
    result = MPI_Send(&(Data.nRows), 1, MPI_INT, rank, 0, MPI_COMM_WORLD);

    //
    //  Send the number of columns in the matrix
    //
    result = MPI_Send(&(Data.nCols), 1, MPI_INT, rank, 0, MPI_COMM_WORLD);
    
    //
    //  Send the data values in one long stream
    //
    result = MPI_Send(Data.array[0], Data.nCols * Data.nRows, MPI_DOUBLE, 
        rank, 0, MPI_COMM_WORLD);

    return SUCCESS;
}

int mpiRecvMatrix(Matrix *Data, int rank) {
    int result;
    MPI_Status Status;
    //
    //  Receive the number of rows in the matrix
    //
    MPI_Recv(&(Data->nRows), 1, MPI_INT, rank, 
        MPI_ANY_TAG, MPI_COMM_WORLD, &Status);

    //
    //  Receive the number of columns in the matrix
    //
    MPI_Recv(&(Data->nCols), 1, MPI_INT, rank, 
        MPI_ANY_TAG, MPI_COMM_WORLD, &Status);
    
    //
    //  Allocate the matrix data structure
    //
    result = MatAlloc(Data, Data->nRows, Data->nCols);
    if(result < SUCCESS) {
        fprintf(stderr, "mpiRecvMatrix: Unable to allocate Matrix data\n");
        return 0;
    }

    //
    //  Receive the data values in one long stream
    //
    MPI_Recv(Data->array[0], Data->nCols * Data->nRows, MPI_DOUBLE, 
        rank, MPI_ANY_TAG, MPI_COMM_WORLD, &Status);

    return SUCCESS;
}

