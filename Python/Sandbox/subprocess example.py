import subprocess

def main():
    cmd_line = ['getmac.exe', '/V']
    try:
        # proc = subprocess.run(cmd_line,
        #                       check=True,
        #                       stdout=subprocess.PIPE,
        #                       stderr=subprocess.STDOUT)
        proc = subprocess.run(cmd_line,
                              check=True,
                              stdout=subprocess.PIPE)
    except subprocess.CalledProcessError as ex:
        print(ex)
        print("=====================================================================")
        if ex.stdout:
            print(ex.stdout.decode("utf-8"))
        else:
            print("stdout is None")
        print("=====================================================================")
        if ex.stderr:
            print(ex.stderr.decode("utf-8"))
        else:
            print("stderr is None")
        sys.exit(1)
    log_file = 'subprocess example.log'
    # Without setting newline to '\n' each line has two \r\n
    with open(log_file, "w", newline='\n') as file:
        output = proc.stdout.decode("utf-8")
        # Why does the output have double \r\n
        #output = output.replace('\r\l', '\n')
        file.write(output)

if __name__ == "__main__":
    main()