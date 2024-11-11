#include <stdio.h>
#include <windows.h>

int WINAPI sort(int *Array, int nElems) {
    int tmp, idxSrc, idxDest;
    char String[10];
    int RetVal;
    
    sprintf(String, "%d", nElems);    
    RetVal = MessageBox(NULL, String, NULL, MB_OK);

    for(idxDest=0; idxDest<nElems; idxDest++) {
        for(idxSrc=0; idxSrc<nElems; idxSrc++) {

            if(Array[idxDest] < Array[idxSrc]) {
                tmp = Array[idxDest];
                Array[idxDest] = Array[idxSrc];
                Array[idxSrc] = tmp;
            }
        }
    }
    return nElems;
}