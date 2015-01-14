#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include <string.h>

#include "std_log2c.h"

void slv_setv(Std_Log_Vect slv, unsigned int nb_b, char *format, ...)
	{
	va_list ap;
	int i;
	int v;
	int uv;
	char *s;
	Std_Log zero_un[] = {STD_0, STD_1};

	va_start(ap, format);
	if ( *format++ != '%')
		{
		fprintf( stderr, "Erreur fonction slv_setv, format invalide!\n");
		return;
		}
	
	switch (*format)
		{
		case 'i' :
			v = va_arg(ap, int);
			for (i = nb_b -1; i >= 0; i--)
				{
				slv[i] = zero_un[v & 1];
				v >>= 1;
				}
			break;

		case 'u' :
			uv = va_arg(ap, unsigned int);
			for (i=nb_b -1; i >= 0; i--)
				{
				slv[i] = zero_un[uv & 1];
				uv >>= 1;
				}
			break;

		case 's' :
			s = va_arg(ap, char *);
			if ( strlen(s) != nb_b)
				{
				fprintf( stderr, "Erreur fonction slv_setv, format s, nb bits differents!\n");
				return;
				}
			for(i=0; *s; i++, s++)
				switch (*s)
					{
					case 'U' : slv[i] = STD_U; break;
					case 'X' : slv[i] = STD_X; break;
					case '0' : slv[i] = STD_0; break;
					case '1' : slv[i] = STD_1; break;
					case 'Z' : slv[i] = STD_Z; break;
					case 'W' : slv[i] = STD_W; break;
					case 'L' : slv[i] = STD_L; break;
					case 'H' : slv[i] = STD_H; break;
					case '_' : slv[i] = STD__; break;
					default :
						fprintf( stderr, "Erreur fonction slv_setv, format s, valeur inconnue!\n");
						return;
					}
				break;

		default :
			fprintf( stderr, "Erreur fonction slv_setv, format invalide!\n");
			return;
		}

	va_end(ap);
	}


unsigned int std2ui(Std_Log_Vect slv, unsigned int nb_b)
	{
	int i;
	unsigned int v = 0;

	for(i = 0; i < nb_b; i++)
		{
		v <<= 1;
		if (slv[i] == STD_1) v |= 1;
		else if (slv[i] != STD_0)
			{
			fprintf( stderr, "Erreur fonction slv2ui, format numerique invalide!\n");
			return 0;
			}
		}
	return v;
	}


int std2i(Std_Log_Vect slv, unsigned int nb_b)
	{
	int i;
	int v;

	if (slv[0] == STD_0)
		v = 0;
	else if (slv[0] == STD_1)
		v = ~0;
	else
		{
		fprintf( stderr, "Erreur fonction slv2i, format numerique invalide!\n");
		return 0;
		}

	for(i = 0; i < nb_b; i++)
		{
		v <<= 1;
		if (slv[i] == STD_1) v |= 1;
		else if (slv[i] != STD_0)
			{
			fprintf( stderr, "Erreur fonction slv2i, format numerique invalide!\n");
			return 0;
			}
		}
	return v;
	}
