#include <stdio.h>
#include <stdlib.h>

main(int argc, char *argv[]) {

    int idx;
    char cmd[1024];

    for(idx = atoi(argv[2]); idx <= atoi(argv[3]); idx++) {
        sprintf(cmd, "mv %s%03d %s.%03d", argv[1], idx, argv[1], idx);
        printf("%s\n", cmd);
        system(cmd);
    }
}
