#include <stdio.h>

main() {

#ifdef __i386__
    printf("__i386__ is defined\n");
#else
    printf("__i386__ is NOT defined\n");
#endif
}
