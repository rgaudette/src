import java.io.File;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;

public class url_test
{
  public static void main(String args[])
  {
    System.out.println(String.valueOf(args.length));
    String path = "C:" + File.separator+ "Program Files (x86)";
    File file = new File(path);
    String path2 = "D:/AXI/Projection Sets/Flextronic_BTC/v810/3.0/jre/1.6.0_21_x86\\bin\\java.exe" ;
    File file2 = new File(path2);
    System.out.println(file2.toString());

    try {
      System.out.println(file.toURI().toString());
      System.out.println(file.toURL());
//      URL url = new URL("file", "localhost", path);
//      System.out.println(url);
    }
    catch (MalformedURLException e) {
      e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
    }


//      try {
//        URI uri = new URI("file", "localhost", path, null);
//        System.out.println(uri);
//      }
//      catch (URISyntaxException e) {
//        e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
//      }

  }
}
