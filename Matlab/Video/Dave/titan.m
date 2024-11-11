titanic = moviein(10);
titanic(:,1) = getframe;

for i=2:10
	eval(['load ',video(i,:)]);
	eval(['new = ',video(i,:),';']);
        image(new)
	titanic(:,i) = getframe;
	eval(['clear ',video(i,:)]);
end;	