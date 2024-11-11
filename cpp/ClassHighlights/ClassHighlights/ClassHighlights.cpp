// ClassHighlights.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "derived1.h"
#include "classa.h"

int _tmain(int argc, _TCHAR* argv[])
{
	ClassA ca;
	ca.a_method(2);

	Derived1 d1;
	d1.method1(0);
	return 0;
}

