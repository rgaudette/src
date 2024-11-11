function parallel_array_fill_for(array)
    blk_start = Int((Threads.threadid() - 1) / Threads.nthreads() * length(array)) + 1
    # println(Threads.threadid(), " blk_start: ", blk_start)
    # # TODO: handle remainder of array, non multiple of nthreads
    blk_size = Int(length(array) / Threads.nthreads())
    blk_stop = blk_start + blk_size - 1
    # println(Threads.threadid(), " blk_stop: ", blk_stop)
    for idx = blk_start:blk_stop
        array[idx] = Threads.threadid()
    end
end


function parallel_array_fill_broadcast(array)
    blk_start = Int((Threads.threadid() - 1) / Threads.nthreads() * length(array)) + 1
    # println(Threads.threadid(), " blk_start: ", blk_start)
    # # TODO: handle remainder of array, non multiple of nthreads
    blk_size = Int(length(array) / Threads.nthreads())
    blk_stop = blk_start + blk_size - 1
    # println(Threads.threadid(), " blk_stop: ", blk_stop)
    array[blk_start:blk_stop] .= Threads.threadid()
end


n_blocks = 2_000_000_000 ÷ 4

# Ensure the n_blocks is evenly divisible by Threads.nthreads() for now
n_blocks = (n_blocks ÷ Threads.nthreads()) * Threads.nthreads()

b = zeros(n_blocks * Threads.nthreads())

print("Filling array...")
Threads.@threads for i = 1:8
    # b[i] = Threads.threadid()
    parallel_array_fill_broadcast(b)
end
println("done")

# println(b)

println("Checking result...")
for idx = 1:length(b)
    if b[idx] != ceil(idx/ n_blocks)
        println("b[idx]: ", b[idx],  " ceil(idx/ n_blocks)", ceil(idx/ n_blocks))
        break
    end
end
println("done")


