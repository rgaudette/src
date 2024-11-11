using Logging
using Printf

ENV["JULIA_DEBUG"] = "all"

# Logging.global_logger(SimpleLogger)
val_0 = 2.0
@debug val_0
val_1 = π
@debug "_val_1_" val_1
val_2 = val_1 + val_0
@debug(@sprintf("*val*_2: %f", val_2))

val_0 = 2.0
@warn val_0
val_1 = π
@warn "val_1 (π:)" val_1
val_2 = val_1 + val_0
@warn @sprintf("using sprintf val_2: %f", val_2)

@info begin
    @printf("This is an info block\n")
    @printf("We can execute multiple statements and format values in this block\n")
    "The last string is on the info line"
end

@error "This is an error log entry"
