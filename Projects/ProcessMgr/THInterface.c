#include <stdio.h>
#include <windows.h>
#include <tlhelp32.h>


long            nProc;
long            nModule;
HANDLE WINAPI   hSnapShot;
MODULEENTRY32   ModEntry;
PROCESSENTRY32  ProcEntry;

long WINAPI ProcessSnapShot() {
    DWORD flgResult;

    //
    //  Get the toolhelp structure
    //
    hSnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0); 
    if (hSnapShot == (HANDLE) -1)
        return -1;
    
    nProc = 0;

    //
    //  Get first process identifier
    //
    ProcEntry.dwSize = sizeof(PROCESSENTRY32);
    
    flgResult = Process32First(hSnapShot, &ProcEntry);
    if (flgResult == FALSE)
        return -2;
    
    nProc++;

    //
    //  Walk through the process
    //
    while(flgResult = Process32Next(hSnapShot, &ProcEntry) != FALSE)
        nProc++;
    flgResult = GetLastError();
    if(flgResult != ERROR_NO_MORE_FILES)
        return -3;
    
    return 0;
}


long WINAPI GetNProc() {
    return nProc;
}

long WINAPI GetFirstProcess(long *ProcID, long *ParentID, long *nThreads,
                            long *Priority, char *ExeFile) {
    int flgResult;
    //
    //  Get the first process in the table
    //
    flgResult = Process32First(hSnapShot, &ProcEntry);
    if (flgResult == FALSE)
        return -1;
    
    *(ProcID) = ProcEntry.th32ProcessID;
    *(ParentID) = ProcEntry.th32ParentProcessID;
    *(nThreads) = ProcEntry.cntThreads;
    *(Priority) = ProcEntry.pcPriClassBase;
    strcpy(ExeFile, ProcEntry.szExeFile);

    return 1;
}

void FreeHandle() {
    CloseHandle(hSnapShot);
}

long WINAPI GetNextProcess(long *ProcID, long *ParentID, long *nThreads,
                            long *Priority, char *ExeFile) {
    int flgResult;
    //
    //  Get the next process in the table
    //
    flgResult = Process32Next(hSnapShot, &ProcEntry);
    if (flgResult == FALSE)
        return 0;
    
    *(ProcID) = ProcEntry.th32ProcessID;
    *(ParentID) = ProcEntry.th32ParentProcessID;
    *(nThreads) = ProcEntry.cntThreads;
    *(Priority) = ProcEntry.pcPriClassBase;
    strcpy(ExeFile, ProcEntry.szExeFile);
    
    return 1;
}


//
//  Get a module snapshot
//
long WINAPI ModuleSnapShot(long ProcID) {
    DWORD flgResult;

    //
    //  Get the toolhelp structure
    //
    hSnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, ProcID); 
    if (hSnapShot == (HANDLE) -1)
        return -1;
    
    nModule = 0;

    //
    //  Get first Module identifier
    //
    ModEntry.dwSize = sizeof(MODULEENTRY32);

    flgResult = Module32First(hSnapShot, &ModEntry);
    if (flgResult == FALSE)
        return -2;
    
    nModule++;

    //
    //  Walk through the process
    //
    while(flgResult = Module32Next(hSnapShot, &ModEntry) != FALSE)
        nModule++;
    flgResult = GetLastError();
    if(flgResult != ERROR_NO_MORE_FILES)
        return -3;
    
    return nModule;
}

//
//  Get the first module structure
//
long WINAPI GetFirstModule(long *ProcID,  long *Count, long *Size, 
                           char *strModule, char *strPath) {
    int flgResult;
    //
    //  Get the first module in the table
    //
    flgResult = Module32First(hSnapShot, &ModEntry);
    if (flgResult == FALSE)
        return -1;
    
    *(ProcID) = ModEntry.th32ProcessID;
    *(Count) = ModEntry.GlblcntUsage;
    *(Size) = ModEntry.modBaseSize;
    strcpy(strModule, ModEntry.szModule);
    strcpy(strPath, ModEntry.szExePath);

    return 1;
}

//
//  Get the next module structure
//
long WINAPI GetNextModule(long *ProcID,  long *Count, long *Size, 
                           char *strModule, char *strPath) {
    int flgResult;

    //
    //  Get the next module in the table
    //
    flgResult = Module32Next(hSnapShot, &ModEntry);
    if (flgResult == FALSE)
        return 0;

    *(ProcID) = ModEntry.th32ProcessID;
    *(Count) = ModEntry.GlblcntUsage;
    *(Size) = ModEntry.modBaseSize;
    strcpy(strModule, ModEntry.szModule);
    strcpy(strPath, ModEntry.szExePath);

    return 1;
}
