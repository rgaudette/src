
    hNewAxes = axes('Position', [0 0 1 1]);
    set(hNewAxes, 'Units', 'normalized')
    axis([0 1 0 1])
    hold on
    plot(0.045, 0.5, '+')
    plot(0.955, 0.5, '+')
    set(hNewAxes, 'visible', 'off');

