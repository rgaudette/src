#include "tbb/tbb.h"

using namespace tbb;

void Foo(float & val, float const & scale)
{
  val *= scale;
}

void SerialApplyFoo(float a[], size_t n, float const & scale)
{

  for (size_t i = 0; i != n; ++i)
    Foo(a[i], scale);
}

class ApplyFoo
{
    float * const my_a;
    float  my_scale;

  public:
    void operator()(const blocked_range<size_t> & r, float const & scale) const
    {
      float * a = my_a;
      for (size_t i = r.begin(); i != r.end(); ++i)
      {
        Foo(a[i], scale);
      }

    }


    ApplyFoo(float a[], scale) :
      my_a(a), my_scale)
    {}
};


void ParallelApplyFoo(float a[], size_t n)
{
  parallel_for(blocked_range<size_t>(0, n), ApplyFoo(a));
}



int main()
{
  int N_ELEMENTS = 1024 * 1024 * 1024;
  float * a = new float[N_ELEMENTS];

  ParallelApplyFoo(a, N_ELEMENTS);
  return 0;
}

