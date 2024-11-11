# run this using the statement include("write_local_enums.jl") or includet("write_local_enums.jl")
module TestEnum
using JLD
@enum AnEnum VAL1 VAL2 VAL3

function test_enum()
    enum_instance = VAL3
    # Save the results to a JLD file
    output_file = "test enums.jld"

    jldopen(output_file, "w", compress = true) do file
        write(file, "enum_instance", enum_instance)
    end

    jld_dict = load(output_file)
    println(jld_dict)
    loaded_enum_instance = jld_dict["enum_instance"]
    println(loaded_enum_instance)
    println(typeof(loaded_enum_instance))
end

test_enum()
end

