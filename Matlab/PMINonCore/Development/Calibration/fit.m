
j=0;k=0;
b = zeros(5,2,3);
c = zeros(5,2,3);
for coupling=0.5,%0.5:0.7:0.9
   k=k+1;
  for noise =0% 0.01:0.01:0.05
     j = j + 1;
    	a = zeros(20,2);
      for i=1%:20
          FF0=measure([10,0.04],coupling,noise);
		 	 a(i,:) = fmins('cali',[10,0.04],[],[],FF0);
        end
   b(j,1,k) = mean(a(:,1));
   b(j,2,k) = std(a(:,1));
   c(j,1,k) = mean(a(:,2));
   c(j,2,k) = std(a(:,2));
  end
end
