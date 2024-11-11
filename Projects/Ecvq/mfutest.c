#include <stdio.h>
#include "../Matlib/matlib.h"


main(int argc, char *argv[]) {
    int flg;

    Matrix InMatrix;
    fprintf(stderr, "Extracting %s from %s\n", argv[2], argv[1]);

    flg = getMatVariable(argv[1], argv[2], &InMatrix);

    if(flg < 1) {
        fprintf(stderr, "mfutest: unable to find %s in %s\n", argv[2], argv[1]);
        exit(-1);
    }

    MatPrint(InMatrix);
}
