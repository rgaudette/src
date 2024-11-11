function swapimage(image1, image2, shift);

set(gca, 'drawmode', 'fast')
set(gcf, 'renderer', 'opengl');
currAxis = axis;
currCAxis = caxis;
currImage = 1;
imagesc(image1);
axis(currAxis);
caxis(currCAxis);

loop  = 1
while  loop
  s = input('q to quit', 's')
  
  if strcmp(s, '')
    disp('Next image')
    if currImage == 1;
      imagesc(image2(shift:end, shift:end));
      currImage = 2;
    else
      imagesc(image1);
      currImage = 1;
    end
    axis(currAxis);
    caxis(currCAxis);
    drawnow
  end
  
  if strcmp(s, 'i');
  end
  
  if strcmp(s, 'q')
    loop = 0;
  end
end
