# Copyright 2000 by Roger S. Bivand
#
# north() is an access function to return the northings coordinates
# of raster cell centres from a grassmeta object
#
north <- function(G)
{
    if (class(G) != "grassmeta") stop("No GRASS metadata object")
    if(is.loaded("northG", PACKAGE="grassR")) {
	north <- .Call("northG", G, PACKAGE="grassR")
    } else {
        north <- as.numeric(c(matrix(G$ryseq, length(G$xseq), length(G$ryseq),
            byrow=TRUE)))
    }
    invisible(north)
}


