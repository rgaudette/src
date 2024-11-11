
import numpy as np

if __name__ == "__main__":

    # Save/load a single array to/from a file 
    int32_array = np.arange(0, 12).reshape(3,4)
    np.save("simple.npy", int32_array)
    int32_load = np.load("simple.npy")
    print int32_load
    print int32_load.dtype
    
    # Save/load multiple arrays to/from a file
    
    float64_array = np.random.normal(size = (5,4))

    # This object will be saved as numpy zero rank array or array scalar
    int_slice = slice(1,3)

    np.savez("simple.npz",
             first_array = int32_array,
             second_array = float64_array,
             third_object = int_slice)

    npzfile = np.load("simple.npz")
    print("Arrays:")
    print npzfile.files
    
    int32_load = npzfile['first_array']
    print int32_load
    print int32_load.dtype

    float64_load = npzfile['second_array']
    print float64_load
    print float64_load.dtype

    #  Need to use the array.item() function to get at the slice
    int_slice_load = npzfile['third_object'].item()
    print int_slice
    print int_slice_load
    print type(int_slice_load)

    # try using the slice for indexing
    print int32_load[:, int_slice_load]
    print float64_load[:, int_slice_load]