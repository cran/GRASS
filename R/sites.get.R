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
# sites.get moves one GRASS 5.0 sites file to a data frame, returning
# the filled object. 
#
sites.get <- function(G, slist = "", debug=FALSE) {
	if (class(G) != "grassmeta") stop("No GRASS metadata object")
	if (! is.character(slist))
		stop("character GRASS data base file name required")
	G.list <- list.GRASS(type="sites")
	res <- slist %in% G.list
	if (! all(res)) {
		warning("The following GRASS data base file was not found:")
		print(slist[res == FALSE])
		stop("transfer terminated")
	}
	FILE <- tempfile("GRtoR")
	system(paste("s.out.ascii -d sites=", slist, " > ", FILE, sep=""))
	data <- read.table(FILE, na.strings="*")
	# CHANGE 000329 RSB Only expect eastings and northings, not id as before
	nc2 <- ncol(data) - 2
	nlist <- character(0)
	for (i in 1:nc2) nlist <- c(nlist, paste("var", i, sep=""))
	names(data) <- c("east", "north", nlist)
	if (!debug) unlink(FILE)
	invisible(data)
}
