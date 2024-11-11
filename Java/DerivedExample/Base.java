//package argoex;

public class Base {
  

  public int attrib1 = 0;
  float attrib2 = 0.0F;
  String baseString = "Base String";

  //
  //  Default constructor
  //
  public Base() {
    System.out.println("In base class constructor");
  }

  public void method1(int value) {
    attrib1 = value;
    attrib2 = value;
  }
}
