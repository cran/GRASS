# Copyright 1999-2000 by Roger S. Bivand
#
# sites.get moves one GRASS 5.0 sites file to a data frame, returning
# the filled object. 
#
sites.get <- function(G, slist = "", all.sites=FALSE, debug=FALSE) {
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
	if (all.sites) allsites <- " -a"
	else allsites <- ""
	FILE <- tempfile("GRtoR")
	system(paste("s.out.ascii -d", allsites, " sites=", slist,
		" > ", FILE, sep=""))
	data <- read.table(FILE, na.strings="*")
	# CHANGE 000329 RSB Only expect eastings and northings, not id as before
	nc2 <- ncol(data) - 2
	nlist <- character(0)
	for (i in 1:nc2) nlist <- c(nlist, paste("var", i, sep=""))
	names(data) <- c("east", "north", nlist)
	if (!debug) unlink(FILE)
	invisible(data)
}
