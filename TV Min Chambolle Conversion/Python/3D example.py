""" A simple 3D example of Chambolle based TV minimization using the scikit.image.restoration code and a simpler
indexed version.  This was to validate the simpler implementation."""

import numpy as np
import numpy.random as nprand
import numpy.testing as nptest


def main() -> None:
    np.set_printoptions(precision=6)
    np.set_printoptions(linewidth=120)

    nprand.seed(0)

    simple_rand_im_3d = nprand.rand(3, 4, 5)

    simple_rand_im_3d = np.arange(3 * 4 * 5.0)
    simple_rand_im_3d.shape = (3, 4, 5)
    n_iter = 2
    denoised = denoise_tv_chambolle(simple_rand_im_3d, weight=0.1, n_iter_max=n_iter, eps=0.0)
    denoised_3D = _denoise_tv_chambolle_3D(simple_rand_im_3d, weight=0.1, n_iter_max=n_iter)
    print(denoised_3D)
    try:
        nptest.assert_array_equal(denoised, denoised_3D)
    except AssertionError as ae:
        print("Comparing slice and simple indexing based denoise_tv_chambolle: {}".format(ae))
    else:
        print("Both volumes are equal.")


def denoise_tv_chambolle(im: np.ndarray,
                         weight: float = 0.1,
                         eps: float = 2.e-4,
                         n_iter_max: int = 200,
                         multichannel: bool = False) -> np.ndarray:
    """Perform total-variation denoising on n-dimensional images.

    Parameters
    ----------
    im : ndarray of ints, uints or floats
        Input data to be denoised. `im` can be of any numeric type,
        but it is cast into an ndarray of floats for the computation
        of the denoised image.
    weight : float, optional
        Denoising weight. The greater `weight`, the more denoising (at
        the expense of fidelity to `input`).
    eps : float, optional
        Relative difference of the value of the cost function that
        determines the stop criterion. The algorithm stops when:

            (E_(n-1) - E_n) < eps * E_0

    n_iter_max : int, optional
        Maximal number of iterations used for the optimization.
    multichannel : bool, optional
        Apply total-variation denoising separately for each channel. This
        option should be true for color images, otherwise the denoising is
        also applied in the channels dimension.

    Returns
    -------
    out : ndarray
        Denoised image.

    Notes
    -----
    Make sure to set the multichannel parameter appropriately for color images.

    The principle of total variation denoising is explained in
    http://en.wikipedia.org/wiki/Total_variation_denoising

    The principle of total variation denoising is to minimize the
    total variation of the image, which can be roughly described as
    the integral of the norm of the image gradient. Total variation
    denoising tends to produce "cartoon-like" images, that is,
    piecewise-constant images.

    This code is an implementation of the algorithm of Rudin, Fatemi and Osher
    that was proposed by Chambolle in [1]_.

    References
    ----------
    .. [1] A. Chambolle, An algorithm for total variation minimization and
           applications, Journal of Mathematical Imaging and Vision,
           Springer, 2004, 20, 89-97.

    Examples
    --------
    2D example on astronaut image:

    >>! from skimage import color, data
    >>! img = color.rgb2gray(data.astronaut())[:50, :50]
    >>! img += 0.5 * img.std() * np.random.randn(*img.shape)
    >>! denoised_img = denoise_tv_chambolle(img, weight=60)

    3D example on synthetic data:

    >>! x, y, z = np.ogrid[0:20, 0:20, 0:20]
    >>! mask = (x - 22)**2 + (y - 20)**2 + (z - 17)**2 < 8**2
    >>! mask = mask.astype(np.float)
    >>! mask += 0.2*np.random.randn(*mask.shape)
    >>! res = denoise_tv_chambolle(mask, weight=100)

    """

    im_type = im.dtype
    if not im_type.kind == 'f':
        im = img_as_float(im)

    if multichannel:
        out = np.zeros_like(im)
        for c in range(im.shape[-1]):
            out[..., c] = _denoise_tv_chambolle_nd(im[..., c], weight, eps, n_iter_max)
    else:
        out = _denoise_tv_chambolle_nd(im, weight, eps, n_iter_max)
    return out


