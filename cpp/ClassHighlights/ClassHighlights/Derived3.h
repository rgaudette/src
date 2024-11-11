#pragma once
#include "base3.h"

class Derived3 :
	public Base3
{
public:
	Derived3(void);
	virtual ~Derived3(void);
	// method 3
	int method3(int arg1);
};
