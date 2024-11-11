// Time.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"

using namespace std;

int _tmain(int argc, _TCHAR* argv[])
{
  __time64_t ltime;
  _time64( &ltime );
  std::cout << "Current time: " << ltime << endl;

  bool ret_val;
  LARGE_INTEGER frequency;
  ret_val = QueryPerformanceFrequency(& frequency);
  if (ret_val)
    cout << "Performance frequency: " << frequency.QuadPart << endl;
  else
    cout << "QueryPerformanceFrequency failed" << endl;

  LARGE_INTEGER start;
  ret_val = QueryPerformanceCounter(& start);
  if (ret_val)
    cout << "Performance counter: " << start.QuadPart << endl;
  else
    cout << "QueryPerformanceCounter failed" << endl;

  Sleep(1000);

  LARGE_INTEGER stop;
  ret_val = QueryPerformanceCounter(& stop);
  if (ret_val)
    cout << "Performance counter: " << stop.QuadPart << endl;
  else
    cout << "QueryPerformanceCounter failed" << endl;
  
  long period = stop.QuadPart - start.QuadPart;
  cout << "QPC period: " << period << endl;

  double period_secs = static_cast<double>(period) / frequency.QuadPart;
  cout << "Period (secs): " << period_secs << endl;

  _time64( &ltime );
  cout << "Current time: " << ltime << endl;
	return 0;
}

