#include <boost/range/combine.hpp>
#include <boost/foreach.hpp>
#include <iostream>
#include <vector>
#include <list>
#include <tuple>

int main(int, const char*[])
{
  std::vector<int> const v{0,1,2,3,4};
  std::list<char> const  l{'a', 'b', 'c', 'd', 'e'};

  // Boost version
//  int ti;
//  char tc;
//  BOOST_FOREACH(boost::tie(ti, tc), boost::combine(v, l))
//  {
//    std::cout << '(' << ti << ',' << tc << ')' << '\n';
//  }

  // C++11 ... doesn't compile
  for (auto const&& i : boost::combine(v, l))
  {
    int ti;
    char tc;
    std::tie(ti, tc) = i;
    std::cout << '(' << ti << ',' << tc << ')' << '\n';
  }

  // C++17? ... doesn't compile
//  for (auto const&[ti, tc] : boost::combine(v, l)) {
//    std::cout << '(' << ti << ',' << tv << ')' << '\n';
//  }

  return 0;
}

