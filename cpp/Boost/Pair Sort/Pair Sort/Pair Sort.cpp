// Pair Sort.cpp : Defines the entry point for the console application.
//
#include "stdafx.h"
#include <iostream>
#include <algorithm>
#include <utility>
#include <vector>
using namespace std;
typedef pair<double, int> indexed_value;
bool indexed_value_compare(indexed_value * left, indexed_value * right)
{
  return left->first > right->first;
}
int _tmain(int argc, _TCHAR * argv[])
{
  double offset = 1.0;

  vector<indexed_value *> vec;
  vec.push_back(new indexed_value(fabs(0.0 - offset), 0));
  vec.push_back(new indexed_value(fabs(1.0 - offset), 1));
  vec.push_back(new indexed_value(fabs(2.0 - offset), 2));

  for (vector<indexed_value * >::iterator it = vec.begin(); it != vec.end(); ++it)
  {
    cout << "vec: " << (*it)->first << "  " << (*it)->second << endl;
  }

  std::sort(vec.begin(), vec.end(), indexed_value_compare);

  for (vector<indexed_value * >::iterator it = vec.begin(); it != vec.end(); ++it)
  {
    cout << "svec: " << (*it)->first << "  " << (*it)->second << endl;
  }

  return 0;
}

