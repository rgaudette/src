#include <stdio.h>
#include <string.h>

void parse_(char *string, int *length, char *ret, int *nRet) {
  int i;
  char *done = "Done";

  for(i = 0; i < *length; i++){
    printf("%c", string[i]);
  }
  printf("\n");
  
  memcpy(ret, done, strlen(done));
  // Fill the remaining part of the fortran string with blanks
  for(i = strlen(done); i < *nRet; i++) {
    ret[i] = ' ';
  }

}
