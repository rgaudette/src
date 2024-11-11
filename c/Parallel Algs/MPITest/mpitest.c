//  This is a very simple MPI program to test the communications between
//  two processes.

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include <mpi.h>

int main(int argc, char *argv[]) {

    int ReturnVal, nProc, myRank;

    int mpiBuffer[2];
    MPI_Status Status;
    
    //
    //  Initial values for mpiBuffer
    //
    mpiBuffer[0] = 7;
    mpiBuffer[1] = 14;

    //
    //  Initialize the MPI state
    //

    if (ReturnVal = MPI_Init(&argc, &argv)) {
        printf("MPI_Init returned %d\n", ReturnVal);
    }

    //
    //  Find out the number of processes running and my rank
    //
    MPI_Comm_size(MPI_COMM_WORLD, &nProc);
    printf("%d processes running\n", nProc);

    MPI_Comm_rank(MPI_COMM_WORLD, &myRank);
    printf("My rank is %d\n", myRank);

    switch (myRank) {
        
    case 0:
        mpiBuffer[0] = 87;
        mpiBuffer[1] = -2;
        MPI_Send(mpiBuffer, 2, MPI_INT, 1, 0, MPI_COMM_WORLD);
        printf("Rank 0 process sent message to rank 1 process\n");
        _sleep(5000);
        break;
    case 1:
        MPI_Recv(mpiBuffer, 2, MPI_INT, 0, MPI_ANY_TAG, MPI_COMM_WORLD, &Status);
        printf("Received %d and %d from rank 0\n", 
            mpiBuffer[0], mpiBuffer[1]);
        _sleep(5000);
        break;
    default:
        printf("%d Doin nothing\n", myRank);
        printf("mpiBuffer 0,1 %d and %d \n", 
            mpiBuffer[0], mpiBuffer[1]);
        _sleep(5000);
        
    }
    //
    //  Close the MPI session
    //
    MPI_Finalize();

    return 0;
}




