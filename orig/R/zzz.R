# Copyright 2000 by Roger S. Bivand. 
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

hh <- system("if test -z $GISBASE ; then echo 1 ; else echo 0 ; fi", 
	intern=TRUE)

if(hh == "0") {
	.First.lib <- function(lib, pkg) {
	  library.dynam("grassR", pkg, lib)
	cat("Running in", paste(system("g.gisenv", intern=T),
		collapse=" "), "\n")
	}
} else {
	cat("No GRASS database defined - running in interpreted mode\n")
}

