hTitleAxes = axes('position', [ 0 0.85 1 0.1]);
set(hTitleAxes, 'Visible', 'off');
hTitleText = text(0.5, 0, 'RESOLUTION CELL SIZE COMPARISON');
set(hTitleText, 'HorizontalAlignment', 'center');
set(hTitleText,'VerticalAlignment', 'bottom');
set(hTitleText,'FontSize', 20);
set(hTitleText, 'FontWeight', 'bold')

hBottomAxes1 = axes('position', [.275 0.1 0.2 0.05]);
set(hBottomAxes1, 'visible', 'off')
hRSTER = text(0,0.5, 'RSTER');
set(hRSTER,'FontSize', 18);
set(hRSTER, 'FontWeight', 'bold')

hBottomAxes2 = axes('position', [.633 0.1 0.2 0.05]);
set(hBottomAxes2, 'visible', 'off')
hRSTER90 = text(0,0.5, 'RSTER90');
set(hRSTER90,'FontSize', 18);
set(hRSTER90, 'FontWeight', 'bold')
set(hRSTER90, 'string', 'RSTER 90')
