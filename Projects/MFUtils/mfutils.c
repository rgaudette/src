/*************************************************************************
**************************************************************************
**    Library: mfutils
**
**    Description:
**        MFUTILS contains a number of utilities to handle MATLAB files
**    within normal C programs.
**
**    Routines:
**        getMatlabVariable
**        getMatVarSubset
**        getMatHeader
**        putMatVariable
**
**
**  $Author: root $
**
**  $Date: 1995/09/12 02:51:28 $
**
**  $Revision: 1.6 $
**
**  $State: Exp $
**
**  $Log: mfutils.c,v $
**    Revision 1.6  1995/09/12  02:51:28  root
**    Define for checking if compiled on a 386 fixed (changed to __i386__).
**    getMatVarSubset now taked a FILE pointer instead of a file name.  This
**    leaves the pointer after the last element read.
**    The number elements left in the matrix is returned.
**
**    Revision 1.5  1995/08/30  03:42:08  root
**    Added definitions for i386-Little Endian
**    Removed header name printing
**    Removed unused variables.
**
**    Revision 1.4  1995/08/19  22:19:21  root
**    Matlib include updated.
**
**    Revision 1.3  1995/08/19  19:09:03  root
**    Added putMatVariable, a function to write out a MATRIX in MATLAB
**    format.
**
**    Revision 1.2  1995/08/18  02:19:50  root
**    Fixed MatAlloc size problem in getMatVarSubset
**
**    Revision 1.1  1995/08/18  01:48:27  root
**    Initial revision
**
**
**************************************************************************
*************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "../Matlib/matlib.h"
#include "mfutils.h"

/**
 **  MATLAB header values - type and precision
 **/
static char     *MachineType[5] = {"IEEE Little Endian",
				   "IEEE Big Endian",
				   "VAX D-float"
				   "VAX G-float"
				   "Cray" };

static char     *Precision[6] = {"8 byte float",
				 "4 byte float",
				 "4 byte int  ",
                                 "2 byte int  ",
				 "2 byte unsigned",
				 "1 byte unsigned" };

#ifndef SEEK_CUR
#define SEEK_CUR 1
#endif


/*************************************************************************
**  Function: getMatVariable                                            **
**                                                                      **
**  Description:                                                        **
**      getMatVariable extracts the named MATLAB variable from the      **
**  given MATLAB file and places it in the Matrix InMatrix.             **
*************************************************************************/
int getMatVariable(char *FileName, char *MatName, Matrix *InMatrix) {
    int flg, idxRow, idxCol;
    double temp;
    size_t nElems;
    FILE *matFile;
    MatlabVar Header;

    /**
     **  Open the matlab file
     **/
    matFile = fopen(FileName, "r");
    if(matFile == NULL) {
        fprintf(stderr, "getMatVariable: Unable to open MATLAB file %s\n",
                FileName);
        return(-1);
    }

    /**
     **  Load up the first MATLAB header
     **/
    flg = getMatHeader(matFile, &Header);
    if(flg <= 0) {
        fprintf(stderr,
                "getMatVariable: Unable to extract first MATLAB header from: %s\n",
                FileName);
        return(-1);
    }


    while(strcmp(MatName, Header.Name)) {
       printf("%s found\n", Header.Name);
        /**
         **  Not the variable we are looking for, free the Header.Name string
         **  fseek past the data portion of the file.
         **/
        free(Header.Name);

#ifdef MYDEBUG
        fprintf(stderr, "Seeking forward %d bytes\n", Header.nRows * Header.nCols * sizeof(double));
#endif
        fseek(matFile, Header.nRows * Header.nCols * sizeof(double), SEEK_CUR);
        if(Header.flgImag)
          fseek(matFile, Header.nRows * Header.nCols * sizeof(double), SEEK_CUR);

        flg = getMatHeader(matFile, &Header);
        if(flg < 0) {
            fprintf(stderr,
                    "getMatVariable: Unable to extract MATLAB header from: %s\n",
                    FileName);
            return(-1);
        }
        if(flg == 0) {
            fprintf(stderr, 
                    "getMatVariable: Unable to find %s in %s\n", MatName, FileName);
            return(0);
        }
    }
    free(Header.Name);

    /**
     **  Read the MATLAB data into a Matrix structure
     **/
    if( ! MatAlloc(InMatrix, Header.nRows, Header.nCols) ) {
        fprintf(stderr, "getMatVariable: Unable allocate memory for Matrix\n");
        return(-1);
    }

    for(idxCol = 0; idxCol < Header.nCols; idxCol++) {
        for(idxRow = 0; idxRow < Header.nRows; idxRow++) {
            nElems = fread(&temp, sizeof(double), 1, matFile);
            if(nElems != 1) {
                if(nElems == 0) {
                    if(feof(matFile)){
                        fprintf(stderr,
                            "getMatVariable: reached end-of-file while reading in array\n");
                        return(0);
                    }
                    if(ferror(matFile)){
                        perror( "Read error" );
                        return(0);
                    }
                }
            }
            InMatrix->array[idxRow][idxCol] = temp;
        }
    }
    
    /**
     **  Close the MATLAB file
     **/
    fclose(matFile);

    return(1);
    
}

