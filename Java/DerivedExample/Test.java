//
//  Test class for the Derived and Base objects
//
public class test {
  static Derived myDerived;

  //
  //  main function
  //
  public static void main(String args[]) {
    myDerived = new Derived();  
    myDerived.showAllValues();
    myDerived.method1(1);
    myDerived.showAllValues();
    myDerived.method2(2);
    myDerived.showAllValues();
  }
}
