/*
 * ProcessTestApp.java
 *
 * Created on December 10, 2001, 8:38 PM
 */

/**
 *
 * @author  rickg
 * @version 
 */
import java.io.*;
import java.util.*;

public class ProcessTestApp {

    /** Creates new ProcessTestApp */
    public ProcessTestApp() {
    }

    public static String[] runLs(){
        String[] cmdArray = {"/bin/ls", "-w", "."};

        return cmdArray;
    }
    /**
    * @param args the command line arguments
    */
    public static void main (String args[]) {
        System.out.println("LS output");
        System.out.print(runLs());
    }

}

