// Complex Function DLL.cpp : Defines the exported functions for the DLL.
//
// WIP: See https://riptutorial.com/cython/example/11296/wrapping-a-dll--cplusplus-to-cython-to-python

#include "pch.h"
#include "framework.h"
#include "Complex Function DLL.h"


// This is an example of an exported variable
COMPLEXFUNCTIONDLL_API int nComplexFunctionDLL=0;

// This is an example of an exported function.
COMPLEXFUNCTIONDLL_API int fnComplexFunctionDLL(void)
{
    return 0;
}

// This is the constructor of a class that has been exported.
CComplexFunctionDLL::CComplexFunctionDLL()
{
    return;
}
