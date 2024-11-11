import sys


def main():
    if len(sys.argv) == 1:
        print("no filename argument present")
        sys.exit(-1)

    with open(sys.argv[1], "r") as file:
        line = file.readline()
        tokens = line.split(" ")
        decision_vars = [ float(x) for x in tokens]
        print(decision_vars[0] + decision_vars[1], decision_vars[0] - decision_vars[1], decision_vars[0] + decision_vars[1])

if __name__ == "__main__":
    main()