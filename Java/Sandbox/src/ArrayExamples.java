/**
 * Created: 6/18/13 2:35 PM
 *
 * @author rick
 * @version %I%, %G%
 * @since X.XX
 */
public class ArrayExamples
{

  public static void main(String[] args)
  {
    double[] uninit = null;
    print_length(uninit);

    double[] zero_length = new double[0];
    print_length(zero_length);
  }

  private static void print_length(double[] array)
  {
    if (array == null) {
      System.out.println("null object reference for the array");
    }
    else
    {
      System.out.println(array.length);
    }
  }
}
