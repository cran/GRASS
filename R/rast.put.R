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
# rast.put moves a single numeric vector to GRASS, using the metadata
# prepared when layers were got from the GRASS data base.
#
rast.put <- function(G, lname="", layer, title="", cat=FALSE, debug=FALSE, interp=FALSE) 
    {
    if (class(G) != "grassmeta") stop("Data not a grass object")
    if (length(lname) != 1)
	stop("Single new GRASS data base file name required")
    if (!(is.numeric(layer) || is.ordered(layer)))
	stop("layer is neither numeric nor ordered")
    if(is.loaded("rastput") && (interp == FALSE)) {
	if(cat && is.ordered(layer)) {
	    x <- .Call("rastput", G=G, layer=as.integer(layer), isfactor=TRUE, 
		levels=levels(layer), output=lname, title=title)
	} else {
	    x <- .Call("rastput", G=G, layer=as.double(layer), isfactor=FALSE, 
		levels=NULL, output=lname, title=title)
	}
    } else {
	G.list <- list.GRASS(type="rast")
	res <- lname %in% G.list
	if (any(res))
		stop(paste(lname, ": GRASS raster file already exists", 
			sep=""))
	if (length(layer) != G$Ncells)
		stop("GRASS object metadata do not match layer length")
	FILE <- tempfile("RtoGR")
	outstr <- paste("north:   ", G$n, "\nsouth:   ", G$s, "\neast:    ", 
		G$e, "\nwest:    ", G$w, "\nrows:    ", G$Nrow, 
		"\ncols:    ", G$Ncol, "\n", sep="")
	cat(outstr, file=FILE)
	if (cat) write(t(matrix(as.integer(layer), nrow=G$Nrow, ncol=G$Ncol,
		byrow=T)), file=FILE, append=T, ncolumns=G$Ncol)
	else write(t(matrix(as.double(layer), nrow=G$Nrow, ncol=G$Ncol, 
		byrow=T)), file=FILE, append=T, ncolumns=G$Ncol)
	if (cat) system(paste("r.in.ascii -i input=", FILE, " nv=NA output=", 
		lname, " title=\"", title, "\"", sep=""))
	else system(paste("r.in.ascii -d input=", FILE, " nv=NA output=", 
		lname, " title=\"", title, "\"", sep=""))
	if (!debug) unlink(FILE)
    }
}
