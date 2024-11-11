abstract type Ex_struct end

struct Imm_struct <: Ex_struct
    a::Int64
    b::Float64
end

function set_imm_struct(imm_struct::Imm_struct, a::Int64, b::Float64)
    imm_struct.a = a
    imm_struct.b = b
end

mutable struct Mut_struct <: Ex_struct
    a::Int64
    b::Float64
end

function set_mut_struct!(imm_struct::Mut_struct, a::Int64, b::Float64)
    imm_struct.a = a
    imm_struct.b = b
end

function copy_struct(ex_struct::Ex_struct)
    new_struct = Mut_struct(ex_struct.a, ex_struct.b)
end
