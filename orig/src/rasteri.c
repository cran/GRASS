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

int G_get_raster_i(void *rast, struct Categories *pcats , RASTER_MAP_TYPE data_type)
{
    CELL i;
    DCELL val;

    val = G_get_raster_value_d(rast, data_type);
    i = G_quant_get_cell_value(&pcats->q, val);
    return (int) i+1;
}
