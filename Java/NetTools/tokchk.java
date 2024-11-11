import java.io.*;
import java.util.*;

public class tokchk{
  public static final String str1 = new String("    lo:10219111   34417    0    0    0     0          0         0 10219111   34417    0    0    0     0       0          0");
  public static final String str2 = new String("  eth0: 5006677   13365    0    0    0     0          0         0  1060069   11134    0    0    0     5       0          0");
  public static final String str3 = new String("eth0:  12345 54321 123");

  public static void main(String[] args) {

    StringTokenizer st1 = new StringTokenizer(str1, ":", false);
    String token1 = st1.nextToken();
    System.out.println(token1);

    StringTokenizer st2 = new StringTokenizer(st1.nextToken());

    //
    //  parse the number of bytes received
    //
    System.out.println("Switching delimiters");    
    String token = st2.nextToken(" ");
    System.out.println("First blank delimited token:" + token);
    
    long rxBytes = Long.parseLong(token);
    System.out.println("RX bytes: " + String.valueOf(rxBytes));
    
    token = st2.nextToken(" ");
    System.out.println("First blank delimited token:" + token);

    long rxPackets = Long.parseLong(token);
    System.out.println("RX packets: " + String.valueOf(rxPackets));

  }
}
