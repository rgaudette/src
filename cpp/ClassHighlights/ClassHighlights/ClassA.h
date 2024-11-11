#pragma once
#include "classb.h"

class ClassA
{
public:
	ClassA(void);
	~ClassA(void);
	ClassB inst_b;
	int a_method(int param);
};
