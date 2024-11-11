//package argoex;
import java.io.*;

public class Derived extends Base {

  int attrib3;
  float attrib4;

  String derivedString = "Derived String";

  //  Contained myContained = new Contained();

  //
  //  Default constructor
  //
  public Derived() {
    System.out.println("In derived class constructor");
  }

  //
  //  set the Base attributes
  //
  public void method2(int value) {
    attrib1 = value;
    attrib2 = value;
  }

  //
  //  Display the attributes
  //
  public void showAllValues() {
    System.out.println("attrib1: " + String.valueOf(attrib1));
    System.out.println("attrib2: " + String.valueOf(attrib2));
    System.out.println("attrib3: " + String.valueOf(attrib3));
    System.out.println("attrib4: " + String.valueOf(attrib4));
  }
}
