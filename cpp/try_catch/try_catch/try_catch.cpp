#include <exception>
#include <iostream>

void throw_exception_base()
{
  throw std::exception("a base exception");
}

// Let the exception pass up the call stack
void call_throw_exception_base()
{
  std::cerr << "calling throw_exception_base" << std::endl;
  throw_exception_base();
}


int main()
{
  try
  {
    throw_exception_base();
  }
  catch (std::exception & exception)
  {
     std::cerr << "in main: " << exception.what() << std::endl;
  }

  try
  {
    call_throw_exception_base();
  }
  catch (std::exception & exception)
  {
    std::cerr << exception.what() << std::endl;
  }

  return 0;
}

