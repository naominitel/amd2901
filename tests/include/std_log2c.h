#ifndef STD_LOG
#define STD_LOG

#define STD_U 0
#define STD_X 1
#define STD_0 2
#define STD_1 3
#define STD_Z 4
#define STD_W 5
#define STD_L 6
#define STD_H 7
#define STD__ 8

typedef unsigned char Std_Log;

typedef Std_Log* Std_Log_Vect;

Std_Log to_std_log(unsigned char v);

void slv_setv(Std_Log_Vect slv, unsigned int nb_b, char *format, ...);

unsigned int std2ui(Std_Log_Vect slv, unsigned int nb_b);

int std2i(Std_Log_Vect slv, unsigned int nb_b);

#endif
