/**
 * Created: 6/5/13 2:30 PM
 *
 * @author rick
 * @version %I%, %G%
 * @since X.XX
 */
public class Test
{

  public static void main(String args[])
  {
    testErfEdge();
    testLaplaceEdge();
  }


  public static void testErfEdge()
  {
    int n_elem = 31;
    int half = n_elem / 2;
    double[] x = new double[n_elem];
    double[] y = new double[n_elem];

    //ErfEdgeFunction edgeFunction = new ErfEdgeFunction();
    ErfEdgeFunction edgeFunction = new ErfEdgeFunction();
    double[] a = new double[4];
    // amplitude = parameters[0];
    // mu = parameters[1];
    // sigma = parameters[2];
    // offset = parameters[3];
    a[0] = 2.0;
    a[1] = 0.0;
    a[2] = 1.0;
    a[3] = -1.0;
    System.out.println("True parameters:");
    print_array(a);
    for (int i = 0; i < n_elem; i++)
    {
      x[i] = (i - half) / 3.0;
      y[i] = edgeFunction.evalFunction(a, x[i]);
    }

    LevenbergMarquardtSolver1D lm_solver = new LevenbergMarquardtSolver1D(edgeFunction);
    lm_solver.setConvergenceCriteria(1E-10, 0.0, 1E-3, 30);

    double[] init_a = new double[4];

    for (double amplitude = 1.8; amplitude <= 2.2; amplitude += 0.1)
    {
      init_a[0] = amplitude;

      for (double mu = -0.7; mu <= 0.7; mu += 0.1)
      {
        init_a[1] = mu;

        for (double sigma = 0.4; sigma <= 1.6; sigma += 0.1)
        {
          init_a[2] = sigma;

          for (double offset = -1.5; offset <= -0.5; offset += 0.1)
          {
            init_a[3] = offset;

            lm_solver.solve(x, y, init_a);
            double[] a_est = lm_solver.get_a();

            if (!arrays_equal(a, a_est, 1E-3))
            {
              System.out.println("Initial estimate:");
              print_array(init_a);

              System.out.println("Final estimate:");
              print_array(a_est);

              System.out.printf("Iterations: %d\n", lm_solver.get_nIter());
              System.out.printf("Chi squared: %f\n", lm_solver.get_chiSq());
            }
          }
        }
      }
    }
  }


  public static void testLaplaceEdge()
  {
    int n_elem = 31;
    int half = n_elem / 2;
    double[] x = new double[n_elem];
    double[] y = new double[n_elem];

    //ErfEdgeFunction edgeFunction = new ErfEdgeFunction();
    LaplaceEdgeFunction edgeFunction = new LaplaceEdgeFunction();
    double[] a = new double[4];
    a[0] = 2.0;
    a[1] = 0.0;
    a[2] = 1.0;
    a[3] = -1.0;
    System.out.println("True parameters:");
    print_array(a);
    for (int i = 0; i < n_elem; i++)
    {
      x[i] = (i - half) / 3.0;
      y[i] = edgeFunction.evalFunction(a, x[i]);
    }

    LevenbergMarquardtSolver1D lm_solver = new LevenbergMarquardtSolver1D(edgeFunction);
    lm_solver.setConvergenceCriteria(1E-10, 0.0, 1E-3, 30);

    double[] init_a = new double[4];

    for (double amplitude = 1.8; amplitude <= 2.2; amplitude += 0.1)
    {
      init_a[0] = amplitude;

      for (double mu = -0.7; mu <= 0.7; mu += 0.1)
      {
        init_a[1] = mu;

        for (double beta = 0.4; beta <= 1.6; beta += 0.1)
        {
          init_a[2] = beta;

          for (double offset = -1.5; offset <= -0.5; offset += 0.1)
          {
            init_a[3] = offset;

            lm_solver.solve(x, y, init_a);
            double[] a_est = lm_solver.get_a();

            if (!arrays_equal(a, a_est, 1E-3))
            {
              System.out.println("Initial estimate:");
              print_array(init_a);

              System.out.println("Final estimate:");
              print_array(a_est);

              System.out.printf("Iterations: %d\n", lm_solver.get_nIter());
              System.out.printf("Chi squared: %f\n", lm_solver.get_chiSq());
            }
          }
        }
      }
    }
  }

  public static void print_array(double[] a)
  {
    for (double v : a)
    {
      System.out.printf("%f, ", v);
    }
    System.out.println("");
  }

  public static boolean arrays_equal(double[] a, double[] b, double tol)
  {
    assert a.length == b.length;
    for (int i = 0; i < a.length; i++)
    {
      double absDiff = Math.abs(b[i] - a[i]);
      if (absDiff > tol)
      {
        return false;
      }
    }
    return true;
  }


}
