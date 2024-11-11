import java.net.*;
import java.io.*;
import java.util.*;

public class udptalk {
  public static int nPacketBytes = 1500;

  public static void main(String[] args) {
    try {
      String host = args[0];
      System.out.println("UDP Writting " + args[0]);

      //
      // Create a UDP packet object to repeatedly send to the listener
      //
      byte[] byteArray = new byte[nPacketBytes];
      Random rng = new Random();
      rng.nextBytes(byteArray);
      DatagramPacket dgPacket = new DatagramPacket(byteArray, nPacketBytes);

      //
      //  Instantiate a datagram socket
      //
      DatagramSocket dgSocket = new DatagramSocket();      
      InetAddress inetAddress = InetAddress.getByName(args[0]);
      System.out.println(inetAddress);

      //
      //  Connect to the listener
      //
      dgSocket.connect(inetAddress, udplisten.PORT);

      //
      //  Repeatedly send the UDP packet through the socket till we get the
      //  requested number of bytes
      //
      long nBytes = Long.parseLong(args[1]);
      long nWrites = nBytes / nPacketBytes;
      long nBytesActual = nWrites * nPacketBytes;
      long stopTime = 0;
      long startTime = System.currentTimeMillis();
      for(int i = 0; i < nWrites; i++) {
        dgSocket.send(dgPacket);
      }
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

      dgSocket.close();
    }
    catch(IOException except) {
      except.printStackTrace();
      System.exit(-1);
    }      
  }
}
    

    

