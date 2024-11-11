#include "Derived1.h"

#include <iostream>

using namespace std;
Derived1::Derived1(void)
{
}

Derived1::~Derived1(void)
{
}

// Another method
int Derived1::method1(int param)
{
	cout << "I'm in Derived1::method1" << endl;
	cout << "param: " << param << endl;
	d2.method2(1);
	return 0;
}
