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
# gmeta is a function that returns GRASS LOCATION metadata in a grassmeta object.
#
# CHANGED 000329 from g.region -g to g.region -p to get numbers of rows and columns directly
# CHANGED 000614 to replace dataframe xy by list xy
#
# CHANGED 000628 to introduce support for compiled "gmeta"
#
# CHANGED 000706 to move east, north, obsno and reverse to access functions
#
# CHANGED 000714 to add interp argument

gmeta <- function(interp=FALSE) {
    if (system("which g.gisenv 2> /dev/null 1> /dev/null") != 0) {
	help(pcbs)
	stop("No GRASS environment detected - start GRASS before entering R")
    }
    if(is.loaded("gmeta") && (interp == FALSE)) {
	G <- .Call("gmeta")
    } else {
	G <- vector(mode="list")
	G$LOCATION <- system("g.gisenv LOCATION_NAME", intern=TRUE)
	G$MAPSET <- system("g.gisenv MAPSET", intern=TRUE)
	META <- system("g.region -p", intern=TRUE)
	ML <- length(META)
	if (ML > 8) G$proj <- paste(META[1:(ML-8)], sep=" ", collapse="; ")
	G$n <- as.numeric(unlist(strsplit(META[ML-7], ":"))[2])
	G$s <- as.numeric(unlist(strsplit(META[ML-6], ":"))[2])
	G$w <- as.numeric(unlist(strsplit(META[ML-5], ":"))[2])
	G$e <- as.numeric(unlist(strsplit(META[ML-4], ":"))[2])
	G$nsres <- as.numeric(unlist(strsplit(META[ML-3], ":"))[2])
	G$ewres <- as.numeric(unlist(strsplit(META[ML-2], ":"))[2])
	G$Nrow <- as.numeric(unlist(strsplit(META[ML-1], ":"))[2])
	G$Ncol <- as.numeric(unlist(strsplit(META[ML], ":"))[2])
	G$Ncells <- G$Nrow * G$Ncol
	G$xlim <- c(G$w, G$e)
	G$ylim <- c(G$s, G$n)
	G$xseq <- seq(from=G$w + (G$ewres/2), to=G$e - (G$ewres/2), by=G$ewres)
	G$yseq <- seq(from=G$s + (G$nsres/2), to=G$n - (G$nsres/2), by=G$nsres)
	G$ryseq <- rev(G$yseq)
#	G$xy <- list(east=c(matrix(G$xseq, length(G$xseq), length(G$ryseq))),
#    		north=c(matrix(G$ryseq, length(G$xseq), length(G$ryseq),
#		 byrow=T)))
#	G$obsno <- 1:length(G$xy$east)
#	G$reverse <- order(G$xy$north, G$xy$east)
	class(G) <- "grassmeta"
    }
    invisible(G)
}
