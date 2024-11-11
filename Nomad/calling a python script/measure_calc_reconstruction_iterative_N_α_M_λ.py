import sys


def main():
    if len(sys.argv) == 1:
        print("no filename argument present")
        sys.exit(-1)

    with open(sys.argv[1], "r") as file:
        line = file.readline()
        tokens = line.split(" ")
        if len(tokens) != 4:
            print("Expected a tag and 2 decisions variables, got ", 
                len(tokens), " in file", sys.argv[1], file=sys.stderr)
            print(line, file=sys.stderr)
            sys.exit(1)
    print(line, file=sys.stderr)
    print(float(tokens[2]) + float(tokens[3]), float(tokens[2]) - float(tokens[3]), 
            float(tokens[2]) + float(tokens[3]))

if __name__ == "__main__":
    main()