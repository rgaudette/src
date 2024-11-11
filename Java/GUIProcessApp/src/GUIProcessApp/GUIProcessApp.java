package guiprocessapp;

import javax.swing.UIManager;
import java.awt.*;

/**
 * Title:
 * Description:
 * Copyright:    Copyright (c) 2001
 * Company:
 * @author
 * @version 1.0
 */

public class GUIProcessApp {
  boolean packFrame = false;
  static SystemProgram sysProgram;
  mainFrame frame;
  /**Construct the application*/
  public GUIProcessApp() {
    frame = new mainFrame(this);

    //Validate frames that have preset sizes
    //Pack frames that have useful preferred size info, e.g. from their layout
    if (packFrame) {
      frame.pack();
    }
    else {
      frame.validate();
    }
    //Center the window
    Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
    frame.setSize(800, 600);
    Dimension frameSize = frame.getSize();

    if (frameSize.height > screenSize.height) {
      frameSize.height = screenSize.height;
    }

    if (frameSize.width > screenSize.width) {
      frameSize.width = screenSize.width;
    }

    //frame.setLocation((screenSize.width - frameSize.width) / 2,
    //  (screenSize.height - frameSize.height) / 2);

    frame.setVisible(true);
  }

  /**Main method*/
  public static void main(String[] args) {
    sysProgram = new SystemProgram();

    try {
      UIManager.setLookAndFeel
        ("com.sun.java.swing.plaf.motif.MotifLookAndFeel");
    }
    catch(Exception e) {
      e.printStackTrace();
    }
    GUIProcessApp guiProcessApp = new GUIProcessApp();
  }

  public void executeCommand(String command) {
    //
    //  Erase the stdout and stderr text panes
    //
    System.out.println("Erasing std* documents");
    frame.eraseStdout();
    frame.eraseStderr();

    //
    //   Execute the requested program
    //
    try {

      //
      //  Run the command
      //
      System.out.println("Running: " + command);
      int exitVal = sysProgram.run(command);

      //
      //  Copy the stdout and stderr to the appropriate text boxes
      //
      String[] stdOut = sysProgram.getStdout();
      for(int i = 0; i < stdOut.length; i++) {
        frame.appendStdout(stdOut[i] + "\n");
      }
      frame.setRowsStdout(stdOut.length);

      String[] stdErr = sysProgram.getStderr();
      for(int i = 0; i < stdErr.length; i++) {
        frame.appendStderr(stdErr[i] + "\n");
      }
      frame.setRowsStdout(stdOut.length);

      //
      //  Write the exit value to the status bar
      //
      frame.setStatusBarText("Exit value: " + String.valueOf(exitVal));
    }
    catch (Exception excep) {
      System.out.println(excep.toString());
    }
    //
    //  Set the exitValue and state of the status bar
    //

  }
}
