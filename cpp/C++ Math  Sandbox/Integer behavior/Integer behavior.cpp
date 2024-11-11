// Integer behavior.cpp : Defines the entry point for the console application.
//
#include <iostream>

using namespace std;

int main(int argc, char * argv[])
{
  int a = 1 << 30;
  int b = 2;
  int c = a * b;

  cout << "int bytes: " << sizeof(int) << endl;
  cout << "a: " << a << endl;
  cout << "b: " << b << endl;
  cout << "c = a * b: " << c << endl;

  size_t d = (1 << 31) + 20;
  size_t e = 2;
  size_t f = d * e;
  
  cout << "size_t bytes: " << sizeof(size_t) << endl;
  cout << "d: " << d << endl;
  cout << "e: " << e << endl;
  cout << "f = d * e: " << f << endl;

  unsigned char g = 175;
  unsigned char h = 2;
  unsigned char i = g * h;

  cout << "unsigned char bytes: " << sizeof(unsigned char) << endl;
  cout << "g: " << (int) g << endl;
  cout << "h: " << (int) h << endl;
  cout << "i = g * h: " << (int) i << endl;

  return 0;
}

