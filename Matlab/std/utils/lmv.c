/*************************************************************************
**************************************************************************
**    program : lmv							**
**									**
**    usage : lmv file1.mat [file2.mat ... filen.mat]			**
**									**
**    Description:							**
**        LMV lists the variable names and properties contained within	**
**    the MAT-file(s) given on the command line.  Multiple filenames	**
**    are allowed.							**
**									**
**  $Author:   rjg  
**									**
**  $Date:   04 Feb 1994 16:14:18  
**									**
**  $Revision:   1.5  
**									**
**  $Log:   /home/ipx1/rjg/Matlab/Vcs/lmv.c,v  
**  
**     Rev 1.5   04 Feb 1994 16:14:18   rjg
**  Fixed precision and machine type reporting.
**  
**     Rev 1.4   03 Feb 1994 16:00:02   rjg
**  Reports on precision and machine type of each variable.
**  
**     Rev 1.3   02 Apr 1993 11:02:52   rjg
**  Fixed argv indexing, error handling if cant open file.
**  
**     Rev 1.1   02 Apr 1993 10:43:26   rjg
**  Modified header keyword, caused a syntax error.
**  
**     Rev 1.0   02 Apr 1993 10:39:26   rjg
**  Initial revision.
**									**
**************************************************************************
*************************************************************************/

#include <stdio.h>

#define OLDSTYLE
#include "mat.h"

/**
 **    Label character strings
 **/
static char	*Density[2] = {"Full", "Sparse"};
static char	*Complex[2] = {"No", "Yes"};

/**
 **    MATLAB type field definintions
 **/
#define GetMachine(x) ((x % 10000)/1000)
#define GetPrecision(x) ((x % 100)/10)

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

main(int argc, char *argv[])
{
    MATFile     *fp;
    Matrix	*matrix;
    int	idxFile, m, n, idx, type;

    union {
	char c_array[4];
	int  integer;
    } type_buf;

    /**
     **    If no file list usage and help
     **/
    if(argc < 2){
	fprintf(stderr,
		"\nusage: lmv file1.mat [file2.mat ... filen.mat]\n\n");
	fprintf(stderr, "    LMV lists the variable names and ");
	fprintf(stderr, "properties contained within\n");
	fprintf(stderr, "the MAT-file(s) given on the command ");
	fprintf(stderr, "line.  Multiple filenames\n");
	fprintf(stderr, "are alloweed.\n\n");
	exit(-1);
    }

    /**
     **    Loop over each file.
     **/
    for(idxFile = 1; idxFile < argc; idxFile++){

	fp = matOpen(argv[idxFile], "r");

	if(fp){
	    printf("%s:\n", argv[idxFile]);
	    printf("Name                     Size      ");
	    printf("Elements  Density  Complex  Precision      Machine\n");
	    printf("------------------------------------------");
	    printf("----------------------------------------------\n");

	    /**
	     **    Read out the type parameter and then place it back on
	     **    the stream so that matGetNextMatrix  is not confused
	     **/

	    while(fread(type_buf.c_array, sizeof(type_buf), 1,
			matGetFp(fp)) != 0){
		fflush(matGetFp(fp));
		/**
		 **    Put type value back onto stream
		 **/
		for(idx=0; idx < sizeof(int); idx++)
		  ungetc(type_buf.c_array[sizeof(int) - 1 - idx],
			 matGetFp(fp));

		if(type_buf.integer > 10000 || type_buf.integer < 0)
		  swab(type_buf.c_array, (char *) type);
		else
		  type = type_buf.integer;

		matrix = matGetNextMatrix(fp);

		m = mxGetM(matrix);
		n = mxGetN(matrix);

		printf("%-19s%6d by %-6d%7d    %s      %-3s   %s  %s\n",
		       mxGetName(matrix), m, n, m*n, 
		       Density[mxIsSparse(matrix)],
		       Complex[mxIsComplex(matrix)],
		       Precision[GetPrecision(type)],
		       MachineType[GetMachine(type)]);
	    }

	    mxFreeMatrix(matrix);
	    matClose(fp);
	    printf("\n\n");
	}
	else
	  printf("Could not open MAT-file: %s\n\n", argv[idxFile]);
	
    }
}
