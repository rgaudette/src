#include <memory>
#include <vector>

struct MyType {
  int int_attr;
  float float_attr;
};

int main(int argc, char* argv[])
{
  std::auto_ptr<MyType> aptr(new MyType);
  
  std::vector<MyType * > vec_pMyTypes;

  vec_pMyTypes.push_back(new MyType);
  vec_pMyTypes.push_back(new MyType);
  // This compiles but probably shouldn't
  std::vector<std::auto_ptr<MyType> > vec_aptr;
  

  return 0;
}

