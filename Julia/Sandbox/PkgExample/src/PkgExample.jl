module PkgExample
    struct Point_2D{T<:Real}
        x::T
        y::T
    end

    struct Labeled_Point_2D{T<:Real}
        label::String
        pos::Point_2D
    end
    export Point_2D, Labeled_Point_2D
end # module
