package APackage;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class AClass_JUnitTest
{
  private AClass a_class;

  @Before
  public void setUp() throws Exception
  {
    a_class = new AClass();

  }

  @After
  public void tearDown() throws Exception
  {

  }

  @Test
  public void testGetAttr() throws Exception
  {
    assertEquals("Failed getAttr", "initialized", a_class.getAttr());
  }

  @Test
  public void testSetAttr() throws Exception
  {
    a_class.setAttr("uninitialized");
    assertEquals("Checking set attr", "uninitialized", a_class.getAttr());
  }
}
