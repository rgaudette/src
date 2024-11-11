module MyTest

export MyStruct, my_print, load_file_into_module_global_scope

struct MyStruct
    a::Int
    b::Float64
end

function my_print(ms::MyStruct)
    println("LOAD_PATH: ", LOAD_PATH)
    println("a: ", ms.a)
    println("b: ", ms.b)
end

tp1 = nothing
tp2 = nothing
tp3 = nothing

function load_file_into_module_global_scope(filename)
    println("loading from:", filename)
    include(filename)
    println("load_file_into_module_global_scope tp1: ", tp1)
    println("load_file_into_module_global_scope tp2: ", tp2)
end

end

module MyTest2
struct MyStruct2
    a::Int
    b::Float64
end
include("MyTest2_names.jl")
end
