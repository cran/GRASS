# GRASS adaptation Copyright 1999-2001 by Roger S. Bivand
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#

#
# trmat copyright 1994-9 W.N.Venables & B.D.Ripley
#
trmat.G <- function (obj, G, east=NULL, north=NULL) 
{
    require(spatial)
    if (!inherits(obj, "trls")) 
        stop("object not a fitted trend surface")
    if (class(G) != "grassmeta") 
        stop("Data not a grass object")
    if (is.null(east)) east <- east(G)
    if (is.null(north)) north <- north(G)
    z <- predict(obj, east, north) 
    invisible(z)
}


