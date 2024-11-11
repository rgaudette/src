/**
 * @author Rick Gaudette
 * @since 5.4
 */
public class ErfEdgeFunction implements DifferentiableFunction
{
  public int numberOfParameters()
  {
    return 4;
  }

  // Compute the Error function given the parameter vector and independent variable x
  //
  // parameters  A double array containing the parameters amplitude, mu, sigma, offset
  public double evalFunction(double[] parameters, double x)
  {
    assert (parameters.length == numberOfParameters());

    double amplitude = parameters[0];
    double mu = parameters[1];
    double sigma = parameters[2];
    double offset = parameters[3];

    double x_shift = x - mu;

    return amplitude * Math.exp(-x_shift * x_shift / (2 * sigma * sigma)) + offset;
  }


  // Compute the gradient of the Error function at the parameter vector and x
  //
  // parameters  A double array containing the parameters amplitude, mu, sigma, offset in that order.  Note that offset
  //             is not used in the gradient evaluation, but to keep the parameter array the same as the function
  //             evaluation it is included.
  //
  // @author Rick Gaudette
  public void evalGradient(double[] parameters, double x, double[] result)
  {
    assert (parameters.length == 4);

    double amplitude = parameters[0];
    double mu = parameters[1];
    double sigma = parameters[2];
    double offset = parameters[3];

    double sigmaInv = 1.0 / sigma;
    double delta = (x - mu) * sigmaInv;
    double deltaSq = delta * delta;
    double t = Math.exp(-0.5 * deltaSq);

    result[0] = t;             // gradient wrt amplitude
    t *= amplitude * sigmaInv;
    result[1] = delta * t;    // gradient wrt mean
    result[2] = deltaSq * t;   // gradient wrt sigma
    result[3] = 1.0;           // gradient wrt background
  }
}
