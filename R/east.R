# Copyright 2001 by Roger S. Bivand
#
# east() is an access function to return the eastings coordinates
# of raster cell centres from a grassmeta object
#
east <- function(G)
{
    if (class(G) != "grassmeta") stop("No GRASS metadata object")
    if(is.loaded("eastG", PACKAGE="grassR")) {
	east <- .Call("eastG", G, PACKAGE="grassR")
    } else {
        east <- as.numeric(c(matrix(G$xseq, length(G$xseq), length(G$ryseq))))
    }
    invisible(east)
}


