/* Copyright 2000 by Roger S. Bivand. 
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
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
}

