module MyTypes

export MyType

using SparseArrays

struct MyType
    value::Int
    s_array::SparseMatrixCSC
end

end

