/**
 * A differentiable function interface
 *
 * @author Rick Gaudette
 * @since 5.4
 */
public interface DifferentiableFunction
{
  public int numberOfParameters();
  public double evalFunction(double[] parameters, double x);
  public void evalGradient(double[] parameters, double x, double[] result);
}
