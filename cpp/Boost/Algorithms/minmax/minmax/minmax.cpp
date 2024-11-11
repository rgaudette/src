// minmax.cpp : Defines the entry point for the console application.
//

#include<utility>

#include "boost/algorithm/minmax.hpp"
#include <iostream>


int main()
{
  int a = 1;
  int b = 2;
  std::pair<int, int> p1 = boost::minmax(b, a);
  std::cout << p1.first << "," << p1.second << std::endl;

    return 0;
}

