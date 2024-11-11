#include "mkl.h"

int main(int argc, char * argv[])
{
  float * v1 = new float[128];
  float * v2 = new float[128];
	float * vT = new float[128];
  vsAdd(128, v1, v2, vT);
  return 0;
}

