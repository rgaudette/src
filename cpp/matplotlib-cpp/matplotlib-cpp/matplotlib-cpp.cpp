// matplotlib-cpp.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <vector>
#include "matplotlibcpp.h"
namespace plt = matplotlibcpp;
int main() {
  std::vector<int> v{1,2,3,4};

  plt::plot(v);
  plt::show();
}

