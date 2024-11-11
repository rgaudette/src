module MyUtils
export append_load_path, ls, mark_console, secs2hm, find_dependent_packages

using Pkg
using Printf

"""
    append_load_path(path)  append the specified path to the Julia LOAD_PATH if it is not already in the list

    path   can either be absolute or relative as realpath will be applied to it
"""
function append_load_path(path)
    dir_path = realpath(path)

    found = false
    for load_path in LOAD_PATH
        if dir_path == load_path
            found = true
        end
    end
    if !found
        push!(LOAD_PATH, dir_path)
    end
end


"""
    mark_console(lines = 3, character = "=", nchars=80)

    mark the console with a number of lines of repeated characters, to help with scanning the console
"""
function mark_console(lines = 3, character = "=", nchars=80)
    for i = 1:lines
        println(character^nchars)
    end
end

 function secs2hm(secs)
       tm = secs / 60
       h = div(tm, 60)
       m = tm - h * 60
       @printf("%02d:%02d\n", h, m)
       return h,m
 end

"""
"""
function ls(dir = pwd())
    entries = readdir(dir)
    for entry in entries
        println(entry)
    end
end


function find_dependent_packages(package_name)
    dependencies_dict = Pkg.dependencies()
    # find the package UUID by searching through the dependencies_dict
    dependents_dict = Dict()
    for (uuid, package_info) in dependencies_dict
        # println(uuid, " ", package_info.name)
        if package_info.name == package_name
            println(uuid, " ", package_info.name)
            println(package_info.dependencies)
        end
        if haskey(package_info.dependencies, package_name)
            dependents_dict[package_info.name] = package_info.dependencies[package_name]
        end
    end

    println(dependents_dict)

end

end
