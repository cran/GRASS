# Copyright 1999-2000 by Roger S. Bivand
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
interp.new.G <- function(G, x, y, z, extrap = FALSE,
		duplicate = "error", dupfun = NULL, reverse=NULL) {
    require(akima)
    temp <- interp.new(x, y, z, xo=G$xseq, yo=G$yseq, 
	extrap = extrap, duplicate = duplicate, dupfun = dupfun)
    if(is.null(reverse)) reverse <- reverse(G)
    return(as.vector(temp$z)[reverse])
}
