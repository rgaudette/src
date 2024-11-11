#pragma once
#include "base2.h"

#include "derived3.h"

class Derived2 :
	public Base2
{
public:
	Derived2(void);
	virtual ~Derived2(void);
	int method2(int param);
private:
	Derived3 d3;
};
