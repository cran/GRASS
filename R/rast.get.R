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
# rast.get moves one or more GRASS 5.0 raster files to a list, returning
# the filled object. Setting catlabels to TRUE imports category labels 
# instead of codes, and requires more memory.
#
rast.get <- function(G, rlist, catlabels=NULL, debug=FALSE, interp=FALSE) 
{
    if (class(G) != "grassmeta") stop("No GRASS metadata object")
    if (! is.character(rlist))
	stop("character vector of GRASS data base file names required")
    if (! is.null(catlabels)) {
	if (! is.logical(catlabels))
	    stop("catlabels should be logical vector")
	if (length(catlabels) != length(rlist))
	    stop("catlabels should be same length as rlist")
    } else catlabels <- rep(FALSE, length(rlist))
    
    if(is.loaded("rastget") && (interp == FALSE)) {
	data <- .Call("rastget", G=G, layers=rlist, flayers=catlabels)
    } else {
	G.list <- list.GRASS(type="rast")
	res <- rlist %in% G.list
	if (! all(res)) {
		warning("The following GRASS data base files were not found:")
		print(rlist[res == FALSE])
		stop("transfer terminated")
	}
	data <- vector(mode="list", length=length(rlist))
	ndata <- character(length=length(rlist))
	for (i in 1:length(rlist)) {
	    FILE <- tempfile("GRtoR")
	    if (catlabels[i]) {
		rstats <- "r.stats -1ql fs=\":\" input="
		rstats <- paste(rstats, rlist[i], ",", sep="")
		rstats <- paste(rstats, " output=", FILE, sep="")
		system(rstats)
		x <- scan(FILE, what=(list(double(0), character(0))), 
		    sep=":", na.strings="*", quiet=TRUE)
		if (length(x[[1]]) != G$Ncells)
		    stop("Number of rows imported does not match metadata")
		x[[2]][is.na(x[[1]])] <- NA
		ndata[i] <- paste(rlist[i], ".f", sep="")
		data[[i]] <- factor(x[[2]], levels=unique(x[[2]]), ordered=TRUE)
		rm(x)
	    } else {
		rstats <- "r.stats -1q fs=\":\" input="
		rstats <- paste(rstats, rlist[i], ",", sep="")
		rstats <- paste(rstats, " output=", FILE, sep="")
		system(rstats)
		x <- scan(FILE, na.strings="*", quiet=TRUE)
		if (length(x) != G$Ncells)
		    stop("Number of rows imported does not match metadata")
		ndata[i] <- rlist[i]
		data[[i]] <- x
		rm(x)
	    }
	    if (!debug) unlink(FILE)
	}
	names(data) <- ndata
    }
    invisible(data)
}
