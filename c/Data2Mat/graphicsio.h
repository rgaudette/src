#ifndef __GRAPHICSIO_H__
#define __GRAPHICSIO_H__


#ifndef UNIX
#define VAX
#endif


#ifdef VAX
#include <stdlib.h>
#include <stdio.h>
#include <unixio.h>
#include <file.h>
#include <time.h>
#endif

#ifdef UNIX
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <time.h>
#include <unistd.h>
#include <malloc.h> 
#include <string.h>
#endif

#include "list.h"

typedef unsigned long FilePtr;
typedef float Scalar;
typedef float *ScalarPtr;
typedef float *TensorPtr;
typedef unsigned char CBoolean;

#ifndef TRUE
#define TRUE 1
#endif

#ifndef FALSE
#define FALSE 0
#endif


/* Define some general purpose error reporting macros */

#define SCREAM(message, function, returnValue, optionalString) \
if (thisFile->errorLevel) report(message, function, \
returnValue, optionalString); \
 return(returnValue)
#define CHECKRESULT if (result < success) {printf("file error\n"); return(result);}

typedef struct FileHeader
{
    long	headerSize;
    long    	fileType;
    FilePtr	fileInfoBlkPtr;
    long	numberOfSurfaces;
    FilePtr	firstSurfaceHeader;
    long	numberOfBoundSurfaces;
    FilePtr	firstBoundSurfaceHeader;
    long    	numberOfTimeSeries;
    FilePtr 	firstTimeSeriesHeader;
    FilePtr	preferedSettingsInfoBlock;
}FileHeader, *FileHeaderPtr;

	/* Offsets from beginning of FileHeader */

#define FTOFFSET    4
#define FIBOFFSET   8
#define NSOFFSET    12
#define FSHOFFSET   16
#define NBSOFFSET   20
#define FBSHOFFSET  24
#define NTSOFFSET   28
#define FTSOFFSET   32
#define PSIBOFFSET  36

enum fileUsage {FILETYPE_DATA = 1, FILETYPE_GEOM};

typedef struct FileInfoBlock
{
    long	blockSize;
    char	expID[80];
    char    	runID[80];
    time_t	creationTime;
    time_t	lastUpdateTime;
    char	text[256];
}FileInfoBlock, *FileInfoBlockPtr;

	/* Offsets from beginning of FileInfoBlock */

#define EXPIDOFFSET 	4
#define RUNIDOFFSET 	84
#define CTIMEOFFSET 	164
#define LUTIMEOFFSET    168
#define TEXTOFFSET  	172

enum ioResult {invalidSurface = -15, invalidTimeSeries, noElements, noTensors, 
	       noVectors, noScalars, wrongNumber, noNodes, invalidOperation, 
	       InvalidSurface, fileReadError, cantOpenFile, fileWriteError, 
	       cantCreateFile, noDynamicMemory, success = 0, existingSurface, 
	       firstSurface, newSurface, existingSeries, firstSeries, 
	       newSeries, noPowerCurve};

typedef struct SurfaceHeader
{
    long    headerSize;
    FilePtr nextSurfaceHeader;
    FilePtr nodeHeader;
    FilePtr elementHeader;
    FilePtr surfaceInfoBlk;
}SurfaceHeader, *SurfaceHeaderPtr;

	/* Offsets from beginning of SurfaceHeader */

#define NSHOFFSET 4
#define NHOFFSET 8
#define EHOFFSET 12
#define SIBOFFSET 16

typedef struct SurfaceInfoBlock
{
    long    headerSize;
    char    name[80];
    long    surfaceType;
}SurfaceInfoBlock, *SurfaceInfoBlockPtr;

	/* Offsets from beginning of SurfaceInfoBlock */

#define NMOFFSET 4
#define STOFFSET 84

enum SurfaceStatus {invalid = -1, first, new, valid};

typedef struct NodeHeader
{
    long    headerSize;
    long    numberOfNodes;
    FilePtr theNodes;
    long    numberOfNodeScalarValues;
    FilePtr firstNodeScalarValueHeader;
    long    numberOfNodeVectorValues;
    FilePtr firstNodeVectorValueHeader;
    long    numberOfNodeTensorValues;
    FilePtr firstNodeTensorValueHeader;
}NodeHeader, *NodeHeaderPtr;

	/* Offsets from beginning of NodeHeader */

