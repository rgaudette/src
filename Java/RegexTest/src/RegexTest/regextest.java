package regextest;

/**
 * <p>Title: Title  goes here</p>
 * <p>Description: Description goes here</p>
 * <p>Copyright: Copyright (c) 2002</p>
 * <p>Company: Boulder Laboratory for 3D Fine Structure</p>
 * @author Rick Gaudette
 * @version 1.0
 */

public class regextest {

  public regextest() {
  }
  public static void main(String[] args) {
    String testString = "adbcd word2     word3 123";

    if(testString.matches("^ad.")) {
      System.out.println("true");
    }
    else {
      System.out.println("false");
    }

    //  White space testing
    testString = "";
    
    System.out.print("Empty string matches \\s*: ");
    if(testString.matches("\\s*")) {
      System.out.println("true");
    }
    else {
      System.out.println("false");
    }

    testString = " ";
    
    System.out.print("one blank matches \\s*: ");
    if(testString.matches("\\s*")) {
      System.out.println("true");
    }
    else {
      System.out.println("false");
    }


    testString = "   ";
    
    System.out.print("multiple blanks matches \\s*: ");
    if(testString.matches("\\s*")) {
      System.out.println("true");
    }
    else {
      System.out.println("false");
    }

    testString = "as   ";
    
    System.out.print("chars followed by multiple blanks matches \\s*: ");
    if(testString.matches("\\s*")) {
      System.out.println("true");
    }
    else {
      System.out.println("false");
    }

    testString = "   fg";
    
    System.out.print("multiple blanks followed by chars matches \\s*: ");
    if(testString.matches("\\s*")) {
      System.out.println("true");
    }
    else {
      System.out.println("false");
    }

  }
}