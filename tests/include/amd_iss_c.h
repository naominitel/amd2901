#ifndef AMD_ISS_C
#define AMD_ISS_C

#include "std_log2c.h"

typedef struct _amd_port
	{
	Std_Log a[4];
	Std_Log b[4];
	Std_Log d[4];
	Std_Log i[9];
	Std_Log cin;
	Std_Log r0;
	Std_Log r3;
	Std_Log q0;
	Std_Log q3;
	Std_Log noe;
	Std_Log y[4];
	Std_Log cout;
	Std_Log np;
	Std_Log ng;
	Std_Log sign;
	Std_Log zero;
	Std_Log ovr;
	} Amd_port;

#endif