def _denoise_tv_chambolle_nd(im: np.ndarray, weight: float = 0.1, eps: float = 2.e-4,
                             n_iter_max: int = 200) -> np.ndarray:
    """Perform total-variation denoising on n-dimensional images.

    Parameters
    ----------
    im : ndarray
        n-D input data to be denoised.
    weight : float, optional
        Denoising weight. The greater `weight`, the more denoising (at
        the expense of fidelity to `input`).
    eps : float, optional
        Relative difference of the value of the cost function that determines
        the stop criterion. The algorithm stops when:

            (E_(n-1) - E_n) < eps * E_0

    n_iter_max : int, optional
        Maximal number of iterations used for the optimization.

    Returns
    -------
    out : ndarray
        Denoised array of floats.

    Notes
    -----
    Rudin, Osher and Fatemi algorithm.

    """

    ndim = im.ndim
    p = np.zeros((im.ndim,) + im.shape, dtype=im.dtype)
    g = np.zeros_like(p)
    d = np.zeros_like(im)
    i = 0
    while i < n_iter_max:
        if i > 0:
            # d will be the (negative) divergence of p
            d = -p.sum(0)
            slices_d = [slice(None), ] * ndim
            slices_p = [slice(None), ] * (ndim + 1)
            for ax in range(ndim):
                slices_d[ax] = slice(1, None)
                slices_p[ax + 1] = slice(0, -1)
                slices_p[0] = ax
                d[slices_d] += p[slices_p]
                slices_d[ax] = slice(None)
                slices_p[ax + 1] = slice(None)
            out = im + d
        else:
            out = im
        E = (d ** 2).sum()

        # g stores the gradients of out along each axis
        # e.g. g[0] is the first order finite difference along axis 0
        # RJG: calculates the first difference of out for all dimensions of im, each dimension is placed in a different
        # slice, indexed according to dimension
        slices_g = [slice(None), ] * (ndim + 1)
        for ax in range(ndim):
            slices_g[ax + 1] = slice(0, -1)
            slices_g[0] = ax
            g[slices_g] = np.diff(out, axis=ax)
            slices_g[ax + 1] = slice(None)

        norm = np.sqrt((g ** 2).sum(axis=0))[np.newaxis, ...]
        E += weight * norm.sum()
        tau = 1. / (2. * ndim)
        norm *= tau / weight
        norm += 1.
        p -= tau * g
        p /= norm
        E /= float(im.size)
        if i == 0:
            E_init = E
            E_previous = E
        else:
            if np.abs(E_previous - E) < eps * E_init:
                break
            else:
                E_previous = E
        i += 1
    return out