/*************************************************************************
**  Function: getMatVarSubset                                           **
**                                                                      **
**  Description:                                                        **
**      getMatVarSubset extracts the specified number of elements from  **
**  the named MATLAB variable present in the given MATLAB file and      **
**  places it in the Matrix InMatrix.                                   **
**                                                                      **
**  Returns:                                                            **
**      The number of elements left in the current matrix if successful **
**  0 if the variable was not found, -1 for other errors.               **
*************************************************************************/
int getMatVarSubset(FILE *matFile, char *MatName, Matrix *InMatrix, int nElem) {
    int flg, idxCol;
    double temp;
    MatlabVar Header;

    /**
     **  Load up the first MATLAB header
     **/
    flg = getMatHeader(matFile, &Header);
    if(flg <= 0) {
        fprintf(stderr,
                "getMatVarSubset: Unable to extract first MATLAB header\n");
        return(-1);
    }


    while(strcmp(MatName, Header.Name)) {
        /**
         **  Not the variable we are looking for, free the Header.Name string
         **  fseek past the data portion of the file.
         **/
        free(Header.Name);

        fseek(matFile, Header.nRows * Header.nCols * sizeof(double), SEEK_CUR);
        if(Header.flgImag)
          fseek(matFile, Header.nRows * Header.nCols * sizeof(double), SEEK_CUR);

        flg = getMatHeader(matFile, &Header);
        if(flg < 0) {
            fprintf(stderr, "getMatVarSubset: Unable to extract MATLAB header\n");
            return(-1);
        }
        if(flg == 0) {
            fprintf(stderr, "getMatVarSubset: Unable to find %s\n", MatName);
            return(0);
        }
    }
    free(Header.Name);

    /**
     **  Check to see if enough data is present in the matrix.
     **/
    if(Header.nRows * Header.nCols < nElem) {
        fprintf(stderr,
   "getMatVarSubset: Not enough data in matrix for requested number of elements\n");
        return(-1);
    }


    /**
     **  Read the MATLAB data into a Matrix structure, create the InMatrix
     **  as a row vector.
     **/
    if( ! MatAlloc(InMatrix, 1, nElem) ) {
        fprintf(stderr, "getMatVarSubset: Unable allocate memory for Matrix\n");
    }

    for(idxCol = 0; idxCol < nElem; idxCol++) {
        fread(&temp, sizeof(double), 1, matFile);
        InMatrix->array[0][idxCol] = temp;
    }
    
    return(Header.nRows * Header.nCols - nElem);
}

