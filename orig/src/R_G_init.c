/* Copyright 2000 by Roger S. Bivand. 
*
**/

#include "grassR.h"

void R_G_init(char *name) {

	G_set_error_routine(R_handler);
	G_sleep_on_error(0);
	G_gisinit(name);
}

int R_handler(char *message, int fatal) {
		if(fatal == 1) error(message);
			else warning(message);
		return(1);
}

