import argparse
import os
import subprocess

"""Execute the specified test executables in the and generate a report of the results"""

description = __doc__
epilog = """
"""

def parse_command_line():
    arg_parser = argparse.ArgumentParser(description = description, epilog = epilog,
                                         formatter_class = argparse.ArgumentDefaultsHelpFormatter)

    arg_parser.add_argument("-e", "--error_output",
                            default="test_errors.txt",
                            help="The name of the output file to which to write the test results")

    arg_parser.add_argument("-g", "--gtest_args",
                            default="",
                            help="Any arguments to pass to the text executables")

    arg_parser.add_argument("-d", "--directory",
                            default=".",
                            help="The root directory in which to search for the tests")

    arg_parser.add_argument("-o", "--output",
                            default="test_results.txt",
                            help="The name of the output file to which to write the test results")

    arg_parser.add_argument("-v", "--verbose",
                            action="store_true",
                            help="Write results to stdout, in addition to the results files")

    args = arg_parser.parse_args()

    return args


def find_test_execs(dir_path):
    test_execs = list()
    for entry in os.scandir(dir_path):
        if not entry.name.startswith('.') and entry.is_dir():
            test_execs.extend(find_test_execs(dir_path + os.path.sep + entry.name))
        if entry.name.startswith("Test_") and entry.name.endswith(".exe"):
            test_execs.append(dir_path + os.path.sep + entry.name)
    return test_execs


def main():
    args = parse_command_line()

    test_execs = find_test_execs(args.directory)
    print(test_execs)

    if len(test_execs) == 0:
        print("No test executables found in {} or it's sub-directories.".format(args.directory))
    n_test_cases = 0
    n_tests = 0
    n_passes = 0
    with open(args.error_output, "w") as error_file:
        with open(args.output, "w") as output_file:
            for test_exec in test_execs:
								# example of an exclusion filter
                #test_exec += " --gtest_filter=*.*-*.simple_pass*"
                if args.verbose:
                    print("Executing: {}".format(test_exec))
                # subprocess.run returns a subprocess.CompletedProcess which a byte object for stdout and stderr a
                process_result = subprocess.run(test_exec, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                stdout_lines = process_result.stdout.decode("utf-8").replace('\r\n', '\n')
                stderr_lines = process_result.stderr.decode("utf-8").replace('\r\n', '\n')
                stdout_lines_array = stdout_lines.split('\n')
                for line in stdout_lines_array:
                    if line.startswith("[==========] Running"):
                        fields = line.split(" ")
                        n_tests += int(fields[2])
                        n_test_cases += int(fields[5])
                    if line.startswith("[  PASSED  ]"):
                        fields = line.split(" ")
                        n_passes += int(fields[5])

                if process_result.returncode != 0:
                    error_file.write("Executing: {}\n".format(test_exec))                   
                    error_file.write(stdout_lines)
                    error_file.write("\n================================================================\n")

                    if args.verbose:
                        print("{} returned a non-zero error code: {}".format(test_exec, process_result.returncode))
                        print("\nstderr:")
                        print(stderr_lines)
                        print("\nstdout:")
                        print(stdout_lines)

                else:
                    if args.verbose:
                        print(stdout_lines)
                output_file.write("Executing: {}\n".format(test_exec))
                output_file.write(stdout_lines)
                output_file.write("\n================================================================\n")


            error_file.write("{} tests from {} test cases, passes: {}, failures {}\n".
                     format(n_tests, n_test_cases, n_passes, n_tests - n_passes))
            output_file.write("{} tests from {} test cases, passes: {}, failures {}\n".
                      format(n_tests, n_test_cases, n_passes, n_tests - n_passes))

    print("{} tests from {} test cases, passes: {}, failures {}".
          format(n_tests, n_test_cases, n_passes, n_tests - n_passes))

if __name__ == "__main__":
    main()