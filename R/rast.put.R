# Copyright 1999-2001 by Roger S. Bivand
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
# retrieved by gmeta() from the GRASS data base.
#
rast.put <- function(G, lname="", layer, title="", cat=FALSE, DCELL=FALSE, breaks=NULL, col=NULL, nullcol=NULL, defcol=NULL, debug=FALSE, interp=FALSE) 
    {
    if (class(G) != "grassmeta") stop("Data not a grass object")
    if (length(lname) != 1)
	stop("Single new GRASS data base file name required")
    if (!(is.numeric(layer) || is.factor(layer)))
	stop("layer is neither numeric nor factor")
    if(is.loaded("rastput") && (interp == FALSE)) {
	if(is.null(nullcol)) nullcol <- "honeydew"
	if(is.null(defcol)) defcol <- "pale turquoise"
	nullcolor <- as.integer(col2rgb(nullcol[1]))
	defcolor <- as.integer(col2rgb(defcol[1]))
	if(cat || is.factor(layer)) {
	    if(!is.null(breaks)) warning("breaks ignored for factor layers")
	    if (is.null(col)) {
		col <- rev(grey(1:length(levels(layer))/length(levels(layer))))
	    }
	    else if(length(levels(layer)) != length(col))
		stop("number of colors must equal number of factor levels")
	    color <- as.integer(col2rgb(col))
	    layer.range <- range(na.omit(codes(layer)))
	        x <- .Call("rastput", G=G, layer=as.integer(codes(layer)),
		isfactor=TRUE, DCELL=FALSE, levels=levels(layer),
		output=lname, title=title, breaks=NULL,
		color=as.integer(color), nullcolor=as.integer(nullcolor),
		as.integer(defcolor), range=as.integer(layer.range))
	} else {
	    if(is.null(breaks)) {
		breaks <- pretty(as.double(na.omit(layer)), n=20, min.n=10)
	    } else {
		if (!is.numeric(breaks))
		    stop("non-numeric breaks not accepted")
	    }
	    if (is.null(col)) {
		col <- rev(grey(1:(length(breaks)-1)/(length(breaks)-1)))
	    } else if(length(breaks) != (length(col)-1))
		stop("number of colors must equal one less than the number of breaks")
	    layer.levels <- character((length(breaks)-1))
	    for (i in 1:(length(breaks)-1)) {
		layer.levels[i] <- paste("(", signif(breaks[i]), ",",
		    signif(breaks[i+1]), "]", sep="")
	    }
	    col <- as.integer(col2rgb(col))
	    layer.range <- range(breaks)
	    x <- .Call("rastput", G=G, layer=as.double(layer), isfactor=FALSE, 
		DCELL=FALSE, levels=layer.levels, output=lname, title=title,
		breaks=as.double(breaks), color=as.integer(col),
		nullcolor=as.integer(nullcolor), as.integer(defcolor),
		range=as.double(layer.range))
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
	if (cat) write(t(matrix(as.integer(codes(layer)), nrow=G$Nrow,
		ncol=G$Ncol, byrow=T)), file=FILE, append=T,
		ncolumns=G$Ncol)
	else write(t(matrix(as.double(layer), nrow=G$Nrow, ncol=G$Ncol, 
		byrow=T)), file=FILE, append=T, ncolumns=G$Ncol)
	if (cat) system(paste("r.in.ascii -i input=", FILE, " nv=NA output=", 
		lname, " title=\"", title, "\"", sep=""))
	else {
	    if (DCELL)
	        system(paste("r.in.ascii -d input=", FILE, " nv=NA output=", 
	  	    lname, " title=\"", title, "\"", sep=""))
	    else
	        system(paste("r.in.ascii -f input=", FILE, " nv=NA output=", 
	  	    lname, " title=\"", title, "\"", sep=""))
	}
	if (!debug) unlink(FILE)
    }
}
