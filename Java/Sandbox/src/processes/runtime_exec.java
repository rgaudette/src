package processes;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

public class runtime_exec
{
  public static void main(String args[])
  {
    char[] _process_io_buffer;
    _process_io_buffer = new char[1024];
    String[] cmd_array = {"cmd", "/k", "dir /s C:\\Windows"};
    //String[] envp = {"Path=C:\\Windows\\System32;Boo"};
    Process proc;
    try {
      proc = Runtime.getRuntime().exec(cmd_array);
//      System.out.println("stdout:");
//      InputStream stdout = proc.getInputStream();
//      InputStreamReader stdout_reader = new InputStreamReader(stdout);
//      BufferedReader stdout_buffer = new BufferedReader(stdout_reader);
//      try {
//        while (stdout_buffer.read(_process_io_buffer, 0, 1024) > 0) {
//          System.out.print(_process_io_buffer);
//        }
//      }
//      catch (IOException e) {
//        e.printStackTrace();
//      }
//      System.out.println("");
//
    }
    catch (IOException e) {
      e.printStackTrace();
    }
    System.out.println("Returned from runtime exec");
  }
}