def _denoise_tv_chambolle_3D(im: np.ndarray, weight: float = 0.1, n_iter_max: int = 200) -> np.ndarray:
    """Perform total-variation denoising on 3-dimensional volumes.

    Parameters
    ----------
    im : ndarray
        n-D input data to be denoised.
    weight : float, optional
        Denoising weight. The greater `weight`, the more denoising (at
        the expense of fidelity to `input`).
    n_iter_max : int
        The number of iterations used for the optimization.

    Returns
    -------
    out : ndarray
        Denoised array of floats.

    Notes
    -----
    Rudin, Osher and Fatemi algorithm.

    """

    ndim = 3
    p = np.zeros((3,) + im.shape, dtype=im.dtype)
    g = np.zeros_like(p)
    d = np.zeros_like(im)
    tau = 1. / (2. * ndim)
    norm_scale = tau / weight

    i = 0
    print("iteration: ", i)
    while i < n_iter_max:
        if i > 0:
            # d will be the (negative) divergence of p
            d = -p.sum(0)
            print("initial neg_div:")
            print(d)

            d[1:, :, :] += p[0, :-1, :, :]
            print("z inc neg_div:")
            print(d)

            d[:, 1:, :] += p[1, :, :-1, :]
            print("y inc neg_div:")
            print(d)

            d[:, :, 1:] += p[2, :, :, :-1]
            print("x inc neg_div:")
            print(d)
            
            out = im + d
            print("estimate update:")
            print(out)
        else:
            out = im

        # g stores the gradients of out along each axis
        # e.g. g[0] is the first order finite difference along axis 0
        # RJG: calculates the first difference of out for all dimensions of im, each dimension is placed in a different
        # slice, indexed according to dimension
        g[0, :-1, :, :] = np.diff(out, axis=0)
        g[1, :, :-1, :] = np.diff(out, axis=1)
        g[2, :, :, :-1] = np.diff(out, axis=2)

        print("diff_z")
        print(g[0, :, :, :])
        print("diff_y")
        print(g[1, :, :, :])
        print("diff_x")
        print(g[2, :, :, :])

        norm = np.sqrt((g ** 2).sum(axis=0))[np.newaxis, ...]
        norm *= norm_scale
        norm += 1.

        p -= tau * g
        print("pre-norm p_z")
        print(p[0, :, :, :])
        print("pre-norm p_y")
        print(p[1, :, :, :])
        print("pre-norm p_x")
        print(p[2, :, :, :])

        p /= norm
        print("post-norm p_z")
        print(p[0, :, :, :])
        print("post-norm p_y")
        print(p[1, :, :, :])
        print("post-norm p_x")
        print(p[2, :, :, :])

        i += 1

    return out


def img_as_float(image: np.ndarray, force_copy: bool = False) -> np.ndarray:
    """Convert an image to double-precision (64-bit) floating point format.

    Parameters
    ----------
    image : ndarray
        Input image.
    force_copy : bool, optional
        Force a copy of the data, irrespective of its current dtype.

    Returns
    -------
    out : ndarray of float64
        Output image.

    Notes
    -----
    The range of a floating point image is [0.0, 1.0] or [-1.0, 1.0] when
    converting from unsigned or signed datatypes, respectively.
    If the input image has a float type, intensity values are not modified
    and can be outside the ranges [0.0, 1.0] or [-1.0, 1.0].

    """
    return convert(image, np.float64, force_copy)


