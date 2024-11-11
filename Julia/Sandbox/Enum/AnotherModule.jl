using MyEnumModule

module AnotherModule

function another_module_function(an_enum_argument)
    println("an_enum_argument: ", an_enum_argument)
end

another_module_function(red)
end
