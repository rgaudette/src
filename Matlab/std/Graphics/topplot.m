function topplot
clg
axes('Position', [0.15 0.6 0.7 0.27])
set(gca, 'box', 'on')
xlabel('X Label')
hlabel = get(gca, 'xlabel');
set(hlabel, 'FontSize', 16);
set(hlabel, 'VerticalAlignment' , 'top')
ylabel('Y Label')
hlabel = get(gca, 'ylabel');
set(hlabel, 'FontSize', 16);
set(hlabel, 'VerticalAlignment' , 'bottom')
title('Title')
hlabel = get(gca, 'title');
set(hlabel, 'FontSize', 16);