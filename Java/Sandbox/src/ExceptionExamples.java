/**
 * Created: 1/24/13 2:09 PM
 *
 * @author rick
 * @version %I%, %G%
 * @since X.XX
 */
public class ExceptionExamples
{
  public static void main(String[] args)
  {
    try {
      System.out.println("in try");
      Object my_null = null;
      System.out.println(my_null.toString());
    }
    finally {
      System.out.println("in finally");
    }
  }
}
