#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "ecg/db.h"

void Usage(void);

main(int argc, char *argv[]) {

    char *fnOut, Opt;
    int flgVerbose, flgHelp, flgFOut, flgNSamp;
    int nSig, idxSignal, idxSample, nSample, idxStart, flgVec;
    FILE *fptrOut;


    extern char *optarg;
    extern int optind;

    Sample Vec[MAXSIG];
    struct siginfo SigInfo[MAXSIG];

    flgHelp  = 0;
    flgVerbose = 0;
    flgFOut = 0;
    flgNSamp = 0;
    idxStart = 0;

    /**
     **  Extract command line options
     **/
    while ((Opt = getopt(argc, argv, "hn:o:s:v")) != EOF) {

        switch(Opt) {

        case 'h':
            flgHelp = 1;
            break;

        case 'n':
            nSample = atoi(optarg);
            flgNSamp = 1;
            break;

        case 'o':
            fnOut = optarg;
            flgFOut = 1;
            break;

        case 's':
            idxStart = atoi(optarg);
            break;

        case 'v':
            flgVerbose = 1;
            break;

        case '?':
            flgHelp = 1;
        }

        if(flgHelp){
            Usage();
            exit(-1);
        }
    }

    
    /**
     **  Open the ASCII output file
     **/
    if(flgFOut) {
        fptrOut = fopen(fnOut, "w");
        if(fptrOut == NULL) {
            fprintf(stderr, "db2ascii: Unable to open output file\n");
            perror("db2ascii");
            exit(-1);
        }
    }        
    else {
        fptrOut = fdopen(1, "w");
        if(fptrOut == NULL) {
            fprintf(stderr, "db2ascii: Unable to open stdout\n");
            perror("db2ascii");
            exit(-1);
        }
    }
        
    
          
    /**
     **  Extract the number of signals present in the data file.
     **/
    nSig =  isigopen(argv[optind], SigInfo, MAXSIG);
    if (nSig == 0) {
        fprintf(stderr, "db2ascii: No signals in %s\n", argv[optind]);
        exit(-1);
    }
        
    if (nSig == -1) {
        fprintf(stderr, "db2ascii: unable to reader header file for %s\n",
                argv[optind]);
        fprintf(stderr, "\tProbably incorrect record name.\n");
        exit(-1);
    }

    if (nSig == 0) {
        fprintf(stderr, "db2ascii: Incorrect header file format for %s\n",
                argv[optind]);
        exit(-1);
    }

    if(flgVerbose) {
        printf("%s contains %d signals\n", argv[optind], nSig);
        
        for(idxSignal = 0; idxSignal < nSig; idxSignal++) {
            printf("Signal #%d\n", idxSignal);
            printf("Filename:\t%s\n", SigInfo[idxSignal].fname);
            printf("Samples:\t%d\n", SigInfo[idxSignal].nsamp);
            printf("Format:\t\t%d\n", SigInfo[idxSignal].fmt);            
            if(SigInfo[idxSignal].units == NULL){
                printf("Units:\t\tmV\n");
            }
            else {
                printf("Units:\t\t%s\n", SigInfo[idxSignal].units);
            }
            printf("Gain:\t\t%f\n", SigInfo[idxSignal].gain);
            printf("Baseline:\t%d\n", SigInfo[idxSignal].baseline);
            printf("ADC Zero:\t%d\n", SigInfo[idxSignal].adczero);
            printf("ADC Res.:\t%d\n", SigInfo[idxSignal].adcres);
            printf("\n");
        }
    }


    if(!flgNSamp) {
        nSample = SigInfo[0].nsamp;
    }
        
    for(idxSample = 0; idxSample < nSample; idxSample++) {
        flgVec = getvec(Vec);
        if (flgVec == -1) {
            fprintf(stderr, "db2ascii: End of data %d not available\n", nSample);
            break;
        }
        if (flgVec == -3) {
            fprintf(stderr, "db2ascii: Unexpected end of file\n");
            exit(-1);
        }
        if (flgVec == -4) {
            fprintf(stderr, "db2ascii: File corrupt\n");
            exit(-1);
        }

        for(idxSignal = 0; idxSignal < nSig; idxSignal++) {
            fprintf(fptrOut, "%8d\t", Vec[idxSignal] - SigInfo[idxSignal].adczero);
        }
        fprintf(fptrOut, "\n");
    }

    /**
     **  Close the ASCII ouput file
     **/
    fclose(fptrOut);

}


void Usage(void) {
fprintf(stderr,
    "\nDB2ASCII\tConvert a MIT-BIH database record to ascii format.\n\n");
fprintf(stderr, "usage: db2ascii [OPTIONS] record\n\n");
fprintf(stderr, "options:\n");
fprintf(stderr, "  -h          display this help page.\n");
fprintf(stderr,
    "  -n count    specify the number of samples to be extract, the default\n");
fprintf(stderr, 
    "              is the whole file\n");
fprintf(stderr,
    "  -o file     the name of the ASCII output file, default: stdout.\n");
fprintf(stderr, "  -s sample   specify the starting index, defualt: 0\n");
fprintf(stderr, "\n");
}
