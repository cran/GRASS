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
#define NO_DATA (G_set_c_null_value (&tmp, 1), (CELL) tmp)

int G_get_raster_cat_i(void *rast, struct Categories *pcats , RASTER_MAP_TYPE data_type)
{
    CELL i;
    CELL tmp;
    DCELL val;

    val = G_get_raster_value_d(rast, data_type);
    i = G_quant_get_cell_value(&pcats->q, val);
    if(i == NO_DATA) G_fatal_error("category code lookup failure");
    return (int) i+1;
}
