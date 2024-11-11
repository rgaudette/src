public class ProcessException extends RuntimeException {
  String strReturnVal = "";

  public ProcessException(int exitValue) {
    strReturnVal = String.valueOf(exitValue);
  }

  public String getMessage(){
    return "Program return value: " + strReturnVal;
  }
}