#define NONOFFSET 4
#define TNOFFSET 8
#define NONSVOFFSET 12
#define FNSVHOFFSET 16
#define NONVVOFFSET 20
#define FNVVHOFFSET 24
#define NONTVOFFSET 28
#define FNTVHOFFSET 32

typedef struct ScalarValueHeader
{
    long    headerSize;
    FilePtr nextScalarValueHeader;
    long    scalarValueType;
    FilePtr theScalars;
}ScalarValueHeader, *ScalarValueHeaderPtr;

	/* Offsets from the beginning of the Scalar Value Header */

#define NSVHOFFSET 4
#define SVTOFFSET 8
#define TSOFFSET 12

enum VectorType {VECTYPE_NORMAL = 1, VECTYPE_FIBDIREC};

typedef struct VectorValueHeader
{
    long    	headerSize;
    FilePtr 	nextVectorValueHeader;
    long	vectorValueType;
    FilePtr 	theVectors;
}VectorValueHeader, *VectorValueHeaderPtr;


	/* Offsets from the beginning of the Vector Value Header */

#define NVVHOFFSET 4
#define VVTOFFSET 8
#define TVOFFSET 12

typedef struct TensorValueHeader
{
    long    headerSize;
    FilePtr nextTensorValueHeader;
    long    tensorValueType;	   
    long    tensorDimension; 
    FilePtr theTensors;
}TensorValueHeader, *TensorValueHeaderPtr;


	/* Offsets from the beginning of the Tensor Value Header */

#define NTVHOFFSET 4
#define TVTOFFSET 8
#define TTOFFSET 12

typedef struct ElementHeader
{
    long    headerSize;
    long    numberOfElements;
    long    sizeOfElements;
    FilePtr theElements;
    long    numberOfElementScalarValues;
    FilePtr firstElementScalarValueHeader;
    long    numberOfElementVectorValues;
    FilePtr firstElementVectorValueHeader;
    long    numberOfElementTensorValues;
    FilePtr firstElementTensorValueHeader;
}ElementHeader, *ElementHeaderPtr;

	/* Offsets from beginning of ElementHeader */

#define NOEOFFSET 4
#define SOEOFFSET 8
#define TEOFFSET 12
#define NOESVOFFSET 16
#define FESVHOFFSET 20
#define NOEVVOFFSET 24
#define FEVVHOFFSET 28
#define NOETVOFFSET 32
#define FETVHOFFSET 36

typedef struct TimeSeriesHeader
{
    long    	    	    headerSize;
    FilePtr 	    	    nextTimeSeriesHeader;
    char    	    	    geometryFileName[80];
    long	    	    dataFormat;
    long    	    	    numberOfChannels;
    long    	    	    numberOfFrames;
    FilePtr 	    	    theData;
    FilePtr 	    	    powerCurve;
    long	    	    qtime;
    long	    	    stime;
    long	    	    ttime;
    long		    rrInterval;
    long	    	    numberOfCorrectedChannels;
    FilePtr 	    	    correctedChannels;
    char    	    	    fileName[80];
    char    	    	    label[80];
    long    	    	    assocSurfaceNumber;
    long	    	    association;
    long	    	    dataUnits;
    FilePtr 	    	    preferedScalingBlock; /* to here is 308 bytes */
    long    	    	    ponset;
    long    	    	    poffset;
    long    	    	    rpeak;
    long    	    	    tpeak; 
}TimeSeriesHeader, *TimeSeriesHeaderPtr;

/*	Offsets from the beginning of the Time Series Header	*/

#define NTSHOFFSET 4

typedef struct FileInfo
{
    long		    fileNumber;
    long		    currentSurfaceIndex;
    SurfaceHeaderPtr	    theCurrentSurface;
    FilePtr 	    	    theCurrentSurfaceLocation;
    long		    lastSurfaceIndex;
    FilePtr 	    	    lastSurfaceLocation;
    long	    	    theCurrentTimeSeriesIndex;
    FilePtr 	    	    theCurrentTimeSeriesLocation;
    long		    externalFileNumber;
    FileHeader		    thisFileHeader;
    long    	    	    errorLevel;
    char    	    	    dataPath[80];
    int	    	    	    externalFileType;
}FileInfo, *FileInfoPtr;

enum extFile {FILE_TYPE_UNKNOWN, FILE_TYPE_RAW, FILE_TYPE_PAK};

