#include <iostream>
#include <vector>
#include <boost/array.hpp>

using namespace std;

int main(int argc, char * argv[])
{
  vector<double> vec;
  vec.push_back(1.0);
  vec.push_back(2.0);
  vec.push_back(3.0);
  boost::array<double, 3> arr = { 1.0, 2.0, 3.0 };
  for (unsigned i = 0; i < arr.size(); i++)
  {
    cout << arr[i] << " " << endl;
  }
	return 0;
}

