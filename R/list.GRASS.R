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
# list.GRASS lists available GRASS data base files of the user-
# specified data type, returning a character vector.
# 
#
list.GRASS <- function(type = "rast") {
	if (system("which g.gisenv 2> /dev/null 1> /dev/null") != 0) {
		help(pcbs)
		stop("No GRASS environment detected - start GRASS before entering R")
	}
	res <- system(paste("g.list ", type, sep=""), intern=TRUE)
	G.list <- character(0)
	for(i in 3:(length(res)-1)) if (nchar(res[i]) > 0) G.list <- c(G.list, breakup(res[i]))
	invisible(G.list)
}

breakup <- function(chars) {
	tmp <- unlist(strsplit(chars, split="\t"))
	tmp1 <- character(0)
	for (i in 1:length(tmp)) tmp1 <- c(tmp1, unlist(strsplit(tmp[i], split=" ")))
	tmp1[nchar(tmp1) > 0]
}
