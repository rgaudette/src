package ClassExamples;

/**
 * Created: 1/28/13 8:39 PM
 *
 * @author rick
 * @version %I%, %G%
 * @since X.XX
 */
public abstract class AnAbstractClass extends ABaseClass
{
  int attribute_1;
  int scale;

  public AnAbstractClass()
  {
  }

  public AnAbstractClass(int value)
  {
    super(value);
  }

  public int get_attribute_1()
  {
    return attribute_1;
  }

  public void scale_attribute()
  {
    attribute_1 *= scale;
  }

  @Override
  public boolean equals(Object o)
  {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;

    AnAbstractClass that = (AnAbstractClass) o;

    return attribute_1 != that.attribute_1;
  }

  @Override
  public int hashCode()
  {
    return attribute_1;
  }

  @Override
  public String toString()
  {
    return "attribute_1: " + attribute_1;
  }
}
