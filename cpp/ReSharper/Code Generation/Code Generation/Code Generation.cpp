#include <vector>

template <typename T>
class InlineClass
{
public:
  InlineClass(int a, float b, const T& v, const std::vector<T>& vt)
    : a(a),
      b(b),
      v(v),
      vt(vt)
  {
  }

  InlineClass(const InlineClass& other)
    : a(other.a),
      b(other.b),
      v(other.v),
      vt(other.vt)
  {
  }

  InlineClass(InlineClass&& other) noexcept
    : a(other.a),
      b(other.b),
      v(std::move(other.v)),
      vt(std::move(other.vt))
  {
  }

  InlineClass& operator=(const InlineClass& other)
  {
    if (this == &other)
      return *this;
    a = other.a;
    b = other.b;
    v = other.v;
    vt = other.vt;
    return *this;
  }

  InlineClass& operator=(InlineClass&& other) noexcept
  {
    if (this == &other)
      return *this;
    a = other.a;
    b = other.b;
    v = std::move(other.v);
    vt = std::move(other.vt);
    return *this;
  }

private:
  int a;
  float b;

  T v;
  std::vector<T> vt;

};


int main()
{
    return 0;
}

