for idx = 1:23,                         
    varidx = sprintf('%02.0f', idx);
    eval(['x=x' varidx '([1:5:251],:);']);
    size(x)
    y = x * conj(w_cbf);                    
 size(y)
    py = (abs(y)).^2;                       
    size(py)
    cbf_resp(idx,:) = mean(py);
end
