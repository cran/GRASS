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

SEXP rastput(SEXP G, SEXP layer, SEXP isfactor, SEXP levels, SEXP output, SEXP title)
{
   SEXP ans;
   int GR_nrows;
   int GR_ncols;
   struct Cell_head cellhd;
   int ncells, icell;
   int cf;
   void *rast, *rast_ptr;
   int row, col;
   int i, i1;
   char *mapset;
   struct Categories *labels=NULL;
   RASTER_MAP_TYPE data_type;

   char *name="rastput()";
   R_G_init(name);



   if (IS_INTEGER(layer)) data_type = CELL_TYPE;
   else if (IS_NUMERIC(layer)) data_type = DCELL_TYPE;
   else { error("Invalid data type"); exit(-1);}
   
   G_get_window(&cellhd);


   if (NUMERIC_POINTER(LIST_POINTER(G)[3])[0] != cellhd.north)
	error("Current GRASS region changed: north");
   if (NUMERIC_POINTER(LIST_POINTER(G)[4])[0] != cellhd.south)
	error("Current GRASS region changed: south");
   if (NUMERIC_POINTER(LIST_POINTER(G)[5])[0] != cellhd.west)
	error("Current GRASS region changed: west");
   if (NUMERIC_POINTER(LIST_POINTER(G)[6])[0] != cellhd.east)
	error("Current GRASS region changed: east");
   if (NUMERIC_POINTER(LIST_POINTER(G)[7])[0] != cellhd.ns_res)
	error("Current GRASS region changed: ns_res");
   if (NUMERIC_POINTER(LIST_POINTER(G)[8])[0] != cellhd.ew_res)
	error("Current GRASS region changed: ew_res");
   if (INTEGER_POINTER(LIST_POINTER(G)[9])[0] != cellhd.rows)
	error("Current GRASS region changed: rows");
   if (INTEGER_POINTER(LIST_POINTER(G)[10])[0] != cellhd.cols)
	error("Current GRASS region changed: cols");

   if((mapset = G_find_cell(CHAR(STRING_ELT(output, 0)), G_mapset())) != NULL)
	G_fatal_error("Output file already exists");

    GR_nrows = cellhd.rows; GR_ncols = cellhd.cols;
    ncells = GR_nrows * GR_ncols;
    rast_ptr = G_allocate_raster_buf(data_type);
    rast = rast_ptr;
    if (G_legal_filename(CHAR(STRING_ELT(output, 0))) < 0) {
	G_fatal_error("illegal output file name");
    }
    if((cf = G_open_raster_new(CHAR(STRING_ELT(output, 0)), data_type)) < 0)
	G_fatal_error ("unable to create raster map");
   if (LOGICAL_POINTER(isfactor)[0]) {
      labels = (struct Categories *) R_alloc ((long) 1, sizeof(struct Categories));
      G_init_raster_cats(CHAR(STRING_ELT(output, 0)), &labels[0]);
      for (i=0; i<GET_LENGTH(levels); i++) {
	 i1 = i+1;
         G_set_c_raster_cat((CELL *) &i1, (CELL *) &i1,
	   CHAR(STRING_ELT(levels, i)), &labels[0]);
      }
   }
   icell = 0;
   for (row = 0; row < GR_nrows; row++) {
      for (col = 0; col < GR_ncols; col++) {
	  if (data_type == CELL_TYPE) {
	      if (INTEGER_POINTER(layer)[icell] == NA_INTEGER)
		  G_set_null_value(rast_ptr, 1, data_type);
	      else G_set_raster_value_c(rast_ptr, 
		  (CELL)(INTEGER_POINTER(layer)[icell]), data_type);
	  }
	  else {
	      if (ISNA(NUMERIC_POINTER(layer)[icell]))
		  G_set_null_value(rast_ptr, 1, data_type);
	      else G_set_raster_value_d(rast_ptr, 
		  (DCELL)(NUMERIC_POINTER(layer)[icell]), data_type);
	  }
	  icell++;
	  rast_ptr = G_incr_void_ptr(rast_ptr, G_raster_size(data_type));
       }
       G_put_raster_row (cf, rast, data_type);
       rast_ptr = rast;
   }
   G_close_cell (cf);
   if(LOGICAL_POINTER(isfactor)[0]) 
      G_write_raster_cats(CHAR(STRING_ELT(output, 0)), &labels[0]);
   G_put_cell_title (CHAR(STRING_ELT(output, 0)), CHAR(STRING_ELT(title, 0)));
   if(LOGICAL_POINTER(isfactor)[0]) 
      G_free_raster_cats(&labels[0]);
   PROTECT(ans = NEW_INTEGER(1));
   INTEGER_POINTER(ans)[0] = 0;
   UNPROTECT(1);
   
   return(ans);
}
