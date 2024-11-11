package arraytest;
import java.util.LinkedList;
/**
 * <p>Title: Title  goes here</p>
 * <p>Description: Description goes here</p>
 * <p>Copyright: Copyright (c) 2002</p>
 * <p>Company: Boulder Laboratory for 3D Fine Structure</p>
 * @author $Author$
 * @version $Revision$
 */

public class arraytest {
  public static void main(String[] args) {
    String[] strArray = new String[0];
    System.out.println(strArray.length);
    String nothing = null;
    System.out.println(nothing);
    LinkedList linkedlist = new LinkedList();
    String[] inputArgs =
      new String[linkedlist.size()];
    System.out.println(inputArgs.length);


  }
}