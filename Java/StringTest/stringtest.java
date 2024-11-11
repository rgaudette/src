


public class stringtest {

  public stringtest() {
  }

  static void main(String[] args) {
    String testString = "testString";
    System.out.println(testString);
    modify(testString);
    System.out.println(testString);    
  }

  static void modify(String stringref) {
    System.out.println(stringref);
    stringref = "modified";
    System.out.println(stringref);
  }
}
