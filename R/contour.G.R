# Copyright 2001 by Roger S. Bivand
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
# contour.G is a wrapper 
contour.G <- function (x, layer = NULL, xlab = "", ylab = "",
    reverse = NULL, add = FALSE, ...) 
{
    G <- x
    if (class(G) != "grassmeta") 
        stop("Data not a grass object")
    if (!add) {
        plot(G$xlim, G$ylim, xlim = G$xlim, ylim = G$ylim, asp = 1, 
            xlab = xlab, ylab = ylab, type = "n")
    }
    if (!is.null(layer)) {
        if (length(layer) != G$Ncells) 
            stop("GRASS object metadata do not match layer length")
        if (is.null(reverse)) 
            reverse <- reverse(G)
        contour(x = G$xseq, y = G$yseq, z = t(matrix(layer[reverse], 
            nrow = G$Nrow, ncol = G$Ncol, byrow = T)), add = T, 
            ...)
    }
}

