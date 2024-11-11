/** A simple program to check if a huge can handle the data sizes I
  need **/
/** It works! **/

#include <stdlib.h>
#include <malloc.h>
#include <stdio.h>
#include <time.h>

#include <sys/resource.h>
#include <unistd.h>


main(int argc, char *argv[])
{
    char in;
    long  i, szArray;
    float *array1;
    float *array2;
    float *array3;
    struct rlimit rl;
    

    time_t start, stop;
    
    szArray = 2000000;
    
    /**  Check out the USER limits **/
    getrlimit(RLIMIT_DATA, &rl);
    printf("DATA Limit %d\n", rl.rlim_max);

    getrlimit(RLIMIT_RSS, &rl);
    printf("RSS Limit %d\n", rl.rlim_max);

    getrlimit(RLIMIT_STACK, &rl);
    printf("STACK  Limit %d\n", rl.rlim_max);

    start = time(NULL);
    array1 = (float *) calloc(szArray, sizeof(float));
    if(array1 == NULL){
	printf("Unable to allocate array 1\n");
	exit(-1);
    }
    else
      printf("Able to allocate array 1\n");
    

    array2 = (float *) calloc(szArray, sizeof(float));
    if(array2 == NULL){
	printf("Unable to allocate array 2\n");
	exit(-1);
			}
    else
      printf("Able to allocate array 2\n");
    

    array3 = (float *) calloc(szArray, sizeof(float));
         if(array3 == NULL){
	     printf("Unable to allocate array 3\n");
	     exit(-1);
	 }
    
         else
	   printf("Able to allocate array 3\n");

    stop = time(NULL);
    printf("Allocation time %f\n", difftime(start, stop));
    
    printf("Generating random numbers...\n");
    start = time(NULL);
    for (i=0; i<szArray; i++){
	array1[i] = rand();
	array2[i] = rand();
         }
    stop = time(NULL);
    printf("Generation time %f\n", difftime(start, stop));
    
    printf("Multiplying numbers ...\n");
         start = time(NULL);
    for (i=0; i<szArray; i++)
      array3[i] = array1[i] * array2[i];
    
    stop = time(NULL);
    printf("Multiplication time %f\n", difftime(start, stop));
    printf("Done\n");
    
    free(array3);
    free(array2);
    free(array1);
    return 0;
}

         
