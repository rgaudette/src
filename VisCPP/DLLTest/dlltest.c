#include <stdio.h>
#include <stdlib.h>
#include <windows.h>

long SimpleSum(long a, long b);
int WINAPI sort(int *Array, int nElems);

void main(int argc, char * argv[]){
    int Array[10];
    int RetVal, i;

    Array[0] = 1;
    Array[1] = 6;
    Array[2] = 3;
    Array[3] = 1;
    Array[4] = 9;
    Array[5] = 2;
    Array[6] = 5;
    Array[7] = -23;
    Array[8] = 27;
    Array[9] = -1;

    RetVal = sort(Array, 10);

    for(i=0; i < 10; i++) {
        printf("%d\n", Array[i]);
    }
}