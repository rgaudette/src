#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[]) {
  int i;
  int l1;
  int l2;

  initialize_();

  for(i = 0; i < argc; i++) {
    l1 = strlen(argv[i]);
    l2 = strlen(argv[i]);
    addargument_(argv[i], &l1,argv[1], &l2);
  }

  return 0;
}
