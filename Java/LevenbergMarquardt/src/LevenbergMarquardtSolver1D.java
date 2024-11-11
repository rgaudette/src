/**
 * @author Rick Gaudette
 * @since 5.4
 */

import Jama.Matrix;

public class LevenbergMarquardtSolver1D

{
  public LevenbergMarquardtSolver1D(DifferentiableFunction func)
  {
    _func = func;
    _m = _func.numberOfParameters();
    allocate();
  }

  public void solve(double[] x, double[] y, double[] a)
  {
    assert (_x.length == y.length);
    assert a.length == _m;
    assert _n > _m;
    _n = x.length;
    _x = new double[_n];
    _y = new double[_n];
    _delta = new double[_n];
    _sigmaInv = new double[_n];

    for (int i = 0; i < _sigmaInv.length; i++)
    {
      _sigmaInv[i] = 1.0;
    }

    System.arraycopy(x, 0, _x, 0, x.length);
    System.arraycopy(y, 0, _y, 0, y.length);
    System.arraycopy(a, 0, _a, 0, a.length);

    double chiSq;
    double maxDeltaA;
    int minDeltaParamIterations = 0;
    int minDeltaChiSqIterations = 0;

    // Compute initial chi squared
    for (int i = 0; i < _n; i++)
    {
      _delta[i] = (_y[i] - _func.evalFunction(_a, _x[i]));
      if (useYWeights)
        _delta[i] *= _sigmaInv[i];
    }
    _chiSq = squaredVectorMagnitude(_delta);   // _chiSq = _delta' * _delta
    //System.out.printf("chi sq: %E\n", _chiSq);

    _nIter = 0;

    // Bail out with no iterations if too few data points
    // or if initial chi squared meets convergence criteria
    boolean converged = _chiSq < _minChiSq;

    while (!converged && _nIter < _maxIter)
    {
      // Compute gradient and approximate Hessian
      // _delta[i] = y_i - f(a[], x_i) has already been computed
      setArray(_g, 0.0);
      setMatrix(_H, 0.0);
      for (int i = 0; i < _n; i++)
      {
        _func.evalGradient(_a, _x[i], _df);         // _df = df/da

        for (int j = 0; j < _m; j++)
        {
          if (useYWeights)
          {
            _df[j] *= _sigmaInv[i];
          }
          _g[j] += _delta[i] * _df[j]; // accumulate _g = -dchiSq/da
        }
        symmetricUpdate(_H, _df); // Approximate Hessian = _df*df'
      }

      while (true)
      {
        _nIter += 1;

        // Compute _M = _H + _lambda * I
        matrixCopy(_H, _M);
        addToDiagonal(_M, _lambda);

        // Solve linear system _M * d = _g, overwriting _g with solution
        try{
          symmetricSolver(_M, _g);    // _g = _M^{-1} * _g
        }
        // _M was singular
        catch (RuntimeException ex)
        {
        }
        // Compute new, trial value for params b = a + d (which is in _g)
        System.arraycopy(_a, 0, _b, 0, _a.length);
        maxDeltaA = 0.0;
        for (int i = 0; i < _m; i++)
        {
          double oldB = _b[i];
          _b[i] += _g[i];

          // If requested, force estimated parameters >= 0
          if (_nonNegativeA[i] && _b[i] < 0.0)
          {
            _b[i] = 0.0;
          }

          if (_minDeltaParam > 0.0)
          {
            maxDeltaA = Math.max(maxDeltaA, Math.abs(_g[i] / _b[i]));
          }
        }

        // Compute new chi squared
        for (int i = 0; i < _n; i++)
        {
          _delta[i] = (_y[i] - _func.evalFunction(_b, _x[i]));
          if (useYWeights)
          {
            _delta[i] *= _sigmaInv[i];
          }
        }
        chiSq = squaredVectorMagnitude(_delta);    // _delta' * _delta
        //System.out.printf("chi sq: %E\n", _chiSq);

        if (chiSq < _chiSq || _nIter >= _maxIter)
        {
          break;                            // only way out of inner loop
        }
        _lambda *= 10.0;
      }
      if (chiSq < _chiSq)
      {
        // count consecutive iterations meeting relative parm change criterion
        if (maxDeltaA < _minDeltaParam)
        {
          minDeltaParamIterations += 1;
        }
        else
        {
          minDeltaParamIterations = 0;
        }

        // count consecutive iterations meeting change in chi squared criterion
        if (_chiSq - chiSq < _minDeltaChiSq)
        {
          minDeltaChiSqIterations += 1;
        }
        else
        {
          minDeltaChiSqIterations = 0;
        }

        // Tests for convergence
        if (minDeltaParamIterations >= 2 || minDeltaChiSqIterations >= 2 || chiSq < _minChiSq)
        {
          converged = true;
        }
        else
        {
          _lambda *= 0.1;
        }
        //System.out.printf("minDeltaParamIterations: %d  minDeltaChiSqIterations: %d\n", minDeltaParamIterations, minDeltaChiSqIterations);
        System.arraycopy(_b, 0, _a, 0, _b.length);
        _chiSq = chiSq;                     // and new best chi squared
      }
    }
  }

