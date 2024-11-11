
class MyClass(object):
    a = 0.0
    b = 0.0

    def load_from_file(self, filename):
        with open(filename) as text_file:
            line = text_file.readline()
            while line:
                tokens = line[:-1].split("=")
                setattr(self, tokens[0].strip(), eval(tokens[1].strip()))
                line = text_file.readline()


def main():
    my_class = MyClass()
    print my_class.a
    print my_class.b
    my_class.load_from_file("class.txt")
    print my_class.a
    print my_class.b


if __name__ == "__main__":
    main()