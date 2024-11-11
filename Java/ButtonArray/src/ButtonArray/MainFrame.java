//
//  Ugh, compiles and runs fine but can't use GUI designer to view and
//  manipulate buttons :(.
//
package buttonarray;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

/**
 * Title:
 * Description:
 * Copyright:    Copyright (c) 2001
 * Company:
 * @author
 * @version 1.0
 */

public class MainFrame extends JFrame {
  JPanel contentPane;
  JLabel statusBar = new JLabel();
  BorderLayout borderLayout1 = new BorderLayout();

  //
  //  Create an array of buttons
  //
  static final int nButtons = 3;
  JButton[] buttonArray = new JButton[nButtons];
  //  JButton jButton1 = new JButton();
//  JButton jButton2 = new JButton();
//  JButton jButton3 = new JButton();

  /**Construct the frame*/
  public MainFrame() {
    enableEvents(AWTEvent.WINDOW_EVENT_MASK);
    try {
      jbInit();
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }
  /**Component initialization*/
  private void jbInit() throws Exception  {
    //setIconImage(Toolkit.getDefaultToolkit().createImage(MainFrame.class.getResource("[Your Icon]")));
    contentPane = (JPanel) this.getContentPane();
    contentPane.setLayout(borderLayout1);
    this.setSize(new Dimension(400, 300));
    this.setTitle("Button Array");
    statusBar.setText(" ");

    for(int i = 0; i < nButtons; i++) {
      buttonArray[i] = new JButton();
    }

    for(int i=0; i<nButtons; i++) {
      buttonArray[i].setText("Button: " + String.valueOf(i));
    }
    //jButton1.setText("jButton1");
    //jButton2.setText("jButton2");
    //jButton3.setText("jButton3");
    contentPane.add(statusBar, BorderLayout.SOUTH);
    //contentPane.add(jButton1, BorderLayout.WEST);
    //contentPane.add(jButton2, BorderLayout.CENTER);
    //contentPane.add(jButton3, BorderLayout.EAST);
    contentPane.add(buttonArray[0], BorderLayout.WEST);
    contentPane.add(buttonArray[1], BorderLayout.CENTER);
    contentPane.add(buttonArray[2], BorderLayout.EAST);

  }
  /**Overridden so we can exit when window is closed*/
  protected void processWindowEvent(WindowEvent e) {
    super.processWindowEvent(e);
    if (e.getID() == WindowEvent.WINDOW_CLOSING) {
      System.exit(0);
    }
  }
}