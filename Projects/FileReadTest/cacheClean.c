#include <stdio.h>

#include <stdlib.h>

int main(int argc, char *argv[]) {
  int * array;
  size_t nMBytes;
  size_t block = 1048576;
  int i = 0;

  if(argc< 2) {
    fprintf(stderr, "%s mBytes\n", argv[0]);
  }

  printf("Block size %d\n", block);

  nMBytes = strtol(argv[1], (char **)NULL, 10);
  printf("Allocating %d blocks\n", nMBytes);

  array = (int *) calloc(nMBytes, block);

  printf("memory address %p\n", array);

  if(array == NULL) {
    fprintf(stderr, "Unable to allocate memory\n");
  }


  //  Each read is 4 bytes
  while(i < nMBytes * block/4) {
    array[i] = 0;
    i++;
  }
}
