function btnShrinkWindow

UIHandles = get(gcf, 'UserData');

if strcmp(get(UIHandles.hBtnShrink, 'String'), 'Shrink Window')
    pos = get(gcf, 'position');
    pos(3) = UIHandles.BtnWindow(1);
    pos(4) = UIHandles.BtnWindow(2);
    set(UIHandles.hBtnShrink, 'String', 'Expand')
else
    pos = get(gcf, 'position');
    pos(3) = UIHandles.FullWindow(1);
    pos(4) = UIHandles.FullWindow(2);
    set(UIHandles.hBtnShrink, 'String', 'Shrink Window')
end
set(gcf, 'Position', pos);
