% Copyright 1999-2000 by Roger S. Bivand
%
\name{kde2d.G}
\alias{kde2d.G}
%- Also NEED an `\alias' for EACH other topic documented here.
\title{Two-Dimensional Kernel Density Estimation on a GRASS Grid}
\description{
 A version of \code{kde2d()} in the MASS package of the VR collection using the metadata of the underlying GRASS LOCATION. \code{kde2d()} is for "two-dimensional kernel density estimation with an axis-aligned bivariate normal kernel, evaluated on a square grid." An optional feature is the introduction of a weighted moving average through the Z argument.
}
\usage{
kde2d.G(x, y, h, G, reverse=NULL, Z=NULL)
}
%- maybe also `usage' for other objects documented here.
\arguments{
 \item{x}{x coordinate of data}
 \item{y}{y coordinate of data}
 \item{h}{vector of bandwidths for x and y directions.
             Defaults to normal reference bandwidth.}
 \item{G}{GRASS metadata from \code{gmeta()}}
 \item{reverse}{see \code{help(reverse)}}
 \item{Z}{vector of attribute values}
}
\value{
  A vector of \code{G$Ncells} values is returned, with the results of density/weighted moving average calculations ordered as a GRASS raster file. Density values are points per unit area, while moving average values are in the units of the Z variable.
}
\references{\url{http://www.geog.uni-hannover.de/grass/statsgrasslist.html}, \url{http://www.baylor.edu/~grass}, Bivand, R. S., (2000) Using the R statistical data analysis language on GRASS 5.0 GIS data base files. Computers and Geosciences, 26, pp. 1043-1052.}
\author{Original \code{kde2d(), bandwidth.nrd()}: Brian D. Ripley and Bill Venables as detailed in the MASS package documentation; adapted by Roger S. Bivand, Department of Geography, Norwegian School of Economics and Business Administration, Breiviksveien 40, N-5045 Bergen, Norway; e-mail: \email{Roger.Bivand@nhh.no.}}

\note{The functions in this package are intended to work with the GRASS geographical information system. The examples will only work if R is started from inside GRASS, choosing the location for the Maas bank soil pollution data. GRASS installations differ in permissions needed to establish a new location, and system administrator privileges may be needed to create the Maas location. Information about the necessary metadata may be found by: \code{help(utm.maas)}. All of the examples in this package may be run from this location in batch by \code{R CMD check GRASS}, to check for correct installation. The actual data may be accessed from R: \code{data(utm.maas)}.}


\seealso{\code{\link{kde2d}}}

\examples{
if(length(ls(pat="Zn.o"))==0){example(utm.maas)}
if(length(ls(pat="G"))==0){example(gmeta)}
inregion <- (utm.maas$east >= G$w & utm.maas$east <= G$e) & (utm.maas$north >= G$s & utm.maas$north <= G$n)
if(all(!inregion)) stop("None of the site locations are inside the current GRASS region")
if(any(!inregion)) warning("Some site locations are outside the current GRASS region")
plot(G, kde2d.G(utm.maas$east, utm.maas$north, h=c(300,300), G=G)*maasmask)
points(utm.maas$east, utm.maas$north)
rug(utm.maas$east, side=1, ticksize=0.02)
rug(utm.maas$north, side=2, ticksize=0.02)
title(main="Kernel estimates of density of soil sample placing",
  xlab="(Bailey & Gatrell, pp. 84-88")
plot(G, kde2d.G(utm.maas$east, utm.maas$north, h=c(300,300), G=G, Z=utm.maas$Zn)*maasmask)
points(utm.maas$east, utm.maas$north)
rug(utm.maas$east, side=1, ticksize=0.02)
rug(utm.maas$north, side=2, ticksize=0.02)
title(main="Kernel density weighted average, Zn ppm",
  xlab="(Bailey & Gatrell, pp. 159-161")
}
\keyword{GRASS, interface, spatial statistics}%-- one or more ...
