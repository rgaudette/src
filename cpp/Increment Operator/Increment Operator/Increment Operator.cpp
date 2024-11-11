#include <iostream>
using namespace std;

int main(int argc, char * argv[])
{
  static const int IMPULSE_LENGTH = 21;
  int halfImpulseLength = IMPULSE_LENGTH / 2;
  int nCols = 100;
  for (int i = 0; i < halfImpulseLength; ++i)
  {
    cout << "i: " << i <<  "  row index: " << halfImpulseLength - i - 1 << endl;
  }

  cout << endl;
  for (int i = 0, j = nCols + halfImpulseLength; i < halfImpulseLength; i++, j++)
  {
    cout << "i: " << i << "  j: " << j <<  "  row index: " << nCols - i - 1 << endl;
  }
	return 0;
}

