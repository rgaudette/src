/**
 * Created by IntelliJ IDEA.
 * User: rick
 * Date: 2/8/12
 * Time: 11:46 AM
 * To change this template use File | Settings | File Templates.
 */
public class MyMain
{
  public static void main(final String[] args)
  {
    String a = "1234";
    String b = a;
    Object c = a;
    System.out.println(Integer.toHexString(System.identityHashCode(c)));
    System.out.println(Integer.toString(System.identityHashCode(c)));
  }
}