typedef struct PakHeader
{
	short					fileNumber;
	short					tapeNumber;
	short					patientNumber;
	short					runNumber;
	short					numberOfLeads;
	short					numberOfFrames;
	short					qTime;
	short					sTime;
	short					tTime;
	short					rrInterval;
	char					header[40];
}PakHeader, *PakHeaderPtr;

typedef struct RawHeader
{
	short					fileNumber;
	short					tapeNumber;
	short					patientNumber;
	short					runNumber;
	short					numberOfLeads;
	short					numberOfFrames;
	char	    	    	    	    	time[8];
	char					header[40];
}RawHeader, *RawHeaderPtr;

enum DataUnits {UNIT_MVOLTS = 1, UNIT_UVOLTS, UNIT_MSECS, UNIT_VOLTS,
	    	UNIT_MVOLTMSECS};
enum DataAssociation {ASSOC_NODES = 1, ASSOC_WHOLEELEMENT,
	    	    	ASSOC_ELEMENTCENTROID};
enum DataFormat {FORMAT_MUXDATA = 1, FORMAT_SCALARS, FORMAT_CVRTIRAW,
		 FORMAT_CVRTIPAK};


typedef struct Node
{
    float x;
    float y;
    float z;
}Node, *NodePtr;

typedef struct Vector
{
    float x;
    float y;
    float z;
}Vector, *VectorPtr;

typedef struct Tri
{
    long v1;
    long v2;
    long v3;
}Tri, *TriPtr;

typedef struct Tetra
{
    long v1;
    long v2;
    long v3;
    long v4;
}Tetra, *TetraPtr;

typedef long *ElementPtr;


typedef void* (*PTRfPTRvoid)(void*);
typedef char* (*PTRfPTRchar)(void*);
typedef long* (*PTRfPTRlong)(void*);
typedef float* (*PTRfPTRfloat)(void*);
typedef NodePtr (*PTRfPTRnode)(void*);
typedef ElementPtr (*PTRfPTRelement)(void*);
typedef TriPtr (*PTRfPTRtri)(void*);
typedef TetraPtr (*PTRfPTRtetra)(void*);
typedef ScalarPtr (*PTRfPTRscalar)(void*);
typedef VectorPtr (*PTRfPTRvector)(void*);
typedef TensorPtr (*PTRfPTRtensor)(void*);

typedef struct rewriteRequest
{
    long    	    dataType;	    /* Data type see enum below */
    long    	    surfaceNumber;  /* Which surface */
    long	    index;  	    /* Index for associated values or timeseries */
    long    	    valueType;	    /* Value type for associated values */
    long    	    quantity;	    /* How many (nodes, tris, etc.) */
    long    	    theDimension;   /* Dimension for tensors */
    void    	    *dataPointer;   /* Pointer to data, zero for call back */
    PTRfPTRvoid	    callBackRoutine;/* Address of call back routine */
}rewriteRequest, *rewriteRequestPtr;

/* CAUTION, searchList depends on the proper 
   order of the dataType enum below! */

enum dataType {EXPID, TEXT, SURFACENAME, SURFACETYPE, NODES, TIMESERIESFILE,
	       TIMESERIESGEOMFILE, TIMESERIESSPECS, TIMESERIESLABEL,
	       TIMESERIESFORMAT, TIMESERIESUNITS, TIMESERIESSURFACE,
	       TIMESERIESASSOC, TIMESERIESDATA, NUMCORRECTEDLEADS,
	       CORRECTEDLEADS, POWERCURVE, QSTTIMES, EXTENDEDFIDUCIALS,
	       ELEMENTS, NODESCALARS, NODEVECTORS, NODETENSORS, ELEMENTSCALARS,
	       ELEMENTVECTORS, ELEMENTTENSORS};


typedef struct timeseriesspecs
{
	long	numberOfChannels;
	long	numberOfFrames;
}timeseriesspecs, *timeseriesspecsPtr;

typedef struct fiducials
{
	long	qtime;
	long	stime;
	long	ttime;
}fiducials, *fiducialsPtr;

typedef struct extendedFiducials
{
	long	ponset;
	long	poffset;
	long	rpeak;
	long	tpeak;
}extendedFiducials, *extendedFiducialsPtr;


