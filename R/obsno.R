# Copyright 2000 by Roger S. Bivand
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
# obsno() is an access function to return the numbers in sequence
# of raster cells. The function is used when NA cells need to be dropped
# for analysis but reinstated later for display or transfer back to GRASS.
#
obsno <- function(G)
{
    if (class(G) != "grassmeta") stop("No GRASS metadata object")
    if(is.loaded("obsnoG")) {
	obsno <- .Call("obsnoG", G)
    } else {
        obsno <- as.integer(1:G$Ncells)
    }
    invisible(obsno)
}

