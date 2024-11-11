package guiprocessapp;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.text.*;


/**
 * Title:
 * Description:
 * Copyright:    Copyright (c) 2001
 * Company:
 * @author
 * @version 1.0
 */

public class mainFrame extends JFrame {
  //
  //  Instantiations for main frame window components
  //
  JPanel contentPane;
  GUIProcessApp mainApp;

  //
  //  Layout for the main pane
  //
  //
  //  Menu bar components
  //
  JMenuBar jMenuBar1 = new JMenuBar();
  JMenu jMenuFile = new JMenu();
  JMenuItem jMenuFileExit = new JMenuItem();
  JMenu jMenuHelp = new JMenu();
  JMenuItem jMenuHelpAbout = new JMenuItem();
  ImageIcon image1;
  ImageIcon image2;
  ImageIcon image3;

  //
  //  Command panel components
  //

  //
  //  Stdout, stderr panel documents
  //
  PlainDocument docStdout = new PlainDocument();
  PlainDocument docStderr = new PlainDocument();

  //
  //  Status bar at bottom
  //
  BorderLayout borderLayout1 = new BorderLayout();
  JLabel statusBar = new JLabel();
  JToolBar jToolBar = new JToolBar();
  JButton jButton3 = new JButton();
  JButton jButton2 = new JButton();
  JButton jButton1 = new JButton();

  JPanel jPanel1 = new JPanel();
  JButton buttonRun = new JButton();
  JPanel panelCommand = new JPanel();
  JTextField textFieldCommand = new JTextField();
  JLabel labelCommand = new JLabel();

  JLabel labelStdout = new JLabel();
  JPanel panelStdout = new JPanel();
  FlowLayout layoutFlowStdout = new FlowLayout();
  JScrollPane scrollPaneStdout = new JScrollPane();
  JSplitPane jSplitPane1 = new JSplitPane();

  JTextArea textStderr = new JTextArea();
  JLabel labelStderr = new JLabel();
  JPanel panelStdErr = new JPanel();
  JScrollPane scrollPaneStderr = new JScrollPane();
  FlowLayout layoutFlowStderr = new FlowLayout();
  JTextArea textStdout = new JTextArea();
  FlowLayout flowLayout1 = new FlowLayout();



