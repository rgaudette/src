#include <stdio.h>
#include <direct.h>

#include "engine.h"

#define CWDSTRLEN 1024
#define OUTBUFLEN 65536

main(int argc, char *argv[]) {

	char strOutput[OUTBUFLEN], strCWD[CWDSTRLEN], strCommand[CWDSTRLEN];
	
	FILE* fOutput;

	Engine *MatlabEng;
	
	//
	//  Read in the filname to execute
	//
	if(argc < 2) {
		fprintf(stderr, "No filename to run present on command line\n");
		exit(-1);
	}

	//
	//  If there is is a second string on the command line, write the output
	//  buffer string to that file.  Otherwise the output buffer is written
	//  to stdout.
	if(argc > 2) {
		fOutput = fopen(argv[2], "w");
		if(fOutput == NULL) {
			fprintf(stderr, "Unable to open the output file\n");
			exit(-1);
		}
	}
	else {
		fOutput = stdout;
	}

	//
	//  Set the MATLAB path to include the current directory
	//
	MatlabEng = engOpen(NULL);
	if(MatlabEng == NULL) {
		fprintf(stderr, "Unable to open the MATLAB Engine, exiting\n");
		exit(-1);
	}
	
	engOutputBuffer(MatlabEng, strOutput, OUTBUFLEN);
	
	_getcwd(strCWD, CWDSTRLEN);
	sprintf(strCommand, "path('%s', path);", strCWD);
	
	engEvalString(MatlabEng, strCommand);
	
	//
	//  CD to the current working directory since the matlab engine starts in 
	//  the MATLAB product directory.
	//
	sprintf(strCommand, "cd %s", strCWD);
	engEvalString(MatlabEng, strCommand);
	
	//
	//  Evaluate the command from the command line
	//
	engEvalString(MatlabEng, argv[1]);

	fprintf(fOutput, "%s\n", strOutput);

	if(argc > 2)
		fclose(fOutput);

	//
	//  Close the MATLAB engine
	//
	engClose(MatlabEng);

	return(0);
 }
