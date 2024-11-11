#include <sys/time.h>
#include <sys/resource.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char*argv[]) {
  int nMBytes;
  int nBytes;
  struct rlimit limit;
  void * block1, * block2;
  char string[] = "buffer";

  getrlimit(RLIMIT_AS, &limit);
  printf("Maximum virtual memory %d\n", limit.rlim_max);

  nMBytes = strtol(argv[1], (char **)NULL, 10);
  printf("Attempting to allocate %d MBytes\n", nMBytes);

  
  block1 = calloc(nMBytes, 1024*1024);
  if(block1 != NULL) {
    printf("First block succeeded\n");
  }
  else {
  }

  block2 = calloc(nMBytes, 1024*1024);
  if(block2 != NULL) {
    printf("Second block succeeded\n");
  }

  if(block1 == NULL) {
    printf("malloc failed\n");
    perror("");
  }
  else {
    printf("malloc succeded\n");
    printf("Hit enter to end");
    scanf("%s", string);
    free(block1);
  }

  if(block2 == NULL) {
    printf("malloc failed\n");
    perror("");
  }
  else {
    printf("malloc succeded\n");
    printf("Hit enter to end");
    scanf("%s", string);
    free(block2);
  }


}
