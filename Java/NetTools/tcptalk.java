import java.net.*;
import java.io.*;

public class tcptalk {

  public static void main(String[] args) {
    try {
      String host = args[0];
      System.out.println("Writting " + args[0]);
      Socket sck = new Socket(host, tcplisten.PORT);
      int nSendBuffer = sck.getSendBufferSize();
      System.out.println("Tx buffer size: " + 
                         String.valueOf(nSendBuffer) +
                         " bytes");
      System.out.println("Rx buffer size: " + 
                         String.valueOf(sck.getReceiveBufferSize()) +
                         " bytes");

      OutputStream out = sck.getOutputStream();

      BufferedOutputStream outBuffer = 
        new BufferedOutputStream(out, nSendBuffer);

      //
      //  Create an array to write to the buffer
      //
      byte[] byteArray = new byte[nSendBuffer];
      for(int i = 0; i < nSendBuffer; i++) {
        byteArray[i] = 'a';
      }
      int ch = 'a';
      long nBytes = Long.parseLong(args[1]);
      long nWrites = nBytes / nSendBuffer;
      long nBytesActual = nWrites * nSendBuffer;
      long stopTime = 0;
      long startTime = System.currentTimeMillis();
      for(int i = 0; i < nWrites; i++) {
        outBuffer.write(byteArray, 0, nSendBuffer);        
      }
      outBuffer.flush();
      stopTime = System.currentTimeMillis();
      float writeTime = (stopTime - startTime) / 1000.0F;
      System.out.println("Wrote " + String.valueOf(nBytesActual) + 
                         " bytes in " + String.valueOf(writeTime) +
                         " seconds");
      float bytesPerSec = nBytesActual / writeTime;
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

      out.close();
    }
    catch(IOException except) {
      except.printStackTrace();
      System.exit(-1);
    }      
  }
}
    

    

