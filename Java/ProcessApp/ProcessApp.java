
import java.io.*;
import java.util.*;

public class ProcessApp {

  public ProcessApp() {
  }

  public static void main(String args[]) {
    System.out.println("ProcessApp");

    if(args.length < 1) {
      System.out.println("Usage: ProcessApp command");
    }
    SystemProgram myProgram = new SystemProgram();
    try {
      int exitValue= myProgram.run(args);
      System.out.print("Command returned: ");
      System.out.println(exitValue);
      //
      //  Stdout
      //
      String[] progStdout = myProgram.getStdout();
      for(int i = 0; i < progStdout.length; i++) {
        System.out.println(progStdout[i]);
      }

      //
      //  Stderr
      //
      String[] progStderr = myProgram.getStderr();
      for(int i = 0; i < progStderr.length; i++) {
        System.out.println(progStderr[i]);
      }

    }
    catch(Exception excep) {
      System.out.println(excep.getMessage());
    }
  }
}
