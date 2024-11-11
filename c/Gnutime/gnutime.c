#include <time.h>
#include <sys/time.h>
#include <unistd.h>

int main(int argc, char * argv[]) {

  struct timeval tv1, tv2;

  gettimeofday(&tv1, NULL);
  sleep(1);
  gettimeofday(&tv2, NULL);

  printf("T1:%u\t%u\n", tv1.tv_sec, tv1.tv_usec);
  printf("T2:%u\t%u\n", tv2.tv_sec, tv2.tv_usec);

  printf("Difference %f\n", tv2.tv_sec - tv1.tv_sec + (tv2.tv_usec - tv1.tv_usec) * 1E-6);


}
