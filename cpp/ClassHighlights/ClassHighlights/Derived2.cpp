#include "Derived2.h"

#include <iostream>
using namespace std;
Derived2::Derived2(void)
{
}

Derived2::~Derived2(void)
{
}
int Derived2::method2(int param)
{
	cout << "I'm in Derived2::method2" << endl;
	//cout << "Hit return to continue" << endl;
	//char carr[1024];

	//cin.getline(&carr[0], 1023);
	d3.method3(param);
	return 0;
}
