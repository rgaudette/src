/**
 * Created: 2/1/13 2:56 PM
 *
 * @author rick
 * @version %I%, %G%
 * @since X.XX
 */
public class StaticMembers
{
  static String str1;
  static String str2 = "initialized";

  static
  {
    System.out.println("starting static block");
    System.out.println("str1: " + str1);
    System.out.println("str2: " + str2);

    str1 = "initialized 1";

    System.out.println("str1: " + str1);
    System.out.println("str2: " + str2);

  }

  public StaticMembers()
  {
    System.out.println("Starting constructor");
    System.out.println("str1: " + str1);
    System.out.println("str2: " + str2);

    str1 = "initialized 2";

    System.out.println("str1: " + str1);
    System.out.println("str2: " + str2);

  }

  public static void static_func1()
  {
    System.out.println("static_func1: this doesn't read any variable");
  }

  public static void static_func2()
  {
    System.out.println("static_func2: this does read members");
    System.out.println("str1: " + str1);
    System.out.println("str2: " + str2);

  }

}
