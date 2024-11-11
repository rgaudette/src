/*************************************************************************
**************************************************************************
**  Program: data2mat
**
**  Usage:
**
**  data2mat -d datafile -m matfile -n varname
**
**  -d datafile     The name of the CVRTI data file to be converted.
**
**  -m matfile      The name of the MATLAB file to output.
**
**  -n varname      The base variable name for the time serieses present
**                  in the file.  The index of each time series is appended
**                  on to the end of the variable name.
**
**  Description:
**      MAT2DATA reads in CVRTI data files, extracts all of the time series
**  present in the file, converts each one to a MATLAB variable and places
**  them all in a MATLAB file.
**
**
**  Output:
**      MATLAB level 1.0 file format.
**
**
**  $Author: rjg $
**
**  $Date: 1996/05/17 15:20:47 $
**
**  $Revision: 1.2 $
**
**  $State: Exp $
**
**  $Log: data2mat.c,v $
**  Revision 1.2  1996/05/17 15:20:47  rjg
**  Added help/usage text and addtnl error handling.
**
**  Revision 1.1  1996/05/17 14:36:40  rjg
**  Initial revision
**
**
**************************************************************************
*************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include "graphicsio.h"

void Usage();


int main(int argc, char * argv[]) {
    char          strExpID[80], strText[256], strLabel[80];
    char          fnDataFile[256], fnMatFile[256], strVarBase[256];
    char          strVarName[256];
    float         *ptrTimeSeries;
    CBoolean      flgPreferedSettingsBlk;
    int           iBlk, flgDataFile = 0, flgMatFile = 0, flgVarBase = 0;
    long          idFileType, idUnits, idFormat;
    long          nSurfaces, nBoundSurfaces, nTimeSeriesBlks;
    long          nChannels, nFrames;
    long          Endian, Size, Text, Type, Rows, Cols, flgImag, nName;
    char          VarName[256];

    FILE          *fptrMatFile;

    FileInfoPtr   DataFile;

    int cflg;
    extern char *optarg;
    extern int optind;

    /**
     **  Extract the command line parameters
     **/
    while ((cflg = getopt(argc, argv, "d:h:m:n:")) != EOF)
      switch(cflg) {

      /**
       **  CVRTI Data file name
       **/
      case 'd':
          strcpy(fnDataFile, optarg);
          flgDataFile++;
          break;

      case 'h':
          Usage();
          exit(0);

      /**
       **  MATLAB file name
       **/
      case 'm':
          strcpy(fnMatFile, optarg);
          flgMatFile++;
          break;

      /**
       **  MATLAB Variable basename
       **/
      case 'n':
          strcpy(strVarBase, optarg);
          flgVarBase++;
          break;


      case '?':
          Usage();
          exit(-1);

      }

    if(flgDataFile == 0) {
        fprintf(stderr, "Data file name not present\n");
        Usage();
        exit(-1);
    }

    if(flgMatFile == 0) {
        fprintf(stderr, "Matlab file name not present\n");
        Usage();
        exit(-1);
    }

    if(flgVarBase == 0) {
        fprintf(stderr, "Matlab variable base name not present\n");
        Usage();
        exit(-1);
    }

    /**
     **  Open the file
     **/
    if( openfile_(fnDataFile, 1, &DataFile) ) {
        exit(-1);
    }

    /**
     **  Get the file info header
     **/
    if( getfileinfo_(DataFile, &idFileType, &nSurfaces, &nBoundSurfaces,
                     &nTimeSeriesBlks, &flgPreferedSettingsBlk) ) {
        exit(-1);
    }
    printf("File: \t%s\n", argv[1]);
    printf("============================================================\n");
    printf("File type: \t\t\t\t%d\n", idFileType);
    printf("Surfaces: \t\t\t\t%d\n", nSurfaces);
    printf("Bound surfaces: \t\t\t%d\n", nBoundSurfaces);
    printf("Time series blocks: \t\t\t%d\n", nTimeSeriesBlks);
    printf("Prefered settings block: \t\t%d\n", flgPreferedSettingsBlk);


    /**
     **  Get any additional information available
     **/
    if( getexpid_(DataFile, strExpID) ) {
        fprintf(stderr, "Experiment ID not available\n");
    }
    printf("Experiment ID: \t\t\t%s\n", strExpID);

    if( gettext_(DataFile, strText) ) {
        fprintf(stderr, "Free format text not available\n");
    }
    printf("Text:\n%s\n\n", strText);


    /**
     **  Open matlab file for writting in append mode
     **/
    fptrMatFile = fopen(fnMatFile, "a");
    if (fptrMatFile == NULL) {
        perror("Data2mat");
    }

    /**
     **  Loop over each time series block
     **/
    for(iBlk = 0; iBlk < nTimeSeriesBlks; iBlk++) {
        settimeseriesindex_(DataFile, iBlk);
        gettimeseriesspecs_(DataFile, &nChannels, &nFrames);
        gettimeserieslabel_(DataFile, strLabel);
        gettimeseriesformat_(DataFile, &idFormat);
        gettimeseriesunits_(DataFile, &idUnits);

        /**
         **  Allocate memory for sequence
         **/
        ptrTimeSeries = (float *) calloc(sizeof(int), nChannels * nFrames);
        if(ptrTimeSeries == NULL) {
            fprintf(stderr, "data2mat: Not enough memory for seqeunce\n");
            exit(-1);
        }
        gettimeseriesdata_(DataFile, ptrTimeSeries);

        printf("Block %d: %s\n", iBlk+1, strLabel);
        if(idFormat == 1) {
            printf("Packed scalar\t");
        }
        else {
            printf("Multiplexed\t");
        }
        printf("Unit ID: %d\n", idUnits);
        printf("\tChannels:\t\t%d\n", nChannels);
        printf("\tFrames:\t\t\t%d\n", nFrames);

        /**
         **  Hard coded level 1.0 matlab file structure to save on space
         **/
        Endian = 1;   /** 1 for SPARC, MIPS, 0 for x86, ALPHA **/
        Size = 1;     /** 3 => short integer, 1 => float **/
        Text = 0;
        
        Type = Endian * 1000 + Size * 10 + Text;
        fwrite(&Type, sizeof(long), 1, fptrMatFile);
        
        /**
         **  Rows & columns
         **/
        fwrite(&nChannels, sizeof(long), 1, fptrMatFile);
        fwrite(&nFrames, sizeof(long), 1, fptrMatFile);


        /**
         ** Real data only
         **/
        Type = 0;
        fwrite(&Type, sizeof(long), 1, fptrMatFile);

        /**
         **  Variable name
         **/
        sprintf(strVarName, "%s_%d", strVarBase, iBlk);

        nName = strlen(strVarName);
        nName++;
        fwrite(&nName, sizeof(long), 1, fptrMatFile);

        fwrite(&strVarName, sizeof(char), nName, fptrMatFile);

        /**
         **  Write out time series
         **/
        fwrite(ptrTimeSeries, sizeof(float), nChannels * nFrames, fptrMatFile);
    }
}

void Usage() {
printf("\n");
printf("Usage:\n");
printf("\n");
printf("data2mat -d datafile -m matfile -n varname\n");
printf("\n");
printf("-d datafile\tThe name of the CVRTI data file to be converted.\n");
printf("\n");
printf("-m matfile\tThe name of the MATLAB file to output.\n");
printf("\n");
printf("-n varname\tThe base variable name for the time serieses present\n");
printf("\t\tin the file.  The index of each time series is appended\n");
printf("\t\ton to the end of the variable name.\n");
printf("\n");
printf("Description:\n");
printf("MAT2DATA reads in CVRTI data files, extracts all of the time series\n");
printf("present in the file, converts each one to a MATLAB variable and places\n");
printf("them all in a MATLAB file.\n");
printf("\n");
printf("\n");
printf("Output:\n");
printf("MATLAB level 1.0 file format.\n\n\n");

}
