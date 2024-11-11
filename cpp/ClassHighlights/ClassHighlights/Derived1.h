#pragma once
#include "derived2.h"
#include "base1.h"

class Derived1 :
	public Base1
{
public:
	Derived1(void);
	virtual ~Derived1(void);
	// Another method
	int method1(int param2);

private:
	Derived2 d2;
};
