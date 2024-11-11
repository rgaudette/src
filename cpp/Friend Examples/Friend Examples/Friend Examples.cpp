// Friend Examples.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include "pch.h"
#include <iostream>

using namespace std;

class AClass
{
  private:
    int attribute_1;
    int n_elements;
    float * array_1;
    bool owns_memory;

    AClass()
    {
      attribute_1 = 42;
      n_elements = 0;
      array_1 = nullptr;
      bool owns_memory = true;
    }

  public:
    AClass(int attribute_1, int n_elements, float initial_value) : attribute_1(attribute_1), n_elements(n_elements)
    {
      array_1 = new float[n_elements];
      owns_memory = true;
      for (int idx = 0; idx < n_elements; ++idx)
      {
        array_1[idx] = initial_value;
      }
    }

    ~AClass()
    {
      if (owns_memory)
      {
        delete[] array_1;
      }
    }

    // Borrow the vector from another instance of this class
    void borrow(AClass const & lender)
    {
      if (owns_memory)
      {
        delete[] array_1;
      }
      owns_memory = false;
      n_elements = lender.n_elements;
      array_1 = lender.array_1;
    }

    friend ostream & operator << (std::ostream & stream, AClass const & a_class);
};


ostream & operator << (std::ostream & stream, AClass const & a_class)
{
  stream << "attribute_1: " << a_class.attribute_1 << "  address: " << &a_class.attribute_1 << endl;
  stream << "n_elements: " << a_class.n_elements << "  address: " << &a_class.n_elements << endl;
  stream << "vector: ";
  for (int idx = 0; idx < a_class.n_elements; ++idx)
  {
    stream << a_class.array_1[idx] << " ";
  }
  stream << endl;
  stream << "vector address: " << &a_class.array_1 << endl;
  return stream;
};



int main()
{
  AClass object_1(1, 3, 23.0F);
  cout << object_1 << endl;

  AClass object_2(2, 4, 12.0F);
  cout << object_2 << endl;

  object_2.borrow(object_1);
  cout << object_2 << endl;
}

