import java.net.*;
import java.io.*;

public class udplisten {

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
        //
        // Create a UDP packet object to repeatedly send to the listener
        //
        byte[] byteArray = new byte[udptalk.nPacketBytes];
        DatagramPacket dgPacket = 
          new DatagramPacket(byteArray, udptalk.nPacketBytes);

        //
        //  Instantiate a datagram socket
        //
        DatagramSocket dgSocket = 
          new DatagramSocket(PORT);

        //
        //  Keep receiving the packet until the scoket closes?
        //
        while(true) {
          dgSocket.receive(dgPacket);
          System.out.println("Received a packet");
        }
      }
      catch(IOException except) {
        except.printStackTrace(System.out);
      }
    }
  }
}
