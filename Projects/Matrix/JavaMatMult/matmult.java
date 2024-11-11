//
//  matrix multiply example
//
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.util.Date;

public class matmult {
    public static void main(String[] args) {

        long start=0, finish=0;
        Matrix x, y, z;
        parseCmdLine(args, false);

        //
        //  Open output file or write to stdout if output file is -
        //
        try {
            FileOutputStream fos = new FileOutputStream(args[0]);
            PrintStream ps = new PrintStream(fos);
            ps.println("%Size:\tMFLOPS:\t\tMFLOPS/Sec:\n");
            
            //
            //  Loop over matrix sizes
            //
            double et, MFLOPS;

            for(int iSize = m_min ; iSize <= m_max ; iSize += m_step) {
                //
                //  Allocate the new matrices
                //
                System.out.print("Matrix size: ");
                System.out.println(iSize);

                x = new Matrix(iSize, iSize);
                y = new Matrix(iSize, iSize);
                z = new Matrix(iSize, iSize);

                //
                //  Fill matrices with random numbers
                //
                x.RandUniform();
                y.RandUniform();

                //
                //  Multiply mactrices
                //
                start = System.currentTimeMillis();

                z.Multiply(x, y);
                x.Multiply(z, y);
                y.Multiply(z, x);
                z.Multiply(x, y);
                x.Multiply(z, y);

                finish = System.currentTimeMillis();

                et = (finish - start) / 1000.0;
                MFLOPS = 5.0 * (iSize * (iSize + (iSize - 1.0)) * iSize)
                    / 1.0E6;
                ps.print(iSize);
                ps.print("\t\t");
                ps.print(MFLOPS);
                ps.print("\t");
                ps.println(MFLOPS/et);
            }
            
            ps.close();
            fos.close();

        }

        catch (java.io.FileNotFoundException fileNotFound) {
            System.out.println("Unable to open " + args[0]);
            System.exit(-1);
        }
        catch (java.io.IOException ioException) {
            System.out.println("IOException in FileOutputStream close !?");
        }
    }

    //
    // Private class members
    //
    private static int m_min, m_max, m_step, nArgs;

    //
    //  Utility functions
    //
    private static void Usage() {
        System.out.println("JavaMatMult file m_min m_max [m_step]");
        System.out.println("file\t\tresults file, - for stdout");
        System.out.println("m_min\t\tthe minimum array size to examine");
        System.out.println("m_min\t\tthe maximum array size to examine");
        System.out.println("[m_step]\tthe step to increment the array size");
        System.out.println("");
        System.out.println("JavaMatMult performs matrix multiplications from size m_min to m_max");
        System.out.println("timing each one.  The performance result are written to file");
        System.out.println("specified");
    }
    
    private static void parseCmdLine(String[] args, boolean verbose) {
        //
        //  Read in the command line arguments
        //
        nArgs = args.length;
        if (nArgs < 3) {
            Usage();
            System.exit(-1);
        }

        m_min = Integer.parseInt(args[1]);
        m_max = Integer.parseInt(args[2]);
        m_step = 1;
        if (nArgs > 3) {
            m_step = Integer.parseInt(args[3]);
        }
        if(verbose) {
            System.out.println("filename: " + args[0]);

            System.out.print("m_min: ");
            System.out.println(m_min);
            System.out.print("m_max: ");
            System.out.println(m_max);
        }
    }
}
