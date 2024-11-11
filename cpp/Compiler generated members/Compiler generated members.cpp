#include <iostream>

using namespace std;

struct SimplePods
{
  int int_attr;
  float float_attr;

  SimplePods(int int_attr, float float_attr) : int_attr(int_attr), float_attr(float_attr) { }
  
};

int main(int argc, char* argv[])
{
  SimplePods sp1(1, 3.0F);
  SimplePods sp2 = sp1;
  SimplePods sp3(2, 4.0F);
  sp3 = sp3;
  cout << "int: " << sp1.int_attr << " float: " << sp1.float_attr << endl;
  cout << "int: " << & sp1.int_attr << " float: " << & sp1.float_attr << endl;
  cout << "int: " << sp2.int_attr << " float: " << sp2.float_attr << endl;
  cout << "int: " << & sp2.int_attr << " float: " << & sp2.float_attr << endl;
  cout << "int: " << sp3.int_attr << " float: " << sp3.float_attr << endl;
  cout << "int: " << & sp3.int_attr << " float: " << & sp3.float_attr << endl;

  return 0;
}

