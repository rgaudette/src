#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

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


getMatHeader(FILE *matFile, MatlabVar Header) {

/**
 **  Load in the type parameter
 **/
    nBytes = fread(Header.type, sizeof(int), 1, matFile);
    if(nBytes)
main(int argc, char *argv[]) {

    int fdMatFile, nBytes, idxData; 
    double temp;
    MatlabVar mvCurrent;


    extern int errno;
    extern char *sys_errlist[];
    extern int sys_nerr;

    /**
     **  Open the matlib file to be read in
     **/
    fdMatFile = open(argv[1], O_RDONLY);
    if(fdMatFile == -1) {
        perror("MATLOAD - opening MATLAB file");
        exit(-1);
    }

    /**
     **  Keep reading in from the file until we are at the end
     **/
    while( ) {

        /**
         **  Read in the head for the current variable
         **/
        nBytes = read(fdMatFile, (char *) &(mvCurrent.type), 4);
        if(nBytes == -1) {
            perror("MATLOAD - reading MATLAB structure");
            exit(-1);
        }

        nBytes = read(fdMatFile, (char *) &(mvCurrent.nRows), 4);
        if(nBytes == -1) {
            perror("MATLOAD - reading MATLAB structure");
            exit(-1);
        }

        nBytes = read(fdMatFile, (char *) &(mvCurrent.nCols), 4);
        if(nBytes == -1) {
            perror("MATLOAD - reading MATLAB structure");
            exit(-1);
        }

        nBytes = read(fdMatFile, (char *) &(mvCurrent.flgImag), 4);
        if(nBytes == -1) {
            perror("MATLOAD - reading MATLAB structure");
            exit(-1);
        }

        nBytes = read(fdMatFile, (char *) &(mvCurrent.lenName), 4);
        if(nBytes == -1) {
            perror("MATLOAD - reading MATLAB structure");
            exit(-1);
        }

        /**
         **  Allocate memory for name and data
         **/
        mvCurrent.Name = calloc(mvCurrent.lenName, sizeof(char));
        if(mvCurrent.Name == NULL) {
            fprintf(stderr, "MATLOAD: Unable to allocate memory for Name string\n");
            exit(-1);
        }

        mvCurrent.Real = calloc(mvCurrent.nRows*mvCurrent.nCols, sizeof(double));
        if(mvCurrent.Real == NULL) {
            fprintf(stderr, "MATLOAD: Unable to allocate memory for Real array\n");
            exit(-1);
        }

        if(mvCurrent.flgImag) {
            mvCurrent.Imag = calloc(mvCurrent.nRows*mvCurrent.nCols, sizeof(double));
            if(mvCurrent.Imag == NULL) {
                fprintf(stderr, "MATLOAD: Unable to allocate memory for Imag array\n");
                exit(-1);
            }
        }

        /**
         **  Read in the name of variable
         **/

        nBytes = read(fdMatFile, mvCurrent.Name, mvCurrent.lenName);
        if(nBytes == -1) {
            perror("MATLOAD - reading MATLAB variable name");
            exit(-1);
        }

        fprintf(stderr, "Variable name: %s\n", mvCurrent.Name);
        fprintf(stderr, "Type     : %d\n", mvCurrent.type);
        fprintf(stderr, "Rows     : %d\n", mvCurrent.nRows);
        fprintf(stderr, "Cols     : %d\n", mvCurrent.nCols);
        fprintf(stderr, "flgImag  : %d\n", mvCurrent.flgImag);
        fprintf(stderr, "lenName  : %d\n", mvCurrent.lenName);

        /**
         **  Read in the real array
         **/
        for(idxData = 0; idxData < mvCurrent.nRows * mvCurrent.nCols; idxData++) {
            nBytes = read(fdMatFile, &temp, 8);
            if(nBytes == -1) {
                perror("MATLOAD - reading MATLAB variable name");
                exit(-1);
            }

            /**
             ** Copy value into array
             **/
            mvCurrent.Real[idxData] = temp;
        }

        /**
         **  Print out array
         **/
        for(idxData = 0; idxData < mvCurrent.nRows * mvCurrent.nCols; idxData++) {
            fprintf(stderr, "%f\n", mvCurrent.Real[idxData]);
        }
    }
}



