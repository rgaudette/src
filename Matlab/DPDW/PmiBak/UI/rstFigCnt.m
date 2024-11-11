%RSTFIGCNT      Reset the current figure counter

UIHandles = get(gcf, 'UserData');
UIHandles.CurrFigure = gcf + 1;
set(gcf, 'UserData', UIHandles);