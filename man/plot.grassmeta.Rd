% Copyright 1999-2000 by Roger S. Bivand
%
\name{plot.grassmeta}
\alias{plot.grassmeta}
\alias{legtext}
%- Also NEED an `\alias' for EACH other topic documented here.
\title{Equal scale plots for GRASS raster and site data}
\description{
plot.grassmeta provides a simple interface between grass data objects and the \code{image()} function; category layers may be plotted by taking \code{codes()} of the layer, and setting zlim to non-default values. If layer is not set, a blank base map is plotted, for instance for use with \code{points()}.
}
\usage{
plot.grassmeta(G, layer=NULL, xlab="", ylab="", reverse=NULL, add=FALSE, ...)
legtext(x)
}

%- maybe also `usage' for other objects documented here.
\arguments{
 \item{G}{GRASS metadata from \code{gmeta()}}
 \item{layer}{GRASS-ordered raster layer passed on to \code{image()}}
 \item{xlab}{a title for the x axis, passed to \code{eqscplot()}}
 \item{ylab}{a title for the y axis, passed to \code{eqscplot()}}
 \item{reverse}{see \code{help(reverse)}}
 \item{add}{FALSE for new plot, TRUE to overlay layer on prior plot}
 \item{\dots}{parameters passed through to \code{eqscplot()} and \code{image()}}
}
\details{
 The function uses \code{asp=1} from the \code{plot.window()} function to
ensure that the scales chosen to be equal on both axes, that is 1cm represents
the same units on each. The \code{legtext} function is a small helper to aid
in converting image break levels into legend texts, taking a numeric argument
as \code{image(break=)}, and returning a character vector.
}
\value{
  none
}
\references{\url{http://www.geog.uni-hannover.de/grass/statsgrasslist.html}, \url{http://www.baylor.edu/~grass}, Bivand, R. S., (2000) Using the R statistical data analysis language on GRASS 5.0 GIS data base files. Computers and Geosciences, 26, pp. 1043-1052.}
\author{Roger S. Bivand, Department of Geography, Norwegian School of Economics and Business Administration, Breiviksveien 40, N-5045 Bergen, Norway; e-mail: \email{Roger.Bivand@nhh.no.}}

\note{The functions in this package are intended to work with the GRASS geographical information system. The examples will only work if R is started from inside GRASS, choosing the location for the Maas bank soil pollution data. GRASS installations differ in permissions needed to establish a new location, and system administrator privileges may be needed to create the Maas location. Information about the necessary metadata may be found by: \code{help(utm.maas)}. All of the examples in this package may be run from this location in batch by \code{R CMD check GRASS}, to check for correct installation. The actual data may be accessed from R: \code{data(utm.maas)}.}

\seealso{\code{\link{plot.window}}, \code{\link{image}}}

\examples{
if(length(ls(pat="Zn.o"))==0){example(utm.maas)}
if(length(ls(pat="G"))==0){example(gmeta)}
plot(G)
points(utm.maas$east, utm.maas$north, pch=codes(Zn.o))
legend(x=c(67600, 68300), y=c(74500, 75000), pch=c(1:5),
legend=levels(Zn.o))
title("Note equal east and north scales")
example(kde2d.G)
}
\keyword{GRASS, interface, spatial statistics}%-- one or more ...
