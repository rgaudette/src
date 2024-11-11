
import java.net.*;
import java.io.*;

public class tcplisten {

  public static final int PORT = 0xCAFE;

  public static void main(String[] args) {
    ServerSocket server = null;

    try {
      server = new ServerSocket(PORT);

    }
    catch(IOException except) {
      except.printStackTrace();
      System.exit(-1);
    }


    byte[] bytes = new byte[1024];
    for(;;) {
      try {
        System.out.println("----------------------------------------");
        Socket sock = server.accept();
        InputStream in = sock.getInputStream();
        long len;
        long totalRead = 0;
        long stopTime = 0;
        long startTime = System.currentTimeMillis();
        while ((len = in.read(bytes)) > 0) {
          totalRead = totalRead + len;
        }
        stopTime = System.currentTimeMillis();
        float readTime = (stopTime - startTime) / 1000.0F;
        System.out.println("Read " + String.valueOf(totalRead) + 
                           " bytes in " + String.valueOf(readTime) +
                           " seconds");
        float bytesPerSec = totalRead / readTime;
        if(bytesPerSec < 1024) {
          System.out.println(String.valueOf(bytesPerSec) +
                             " bytes/sec");
        }
        else {
          if(bytesPerSec < (1024 * 1024)) {
            System.out.println(String.valueOf(bytesPerSec / 1024 ) 
                               + " Kbytes/sec");
          }
          else {
            System.out.println(String.valueOf(bytesPerSec / (1024 * 1024)) 
                               + " Mbytes/sec");
          }
        }
        in.close();
      }
      catch(IOException except) {
        except.printStackTrace(System.out);
      }
    }
  }
}
