/*************************************************************************
**************************************************************************
**  Header: mfutils.h
**
**  Description:
**     Function declarations for the MATLAB file utils library.
**
**  Routines:
**
**
**  $Author: root $
**
**  $Date: 1996/03/20 03:01:08 $
**
**  $Revision: 1.3 $
**
**  $State: Exp $
**
**  $Log: mfutils.h,v $
**  Revision 1.3  1996/03/20 03:01:08  root
**  *** empty log message ***
**
**    Revision 1.3  1995/09/12  02:55:20  root
**    Updated declaration for FILE* in getMatVarSubset.
**
**    Revision 1.2  1995/08/30  03:52:30  root
**    Fixed RCS keywords.
**
**
**
**************************************************************************
*************************************************************************/

#ifndef _MFUTILS_INC
#define _MFUTILS_INC

typedef struct mat_var {
    int type;
    int nRows;
    int nCols;
    int flgImag;
    int lenName;

    char *Name;

    double *Real;
    double *Imag;
} MatlabVar;


int   getMatVariable(char *FileName, char *MatName, Matrix *InMatrix);
int   getMatVarSubset(FILE *MatFile, char *MatName, Matrix *InMatrix, int nElem);
int   getMatHeader(FILE *matFile, MatlabVar *Header);
int   putMatVariable(FILE *matFile, Matrix OutMatrix, char *Name);

#endif
