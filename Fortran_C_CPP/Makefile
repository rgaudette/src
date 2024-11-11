OBJS=cmdline.o cmap.o
LIBS=stdc++

cmdline: $(OBJS)
	f77 $^ -o $@ -l $(LIBS)

cmdline.o: cmdline.f

cmap.o: cmap.cpp


clean:
	rm -rf $(OBJS) cmdline
