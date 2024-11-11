/**
 * Created: 2/2/13 8:01 PM
 *
 * @author rick
 * @version %I%, %G%
 * @since X.XX
 */
public class StackPrintingExample
{
  public static void main(String[] args)
  {
    func_1();
  }
  static void func_1()
  {
    func_2();
  }
  static void func_2()
  {
    func_3();
  }
  static void func_3()
  {
    Object obj = null;
    obj.getClass();
  }

}