typedef struct queuedRewriteRequest
{
    TLISTHDR(struct queuedRewriteRequest);
    rewriteRequest  theRequest;
}queuedRewriteRequest, *queuedRewriteRequestPtr;

	/* Function Prototypes */

/* Utility Routines */

void convertLong(long* theData, long howMany);
void convertFloat(float* theData, long howMany, CBoolean toUnix);
void convertShort(short* theData, long howMany);
long readtimeseriesheader(FileInfoPtr thisFile, TimeSeriesHeaderPtr theHeader);
long writetimeseriesheader(FileInfoPtr thisFile, 
			   TimeSeriesHeaderPtr theHeader);
void fixPath(FileInfoPtr thisFile, char* inputFileName, char* outputFileName);


/* Basic File Routines */

long createfile_(char *fileName, long fileType, 
		 long errorLevel, FileInfoPtr *theFile);
long closefile_(FileInfoPtr thisFile);
long openfile_(char* fileName, long errorLevel, FileInfoPtr *theFile);
long getfileinfo_(FileInfoPtr thisFile, long* fileType, long* numberOfSurfaces,
		 long* numberOfBoundSurfaces, long* numberOfTimeSeriesBlocks,
		 CBoolean* preferedSettingsBlock);
long setexpid_(FileInfoPtr thisFile, char* theExp);
long getexpid_(FileInfoPtr thisFile, char* theExp);
long settext_(FileInfoPtr thisFile, char* theText);
long gettext_(FileInfoPtr thisFile, char* theText);

/* Surface Information Routines */

long setsurfaceindex_(FileInfoPtr thisFile, long theSurface);
long getsurfaceindex_(FileInfoPtr thisFile, long *theSurface);
long setsurfacename_(FileInfoPtr thisFile, char* theName);
long getsurfacename_(FileInfoPtr thisFile, char* theName);
long setsurfacetype_(FileInfoPtr thisFile, long theType);
long getsurfacetype_(FileInfoPtr thisFile, long *theType);

	/* for nodes */
long setnodes_(FileInfoPtr thisFile, long numberOfNodes, NodePtr theNodes);
long getnodeinfo_(FileInfoPtr thisFile, long *numberOfNodes,
		  long *numberOfScalarValues, long *numberOfVectorValues,
		  long *numberOfTensorValues);
long getnodes_(FileInfoPtr thisFile, NodePtr theNodeData);

	/* for elements */
long setelements_(FileInfoPtr thisFile, long sizeOfElements,
		  long numberOfElements, long *theElements);
long getelementinfo_(FileInfoPtr thisFile, long *numberOfElements,
		  long *elementSize, long *numberOfScalarValues, 
		  long *numberOfVectorValues, long *numberOfTensorValues);
long getelements_(FileInfoPtr thisFile, long *theElements);

	/* for associated values */
long setnodescalars_(FileInfoPtr thisFile, long theType,
		     long numberOfScalars, ScalarPtr theScalarData);
long getnodescalars_(FileInfoPtr thisFile, long scalarIndex, 
		     long  *theType, ScalarPtr theScalarData);
long getnodescalartypes_(FileInfoPtr thisFile, long *theTypes);

long setnodevectors_(FileInfoPtr thisFile, long theType,
		     long numberOfVectors, VectorPtr theVectorData);
long getnodevectors_(FileInfoPtr thisFile, long vectorIndex, 
		     long  *theType, VectorPtr theVectorData);
long getnodevectortypes_(FileInfoPtr thisFile, long *theTypes);

long setnodetensors_(FileInfoPtr thisFile, long theType, long theDimension,
		     long numberOfTensors, TensorPtr theTensorData);
long getnodetensors_(FileInfoPtr thisFile, long tensorIndex, 
		     long *theDimension,
		     long  *theType, TensorPtr theTensorData);
long getnodetensortypes_(FileInfoPtr thisFile, long *theTypes,
			 long *theDimensions);

long setelementscalars_(FileInfoPtr thisFile, long theType,
		     long numberOfScalars, ScalarPtr theScalarData);
long getelementscalars_(FileInfoPtr thisFile, long scalarIndex, 
		     long  *theType, ScalarPtr theScalarData);
long getelementscalartypes_(FileInfoPtr thisFile, long *theTypes);

long setelementvectors_(FileInfoPtr thisFile, long theType,
		     long numberOfVectors, VectorPtr theVectorData);
