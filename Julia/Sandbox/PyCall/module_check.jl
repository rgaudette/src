module AModule
@time using PyCall
@time py_numpy = pyimport("numpy.version")

function a_function()
    println(py_numpy.full_version)
end

end

AModule.a_function()
