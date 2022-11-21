#include <stdio.h>
#include <stdlib.h>
#include <svdpi.h>

using namespace std;

extern "C" int report()
{
	FILE * rp;
	rp = fopen("report.csv","a");
	fprintf(rp,"%s","X,Y,Rounding mode,Overflow,Underflow,Z,Expected Z");
	fclose(rp);
	return 0;
}


