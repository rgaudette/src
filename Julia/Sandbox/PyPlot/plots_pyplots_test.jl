using Plots

pyplot()
# f = figure()
r = 1:10
p1 = plot(r)
xlabel!("X label")
ylabel!("Y label")
display(p1)
println("Enter for next plot ...")
readline()
p2 = plot(r.^2)
display(p2)
println("Enter to quit...")
readline()