  /**Construct the main frame*/
  public mainFrame(GUIProcessApp app) {
  mainApp = app;

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
    image1 = new ImageIcon(guiprocessapp.mainFrame.class.getResource("openFile.gif"));
    image2 = new ImageIcon(guiprocessapp.mainFrame.class.getResource("closeFile.gif"));
    image3 = new ImageIcon(guiprocessapp.mainFrame.class.getResource("help.gif"));
    //setIconImage(Toolkit.getDefaultToolkit().createImage(mainFrame.class.getResource("[Your Icon]")));
    contentPane = (JPanel) this.getContentPane();
    contentPane.setLayout(borderLayout1);
    this.setDefaultCloseOperation(WindowConstants.DO_NOTHING_ON_CLOSE);
    this.setSize(new Dimension(800, 600));
    this.setTitle("ProcessApp GUI");
    jMenuFile.setText("File");
    jMenuFileExit.setText("Exit");
    jMenuFileExit.addActionListener(new mainFrame_jMenuFileExit_ActionAdapter(this));
    jMenuHelp.setText("Help");
    jMenuHelpAbout.setText("About");
    jMenuHelpAbout.addActionListener(new mainFrame_jMenuHelpAbout_ActionAdapter(this));

    textStdout.setColumns(80);
    textStdout.setRows(40);
    textStdout.setEditable(false);
    labelCommand.setHorizontalAlignment(SwingConstants.RIGHT);
    labelCommand.setHorizontalTextPosition(SwingConstants.RIGHT);
    labelCommand.setLabelFor(textFieldCommand);
    jSplitPane1.setAlignmentX((float) 0.5);
    jSplitPane1.setAlignmentY((float) 0.5);
    flowLayout1.setAlignment(FlowLayout.LEFT);
    panelCommand.setLayout(flowLayout1);
    layoutFlowStdout.setAlignment(FlowLayout.LEFT);
    layoutFlowStderr.setAlignment(FlowLayout.LEFT);
    jToolBar.add(jButton1);
    jToolBar.add(jButton2);
    jToolBar.add(jButton3);
    contentPane.setPreferredSize(new Dimension(800, 600));

    statusBar.setText("No command yet run");
    jButton3.setIcon(image3);
    jButton3.setToolTipText("Help");
    jButton2.setIcon(image2);
    jButton2.setToolTipText("Close File");
    jButton1.setIcon(image1);
    jButton1.setToolTipText("Open File");
    jPanel1.setLayout(new BoxLayout(jPanel1, BoxLayout.Y_AXIS));
    buttonRun.setText("Run");
    buttonRun.addActionListener(new mainFrame_buttonRun_actionAdapter(this));

    panelCommand.setMinimumSize(new Dimension(134, 10));
    panelCommand.setPreferredSize(new Dimension(777, 45));
    textFieldCommand.setBackground(Color.white);
    textFieldCommand.setPreferredSize(new Dimension(400, 19));
    textFieldCommand.setText("Enter command here");
    labelCommand.setText("Command:");
    panelCommand.add(labelCommand, null);
    panelCommand.add(textFieldCommand, null);
    panelCommand.add(buttonRun, null);

    labelStdout.setPreferredSize(new Dimension(40, 150));
    labelStdout.setText("Stdout:");
    labelStdout.setVerticalAlignment(SwingConstants.TOP);
    textStdout.setPreferredSize(new Dimension(720, 160));
    textStdout.setBackground(Color.white);
    textStdout.setDocument(docStdout);
    scrollPaneStdout.setPreferredSize(new Dimension(720, 160));
    panelStdout.setLayout(layoutFlowStdout);
    panelStdout.setPreferredSize(new Dimension(775, 100));

    labelStderr.setPreferredSize(new Dimension(40, 150));
    labelStderr.setText("Stderr:");
    labelStderr.setVerticalAlignment(SwingConstants.TOP);
    labelStderr.setVerticalTextPosition(SwingConstants.TOP);
    textStderr.setPreferredSize(new Dimension(720, 160));
    textStderr.setBackground(Color.white);
    textStderr.setDocument(docStderr);
    scrollPaneStderr.setPreferredSize(new Dimension(720, 160));
    panelStdErr.setLayout(layoutFlowStderr);
    panelStdErr.setPreferredSize(new Dimension(775, 60));

    jSplitPane1.setOrientation(JSplitPane.VERTICAL_SPLIT);
    jSplitPane1.setPreferredSize(new Dimension(777, 450));
    jSplitPane1.setOneTouchExpandable(true);
    jSplitPane1.setDividerLocation(225);

    jPanel1.setPreferredSize(new Dimension(777, 460));
    jPanel1.add(panelCommand, null);

    contentPane.add(statusBar, BorderLayout.SOUTH);
    contentPane.add(jToolBar, BorderLayout.NORTH);
    contentPane.add(jPanel1, BorderLayout.CENTER);
    jPanel1.add(jSplitPane1, null);
    jSplitPane1.add(panelStdout, JSplitPane.TOP);
    panelStdout.add(labelStdout, null);
    panelStdout.add(scrollPaneStdout, null);
    scrollPaneStdout.getViewport().add(textStdout, null);
    jSplitPane1.add(panelStdErr, JSplitPane.BOTTOM);
    panelStdErr.add(labelStderr, null);
    panelStdErr.add(scrollPaneStderr, null);
    scrollPaneStderr.getViewport().add(textStderr, null);



    jMenuFile.add(jMenuFileExit);
    jMenuHelp.add(jMenuHelpAbout);
    jMenuBar1.add(jMenuFile);
    jMenuBar1.add(jMenuHelp);
    this.setJMenuBar(jMenuBar1);

  }
  /**File | Exit action performed*/
  public void jMenuFileExit_actionPerformed(ActionEvent e) {
    System.exit(0);
  }
  /**Help | About action performed*/
  public void jMenuHelpAbout_actionPerformed(ActionEvent e) {
    mainFrame_AboutBox dlg = new mainFrame_AboutBox(this);
    Dimension dlgSize = dlg.getPreferredSize();
    Dimension frmSize = getSize();
    Point loc = getLocation();
    dlg.setLocation((frmSize.width - dlgSize.width) / 2 + loc.x, (frmSize.height - dlgSize.height) / 2 + loc.y);
    dlg.setModal(true);
    dlg.show();
  }
  /**Overridden so we can exit when window is closed*/
  protected void processWindowEvent(WindowEvent e) {
    super.processWindowEvent(e);
    if (e.getID() == WindowEvent.WINDOW_CLOSING) {
      jMenuFileExit_actionPerformed(null);
    }
  }

  void buttonRun_actionPerformed(ActionEvent e) {
    //
    //  Get the command string from textFieldCommand
    //
    String command = textFieldCommand.getText();
    mainApp.executeCommand(command);
  }

  //
  //  Erase Stdout text object
  //
  void eraseStdout() {
    textStdout.setText(null);
  }

  //
  //  Erase Stderr text object
  //
  void eraseStderr() {
    textStderr.setText(null);
  }

  //
  //  Append text into stdout text object
  //
  void appendStdout(String line){
    textStdout.append(line);
  }

  //
  //  Append text into stderr text object
  //
  void appendStderr(String line){
    textStderr.append(line);
  }

  //
  //  Set the number of rows in the stdout text area
  //
  void setRowsStdout(int nRows) {
    textStdout.setRows(nRows);
  }

  //
  //  Set the number of rows in the stdout text area
  //
  void setRowsStderr(int nRows) {
    textStderr.setRows(nRows);
  }

  //
  //  Set the status bar text
  //
  void setStatusBarText(String text) {
    statusBar.setText(text);
  }

}

class mainFrame_jMenuFileExit_ActionAdapter implements ActionListener {
  mainFrame adaptee;

  mainFrame_jMenuFileExit_ActionAdapter(mainFrame adaptee) {
    this.adaptee = adaptee;
  }
  public void actionPerformed(ActionEvent e) {
    adaptee.jMenuFileExit_actionPerformed(e);
  }
}

class mainFrame_jMenuHelpAbout_ActionAdapter implements ActionListener {
  mainFrame adaptee;

  mainFrame_jMenuHelpAbout_ActionAdapter(mainFrame adaptee) {
    this.adaptee = adaptee;
  }
  public void actionPerformed(ActionEvent e) {
    adaptee.jMenuHelpAbout_actionPerformed(e);
  }
}

class mainFrame_buttonRun_actionAdapter implements java.awt.event.ActionListener {
  mainFrame adaptee;

  mainFrame_buttonRun_actionAdapter(mainFrame adaptee) {
    this.adaptee = adaptee;
  }
  public void actionPerformed(ActionEvent e) {
    adaptee.buttonRun_actionPerformed(e);
  }
}