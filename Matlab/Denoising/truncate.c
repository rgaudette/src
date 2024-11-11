// Compile with:
// -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE
#include <unistd.h>
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

int main(int argc, char *argv[]) {
  
  long long int length;

  fprintf(stderr, "%d bytes\n", sizeof(length));
  if(argc < 3) {
    fprintf(stderr, "truncate file length\n");
    exit(-1);
  }

  length = strtoll(argv[2], NULL, 10);

  if(truncate(argv[1], length)) {
    perror("truncate");
  }

}

