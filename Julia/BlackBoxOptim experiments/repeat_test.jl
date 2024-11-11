using BlackBoxOptim
using Printf
using PyPlot

function rosenbrock2d(x)
    return (1.0 .- x[1]).^2 + 100.0 .* (x[2] .- x[1].^2).^2
end

function rastrigin(x)
    return 20 .+ x[1].^2 .+ x[2].^2 .- 10 * (cos.(2 .* pi .* x[1]) .+ cos.(2 .* pi .* x[2]))
end

function rosen_rastrigin(x)
    # shift the rosenbrock function so that it minimum aligns with with rastrigin minimum at 0,0
    return rosenbrock2d(x .+ [1.0, 1.0]) + 10 * rastrigin(x)
end

function draw_function(cost_function)
    # Define the ranges
    x = -2:0.05:2
    y = -1:0.05:3

    # Create the meshgrid
    X = repeat(collect(x)', length(y), 1)
    Y = repeat(collect(y), 1, length(x))
    Z = cost_function([X, Y])

    plt.figure(figsize=(8, 6))
    levels=collect(10 .^ range(-1, log10(maximum(Z)), 50))
    cp = plt.contourf(X, Y, Z, levels=levels) #, cmap="jet')
    plt.colorbar(cp)
    plt.xlabel("X")
    plt.xlabel("Y")
    plt.title("rosenbrock2d(x) + 10 * rastrigin(x)")
    plt.show()
end

draw_function(rastrigin)

#Methods = :adaptive_de_rand_1_bin_radiuslimited, :generating_set_search, :separable_nes, :xnes, :random_search, :simultaneous_perturbation_stochastic_approximation

search_space = ContinuousRectSearchSpace([-2.0, -1.0], [2.0, 3.0])
fitness_scheme = MinimizingFitnessScheme # MaximizingFitnessScheme

rastrigin_maximization_problem = FunctionBasedProblem(rastrigin, "rastrigin_maximize", MaximizingFitnessScheme, search_space)
rosenbrock2d_problem = FunctionBasedProblem(rosenbrock2d, "rosenbrock", fitness_scheme, search_space, 1.0)

optimization_result = bboptimize(rastrigin_maximization_problem;
    NumDimensions=2,
    Method=:generating_set_search,
    MaxTime=0.0,
    # MaxSteps=20,
    MinDeltaFitnessTolerance=1e-7,
    NumRepetitions=100,
    MaxStepsWithoutProgress=100,
    problem_name = "rosen_rastrigin",
    TraceMode=:verbose,
    SaveFitnessTraceToCsv=false,
    SaveParameters=true)
println("best_fitness: ", best_fitness(optimization_result))
candidate = best_candidate(optimization_result)
@printf("best candidate: %.2f, %.2f", candidate[1], candidate[2])

# num_repeats = 1
# num_dims = 2
# max_time = 3600
# min_delta_fitness_tolerance = 1e-7
# extra_params = ParamsDict(:TraceMode => :verbose)

# BlackBoxOptim.repeated_bboptimize(num_repeats, rosenbrock2d_problem, num_dims, [:generating_set_search], max_time, min_delta_fitness_tolerance)

