import java.io.*;
import java.util.*;

public class netrate {
  static long currRxBytes;
  static long prevRxBytes;
  static long currTxBytes;
  static long prevTxBytes;

  static int samplePeriod = 1000;

  static String strInterface = "eth0";
    
  public netrate() {

  }

  public static void main(String[] args) {
    ProcNetDevice pnd = new ProcNetDevice();

    try{    

      while(true) {
        //
        //  Open the /proc/net/dev file and mark the beginning of the file.
        //
        InputStream devStream = new FileInputStream("/proc/net/dev");
        BufferedReader devBuffer = 
          new BufferedReader(new InputStreamReader(devStream));
        String input;
        input = devBuffer.readLine();

        while(input != null) {
          input = input.trim();
          //
          //  Does the interface name match the one we are looking for
          //
          if(input.startsWith(strInterface)) {
            pnd.set(input);
            prevRxBytes = currRxBytes;
            currRxBytes = pnd.getRxBytes();
            prevTxBytes = currTxBytes;
            currTxBytes = pnd.getTxBytes();

            System.out.print(((currRxBytes - prevRxBytes) * 1000.0) /
                               samplePeriod/1E6);
            System.out.print("\t");
            System.out.println(((currTxBytes - prevTxBytes) * 1000.0) /
                               samplePeriod / 1E6);

          }
          input = devBuffer.readLine();
        }
        Thread.sleep(samplePeriod);
      }
    }
    catch(Exception except) {
      System.out.println(except.getMessage());
      except.printStackTrace();
      System.out.println(except.toString());
    }
  }
  
  //
  //  Parse the line from the proc file
  //
  
}

class ProcNetDevice {
  String interfaceName;
  long rxBytes;
  long rxPackets;
  int rxErrs;
  int rxDropped;
  int rxFifo;
  int rxFrame;
  int rxCompressed;
  int rxMulticast;

  long txBytes;
  long txPackets;
  int txErrs;
  int txDropped;
  int txFifo;
  int txCollisions;
  int txCompressed;
  int txCarrier;

  long junk;

  ProcNetDevice() {
  }

  public void set(String procString) {
    //
    //  Split the string into two strings delimited by the colon
    //
    StringTokenizer stName = new StringTokenizer(procString, ":");
    interfaceName = stName.nextToken();

    //
    //  Parse the sequence of space delimited numbers from the second token
    //
    StringTokenizer stNumbers = new StringTokenizer(stName.nextToken());
    rxBytes = Long.parseLong(stNumbers.nextToken());
    rxPackets = Long.parseLong(stNumbers.nextToken());
    junk = Long.parseLong(stNumbers.nextToken());
    junk = Long.parseLong(stNumbers.nextToken());
    junk = Long.parseLong(stNumbers.nextToken());
    junk = Long.parseLong(stNumbers.nextToken());
    junk = Long.parseLong(stNumbers.nextToken());
    junk = Long.parseLong(stNumbers.nextToken());
    txBytes = Long.parseLong(stNumbers.nextToken());
    //
    //
    //
  }
  public long getRxBytes() {
    return rxBytes;
  }

  public long getTxBytes() {
    return txBytes;
  }
  
}
