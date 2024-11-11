#include <time.h>
#include <sys/times.h>
#include <unistd.h>

int main(int argc, char * argv[]) {

  clock_t  t1, t2;
  struct tms tms1, tms2;

  times(&tms1);
  printf("User %x\n", tms1.tms_utime);
  printf("System %x\n", tms1.tms_stime);


  t1 = clock();
  sleep(1);
  t2 = clock();

  printf("T1:%u\n", t1);
  printf("T2:%u\n", t2);
  times(&tms1);
  printf("User %x\n", tms1.tms_utime);
  printf("System %x\n", tms1.tms_stime);

}
