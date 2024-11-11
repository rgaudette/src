#include <stdio.h>
#include <windows.h>

int main(int argc, char *argv[]) {

	long	mSecUptime;
	long	mSec_per_min, mSec_per_hour, mSec_per_day;
	long	days, hours, mins, secs;
	

	mSecUptime = GetCurrentTime();
	
	mSec_per_min = 1000 * 60;
	mSec_per_hour = mSec_per_min * 60;
	mSec_per_day = mSec_per_hour * 24;
	
	days = mSecUptime / mSec_per_day;
	hours = (mSecUptime - days * mSec_per_day) / mSec_per_hour;
	mins = (mSecUptime - days * mSec_per_day - hours * mSec_per_hour) 
		/ mSec_per_min;
	secs = (mSecUptime - days * mSec_per_day - hours * mSec_per_hour - mins * mSec_per_min)
		/ 1000;

	printf("Up %d day(s) %d:%02d:%02d\n", days, hours, mins, secs);
}
