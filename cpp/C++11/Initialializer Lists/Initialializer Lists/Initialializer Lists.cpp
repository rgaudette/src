#include <iostream>
#include <vector>

struct ANewClass
{
  int an_int;
  float a_float;
};



int main(int argc, char * argv[])
{
  using namespace std;
  ANewClass a_new_clas = { 1, 2.0 };

  vector<float> fvec = { 1.0, 2.0, 3.0 };
  cout << fvec.size() << endl;
  cout << fvec.capacity() << endl;
	return 0;
}

