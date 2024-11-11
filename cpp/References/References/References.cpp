// References.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"


int _tmain(int argc, _TCHAR* argv[])
{
  int a = 1;
  int b = 2;
  bool refa = false;
  int & ref = a;
  if (refa)
  {
    ref = a;
  }
  else
  {
    ref = b;
  }

  printf("ref: %d\n", ref);
	return 0;
}

