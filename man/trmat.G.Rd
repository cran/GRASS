% Copyright 1999-2000 by Roger S. Bivand
%
\name{trmat.G}
\alias{trmat.G}
\title{Evaluate Trend Surface over a GRASS Grid}
\description{
 A wrapper for \code{trmat()} from the \code{spatial} package in the VR bundle, using the metadata of the underlying GRASS LOCATION.
}
\usage{
trmat.G(obj, G, east=NULL, north=NULL)
}
%- maybe also `usage' for other objects documented here.
\arguments{
 \item{obj}{object returned by \code{surf.ls} or \code{surf.gls}}
 \item{G}{GRASS metadata from \code{gmeta()}}
 \item{east}{see \code{help(east)}}
 \item{north}{see \code{help(north)}}
}

\value{
  A vector of \code{G$Ncells} values is returned, with the results of interpolation ordered as a GRASS raster file.
}
\references{\url{http://www.geog.uni-hannover.de/grass/statsgrasslist.html}, \url{http://www.baylor.edu/~grass}, Bivand, R. S., (2000) Using the R statistical data analysis language on GRASS 5.0 GIS data base files. \emph{Computers and Geosciences}, 26, pp. 1043-1052; Unwin, D. J., Wrigley, N. (1987) Towards a general-theory of control point distribution effects in trend surface models. \emph{Computers and Geosciences}, 13, pp. 351-355.}
\author{Original \code{trmat()}: Brian D. Ripley and Bill Venables as detailed in the spatial package documentation; adapted by Roger S. Bivand, Department of Geography, Norwegian School of Economics and Business Administration, Breiviksveien 40, N-5045 Bergen, Norway; e-mail: \email{Roger.Bivand@nhh.no.}}

\note{The functions in this package are intended to work with the GRASS geographical information system. The examples will only work if R is started from inside GRASS, choosing the location for the Maas bank soil pollution data. GRASS installations differ in permissions needed to establish a new location, and system administrator privileges may be needed to create the Maas location. Information about the necessary metadata may be found by: \code{help(utm.maas)}. All of the examples in this package may be run from this location in batch by \code{R CMD check GRASS}, to check for correct installation. The actual data may be accessed from R: \code{data(utm.maas)}.}

\seealso{\code{\link{trmat}}}

\examples{
if(length(ls(pat="Zn.o"))==0){example(utm.maas)}
if(length(ls(pat="G"))==0){example(gmeta)}
if(G$Ncells != length(maasmask))
    stop("example not running in Maas GRASS location")
require(spatial)
s1 <- surf.ls(1, utm.maas$east, utm.maas$north, utm.maas$Zn)
s2 <- surf.ls(2, utm.maas$east, utm.maas$north, utm.maas$Zn)
s3 <- surf.ls(3, utm.maas$east, utm.maas$north, utm.maas$Zn)
s4 <- surf.ls(4, utm.maas$east, utm.maas$north, utm.maas$Zn)
summary(s2)
summary(s3)
summary(s4)
anova(s2,s3,s4)
plot(G, trmat.G(s3, G)*maasmask, breaks=c(-10000, seq(-100, 1500, 200),
  10000), col=c("yellow", grey(8:1/8), "red"))
plot(G, ifelse(is.na(maasmask), 1, NA), col="wheat", add=T)
plot(s3, add=T)
legend(c(269900, 270600), c(5652000, 5652900), bty="n", bg="wheat",
  legend=c("> 1500", rev(legtext(seq(-100,1500,200))), "< -100", "mask=NA"),
  fill=c("red", rev(grey(8:1/8)), "yellow", "wheat"))
oldpar <- par(mfrow=c(2,2))
plot(G, trmat.G(s1, G)*maasmask, breaks=c(-10000, seq(-100, 1500, 200),
  10000), col=c("yellow", grey(8:1/8), "red"))
plot(G, ifelse(is.na(maasmask), 1, NA), col="wheat", add=T)
plot(s1, add=T)
plot(G, trmat.G(s2, G)*maasmask, breaks=c(-10000, seq(-100, 1500, 200),
  10000), col=c("yellow", grey(8:1/8), "red"))
plot(G, ifelse(is.na(maasmask), 1, NA), col="wheat", add=T)
plot(s2, add=T)
plot(G, trmat.G(s3, G)*maasmask, breaks=c(-10000, seq(-100, 1500, 200),
  10000), col=c("yellow", grey(8:1/8), "red"))
plot(G, ifelse(is.na(maasmask), 1, NA), col="wheat", add=T)
plot(s3, add=T)
plot(G, trmat.G(s4, G)*maasmask, breaks=c(-10000, seq(-100, 1500, 200),
  10000), col=c("yellow", grey(8:1/8), "red"))
plot(G, ifelse(is.na(maasmask), 1, NA), col="wheat", add=T)
plot(s4, add=T)
par(oldpar)
}
\keyword{spatial}
\keyword{IO}