def convert(image: np.ndarray, dtype: np.dtype, force_copy: bool = False, uniform: bool = False) -> np.ndarray:
    """
    Convert an image to the requested data-type.

    Warnings are issued in case of precision loss, or when negative values
    are clipped during conversion to unsigned integer types (sign loss).

    Floating point values are expected to be normalized and will be clipped
    to the range [0.0, 1.0] or [-1.0, 1.0] when converting to unsigned or
    signed integers respectively.

    Numbers are not shifted to the negative side when converting from
    unsigned to signed integer types. Negative values will be clipped when
    converting to unsigned integers.

    Parameters
    ----------
    image : ndarray
        Input image.
    dtype : dtype
        Target data-type.
    force_copy : bool, optional
        Force a copy of the data, irrespective of its current dtype.
    uniform : bool, optional
        Uniformly quantize the floating point range to the integer range.
        By default (uniform=False) floating point values are scaled and
        rounded to the nearest integers, which minimizes back and forth
        conversion errors.

    References
    ----------
    .. [1] DirectX data conversion rules.
           http://msdn.microsoft.com/en-us/library/windows/desktop/dd607323%28v=vs.85%29.aspx
    .. [2] Data Conversions. In "OpenGL ES 2.0 Specification v2.0.25",
           pp 7-8. Khronos Group, 2010.
    .. [3] Proper treatment of pixels as integers. A.W. Paeth.
           In "Graphics Gems I", pp 249-256. Morgan Kaufmann, 1990.
    .. [4] Dirty Pixels. J. Blinn. In "Jim Blinn's corner: Dirty Pixels",
           pp 47-57. Morgan Kaufmann, 1998.

    """
    image = np.asarray(image)
    dtypeobj_in = image.dtype
    dtypeobj_out = np.dtype(dtype)
    dtype_in = dtypeobj_in.type
    dtype_out = dtypeobj_out.type
    kind_in = dtypeobj_in.kind
    kind_out = dtypeobj_out.kind
    itemsize_in = dtypeobj_in.itemsize
    itemsize_out = dtypeobj_out.itemsize

    if dtype_in == dtype_out:
        if force_copy:
            image = image.copy()
        return image

    if not (dtype_in in _supported_types and dtype_out in _supported_types):
        raise ValueError("Can not convert from {} to {}."
                         .format(dtypeobj_in, dtypeobj_out))

    def sign_loss():
        warn("Possible sign loss when converting negative image of type "
             "{} to positive image of type {}."
             .format(dtypeobj_in, dtypeobj_out))

    def prec_loss():
        warn("Possible precision loss when converting from {} to {}"
             .format(dtypeobj_in, dtypeobj_out))

    def _dtype_itemsize(itemsize, *dtypes):
        # Return first of `dtypes` with itemsize greater than `itemsize`
        return next(dt for dt in dtypes if np.dtype(dt).itemsize >= itemsize)

    def _dtype_bits(kind, bits, itemsize=1):
        # Return dtype of `kind` that can store a `bits` wide unsigned int
        def compare(x, y, kind='u'):
            if kind == 'u':
                return x <= y
            else:
                return x < y

        s = next(i for i in (itemsize,) + (2, 4, 8) if compare(bits, i * 8,
                                                               kind=kind))
        return np.dtype(kind + str(s))

    def _scale(a, n, m, copy=True):
        """Scale an array of unsigned/positive integers from `n` to `m` bits.

        Numbers can be represented exactly only if `m` is a multiple of `n`.

        Parameters
        ----------
        a : ndarray
            Input image array.
        n : int
            Number of bits currently used to encode the values in `a`.
        m : int
            Desired number of bits to encode the values in `out`.
        copy : bool, optional
            If True, allocates and returns new array. Otherwise, modifies
            `a` in place.

        Returns
        -------
        out : array
            Output image array. Has the same kind as `a`.
        """
        kind = a.dtype.kind
        if n > m and a.max() < 2 ** m:
            mnew = int(np.ceil(m / 2) * 2)
            if mnew > m:
                dtype = "int{}".format(mnew)
            else:
                dtype = "uint{}".format(mnew)
            n = int(np.ceil(n / 2) * 2)
            warn("Downcasting {} to {} without scaling because max "
                 "value {} fits in {}".format(a.dtype, dtype, a.max(), dtype))
            return a.astype(_dtype_bits(kind, m))
        elif n == m:
            return a.copy() if copy else a
        elif n > m:
            # downscale with precision loss
            prec_loss()
            if copy:
                b = np.empty(a.shape, _dtype_bits(kind, m))
                np.floor_divide(a, 2 ** (n - m), out=b, dtype=a.dtype,
                                casting='unsafe')
                return b
            else:
                a //= 2 ** (n - m)
                return a
        elif m % n == 0:
            # exact upscale to a multiple of `n` bits
            if copy:
                b = np.empty(a.shape, _dtype_bits(kind, m))
                np.multiply(a, (2 ** m - 1) // (2 ** n - 1), out=b, dtype=b.dtype)
                return b
            else:
                a = a.astype(_dtype_bits(kind, m, a.dtype.itemsize), copy=False)
                a *= (2 ** m - 1) // (2 ** n - 1)
                return a
        else:
            # upscale to a multiple of `n` bits,
            # then downscale with precision loss
            prec_loss()
            o = (m // n + 1) * n
            if copy:
                b = np.empty(a.shape, _dtype_bits(kind, o))
                np.multiply(a, (2 ** o - 1) // (2 ** n - 1), out=b, dtype=b.dtype)
                b //= 2 ** (o - m)
                return b
            else:
                a = a.astype(_dtype_bits(kind, o, a.dtype.itemsize), copy=False)
                a *= (2 ** o - 1) // (2 ** n - 1)
                a //= 2 ** (o - m)
                return a

    if kind_in in 'ui':
        imin_in = np.iinfo(dtype_in).min
        imax_in = np.iinfo(dtype_in).max
    if kind_out in 'ui':
        imin_out = np.iinfo(dtype_out).min
        imax_out = np.iinfo(dtype_out).max

    # any -> binary
    if kind_out == 'b':
        if kind_in in "fi":
            sign_loss()
        prec_loss()
        return image > dtype_in(dtype_range[dtype_in][1] / 2)

    # binary -> any
    if kind_in == 'b':
        result = image.astype(dtype_out)
        if kind_out != 'f':
            result *= dtype_out(dtype_range[dtype_out][1])
        return result

    # float -> any
    if kind_in == 'f':
        if np.min(image) < -1.0 or np.max(image) > 1.0:
            raise ValueError("Images of type float must be between -1 and 1.")
        if kind_out == 'f':
            # float -> float
            if itemsize_in > itemsize_out:
                prec_loss()
            return image.astype(dtype_out)

        # floating point -> integer
        prec_loss()
        # use float type that can represent output integer type
        image = image.astype(_dtype_itemsize(itemsize_out, dtype_in,
                                             np.float32, np.float64))
        if not uniform:
            if kind_out == 'u':
                image *= imax_out
            else:
                image *= imax_out - imin_out
                image -= 1.0
                image /= 2.0
            np.rint(image, out=image)
            np.clip(image, imin_out, imax_out, out=image)
        elif kind_out == 'u':
            image *= imax_out + 1
            np.clip(image, 0, imax_out, out=image)
        else:
            image *= (imax_out - imin_out + 1.0) / 2.0
            np.floor(image, out=image)
            np.clip(image, imin_out, imax_out, out=image)
        return image.astype(dtype_out)

    # signed/unsigned int -> float
    if kind_out == 'f':
        if itemsize_in >= itemsize_out:
            prec_loss()
        # use float type that can exactly represent input integers
        image = image.astype(_dtype_itemsize(itemsize_in, dtype_out,
                                             np.float32, np.float64))
        if kind_in == 'u':
            image /= imax_in
            # DirectX uses this conversion also for signed ints
            # if imin_in:
            #     np.maximum(image, -1.0, out=image)
        else:
            image *= 2.0
            image += 1.0
            image /= imax_in - imin_in
        return image.astype(dtype_out)

    # unsigned int -> signed/unsigned int
    if kind_in == 'u':
        if kind_out == 'i':
            # unsigned int -> signed int
            image = _scale(image, 8 * itemsize_in, 8 * itemsize_out - 1)
            return image.view(dtype_out)
        else:
            # unsigned int -> unsigned int
            return _scale(image, 8 * itemsize_in, 8 * itemsize_out)

    # signed int -> unsigned int
    if kind_out == 'u':
        sign_loss()
        image = _scale(image, 8 * itemsize_in - 1, 8 * itemsize_out)
        result = np.empty(image.shape, dtype_out)
        np.maximum(image, 0, out=result, dtype=image.dtype, casting='unsafe')
        return result

    # signed int -> signed int
    if itemsize_in > itemsize_out:
        return _scale(image, 8 * itemsize_in - 1, 8 * itemsize_out - 1)

    image = image.astype(_dtype_bits('i', itemsize_out * 8))
    image -= imin_in
    image = _scale(image, 8 * itemsize_in, 8 * itemsize_out, copy=False)
    image += imin_out
    return image.astype(dtype_out)


if __name__ == "__main__":
    main()
