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

#include <string.h>
#include <unistd.h>
#include "grassR.h"

int G_get_raster_i(void *, struct Categories *, RASTER_MAP_TYPE);



SEXP rastget(SEXP G, SEXP layers, SEXP flayers) {
   int GR_nrows;
   int GR_ncols;
   int *is_fp=NULL;
   int *ncats=NULL;

   struct Categories *labels=NULL;

   SEXP ans;
   SEXP ansnames;
   SEXP anslevels;
   SEXP class;
   int nlayers = GET_LENGTH(layers);
   int i, j;
   int *fd;
   int ncells, icell;
   int row, col;
   char *mapset;
   char msg[255], tmp[255];
   void **rast, **rastp;
   void *rast1, *rast2;
   struct Cell_head cellhd;
   CELL null_cell;
   RASTER_MAP_TYPE *map_type;


   char *name="rastget()";
   R_G_init(name);
   
   G_get_window(&cellhd);


   if (NUMERIC_POINTER(VECTOR_ELT(G, 3))[0] != cellhd.north)
      error("Current GRASS region changed: north");
   if (NUMERIC_POINTER(VECTOR_ELT(G, 4))[0] != cellhd.south)
      error("Current GRASS region changed: south");
   if (NUMERIC_POINTER(VECTOR_ELT(G, 5))[0] != cellhd.west)
      error("Current GRASS region changed: west");
   if (NUMERIC_POINTER(VECTOR_ELT(G, 6))[0] != cellhd.east)
      error("Current GRASS region changed: east");
   if (NUMERIC_POINTER(VECTOR_ELT(G, 7))[0] != cellhd.ns_res)
      error("Current GRASS region changed: ns_res");
   if (NUMERIC_POINTER(VECTOR_ELT(G, 8))[0] != cellhd.ew_res)
      error("Current GRASS region changed: ew_res");
   if (INTEGER_POINTER(VECTOR_ELT(G, 9))[0] != cellhd.rows)
      error("Current GRASS region changed: rows");
   if (INTEGER_POINTER(VECTOR_ELT(G, 10))[0] != cellhd.cols)
      error("Current GRASS region changed: cols");

   
   for (i = 0; i < nlayers; i++) {
      if((mapset = G_find_cell(CHAR(STRING_ELT(layers, i)), "")) == NULL) {
         sprintf(msg, "raster map: %s not found", CHAR(STRING_ELT(layers, i)));
         error(msg);
      }
   }   

   GR_nrows = cellhd.rows; GR_ncols = cellhd.cols;
   ncells = GR_nrows * GR_ncols;
   fd = (int *) R_alloc ((long) nlayers, sizeof(int));
   is_fp = (int *) R_alloc ((long) nlayers, sizeof(int));
   ncats = (int *) R_alloc ((long) nlayers, sizeof(int));
   labels = (struct Categories *) R_alloc ((long) nlayers, 
      sizeof(struct Categories));
   rast = (void **) R_alloc ((long) nlayers, sizeof (void *));
   rastp = (void **) R_alloc ((long) nlayers, sizeof (void *));
   map_type = (RASTER_MAP_TYPE *) R_alloc ((long) nlayers, 
      sizeof( RASTER_MAP_TYPE));


   for (i = 0; i < nlayers; i++) {

      mapset = G_find_cell(CHAR(STRING_ELT(layers, i)), "");

      fd[i] = G_open_cell_old (CHAR(STRING_ELT(layers, i)), mapset);
      if (fd[i] < 0) {
         for (j=0; j<i; j++) G_close_cell(fd[j]);
             sprintf(msg, "unable to open %s", 
            CHAR(STRING_ELT(layers, i)));
          error(msg);
      }

      is_fp[i] = G_raster_map_is_fp(CHAR(STRING_ELT(layers, i)), mapset);
      
        if (LOGICAL_POINTER(flayers)[i]) {
         if (G_read_raster_cats (CHAR(STRING_ELT(layers, i)), 
		mapset, &labels[i]) < 0)
            G_init_raster_cats("", &labels[i]);
	 ncats[i] = G_number_of_raster_cats(&labels[i]);
      }
   }

   
   for (i = 0; i < nlayers; i++) {
      if(is_fp[i]) map_type[i] = DCELL_TYPE;
      else    map_type[i] = CELL_TYPE;
      rast[i] = (void *) R_alloc (cellhd.cols + 1, G_raster_size(map_type[i]));
   }

   PROTECT(ans = NEW_LIST(nlayers));
   PROTECT(anslevels = NEW_LIST(nlayers));
   PROTECT(ansnames = NEW_CHARACTER(nlayers));
   PROTECT(class = NEW_CHARACTER(2));
   SET_STRING_ELT(class, 0, COPY_TO_USER_STRING("ordered"));
   SET_STRING_ELT(class, 1, COPY_TO_USER_STRING("factor"));

   G_set_c_null_value(&null_cell, 1);

   for (i = 0; i < nlayers; i++) {

      icell = 0;

      if(LOGICAL_POINTER(flayers)[i]) {
	 SET_VECTOR_ELT(ans, i, NEW_INTEGER(ncells));
	 SET_VECTOR_ELT(anslevels, i, NEW_CHARACTER(ncats[i]));
	 sprintf(tmp, "%s.f", CHAR(STRING_ELT(layers, i)));
	 SET_VECTOR_ELT(ansnames, i, COPY_TO_USER_STRING(tmp));
	 for (j=0; j<ncats[i]; j++) {
	   SET_VECTOR_ELT(VECTOR_ELT(anslevels, i), j, 
	      COPY_TO_USER_STRING(G_get_ith_raster_cat(&labels[i], j, 
		&rast1, &rast2, map_type[i])));
	 }
      }
      else {
	 SET_VECTOR_ELT(ans, i, NEW_NUMERIC(ncells));
	 SET_VECTOR_ELT(ansnames, i, VECTOR_ELT(layers, i));
      }

      for (row = 0; row < GR_nrows; row++) {

         if(G_get_raster_row(fd[i], rast[i], row, map_type[i]) < 0) {
            for (j=0; j<nlayers; j++) G_close_cell(fd[j]);
            sprintf(msg, "read failure at row %d for layer %s", 
               row, CHAR(STRING_ELT(layers, i)));
            error(msg);
         }
         rastp[i] = rast[i];

         for (col = 0; col < GR_ncols; col++) {

            if (G_is_null_value(rastp[i], map_type[i])) {
               if (LOGICAL_POINTER(flayers)[i]) {
                  INTEGER_POINTER(VECTOR_ELT(ans, i))[icell] =
                     NA_INTEGER;
               } else {
                  NUMERIC_POINTER(VECTOR_ELT(ans, i))[icell] = NA_REAL;
               }
            }
            else if(map_type[i] == CELL_TYPE) {
               if (LOGICAL_POINTER(flayers)[i]) {
                  INTEGER_POINTER(VECTOR_ELT(ans, i))[icell] =
                     G_get_raster_i(rastp[i], &labels[i], map_type[i]);
               } else {
                  NUMERIC_POINTER(VECTOR_ELT(ans, i))[icell] =
                     (double) *((CELL *) rastp[i]);
               }
            }
            else {
               if (LOGICAL_POINTER(flayers)[i]) {
                  INTEGER_POINTER(VECTOR_ELT(ans, i))[icell] = 
                     G_get_raster_i(rastp[i], &labels[i], map_type[i]);
               } else {
                  NUMERIC_POINTER(VECTOR_ELT(ans, i))[icell] = 
                     *((DCELL *) rastp[i]);
               }
            }
            rastp[i] = G_incr_void_ptr(rastp[i], G_raster_size(map_type[i]));
            icell++;
         }
      }
      if(LOGICAL_POINTER(flayers)[i]) {
	 setAttrib(VECTOR_ELT(ans, i), R_LevelsSymbol, 
	    VECTOR_ELT(anslevels, i));
	 setAttrib(VECTOR_ELT(ans, i), R_ClassSymbol, class);
      }
   }
   for (i=0; i<nlayers; i++) G_close_cell(fd[i]);
   for (i=0; i<nlayers; i++)  
      if (LOGICAL_POINTER(flayers)[i])
         G_free_raster_cats(&labels[i]);
   setAttrib(ans, R_NamesSymbol, ansnames);
   
   UNPROTECT(4);
   return (ans); 
}

