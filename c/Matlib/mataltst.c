#include <stdio.h>

#include "matlib.h"

main(int argc, char *argv[]) {
    
    int idx;
    Matrix Mat;

    MatAlloc(&Mat, 5, 4);
        
    for(idx=0; idx<20; idx++) {
        Mat.array[0][idx] = idx;
    }

    MatPrint(Mat);

    MatReshape(&Mat, 10,2);

    MatPrint(Mat);
}
