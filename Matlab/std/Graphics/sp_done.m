%SP_DONE
function sp_done

%%
%% Perform any cleanup necessary
%%
Data = get(gcf, 'UserData');
delete(Data.hWidthText);
delete(Data.hPosText);
delete(Data.hWidthSlider);
delete(Data.hPosSlider);
delete(Data.hDoneBtn);
set(Data.hAx, 'position', Data.AxOrigPos);
