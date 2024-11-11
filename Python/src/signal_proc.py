"""
Signal processing methods
"""
import numpy as np

def circshift(x, shift):
    """ Implement the MATLAB concept of a circular shift with numpy.roll
    NOTE: For a single shift argument this will perform circular shift along the fastest changing dimension (rows), 
    whereas MATLAB shifts along a MATLAB array fastest changing dimension (columns) 
    """
    # Convert shift into a array if not iterable
    if not np.iterable(shift):
        shift = np.array([shift])
    
    if len(shift) == 1:
        return np.roll(x, shift, axis = 0)
    else:
        if x.ndim != len(shift):
            msg_1 = "The length of the shift argument must be one or equal to the number of dimensions of X\n"
            msg_2 = "x.ndim = {0}   len(shift) = {1}".format(x.ndim, len(shift))
            raise ValueError(msg_1 + msg_2)

        for axis, dshift in enumerate(shift):
            x = np.roll(x, dshift, axis = axis)
        
        return x
        
    
def xcorr_fd(x, y, x_first = None, x_last = None):
    """ Compute the cross-correlation sequence of the signals x and Y
    
    x, y the arrays to cross-correlate.  The origin for each signal is the FIXME
    
    x_first, x_last
    
    Returns r(j) = \sum_i x(i) * y(i - j)
    """
    
    if not x.ndim == y.ndim:
        raise ValueError("Both arrays must have the same number of dimensions")

    if x_first is None:
        x_first = np.zeros(x.ndim, dtype = np.int)
    
    if x_last is None:
        x_last = x.shape

    # Compute the lag indices and lag values requested
    lag_min = np.array(x_last) - np.array(y.shape)
    lag_max = x_first

    n_lags = lag_max - lag_min + 1
    
    Y_conj = np.conjugate(np.fft.fftn(y))
    X = np.fft.fftn(x, Y_conj.shape)
    
    r_circ = np.real(np.fft.ifftn(X * Y_conj))
    r_circ = circshift(r_circ, -lag_min)
    
    if x.ndim == 1:
        r = r_circ[0:n_lags]
        lags = range(lag_min, lag_max + 1)
    elif x.ndim == 2:
        r = r_circ[0:n_lags[0], 0:n_lags[1]]
        lags = [range(lag_min[0], lag_max[0] + 1), range(lag_min[1], lag_max[1] + 1)] 
    else:
        raise NotImplementedError("Implement for dimensions > 2")
    return r, lags


def lenxcorr(x, y, x_first = None, x_last = None, conj_Y_sq = None):
    """ Compute the local energy normalized cross correlation sequence
        
        x,y    the n-dimensional signals to be cross-correlated
        
        x_first
        
        x_last
        
        conj_Y_sq
        
        Returns:
        r the local energy normalized cross correlation sequence
        l the lag value for each element of r
    """
    if not x.ndim == y.ndim:
        raise ValueError("Both arrays must have the same number of dimensions")

    if x_first is None:
        x_first = np.zeros(x.ndim, dtype = np.int)
    
    if x_last is None:
        x_last = np.array(x.shape)

    mask = np.zeros_like(x)
    
    # Compute the cross-correlation sequence and the mask
    if x.ndim == 1:
        ccs, lags = xcorr_fd(x, y, x_first, x_last)
        mask[x_first[0]:x_last[0]] = 1
    
    elif x.ndim == 2:
        ccs, lags = xcorr_fd(x, y, x_first, x_last)
        mask[x_first[0]:x_last[0], x_first[1]:x_last[1]] = 1

    else:
        raise NotImplementedError("Implement for dimensions > 2")
    
    if np.all(np.isreal(y)):
        y_nrg, junk = xcorr_fd(mask, y ** 2, x_first, x_last)
        y_nrg = np.abs(y_nrg)
    else:
        if conj_Y_sq is None:
            conj_Y_sq = np.conj(y ** 2)
            
        y_nrg = np.abs(xcorr_fd(mask, conj_Y_sq, x_first, x_last))
    
    if np.all(np.isreal(x)):
        x_nrg = np.sum(x ** 2)
    else:
        x_nrg = np.sum(x * np.conj(x)) / x.size
    
    r = ccs / np.sqrt(x_nrg * y_nrg)
    
    return r, lags
        
    
