
int main(int argc, char* argv[])
{
  const int SIZE = 1024;
  double * vec1;
  vec1 = new double[SIZE];

  double * vec2;
  vec2 = new double[SIZE];

  double *sum;
  sum = new double[SIZE];

  for (int i = 0; i < SIZE; i++)
  {
    sum[i] = vec1[i] + vec2[i];
  }
}

