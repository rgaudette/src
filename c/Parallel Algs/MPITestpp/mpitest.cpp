//  This is a very simple MPI program to test the communications between
//  two processes.
#include <stdio.h>
#include <iostream.h>
#include <stdlib.h>
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

    ReturnVal = MPI_Init(&argc, &argv);
    cout << "MPI_Init returned " << ReturnVal << '\n';
    

    //
    //  Find out the number of processes running and my rank
    //
    MPI_Comm_size(MPI_COMM_WORLD, &nProc);
    cout << nProc << " processes running\n";

    MPI_Comm_rank(MPI_COMM_WORLD, &myRank);
    cout << "My rank is " << myRank << '\n' << flush;

    switch (myRank) {
        
    case 0:
        mpiBuffer[0] = 87;
        mpiBuffer[1] = -2;
        MPI_Send(mpiBuffer, 2, MPI_INT, 1, 0, MPI_COMM_WORLD);
        cout << "Rank 0 process sent message to rank 1 process\n" << flush;
        break;
    case 1:
        MPI_Recv(mpiBuffer, 2, MPI_INT, 0, MPI_ANY_TAG, MPI_COMM_WORLD, &Status);
        cout << "Received " << mpiBuffer[0] << " and " 
            << mpiBuffer[1] << "from rank 0\n" << flush;
        break;
    default:
        cout << myRank << "Doin nothing\n";
        cout << "mpiBuffer 0,1 " << mpiBuffer[0] << " and " << mpiBuffer[1] << '\n' << flush;
        
        
    }
    
    //
    //  Close the MPI session
    //
    MPI_Finalize();

    return 0;
}




