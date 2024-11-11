# add this directory to the LOAD_PATH if necessary
using MyUtils
append_load_path(@__DIR__)

using MyTest

# call this script with the argument test.params
load_file_into_module_global_scope("test.params")

println("MyTest names:")
my_test_names = names(MyTest, all = true)
for name in my_test_names
    println(name)
end
println("")

println("Values of included variables:")
println("MyTest.tp1: ", MyTest.tp1)
println("MyTest.tp2: ", MyTest.tp2)
println("MyTest.tp3: ", MyTest.tp3)
