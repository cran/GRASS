# Copyright 2000 by Roger S. Bivand
#
# obsno() is an access function to return the numbers in sequence
# of raster cells. The function is used when NA cells need to be dropped
# for analysis but reinstated later for display or transfer back to GRASS.
#
obsno <- function(G)
{
    if (class(G) != "grassmeta") stop("No GRASS metadata object")
    if(is.loaded("obsnoG", PACKAGE="grassR")) {
	obsno <- .Call("obsnoG", G, PACKAGE="grassR")
    } else {
        obsno <- as.integer(1:G$Ncells)
    }
    invisible(obsno)
}

