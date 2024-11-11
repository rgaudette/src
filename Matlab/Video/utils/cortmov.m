figure(1)
colormap(gray(256));

load cortez00
image(cortez00);
axis('image')
set(gca, 'units', 'pixels');
pos = get(gca, 'position')
set(gca, 'position', [pos(1) pos(2) pos(1)+256 pos(2)+256]);
mov = moviein(50);
mov(:,1) = getframe;

for i=1:49,
    fname = sprintf('cortez%02d', i);
    load(fname);
    eval(['image(' fname ');']);
    axis('image')
    mov(:,i+1) = getframe;
    eval(['clear ' fname ]);
    
end

