import java.io.*;
import java.util.*;

public class SystemProgram {
  int exitValue;
  ArrayList stdout;
  ArrayList stderr;

  public SystemProgram() {
    stdout = new ArrayList();
    stderr = new ArrayList();
  }

  //
  //  String array version of run
  //
  public int run(String[] commandLine)
    throws ProcessException, IOException, InterruptedException {

    //
    //  Clear the stderr and stdout from any previous commands
    //
    stderr.clear();
    stdout.clear();

    //
    //  Setup the Process object and run the command
    //
    Process process = Runtime.getRuntime().exec(commandLine);

    //
    //  Create a buffered reader to handle the stdout stream
    //
    InputStream cmdOut = process.getInputStream();
    InputStreamReader cmdOutReader = new InputStreamReader(cmdOut);
    BufferedReader cmdOutBuffer = new BufferedReader(cmdOutReader);

    //
    //  Create a buffered reader to handle the stderr stream
    //
    InputStream cmdErr = process.getErrorStream();
    InputStreamReader cmdErrReader = new InputStreamReader(cmdErr);
    BufferedReader cmdErrBuffer = new BufferedReader(cmdErrReader);

    String line;
    //
    //  Read in the command's stderr
    //
    List errorLines = new ArrayList();
    while ((line = cmdErrBuffer.readLine()) != null)
      stderr.add(line);

    //
    //  Read in the command's output
    //
    List outputLines = new ArrayList();
    while ((line = cmdOutBuffer.readLine()) != null)
      stdout.add(line);

    //
    //  Wait for the prcess to exit
    //  why can we read the stdout and stderr above before this completes
    //
    process.waitFor();
    return process.exitValue();
  }

  //
  //  Single string version of run
  //
  public int run(String commandLine)
    throws ProcessException, IOException, InterruptedException {

    //
    //  Clear the stderr and stdout from any previous commands
    //
    stderr.clear();
    stdout.clear();

    //
    //  Setup the Process object and run the command
    //
    Process process = Runtime.getRuntime().exec(commandLine);

    //
    //  Create a buffered reader to handle the stdout stream
    //
    InputStream cmdOut = process.getInputStream();
    InputStreamReader cmdOutReader = new InputStreamReader(cmdOut);
    BufferedReader cmdOutBuffer = new BufferedReader(cmdOutReader);

    //
    //  Create a buffered reader to handle the stderr stream
    //
    InputStream cmdErr = process.getErrorStream();
    InputStreamReader cmdErrReader = new InputStreamReader(cmdErr);
    BufferedReader cmdErrBuffer = new BufferedReader(cmdErrReader);

    String line;
    //
    //  Read in the command's stderr
    //
    List errorLines = new ArrayList();
    while ((line = cmdErrBuffer.readLine()) != null)
      stderr.add(line);

    //
    //  Read in the command's output
    //
    List outputLines = new ArrayList();
    while ((line = cmdOutBuffer.readLine()) != null)
      stdout.add(line);

    //
    //  Wait for the prcess to exit
    //  why can we read the stdout and stderr above before this completes
    //
    process.waitFor();
    return process.exitValue();
  }

  public String[] getStdout() {
    return (String[]) stdout.toArray(new String[] { });
  }

  public String[] getStderr() {
    return (String[]) stderr.toArray(new String[] { });
  }
}