long getelementvectors_(FileInfoPtr thisFile, long vectorIndex, 
		     long  *theType, VectorPtr theVectorData);
long getelementvectortypes_(FileInfoPtr thisFile, long *theTypes);

long setelementtensors_(FileInfoPtr thisFile, long theType, long theDimension,
		     long numberOfTensors, TensorPtr theTensorData);
long getelementtensors_(FileInfoPtr thisFile, long tensorIndex,
			long *theDimension,
		     long  *theType, TensorPtr theTensorData);
long getelementtensortypes_(FileInfoPtr thisFile, long *theTypes,
			 long *theDimensions);

/* Time Series Routines */

long settimeseriesdatapath_(FileInfoPtr thisFile, char *thePath);
long settimeseriesindex_(FileInfoPtr thisFile, long theIndex);
long gettimeseriesindex_(FileInfoPtr thisFile, long *theIndex);
long settimeseriesfile_(FileInfoPtr thisFile, char *theFile);
long gettimeseriesfile_(FileInfoPtr thisFile, char *theFile);
long settimeseriesgeomfile_(FileInfoPtr thisFile, char *theFile);
long gettimeseriesgeomfile_(FileInfoPtr thisFile, char *theFile);

long settimeseriesspecs_(FileInfoPtr thisFile, long numberOfChannels, 
			 long numberOfFrames);
long gettimeseriesspecs_(FileInfoPtr thisFile, long *numberOfChannels,
			 long *numberOfFrames);
long settimeserieslabel_(FileInfoPtr thisFile, char *theLabel);
long gettimeserieslabel_(FileInfoPtr thisFile, char *theLabel);
long settimeseriesformat_(FileInfoPtr thisFile, long theFormat);
long gettimeseriesformat_(FileInfoPtr thisFile, long *theFormat);
long settimeseriesunits_(FileInfoPtr thisFile, long theUnits);
long gettimeseriesunits_(FileInfoPtr thisFile, long *theUnits);
long settimeseriessurface_(FileInfoPtr thisFile, long theSurface);
long gettimeseriessurface_(FileInfoPtr thisFile, long *theSurface);
long settimeseriesassoc_(FileInfoPtr thisFile, long theAssociation);
long gettimeseriesassoc_(FileInfoPtr thisFile, long *theAssociation);
long settimeseriesdata_(FileInfoPtr thisFile, float *theData);
long gettimeseriesdata_(FileInfoPtr thisFile, float *theData);
long setnumcorrectedleads_(FileInfoPtr thisFile, long numberOfCorrectedLeads);
long getnumcorrectedleads_(FileInfoPtr thisFile, long *numberOfCorrectedLeads);
long setcorrectedleads_(FileInfoPtr thisFile, long *theLeads);
long getcorrectedleads_(FileInfoPtr thisFile, long *theLeads);
long setpowercurve_(FileInfoPtr thisFile, float *powerCurveData);
long getpowercurve_(FileInfoPtr thisFile, float *powerCurveData);
long setqsttimes_(FileInfoPtr thisFile, long qtime, long stime, long ttimes);
long getqsttimes_(FileInfoPtr thisFile, long *qtime, long *stime,
		  long *ttimes);
long checkextendedfiducials_(FileInfoPtr thisFile, CBoolean *available);
long setextendedfiducials_(FileInfoPtr thisFile, long ponset, long poffset,
	    	    	    long rpeak, long tpeak);
long getextendedfiducials_(FileInfoPtr thisFile, long *ponset, long *poffset,
	    	    	    long *rpeak, long *tpeak);
long readpakheader(FileInfoPtr thisFile, PakHeaderPtr aPakHeader);
long readrawheader(FileInfoPtr thisFile, RawHeaderPtr aRawHeader);
int findFileType(FileInfoPtr thisFile, char* fileName);
long findFileSize(FileInfoPtr thisFile, long *numberOfFrames);

/*	File rewrite routines	*/

long initrewrite(void);
long addrewriterequest(rewriteRequestPtr theRequest);
long rewritefile(char *oldFileName, char *newFileName);
rewriteRequestPtr searchList(long theDataType, long whichSurface, 
			     long whichOne);

/* misc routines */

void report(char *message, char *function, long returnValue, 
	    char *optionalString);
off_t	myLseek(int fildes, off_t offset, int whence);
#endif
