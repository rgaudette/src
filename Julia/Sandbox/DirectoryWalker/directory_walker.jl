"""
    find_starts_with(path::String, starts_with::String, found=nothing)

Find all files whos name start with the given argument.

Returns: Dict{String, Vector{String}} - with pathnames as the key and a Vector of filenames as the value
"""

function find_starts_with(path::String, starts_with::String, found=nothing)
    # First time through, create the found dictionary
    if found === nothing
        found = Dict{String, Vector{String}}()
    end

    println("walking: ", path)
    found_in_files = false
    for (pathname, dirs, files) in walkdir(path)
        println("  pathname: ", pathname)

        println("  files: ", files)
        # Search files first since we only want to find the first instance in each directory branch
        for filename in files
            println("  analyzing: ", filename)
            if startswith(filename, starts_with)
                println("  match filename : ", filename, " in ", pathname)
                if haskey(found, pathname)
                    push!(found[pathname], filename)
                else
                    found[pathname] = [filename]
                end
                search_deeper = false 
                println("  added entry, exiting call")
                break  
            end
        end
    end
    println("done walking: ", path)
    return found
end

root = raw"C:\Users\rick\temp\dataset_name\dataset_subname\irpLog"
found = find_starts_with(root, "cam_00_00")
for (pathname, files) in found
    println(pathname)
    for file in files
        print("  ", file)
        test_path = joinpath(root, pathname, file)
        if ispath(test_path)
            println(" exists")
        else
            println(" DOES NOT EXIST")
        end
    end
end
