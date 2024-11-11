#include <iostream>
using namespace std;

void access_null()
{
  int * ptr = 0;
  cout << "read 0 " << * ptr << endl;
  cout << "write 0 " << endl;

}
int write_past_a()
{
  int a[10];
  cout << "a: " << a << endl;
  int last = 11;
  for (int i = 0; i < last; i++)
  {
    a[i] = i;
    cout << i << endl;
  }
  cout << "write array" << endl;

  int sum = 0;
  for (int i = 0; i < last; i++)
  {
    if (i % 2)
      sum += a[i];
    else
      sum -= a[i];
  }
  return sum;
}


int main(int argc, char* argv[])
{

  access_null();

  int res = write_past_a();
  cout << "res: " << res << endl;

  int b[10];
  int * y = new int[10];
  int * z = new int[10];

  cout << "b: " << b << endl;
  cout << "y: " << y << endl;
  cout << "z: " << z << endl;

  for (int i = 0; i < 11; i++)
  {
    b[i] = 1;
  }

  for (int i = 0; i < 11; i++)
  {
    y[i] = 1;
  }

  for (int i = 0; i < 11; i++)
  {
    z[i] = 1;
  }

  return 0;
}
