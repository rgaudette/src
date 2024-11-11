function w=mti(n)

for k=1:n

   w(k) = (-1)^k * fact(n-1) / ( fact(n-k) * fact(k-1) ) / (n-1);

end

