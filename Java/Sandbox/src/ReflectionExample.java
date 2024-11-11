import java.lang.reflect.Field;

/**
 * Created: 6/24/13 5:43 PM
 *
 * @author rick
 * @version %I%, %G%
 * @since X.XX
 */

public class ReflectionExample
{
  static class Stat
  {
    int a;

    private Stat(int val)
    {
      a = val;
    }

    public static final Stat four = new Stat(4);
  }

  public static void main(String[] args)
  {
//    Stat s = new Stat(3);
//
//    try
//    {
//      Class cls = Class.forName("Stat");
//      System.out.println(cls.getName());
//    }
//    catch (ClassNotFoundException e)
//    {
//      e.printStackTrace();
//    }
    Class cls = null;
    try
    {
      cls = Class.forName("ReflectionExample$Stat");
    }
    catch (ClassNotFoundException e)
    {
      e.printStackTrace();
    }

    Field field_four = null;
    try
    {
      field_four = cls.getField("four");
    }
    catch (NoSuchFieldException e)
    {
      e.printStackTrace();
    }
    System.out.println(field_four);

    try
    {
      Stat cast = (Stat) field_four.get(cls);
      System.out.println(cast.a);
    }
    catch (IllegalAccessException e)
    {
      e.printStackTrace();
    }

//    Stat fourRef = Stat.four;
//    System.out.println(fourRef.getClass().getName());
  }
}
