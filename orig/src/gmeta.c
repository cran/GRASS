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

SEXP gmeta() {
	SEXP ans, elnames, class, xynames;
	int i, j, k, ii, proj;
	char chbuf[256];
	struct Cell_head cellhd;
	double start;

	char *name="gmeta()";
	R_G_init(name);

	PROTECT(ans = NEW_LIST(17));
	LIST_POINTER(ans)[0] = NEW_CHARACTER(1);
	LIST_POINTER(ans)[1] = NEW_CHARACTER(1);
	LIST_POINTER(ans)[2] = NEW_CHARACTER(1);
	LIST_POINTER(ans)[3] = NEW_NUMERIC(1);
	LIST_POINTER(ans)[4] = NEW_NUMERIC(1);
	LIST_POINTER(ans)[5] = NEW_NUMERIC(1);
	LIST_POINTER(ans)[6] = NEW_NUMERIC(1);
	LIST_POINTER(ans)[7] = NEW_NUMERIC(1);
	LIST_POINTER(ans)[8] = NEW_NUMERIC(1);
	LIST_POINTER(ans)[9] = NEW_INTEGER(1);
	LIST_POINTER(ans)[10] = NEW_INTEGER(1);
	LIST_POINTER(ans)[11] = NEW_INTEGER(1);
	LIST_POINTER(ans)[12] = NEW_NUMERIC(2);
	LIST_POINTER(ans)[13] = NEW_NUMERIC(2);
	
	CHARACTER_POINTER(LIST_POINTER(ans)[0])[0] = 
		COPY_TO_USER_STRING(G_location());
	CHARACTER_POINTER(LIST_POINTER(ans)[1])[0] = 
		COPY_TO_USER_STRING(G_mapset());
	proj = G_projection();
	if (proj != 1) CHARACTER_POINTER(LIST_POINTER(ans)[2])[0] = 
		COPY_TO_USER_STRING(G_database_projection_name());
	else {
		sprintf(chbuf, "%s, zone: %d", G_database_projection_name(),
			G_zone());
		CHARACTER_POINTER(LIST_POINTER(ans)[2])[0] = 
		COPY_TO_USER_STRING(chbuf);
	}

	G_get_window(&cellhd);
	NUMERIC_POINTER(LIST_POINTER(ans)[3])[0] = cellhd.north;
	NUMERIC_POINTER(LIST_POINTER(ans)[4])[0] = cellhd.south;
	NUMERIC_POINTER(LIST_POINTER(ans)[5])[0] = cellhd.west;
	NUMERIC_POINTER(LIST_POINTER(ans)[6])[0] = cellhd.east;
	NUMERIC_POINTER(LIST_POINTER(ans)[7])[0] = cellhd.ns_res;
	NUMERIC_POINTER(LIST_POINTER(ans)[8])[0] = cellhd.ew_res;
	INTEGER_POINTER(LIST_POINTER(ans)[9])[0] = cellhd.rows;
	INTEGER_POINTER(LIST_POINTER(ans)[10])[0] = cellhd.cols;
	INTEGER_POINTER(LIST_POINTER(ans)[11])[0] = cellhd.rows*cellhd.cols;

	NUMERIC_POINTER(LIST_POINTER(ans)[12])[0] = cellhd.west;
	NUMERIC_POINTER(LIST_POINTER(ans)[12])[1] = cellhd.east;
	NUMERIC_POINTER(LIST_POINTER(ans)[13])[0] = cellhd.south;
	NUMERIC_POINTER(LIST_POINTER(ans)[13])[1] = cellhd.north;
	
	LIST_POINTER(ans)[14] = NEW_NUMERIC(cellhd.cols);
	start = cellhd.west + (cellhd.ew_res / 2);
	for (i = 0; i < cellhd.cols; i++) {
		NUMERIC_POINTER(LIST_POINTER(ans)[14])[i] = start;
		start += cellhd.ew_res;
	}

	LIST_POINTER(ans)[15] = NEW_NUMERIC(cellhd.rows);
	start = cellhd.south + (cellhd.ns_res / 2);
	for (i = 0; i < cellhd.rows; i++) {
		NUMERIC_POINTER(LIST_POINTER(ans)[15])[i] = start;
		start += cellhd.ns_res;
	}
	LIST_POINTER(ans)[16] = NEW_NUMERIC(cellhd.rows);
	start = cellhd.north - (cellhd.ns_res / 2);
	for (i = 0; i < cellhd.rows; i++) {
		NUMERIC_POINTER(LIST_POINTER(ans)[16])[i] = start;
		start -= cellhd.ns_res;
	}

	PROTECT(elnames = NEW_CHARACTER(17));
	LIST_POINTER(elnames)[0] = COPY_TO_USER_STRING("LOCATION");
	LIST_POINTER(elnames)[1] = COPY_TO_USER_STRING("MAPSET");
	LIST_POINTER(elnames)[2] = COPY_TO_USER_STRING("proj");
	LIST_POINTER(elnames)[3] = COPY_TO_USER_STRING("n");
	LIST_POINTER(elnames)[4] = COPY_TO_USER_STRING("s");
	LIST_POINTER(elnames)[5] = COPY_TO_USER_STRING("w");
	LIST_POINTER(elnames)[6] = COPY_TO_USER_STRING("e");
	LIST_POINTER(elnames)[7] = COPY_TO_USER_STRING("nsres");
	LIST_POINTER(elnames)[8] = COPY_TO_USER_STRING("ewres");
	LIST_POINTER(elnames)[9] = COPY_TO_USER_STRING("Nrow");
	LIST_POINTER(elnames)[10] = COPY_TO_USER_STRING("Ncol");
	LIST_POINTER(elnames)[11] = COPY_TO_USER_STRING("Ncells");
	LIST_POINTER(elnames)[12] = COPY_TO_USER_STRING("xlims");
	LIST_POINTER(elnames)[13] = COPY_TO_USER_STRING("ylims");
	LIST_POINTER(elnames)[14] = COPY_TO_USER_STRING("xseq");
	LIST_POINTER(elnames)[15] = COPY_TO_USER_STRING("yseq");
	LIST_POINTER(elnames)[16] = COPY_TO_USER_STRING("ryseq");
	setAttrib(ans, R_NamesSymbol, elnames);
	
	PROTECT(class = NEW_CHARACTER(1));
	LIST_POINTER(class)[0] = COPY_TO_USER_STRING("grassmeta");
	setAttrib(ans, R_ClassSymbol, class);

	UNPROTECT(3);
	return(ans);
}

