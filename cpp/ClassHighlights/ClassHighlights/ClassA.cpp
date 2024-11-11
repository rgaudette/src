#include "ClassA.h"

ClassA::ClassA(void)
{
}

ClassA::~ClassA(void)
{
}

int ClassA::a_method(int param)
{
	inst_b.b_method(param);

	return 0;
}
