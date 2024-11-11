package APackage;

import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

import static org.testng.Assert.*;

/**
 * Created: 1/15/13 12:12 PM
 * @author    rick
 * @version
 * @since     1.0
 */
public class AClass_TestNG
{
  private AClass a_class;

  @BeforeMethod
  public void setUp() throws Exception
  {
    a_class = new AClass();
  }

  @AfterMethod
  public void tearDown() throws Exception
  {

  }

  @Test
  public void testGetAttr() throws Exception
  {
    assertEquals(a_class.getAttr(), "initialized", "getAttr failed");
  }

  @Test
  public void testSetAttr() throws Exception
  {

  }
}
