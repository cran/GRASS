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

#include <R.h>
#include <Rdefines.h>
#include <R_ext/Applic.h>

#include <gis.h>

int R_handler(char *message, int fatal);
void R_G_init(char *name);

#if R_VERSION < R_Version(1, 2, 0)
# define STRING_ELT(x, i)		(STRING(x)[i])
# define VECTOR_ELT(x, i)		(VECTOR(x)[i])
# define SET_STRING_ELT(x, i, v)	(STRING(x)[i] = (v))
# define SET_VECTOR_ELT(x, i, v)	(VECTOR(x)[i] = (v))
#endif
