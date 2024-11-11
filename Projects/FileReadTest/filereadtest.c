#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <asm/fcntl.h>

extern int errno;
#define __USE_LARGEFILE64

int main(int argc, char *argv[]) {
  FILE *file;
  int nBytesPerRead;
  int fd;
  char *cBuffer;

  if(argc < 3) {
    fprintf(stderr, "Usage: %s fileToRead bufferSize\n", argv[0]);
    exit(-1);
  }

  //  Open the file using the system call
  fd = open64(argv[1], O_RDONLY);
  if(fd == -1) {
    perror("opening file");
    fprintf(stderr, "Can not open fd for %s\n", argv[1]);
    exit(-1);
  }

  nBytesPerRead = atoi(argv[2]);
  if(nBytesPerRead < 1) {
    fprintf(stderr, "Need to read more than 0 bytes per read: %s\n", argv[2]);
    exit(-1);
  }
  
  cBuffer = (char *) calloc(nBytesPerRead, sizeof(char));
  if(cBuffer == NULL) {
    fprintf(stderr, "Can't allocate buffer memory!\n");
    exit(-1);
  }

  while(read(fd, cBuffer, nBytesPerRead) == nBytesPerRead) {
  }
}