  private void allocate()
  {
    _a = new double[_m];
    _df = new double[_m];
    _g = new double[_m];
    _b = new double[_m];

    _H = new Matrix(_m, _m);
    _M = new Matrix(_m, _m);

    _nonNegativeA = new boolean[_m];
    for (int i = 0; i < _nonNegativeA.length; i++)
    {
      _nonNegativeA[i] = false;
    }

  }

  public void setConvergenceCriteria(double minChiSq, double minDeltaChiSq, double minDeltaParam, int maxIter)
  {
    _minChiSq = minChiSq;
    _minDeltaChiSq = minDeltaChiSq;
    _minDeltaParam = minDeltaParam;
    _maxIter = maxIter;
  }


  private void setArray(double[] vec, double value)
  {
    for (int i = 0; i < vec.length; i++)
    {
      vec[i] = value;
    }
  }


  private void setMatrix(Matrix matrix, double value)
  {
    for (int i = 0; i < matrix.getRowDimension(); i++)
    {
      for (int j = 0; j < matrix.getColumnDimension(); j++)
      {
        matrix.set(i, j, value);
      }
    }
  }


  private void matrixCopy(Matrix src, Matrix dest)
  {
    for (int i = 0; i < src.getRowDimension(); i++)
    {
      for (int j = 0; j < src.getColumnDimension(); j++)
      {
        dest.set(i, j, src.get(i, j));
      }
    }
  }


  private void addToDiagonal(Matrix matrix, double value)
  {
    int l = Math.min(matrix.getRowDimension(), matrix.getColumnDimension());
    for (int i = 0; i < l; i++)
    {
      matrix.set(i, i, matrix.get(i, i) + value);
    }
  }

  private void symmetricUpdate(Matrix matrix, double[] vector)
  {
    // FIXME, only need to do upper triangle
    for (int i = 0; i < matrix.getRowDimension(); i++)
    {
      for (int j = 0; j < matrix.getColumnDimension(); j++)
      {
        matrix.set(i, j, matrix.get(i, j) + vector[i] * vector[j]);
      }
    }
  }

  private void symmetricSolver(Matrix matrix, double[] vector)
  {
    // FIXME take advantage of the symmetry
    Matrix vec = new Matrix(vector.length, 1);
    for (int i = 0; i < vector.length; i++)
    {
      vec.set(i, 0, vector[i]);
    }

    Matrix solution = matrix.solve(vec);

    for (int i = 0; i < vector.length; i++)
    {
      vector[i] = solution.get(i, 0);
    }

  }

  private double squaredVectorMagnitude(double[] a)
  {
    double sum = 0.0;
    for (double v : a)
    {
      sum += v * v;
    }
    return sum;
  }

  int _m;
  int _n;
  int _maxM;
  int _maxN;

  int _nIter;
  int _MSize;
  double[] _x;
  double[] _y;

  double[] _a;

  boolean[] _nonNegativeA;

  boolean useYWeights;
  double[] _sigmaInv;

  double _chiSq;
  double _lambda;
  DifferentiableFunction _func;

  double _minChiSq;
  double _minDeltaChiSq;
  double _minDeltaParam;
  int _maxIter;

  // Following are used as temporary storage
  Matrix _H;    // a symmetric _m by _m matrix in upper triangular form
  Matrix _M;    // a symmetric _m by _m matrix in upper triangular form
  double[] _df;    // gradient of f wrt a[];
  double[] _g;     // gradient of chi squared wrt a[];
  double[] _b;     // same size as a[]
  double[] _delta; // y_i -f(a, x_i)

  public double[] get_a()
  {
    return _a;
  }

  public int get_nIter()
  {
    return _nIter;
  }


  public double get_chiSq()
  {
    return _chiSq;
  }


  public double[] get_sigmaInv()
  {
    return _sigmaInv;
  }


  public void set_sigmaInv(double[] _sigmaInv)
  {
    this._sigmaInv = _sigmaInv;
  }


  public boolean[] nonNegativeA()
  {
    return _nonNegativeA;
  }


  public void set_nonNegativeA(boolean[] _nonNegativeA)
  {
    this._nonNegativeA = _nonNegativeA;
  }


  public double get_lambda()
  {
    return _lambda;
  }

  public void set_lambda(double _lambda)
  {
    this._lambda = _lambda;
  }
}
