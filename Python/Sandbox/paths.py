import os.path
import os

if __name__ == "__main__":
    cwd = os.getcwd()
    print(cwd)
    print(os.path.basename(cwd))
    head, tail = os.path.split(cwd)
    print("Head: " + head)
    print("Tail: " + tail)

    home = "h:/users/rick"
    print(home)
    print(os.path.basename(home))
    head, tail = os.path.split(home)
    print("Head: " + head)
    print("Tail: " + tail)

    nc_home = os.path.normpath(home)
    print(nc_home)

    home_tr = "h:/users/rick/"
    print(home_tr)
    # Trailing slash causes basename to return an empty string
    print(":" + os.path.basename(home_tr) + ":")
    head, tail = os.path.split(home_tr)
    print("Head: " + head)
    print("Tail: " + tail)

    nc_home_tr = os.path.normpath(home_tr)
    print(nc_home_tr)
