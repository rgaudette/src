package ClassExamples;

/**
 * Created: 1/28/13 10:13 PM
 *
 * @author rick
 * @version %I%, %G%
 * @since X.XX
 */
public class AConcreteSingleton extends AnAbstractClass
{
  private static AConcreteSingleton instance = null;

  private AConcreteSingleton()
  {
    // Initialize super class attributes
    attribute_1 = 1;
    scale = 2;
   }


  public static AConcreteSingleton getInstance() {
    if(instance == null) {
      instance = new AConcreteSingleton();
    }

    return instance;
  }

  public static void main(String[] args)
  {
    AConcreteSingleton instance = AConcreteSingleton.getInstance();
    System.out.println("attribute: " + instance.get_attribute_1());
    instance.scale_attribute();
    System.out.println("attribute: " + instance.get_attribute_1());
  }
}
