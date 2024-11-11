using LinearAlgebra
using Printf
using Random
using SparseArrays
using Statistics

using OSQP


function osqp_least_squares(
    A,
    b;
    x_true = nothing,
    verbose = false,
    n_print_limit = 20,
    max_iter = 4000,
)
    m, n = size(A)
    P = vcat(spzeros(n, m + n), hcat(spzeros(m, n), sparse(I, m, m)))
    if verbose && n + m < n_print_limit
        @printf("P:%s\n", P)
    end

    q = zeros(n + m)

    A_model = vcat(hcat(A, -sparse(I, m, m)), hcat(sparse(I, n, n), spzeros(n, m)))
    if verbose && n + m < n_print_limit
        @printf("A_model:%s\n", A_model)
    end

    l = vcat(b, zeros(n))
    u = vcat(b, Inf * ones(n))

    if verbose && n < n_print_limit
        @printf("l: %s\n", l)
        @printf("u: %s\n", u)
    end

    # Create OSQP object
    osqp_model = OSQP.Model()

    # Setup workspace and change alpha parameter
    OSQP.setup!(osqp_model; P = P, q = q, A = A_model, l = l, u = u, max_iter = max_iter)

    # Solve problem
    results = OSQP.solve!(osqp_model)

    if verbose
        @printf("OSQP result\n")
        @printf("==================================================\n")
        @printf("Solver status: %s\n", results.info.status)
        @printf("Iterations: %d\n", results.info.iter)
        @printf("Solver status value: %s\n", results.info.status_val)
        @printf("Polishing statis: %s\n", results.info.status_polish)
        @printf("Setup time: %g\n", results.info.setup_time)
        @printf("Solve time: %g\n", results.info.solve_time)
        @printf("Update time: %g\n", results.info.update_time)
        @printf("Polish time: %g\n", results.info.polish_time)
        @printf("Total run time: %g\n", results.info.run_time)
        @printf("Objective value: %s\n", results.info.obj_val)
        @printf("Optimal rho estimate: %s\n", results.info.rho_estimate)
        @printf("# of rho updates: %d\n\n", results.info.rho_updates)

        @printf("Primal residual: %g\n", results.info.pri_res)
        @printf("Dual residual: %g\n\n", results.info.dua_res)

        if n < 20
            @printf("x_true: %s\n", x_true)

            @printf("Primal solution: %s\n", results.x)
            @printf("Primal infeasibility certificate: %s\n", results.prim_inf_cert)


            @printf("Dual solution: %s\n", results.y)
            @printf("Dual infeasibility certificate: %s\n", results.dual_inf_cert)
        end
    end


    x_est = results.x[1:n]
    if verbose && !isnothing(x_true)
        rmse = sqrt(mean((x_est - x_true) .^ 2))
        @printf("RMSE: %g\n", rmse)
    end

    if verbose
        println()
    end

    return x_est, results
end


# A small, identity model least squares problem
println("A small, identity model least squares problem")
println("==================================================================")
m = 5
n = m
A = sparse(I, m, n)
x_true = rand(n) * 10.0
b = A * x_true
x_est, results = osqp_least_squares(A, b; x_true = x_true, verbose = true)

b_est = A * x_est
residual_rmse = sqrt(mean((b_est - b) .^ 2))
@printf("Residual RMSE: %g\n", residual_rmse)

println("")


# A small smoothed least squares problem
println("A small, identity model least squares problem")
println("==================================================================")
Afull = [
    0.0 0.0 1.0
    0.0 1.0 2.0
    1.0 2.0 1.0
    2.0 1.0 0.0
    1.0 0.0 0.0
]
m, n = size(Afull)

A = sparse(Afull)
x_true = rand(n) * 10.0
b = A * x_true
x_est, results = osqp_least_squares(A, b; x_true = x_true, verbose = true)

b_est = A * x_est
residual_rmse = sqrt(mean((b_est - b) .^ 2))
@printf("Residual RMSE: %g\n", residual_rmse)

println("")


# A small under determined least squares problem
println("A small under determined least squares problem")
println("==================================================================")
Afull = [
    0.0 0.0 1.0 2.0 1.0
    0.0 1.0 2.0 1.0 0.5
    1.0 2.0 1.0 0.5 0.0
]
m, n = size(Afull)

A = sparse(Afull)
x_true = rand(n) * 10.0
b = A * x_true
x_est, results = osqp_least_squares(A, b; x_true = x_true, verbose = true)
println("")

b_est = A * x_est
residual_rmse = sqrt(mean((b_est - b) .^ 2))

@printf("Residual RMSE: %g\n", residual_rmse)
