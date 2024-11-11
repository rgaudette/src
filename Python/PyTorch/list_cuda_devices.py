import torch

# Check if CUDA is available
if torch.cuda.is_available():
    print("CUDA is available.")

    # Get the number of available CUDA devices
    device_count = torch.cuda.device_count()
    print(f"Number of available CUDA devices: {device_count}")

    # Get the current default device
    default_device = torch.cuda.current_device()
    print(f"Current default CUDA device: {default_device}")

    for i in range(device_count):
        print(f"\nCUDA device {i}:")
        device_name = torch.cuda.get_device_name(i)
        print(f"  Name: {device_name}")

        compute_capability = torch.cuda.get_device_capability(i)
        print(f"  Compute Capability: {compute_capability[0]}.{compute_capability[1]}")

        device_properties = torch.cuda.get_device_properties(i)
        print(f"  Total Memory: {device_properties.total_memory / (1024 ** 2):.2f} MB")
        print(f"  Multi-processor (SMI) count: {device_properties.multi_processor_count}")

    # Set the desired CUDA device (e.g., device 1)
    desired_device = 0
    if desired_device < device_count:
        torch.cuda.set_device(desired_device)
        print(f"Set CUDA device to {desired_device}")

        # Now, when you create a tensor, you can use the .cuda() method to move it to the GPU
        x = torch.tensor([1.0, 2.0, 3.0]).cuda()
        print(x)

    else:
        print(f"Desired device index ({desired_device}) is out of range. Maximum index is {device_count - 1}.")
else:
    print("CUDA is not available on this system.")
