% Copyright 2001 by Roger S. Bivand

\name{contour.G}
\alias{contour.G}
%- Also NEED an `\alias' for EACH other topic documented here.
\title{Equal scale contour plots for GRASS raster and site data}
\description{
contour.G provides a simple interface between grass data objects and the \code{contour()} function}.
\usage{
contour.G(x, layer=NULL, xlab="", ylab="", reverse=NULL, add=FALSE, ...)
}
%- maybe also `usage' for other objects documented here.
\arguments{
 \item{x}{GRASS metadata from \code{gmeta()}}
 \item{layer}{GRASS-ordered raster layer passed on to \code{contour()}}
 \item{xlab}{a title for the x axis, passed to \code{plot()}}
 \item{ylab}{a title for the y axis, passed to \code{plot()}}
 \item{reverse}{see \code{help(reverse)}}
 \item{add}{FALSE for new plot, TRUE to overlay layer on prior plot}
 \item{\dots}{parameters passed through to \code{contour()}}}
\details{
 The function uses \code{asp=1} from the \code{plot.window()} function to
ensure that the scales chosen to be equal on both axes, that is 1cm represents
the same units on each. 
}
\value{
  none
}
\references{\url{http://www.geog.uni-hannover.de/grass/statsgrasslist.html}, \url{http://www.baylor.edu/~grass}, Bivand, R. S., (2000) Using the R statistical data analysis language on GRASS 5.0 GIS data base files. Computers and Geosciences, 26, pp. 1043-1052.}
\author{Roger S. Bivand, Department of Geography, Norwegian School of Economics and Business Administration, Breiviksveien 40, N-5045 Bergen, Norway; e-mail: \email{Roger.Bivand@nhh.no.}}

\note{The functions in this package are intended to work with the GRASS geographical information system. The examples will only work if R is started from inside GRASS, choosing the location for the Maas bank soil pollution data. GRASS installations differ in permissions needed to establish a new location, and system administrator privileges may be needed to create the Maas location. Information about the necessary metadata may be found by: \code{help(utm.maas)}. All of the examples in this package may be run from this location in batch by \code{R CMD check GRASS}, to check for correct installation. The actual data may be accessed from R: \code{data(utm.maas)}.}

\seealso{\code{\link{plot.window}}, \code{\link{contour}}, \code{\link{plot.grassmeta}}}


\examples{
if(length(ls(pat="Zn.o"))==0){example(utm.maas)}
if(length(ls(pat="G"))==0){example(gmeta)}
contour.G(G)
points(utm.maas$east, utm.maas$north, pch=codes(Zn.o))
legend(x=c(269800, 270500), y=c(5652300, 5653000), pch=c(1:5),
legend=levels(Zn.o))
title("Note equal east and north scales")
contour.G(G, kde2d.G(utm.maas$east, utm.maas$north, h=c(300,300), G=G, Z=utm.maas$Zn)*maasmask)
points(utm.maas$east, utm.maas$north, pch=codes(Zn.o))
legend(x=c(269800, 270500), y=c(5652300, 5653000), pch=c(1:5),
legend=levels(Zn.o))
title("Kernel density representation of soil Zn")
}
\keyword{spatial}
\keyword{IO}
