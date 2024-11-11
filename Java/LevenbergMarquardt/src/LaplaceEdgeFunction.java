/**
 * @author rick
 * @since 5.4
 */

public class LaplaceEdgeFunction implements DifferentiableFunction
{
  public int numberOfParameters()
  {
    return 4;
  }


  public double evalFunction(double[] parameters, double x)
  {
    assert parameters.length == numberOfParameters();

    double amplitude = parameters[0];
    double mu = parameters[1];
    double beta = parameters[2];
    double offset = parameters[3];

    assert beta != 0.0;

    double x_shift = x - mu;
    return 0.5 * amplitude * (1.0 + Math.signum(x_shift) * (1.0 - Math.exp(- Math.abs(x_shift) / beta))) + offset;
  }

  public void evalGradient(double[] parameters, double x, double[] result)
  {
    assert parameters.length == 4;

    double amplitude = parameters[0];
    double mu = parameters[1];
    double beta = parameters[2];
    // double offset = parameters[3];

    assert beta != 0.0;

    double exp_arg = -1.0 * Math.abs(x - mu) / beta;

    result[0] = 0.5 * (1.0 + Math.signum(x - mu) * (1.0 - Math.exp(exp_arg)));
    result[1] = -1.0 * amplitude / (2.0 * beta) * Math.exp(exp_arg);
    result[2] = amplitude * (mu - x) / (2.0 * beta * beta) * Math.exp(exp_arg);
    result[3] = 1.0;

  }

}
