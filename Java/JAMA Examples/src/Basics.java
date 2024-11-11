import Jama.Matrix;


public class Basics
{
  static void printMat(Matrix matrix)
  {
    for (int i = 0; i < matrix.getRowDimension(); i++)
    {
      for (int j = 0; j < matrix.getColumnDimension(); j++)
      {
        System.out.print(matrix.get(i, j));
        System.out.print(" ");
      }
      System.out.println("");
    }
  }
  public static void main(String[] args)
  {
    Jama.Matrix mat1 = new Matrix(3, 3, 2.0);
    Jama.Matrix mat2 = new Matrix(3,3);
    System.out.println(mat2);
    System.out.println(mat2.getArray());
    mat2 = mat1.copy();
    System.out.println(mat2);
    System.out.println(mat2.getArray());
    printMat(mat2);
  }
}
