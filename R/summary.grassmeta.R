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
#
# summary.grassmeta displays the metadata prepared when map layers are moved to R.
#
# CHANGED 000329 RSB added projection output
summary.grassmeta <- function(object, ...) {
	G <- object
	if (class(G) != "grassmeta") stop("Data not a grass object")
	cat("Data from GRASS 5.0 LOCATION ", G$LOCATION, " with ", G$Ncol,
	" columns and ", G$Nrow, " rows;\n", G$proj, "\nThe west-east range is: ",
	G$w, ", ", G$e, ", and the south-north: ",
	G$s, ", ", G$n,
	";\nWest-east cell sizes are ", G$ewres,
	" units, and south-north ", G$nsres,
	" units.\n", sep="")
}
