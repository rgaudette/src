// Macro Example.cpp : Defines the entry point for the console application.
//
#include <iostream>

//#define USE_MAC
#ifdef USE_MAC
#define INIT_CNT(counter) counter = 0
#define INCR_CNT(counter, increment) (counter) += (increment)
#define DISPLAY_CNT(counter, name) 
#else
#define INIT_CNT(...)
#define INCR_CNT(...)
#define DISPLAY_CNT(...)

#endif

int main(int argc, char * argv[])
{
  using namespace std;
	int counter;
  INIT_CNT(counter);
  INCR_CNT(counter, 2);
  cout << "counter: " << counter << endl;
  INCR_CNT(counter, 2);
  cout << "counter: " << counter << endl;
  return 0;
}

