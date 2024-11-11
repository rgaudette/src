State of the algorithms in this directory.

dwtp <-> idwtp
* works as expected with the orthogonal wavelets such as Daubechies
* have not investigated detail sequence coefficient alignment with
  respect to the original sequence alignment.
  * since the code only periodizes one end of the sequence, there is probably
    a time shift on the output coeffs.

dwtz <-> idwtz
* works as expected with orthogonal wavelets such as Daubechies.  Ends of signal for reconstruction (and decompostion) are incorrect due to zeros.


Periodizing vs. zero padding vs. mirroring

 - periodizing allows for storage of information missed in the filter at the other end of the decomposition.
