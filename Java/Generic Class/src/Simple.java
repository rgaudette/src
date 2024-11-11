/**

 */
public class Simple<T extends Number>
{
  private T attrib1;
  public Simple()
  {

  }

  public T getAttrib1()
  {
    return attrib1;
  }

  public void setAttrib1(T attrib1)
  {
    this.attrib1 = attrib1;
  }

  public void increment(T[] array)
  {
    for(int i = 0; i < array.length; ++i)
    {
      array[i] = array[i] + 1;
    }
  }
  public static void main(String[] args)
  {
    Simple<Integer> si = new Simple<Integer>();
    si.setAttrib1(1);
    System.out.println("Attrib1: " + si.getAttrib1());
  }
}
