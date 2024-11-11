/**********************************************************************/
/** cmd_line_ex  a simple example of handling command line arguments **/
/**                                                                  **/
/** usage: cmd_line_ex arg1 arg2 arg3 arg4                           **/
/**                                                                  **/
/**                                                                  **/
/** cmd_line_ex read in the arguments on the command line and prints **/
/** them out.  As an example of the system function it then trys to  **/
/** run the arguments as a command                                   **/
/**                                                                  **/
/**********************************************************************/
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  int iArg, return_value;
  char strNewCommand[1024];

  //
  //  Print out the number of arguments
  //
  printf("Number of arguments, including the command itself: %d\n", argc);

  //
  //  Print out each of the arguments
  //
  for(iArg=0; iArg<argc; iArg++) {
    printf("Command line argument %d is %s\n", iArg, argv[iArg]);
  }

  //
  // An example of the `system' command FYI, first concatenate all of the
  // command line arguments (except the orginal command) into a single
  // string.
  //
  strNewCommand[0] = 0;
  for(iArg=1; iArg<argc; iArg++) {
    strcat(strNewCommand, argv[iArg]);
    strcat(strNewCommand, " ");
  }
  
  printf("Trying to execute: %s\n", strNewCommand);

  return_value = system(strNewCommand);

  printf("system return value %d\n", return_value);

  if(return_value == 127) {
    printf("execve() failed\n");
  }

  if(return_value == -1) {
    printf("some unknown error\n are the arguments on the command line really a  valid command?\n");
  }


}

