#include "stdafx.h"

using namespace std;

struct Point
{
  int x;
  int y;
  Point(int x, int y)
  {
    this->x = x;
    this->y = y;
  }
};


void c_plus_plus_98()
{
  // From C++98
  const int i1(3);   // "direct" initialization
  const int i2 = 4;  // "assignment" initialization
  const int arr1[] = { 1, 2, 3 };  // brace initialization for arrays

  Point p1 = { 10, 11 };  // brace initialization for user defined types (UDT)
  Point p2 = Point(3, 4); // constructor initialization

  // Initializing a vector is ugly and inefficient, first we need to create an array, the call the based
  // constructor
  int init_array[] = { 3, 4, 5 };

  vector<int> v1(init_array, init_array + 3);

  // With member and heap arrays it is not possible to initialize, need to use some assignment code
}

void c_plus_plus_11(void)
{
  // Brace initialization syntax is allowed everywhere
  const int val1 { 5 };
  const int val2 { 5 };
  int a[] {1, 2, val1, val2};
  Point p1 { 10, 20 };
  const Point p2 { 10, 20 };
  // constructs the vector with an std::initializer_list
  const vector<int> cv { a[0], 20, val2 };
  cout << cv.size() << endl;
  
  // again, constructs the vector with an std::initializer_list
  const vector<int> cv2 { 20, val1 };
  cout << cv2.size() << endl;
  
  // constructs the vector via the 2 element constructor
  const vector<int> cv3 (20, val1);
  cout << cv3.size() << endl;
}
int main(int argc, char * argv[])
{
  c_plus_plus_98();
  c_plus_plus_11();
  return 0;
}

