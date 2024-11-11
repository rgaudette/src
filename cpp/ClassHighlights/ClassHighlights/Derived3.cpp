#include "Derived3.h"

#include <iostream>

using namespace std;
Derived3::Derived3(void)
{
}

Derived3::~Derived3(void)
{
}

// method 3
int Derived3::method3(int arg1)
{
	cout << "I'm in Derived3::method3" << endl;
	return 0;
}
