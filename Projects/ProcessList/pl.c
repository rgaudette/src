#include <stdio.h>
#include <windows.h>
#include <tlhelp32.h>

void main(int argc, char *argv[]) {
    HANDLE WINAPI   hSnapShot;
    PROCESSENTRY32  ProcEntry;
    BOOL            flgResult;
    
    /**
     ** Get the toolhelp structure
     **/
    hSnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0); 
    if (hSnapShot == (HANDLE) -1) {
        printf("Unable to get system snapshot\n");
        exit(-1);
    }
    
    /**
     ** Get first process identifier
     **/
    ProcEntry.dwSize = sizeof(PROCESSENTRY32);
    flgResult = Process32First(hSnapShot, &ProcEntry);
    if (flgResult == FALSE) {
        printf("Unable to get first process entry\n");
        exit(-1);
    }


    //
    //  Print out the process table
    //
    printf(" Process ID  Parent ID   Thrd   Pri Executable\n");
    printf("=====================================================\n");
    printf("%10d  %10d    %2d    %2d  %s\n",
        ProcEntry.th32ProcessID, ProcEntry.th32ParentProcessID,
        ProcEntry.cntThreads, ProcEntry.pcPriClassBase,
        ProcEntry.szExeFile);
    
    while(flgResult = Process32Next(hSnapShot, &ProcEntry) != FALSE) {
        printf("%10d  %10d    %2d    %2d  %s\n",
            ProcEntry.th32ProcessID, ProcEntry.th32ParentProcessID,
            ProcEntry.cntThreads, ProcEntry.pcPriClassBase,
            ProcEntry.szExeFile);
    
    }   
}