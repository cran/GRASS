# Copyright 2000 by Roger S. Bivand. 
#

hh <- system("if test -z $GISBASE ; then echo 1 ; else echo 0 ; fi", 
	intern=TRUE)

if(hh == "0") {
	.First.lib <- function(lib, pkg) {
	  library.dynam("grassR", pkg, lib)
	cat("Running in", paste(system("g.gisenv", intern=TRUE),
		collapse=" "), "\n")
	}
} else {
	cat("No GRASS database defined - running in interpreted mode\n")
}

