#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <asm/fcntl.h>

extern int errno;
#define __USE_LARGEFILE64

int main(int argc, char *argv[]) {
  FILE *file;
  int nBytesPerRead, bytesRead;
  int fd, i;
  int retVal;
  char *cBuffer;


  if(argc < 3) {
    fprintf(stderr, "Usage: %s fileToRead bufferSize\n", argv[0]);
    exit(-1);
  }

  //  Open the file using the system call to use O_DIRECT
  fd = open64(argv[1], O_RDONLY | O_DIRECT);
  if(fd == -1) {
    perror("opening file");
    fprintf(stderr, "Can not open fd for %s\n", argv[1]);
    exit(-1);
  }
  else {
    printf("File opened on descriptor: %d\n", fd);
  }
  
  /*  retVal = fcntl(fd, F_SETFL, O_DIRECT);
  if(retVal != 0) {
    perror("Setting O_DIRECT");
    exit(-1);
  }
  */
  nBytesPerRead = atoi(argv[2]);
  if(nBytesPerRead < 1) {
    fprintf(stderr, "Need to read more than 0 bytes per read: %s\n", argv[2]);
    exit(-1);
  }
  else {
    printf("Bytes per read %d\n", nBytesPerRead);
  }
  
  cBuffer = (char *) calloc(nBytesPerRead+4096, sizeof(char));
  if(cBuffer == NULL) {
    fprintf(stderr, "Can't allocate buffer memory!\n");
    exit(-1);
  }
  else {
    fprintf(stdout, "Allocated memory at %p\n", cBuffer);
  }

  /* 
   * Align the usable part of the buffer to 4096 byte boundary
   * it might be smalled for ext3 filesystems.
   */
  cBuffer = (char *)((((long)cBuffer + (long) 4096))& ~(((long)4095-1)));
  fprintf(stdout, "Using memory at %p\n", cBuffer);
  while((bytesRead = read(fd, cBuffer, nBytesPerRead)) == nBytesPerRead) {
  }
  if(bytesRead != 0) {
    perror("Reading file");
  }

}
