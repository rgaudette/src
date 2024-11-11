#pragma once

#include <vector>

template <typename T>
class AClass
{
  T value;
  std::vector<T> vec;


public:

  AClass()
  {
  }

  AClass(const T& value, const std::vector<T>& vec)
    : value(value),
      vec(vec)
  {
  }


  AClass(const AClass& other)
    : value(other.value),
      vec(other.vec)
  {
  }

  AClass(AClass&& other) noexcept
    : value(std::move(other.value)),
      vec(std::move(other.vec))
  {
  }

  AClass& operator=(const AClass& other)
  {
    if (this == &other)
      return *this;
    value = other.value;
    vec = other.vec;
    return *this;
  }

  AClass& operator=(AClass&& other) noexcept
  {
    if (this == &other)
      return *this;
    value = std::move(other.value);
    vec = std::move(other.vec);
    return *this;
  }

  T get_value() const
  {
    return value;
  }

  void set_value(const T& value)
  {
    this->value = value;
  }

  std::vector<T> get_vec() const
  {
    return vec;
  }

  void set_vec(const std::vector<T>& vec)
  {
    this->vec = vec;
  }
};