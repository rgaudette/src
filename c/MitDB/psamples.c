#include <ecg/db.h>

main()
{
    int i, v[2];
    struct siginfo s[2];

    if (isigopen("100s", s, 2) < 1)
	exit(1);
    for (i = 0; i < 10; i++) {
	if (getvec(v) < 0)
	    break;
	printf("%d\n", v[0]);
    }
    exit(0);
}
