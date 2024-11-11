package ClassExamples;

/**
 * Created: 1/30/13 10:12 AM
 *
 * @author rick
 * @version %I%, %G%
 * @since X.XX
 */
public class AnotherConcreteSingleton extends AnAbstractClass
{
  private static AnotherConcreteSingleton instance = null;

  private AnotherConcreteSingleton()
  {
    super(10);
    // Initialize super class attributes
    attribute_1 = 3;
    scale = 3;
  }


  public static AnotherConcreteSingleton getInstance()
  {
    if (instance == null)
      instance = new AnotherConcreteSingleton();
    return instance;
  }

  public static void main(String[] args)
  {
    AConcreteSingleton a_concrete = AConcreteSingleton.getInstance();
    System.out.println("a_concrete attribute: " + a_concrete.get_attribute_1());
    a_concrete.scale_attribute();
    System.out.println("a_concrete attribute: " + a_concrete.get_attribute_1());

    AnotherConcreteSingleton another_concrete = AnotherConcreteSingleton.getInstance();
    System.out.println("another_concrete attribute: " + another_concrete.get_attribute_1());
    System.out.println("a_concrete attribute: " + a_concrete.get_attribute_1());

    System.out.println("another_concrete attribute: " + another_concrete.attribute_0);
    System.out.println("a_concrete attribute: " + a_concrete.attribute_0);

  }
}

