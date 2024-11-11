
function load_parameters()
    # This "causes the contents of the file parameters.jl to be evaluated in the global scope of the module where the include call occurs"
    # https://docs.julialang.org/en/v1/manual/code-loading/
    include("parameters.jl")
    # global a, b, c
    # println("a: ", a)
    # println("b: ", b)
    # println("c: ", c)
    if c == "a string"
        # If these statements are uncommented, then the names become local and the println below tries to print an
        # undefined value, unless they are declared global
        a = 7
        a = modify_value(4)
        b = modify_value(14)
    else
        # a = modify_value(3)
        b = modify_value(22)
    end

    println("a: ", a)
    println("b: ", b)
    println("c: ", c)
end

function modify_value(new_value)
    return new_value
end

load_parameters()
