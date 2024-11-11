using OSQP
using SparseArrays
using Printf

# OSQP solves quadratic programs of the form
#
#   minimize 0.5 x^T P x + q^T x
#   subject to l ≤ Ax ≤ u
#
#  where x ∈ 𝐑^n
#
# The objective function is specified by the positive semi-definite matrix P ∈ 𝐒^n_+ and
# the vector q ∈ 𝐑^n
#
# The linear constraint are defined by the matrix A ∈ 𝐑^mxn and vectors l and u such that l_i ∈ 𝐑 𝖴 {+∞}
# and u_i ∈ 𝐑 𝖴 {+∞}

# using the ADMM algorithm

# Define problem data
P = sparse([4.0 1.0; 1.0 2.0])
q = [1.0; 1.0]
A = sparse([1.0 1.0; 1.0 0.0; 0.0 1.0])
l = [1.0; 0.0; 0.0]
u = [1.0; 0.7; 0.7]

# Crate OSQP object
prob = OSQP.Model()

# Setup workspace and change alpha parameter
OSQP.setup!(prob; P = P, q = q, A = A, l = l, u = u, alpha = 1)

# Solve problem
results = OSQP.solve!(prob)
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
@printf("Optimal rho estimate: %f\n", results.info.rho_estimate)
@printf("# of rho updates: %d\n\n", results.info.rho_updates)

@printf("Primal solution: %s\n", results.x)
@printf("Primal infeasibility certificate: %s\n", results.prim_inf_cert)
@printf("Primal residual: %s\n\n", results.info.pri_res)

@printf("Dual solution: %s\n", results.y)
@printf("Dual infeasibility certificate: %s\n", results.dual_inf_cert)
@printf("Dual residual: %s\n", results.info.dua_res)
