// The following ifdef block is the standard way of creating macros which make exporting
// from a DLL simpler. All files within this DLL are compiled with the COMPLEXFUNCTIONDLL_EXPORTS
// symbol defined on the command line. This symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see
// COMPLEXFUNCTIONDLL_API functions as being imported from a DLL, whereas this DLL sees symbols
// defined with this macro as being exported.
#ifdef COMPLEXFUNCTIONDLL_EXPORTS
#define COMPLEXFUNCTIONDLL_API __declspec(dllexport)
#else
#define COMPLEXFUNCTIONDLL_API __declspec(dllimport)
#endif

// This class is exported from the dll
class COMPLEXFUNCTIONDLL_API CComplexFunctionDLL {
public:
	CComplexFunctionDLL(void);
	// TODO: add your methods here.
};

extern COMPLEXFUNCTIONDLL_API int nComplexFunctionDLL;

COMPLEXFUNCTIONDLL_API int fnComplexFunctionDLL(void);