/*************************************************************************
**  Function: getMatHeader                                              **
**                                                                      **
**  Description:                                                        **
**      getMatHeader fills in the MATLAB header structure from the      **
**  given file pointer.  The file shoud be positioned at the start of a **
**  MATLAB matrix header.  If succesful a 1 is returned, if there are   **
**  no more matrices in the file a 0 is returned, any other error       **
**  returns a -1.                                                       **
*************************************************************************/
int getMatHeader(FILE *matFile, MatlabVar *Header) {

    int nElems;

    /**
     **  Load in the type parameter
     **/
    nElems = fread(&(Header->type), sizeof(int), 1, matFile);
    if(nElems == 0) {
        if(feof(matFile))
          return(0);
        else
          return(-1);
    }
#ifdef MYDEBUG
    fprintf(stderr, "Header.type\t%d\n", Header->type);
#endif

    /**
     **  Load in the rest of the header
     **/
    nElems = fread(&(Header->nRows), sizeof(int), 1, matFile);
    if(nElems == 0) return(-1);
#ifdef MYDEBUG
    fprintf(stderr, "Header.nRows\t%d\n", Header->nRows);
#endif

    nElems = fread(&(Header->nCols), sizeof(int), 1, matFile);
    if(nElems == 0) return(-1);
#ifdef MYDEBUG
    fprintf(stderr, "Header.nCols\t%d\n", Header->nCols);
#endif

    nElems = fread(&(Header->flgImag), sizeof(int), 1, matFile);
    if(nElems == 0) return(-1);
#ifdef MYDEBUG
    fprintf(stderr, "Header.flgImag\t%d\n", Header->flgImag);
#endif

    nElems = fread(&(Header->lenName), sizeof(int), 1, matFile);
    if(nElems == 0) return(-1);
#ifdef MYDEBUG
    fprintf(stderr, "Header.lenName\t%d\n", Header->lenName);
#endif


    /**
     **  Allocate the memory for the name of the variable
     **/
    Header->Name = calloc(Header->lenName, sizeof(char));
    if(Header->Name == NULL) {
        fprintf(stderr,
                "getMatHeader: Unable to allocate memory for variable name\n");
        return(-1);
    }

    /**
     **  Read in the name string
     **/
    nElems = fread(Header->Name, sizeof(char), Header->lenName, matFile);
    if(nElems == 0) return(-1);
#ifdef MYDEBUG
    fprintf(stderr, "Name:\t\t%s\n", Header->Name);
#endif

    return(1);
}

/*************************************************************************
**  Function: putMatVariable                                            **
**                                                                      **
**  Description:                                                        **
**    putMatVariable writes out a Matrix in MATLAB variable structure   **
**  to the file associate with matFile.  Name provides the variable     **
**  name for the matrix.                                                **
*************************************************************************/

int putMatVariable(FILE *matFile, Matrix OutMatrix, char *Name) {

    int nElems, idxRow, idxCol, lenName, nBytesWritten;
    int Machine, Precision, T, temp;
    double dtemp;

    /**
     **  Write out the header portion of the structure
     **/

    /**
     **  Figure out which type of machine I am on.
     **/
#if defined __i386__
    Machine = 0;
#elif defined _M_IX86
    Machine = 0;
#else
    Machine = 1;
#endif
    Precision = 0;
    T = 0;
    temp = Machine * 1000 + Precision * 10 + T;
    nBytesWritten = 0;

    nElems = fwrite(&temp, sizeof(int), 1, matFile);
    if(nElems < 1) return(0);
    nBytesWritten += nElems * sizeof(int);

    nElems = fwrite(&(OutMatrix.nRows), sizeof(int), 1, matFile);
    if(nElems < 1) return(0);
    nBytesWritten += nElems * sizeof(int);

    nElems = fwrite(&(OutMatrix.nCols), sizeof(int), 1, matFile);
    if(nElems < 1) return(0);
    nBytesWritten += nElems * sizeof(int);

    temp = 0;
    nElems = fwrite(&temp, sizeof(int), 1, matFile);
    if(nElems < 1) return(0);
    nBytesWritten += nElems * sizeof(int);

    lenName = strlen(Name) + 1;
    nElems = fwrite(&lenName, sizeof(int), 1, matFile);
    if(nElems < 1) return(0);
    nBytesWritten += nElems * sizeof(int);

    /**
     **  Write out the name of the variable
     **/
    nElems = fwrite(Name, sizeof(char), lenName, matFile);
    if(nElems < 1) return(0);
    nBytesWritten += nElems * sizeof(char);
    
    /**
     **  Write out the data in column order
     **/
    for(idxCol = 0; idxCol < OutMatrix.nCols; idxCol++) {
        for(idxRow = 0; idxRow < OutMatrix.nRows; idxRow++) {
            dtemp = OutMatrix.array[idxRow][idxCol];
            nElems = fwrite(&dtemp, sizeof(double), 1, matFile);
            if(nElems < 1) return(0);
            nBytesWritten += nElems * sizeof(double);
        }
    }
    printf("Total bytes written %d\n", nBytesWritten);
    return(1);
}
