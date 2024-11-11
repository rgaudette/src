package ClassExamples;

/**
 * Created: 1/28/13 8:45 PM
 *
 * @author rick
 * @version %I%, %G%
 * @since X.XX
 */
public class AConcreteClass extends AnAbstractClass
{

  public AConcreteClass()
  {

  }

  public static void main(String[] args)
  {
    AConcreteClass a_concrete_class = new AConcreteClass();

    System.out.println("attribute_1: " + a_concrete_class.get_attribute_1());
  }
}
