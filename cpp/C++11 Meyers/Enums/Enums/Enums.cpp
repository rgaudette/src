// C++11 enums

#include "stdafx.h"

using namespace std;


template <typename T1, typename T2>
void compare_enums(T1 enum1, T2 enum2)
{
  if (enum1 == enum2)
  {
    cout << "enum1 and enum2 are equal" << endl;
  }
  else
  {
    cout << "enum1 and enum2 are not equal" << endl;
  }
}


//template <typename Enumeration>
//auto as_integer(Enumeration const value) -> typename std::underlying_type<Enumeration>::type
//{
//  return static_cast<typename std::underlying_type<Enumeration>::type>(value);
//}

// Pulled this out of main because when it is main the type is decorated by main and some additional text
enum class StrongShape : unsigned int { Square, Circle, Triangle };

// A simpler version if we don't need to templatize the function
underlying_type<StrongShape>::type as_integer(StrongShape value)
{
  return static_cast<underlying_type<StrongShape>::type>(value);
}


int main(int argc, char * argv[])
{
  // Can now specify the underlying type
  enum Shape : unsigned int {Square, Circle, Triangle};

  Shape shape_1 = Circle;
  printf("Shape typeid: %s  value: %u\n", typeid(shape_1).name());
  cout << "shape_1 value: " << shape_1 << endl;

  enum Color {Red, Blue, Green};
  Color color = Red;
  printf("Color typeid: %s\n", typeid(color).name());
  cout << "color value: " << color << endl;

  Shape shape_2 = Square;
  cout << "shape_2 value: " << shape_2 << endl;

  cout << "comparing shape_1 and shape_2 ... ";
  compare_enums(shape_1, shape_2);

  Shape shape_3 = Square;
  cout << "shape_3 value: " << shape_3 << endl;

  cout << "comparing shape_2 and shape_3 ... ";
  compare_enums(shape_2, shape_3);

  // even though shape_2 and color are different types they compare equal
  cout << "comparing shape_2 and color ... ";
  compare_enums(shape_2, color);

  // Strongly type shapes provide more careful control of comparisons
  //enum class StrongShape : unsigned int { Square, Circle, Triangle };
  StrongShape strong_shape_1 = StrongShape::Triangle;

  printf("StrongShape typeid: %s  value: %u\n", typeid(strong_shape_1).name());

  // Need to explicitly convert
  cout << "strong_shape_1 value: " << as_integer(strong_shape_1) << endl;

  // This produces a compile time error because the template instantiation results in a comparison of a Shape with a
  // StrongShape
  //compare_enums(shape_2, strong_shape_1);

}
