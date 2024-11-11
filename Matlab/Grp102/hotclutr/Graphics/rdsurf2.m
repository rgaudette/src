clg
axes('Position', [0.18 0.6 0.65 0.27])
colormap(vibgyor(128))
surf( RangeKM, Doppler, bfrd_pwr_db);
axis([0 500 0 300 0 50])
%set(gca, 'box', 'on')
grid on
shading('interp')


axes('Position', [0.18 0.15 0.65 0.27])
surf( RangeKM, Doppler, local_db) 
axis([0 500 0 300 0 50])
%set(gca, 'box', 'on')
grid on
shading('interp')