# Copyright 1999-2000 by Roger S. Bivand
#
# sites.put moves a single variable site to GRASS, using the metadata
# prepared when layers were got from the GRASS data base.
#
sites.put <- function(G, lname="", east, north, var, debug=FALSE) {
	if (class(G) != "grassmeta") stop("Data not a grass object")
	if (length(lname) != 1)
		stop("Single new GRASS data base file name required")
	G.list <- list.GRASS(type="sites")
	res <- lname %in% G.list
	if (any(res))
		stop(paste(lname, ": GRASS sites file already exists", sep=""))
	if (length(east) != length(north))
		stop("Different numbers of eastings and northings")
	if (length(east) != length(var))
		stop("Different numbers of coordinates and observations")
	inregion <- (east >= G$w & east <= G$e) & (north >= G$s & north <= G$n)
	if(all(!inregion)) stop("None of the site locations are inside the current GRASS region")
	if(any(!inregion)) warning("Some site locations are outside the current GRASS region")
	FILE <- tempfile("RtoGR")
	if (is.numeric(var))
		a <- data.frame(x=east, y=north, z=as.character(paste("%", var, sep="")))
	else
		a <- data.frame(x=east, y=north, z=as.character(paste("@", var, sep="")))
	write.table(a, row.names=FALSE, col.names=FALSE, quote=FALSE, file=FILE)
	system(paste("s.in.ascii input=", FILE, " sites=", lname, sep=""))
	if (!debug) unlink(FILE)
}
