module ParameterFileTest

export load_parameters

function load_parameters()
    # a = 76
    # b = -1
    # This "causes the contents of the file parameters.jl to be evaluated in the global scope of the module where the include call occurs"
    # https://docs.julialang.org/en/v1/manual/code-loading/
    include("parameters.jl")

    # The names a, b, c only work if there are no local variables with the same names
    # Use ParameterFileTest.a, ... if there are local variables with the same name
    println("a: ", a)
    println("b: ", b)
    println("c: ", c)
    if c == "a string"
        # If these statements are uncommented, then the names become local and the println above tries to print an undefined value
        # a = 7
        # a = modify_value(4)
        # b = modify_value(14)
    else
        # a = modify_value(3)
        # b = modify_value(22)
    end

    println("a: ", a)
    println("b: ", b)
    println("c: ", c)

    check_local_scope()
end

function modify_value(new_value)
    return new_value
end

function check_local_scope()
    println("in check_local_scope")
    a = "local a"
    b = "local b"
    # c will default to the global value
    d = c * " appended"
    println("a: ", a)
    println("b: ", b)
    println("c: ", c)
    println("d: ", d)
end

end
