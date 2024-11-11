// Exploration of the auto keyword
//

#include "stdafx.h"

using namespace std;

int main(int argc, char * argv[])
{
  // could use auto here as well
  int i = 1;
  auto j = i;
  auto & k = i;
  auto * l = & i;
  // auto & m = 2;  This does not work because we can not convert the rvalue to into a lvalue need for the reference
  //                as there is nothing to refer to
  auto && n = 2;    // This does work because && allows for an rvalue


  cout << "i is a: " << typeid(i).name() << "  value: " << i << "  location: " << & i << endl;
  cout << "j is a: " << typeid(j).name() << "  value: " << j << "  location: " << & j << endl;
  cout << "k is a: " << typeid(k).name() << "  value: " << k << "  location: " << & k << endl;
  cout << "l is a: " << typeid(l).name() << "  value: " << l << "  location: " << & l << endl;
  cout << "n is a: " << typeid(n).name() << "  value: " << n << "  location: " << & n << endl;

  vector<float> v1;
  auto & v1r = v1;
  v1.push_back(2.0f);
  auto v1_iter = v1.begin();
  auto & v1_iter_ref = v1.begin();
  auto & v1_citer = v1.cbegin();
  auto & v1_citer_ref = v1.cbegin();

  cout << "v1 is a: " << typeid(v1).name() << "  value: " << v1[0] << "  location: " << & v1r << endl;
  cout << "v1r is a: " << typeid(v1r).name() << "  value: " << v1r[0] << "  location: " << & v1r << endl;
  cout << "v1_iter is a: " << typeid(v1_iter).name() << "  value: " << * v1_iter << "  location: " 
    << & v1_iter << endl;
  cout << "v1_iter_ref is a: " << typeid(v1_iter_ref).name() << "  value: " << * v1_iter_ref << "  location: " 
    << &v1_iter_ref << endl;
  cout << "v1_citer is a: " << typeid(v1_citer).name() << "  value: " << * v1_citer << "  location: " 
    << &v1_citer << endl;

  printf("v1_citer_ref is a: %s  value: %f  location: %p", typeid(v1r).name(), *v1_citer_ref, &v1_citer_ref);

  float arr[10];
  auto arr1 = arr;
  cout << "arr is a :" << typeid(arr).name() << "  value : " << arr << "  location: " << &arr << endl;
  cout << "arr1 is a :" << typeid(arr1).name() << "  value : " << arr1 << "  location: " << &arr1 << endl;

  return 0;
}

