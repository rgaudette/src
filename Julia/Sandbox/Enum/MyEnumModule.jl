module MyEnumModule
export MyEnum, red, green, blue

@enum MyEnum red green blue

struct MyStruct
    a::Integer
end

function my_enum(an_enum_argument::MyEnum = red)
    println("an_enum_argument: ", an_enum_argument)
end

println("Calling my_num with green")
my_enum(green)

end
