"""
Created on Dec 7, 2009

@author: Rick Gaudette
"""
import matplotlib.pyplot as plt
import numpy as np
import scipy.linalg as spla

def compute_l_curve_1(A, b):
    U, s, Vh = spla.svd(A)
    print s
    n_sv = len(s)
    x_hat = np.zeros((n_sv, 1))
    residual_norm = np.zeros((n_sv, 1))
    solution_norm = np.zeros((n_sv, 1))
    for idx in range(0, n_sv):
        sigma_inv = 1 / s[idx]
        su_row = sigma_inv * U[:,idx].transpose()
        v_col = Vh[idx, :].transpose()
        m1 = np.outer(v_col, su_row)
        v1 = np.dot(m1, b)
        x_hat = x_hat + v1
        residual_norm[idx] = spla.norm(np.dot(A, x_hat) - b)
        solution_norm[idx] = spla.norm(x_hat)
    
    return residual_norm, solution_norm

def compute_l_curve_2(A, b):
    U, s, Vh = spla.svd(A)
    n_sv = len(s)
    ut_b = np.dot(U.transpose(), b)
    V = Vh.transpose()
    # Broadcast multiply the elements of across the columns of V
    V_SIGMA_INV = V * (1 / s)

    residual_norm = np.zeros((n_sv, 1))
    solution_norm = np.zeros((n_sv, 1))
    for idx in range(0, n_sv):
        x_hat = np.dot(V_SIGMA_INV[:, 0:idx], ut_b[0:idx])
        residual_norm[idx] = spla.norm(np.dot(A, x_hat) - b)
        solution_norm[idx] = spla.norm(x_hat)

    return residual_norm, solution_norm



def scaled_sv(dim, spectral_range):
    z = np.random.rand(dim[0], dim[1])
    U,s,Vh = spla.svd(z)
    new_s = np.exp(-1 * np.linspace(spectral_range[0], spectral_range[1], len(s)))
    
    return np.dot(np.dot(U[:,0:dim[1]], spla.diag(new_s)), Vh)


if __name__ == "__main__":
    m = 500
    n = 200
    A = scaled_sv((m, n), (1, 10))
    b = np.random.rand(m, 1)
    residual_norm_1, solution_norm_1 = compute_l_curve_1(A, b)
    residual_norm_2, solution_norm_2 = compute_l_curve_2(A, b)
    plt.figure()
    plt.plot(np.log(residual_norm_1), np.log(solution_norm_1), 'b')
    plt.plot(np.log(residual_norm_2), np.log(solution_norm_2), 'r')
    plt.show()
    