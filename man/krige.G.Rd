\name{krige.G}
\alias{krige.G}
\alias{prmat2.G}
\alias{semat2.G}
%- Also NEED an `\alias' for EACH other topic documented here.
\title{Kriging prediction for GRASS maps}
\description{
  The function is a modified and simplified version of the sgeostat \code{krige()} function, using the current GRASS region to generate points for ordinary kriging prediction. Based in part on advice from Albrecht Gebhardt (for the implementation of which I am responsible!), it uses compiled code from the spatial library, and only supports exponential, gaussian, and spherical variogram models. The examples also illustrate the use of the contributed \code{fields} package.
}
\usage{
krige.G(point.obj, at, var.mod.obj, G, mask=NULL)
}
%- maybe also `usage' for other objects documented here.
\arguments{
  \item{point.obj}{The point data frame used for fitting the variogram}
  \item{at}{The string name of the variable in \code{point.obj} to be predicted}
  \item{var.mod.obj}{The chosen fitted variogram model}
  \item{G}{A grassmeta object describing the current GRASS region}
  \item{mask}{A vector of length \code{east(G)} with NA's in locations for which no prediction is needed}
}
\details{
  The function appears to correspond to Gstat
  (\url{http://www.geog.uu.nl/gstat}) ordinary kriging predictions for
  point locations. The specific links between the sgeostat variogram
  models and the spatial \code{surf.gls} covariance arguments are:
  \code{se=sqrt(nugget+sill)}, \code{alpha=nugget/(nugget+sill)},
  and \code{d=range}.

}
\value{
  The function returns a list of three components:
  \item{kr}{trgls object returned by surf.gls}
  \item{zhat}{kriging predictions}
  \item{sehat}{kriging standard errors}
  ...
}
\references{\url{http://grass.itc.it/statsgrass/index.html}, \url{http://www.gis.iastate.edu/SGeoStat/homepage.html}; Bivand, R. S., (2000) Using the R statistical data analysis language on GRASS 5.0 GIS data base files. Computers and Geosciences, 26, pp. 1043-1052.}
\author{Original \code{krige()}: as detailed in the sgeostat package documentation and Albrecht Gephardt, the package's R maintainer; adapted by Roger S. Bivand, e-mail: \email{Roger.Bivand@nhh.no.}}

\note{The functions in this package are intended to work with the GRASS geographical information system. The examples will only work if R is started from inside GRASS, choosing the location for the Maas bank soil pollution data. GRASS installations differ in permissions needed to establish a new location, and system administrator privileges may be needed to create the Maas location. Information about the necessary metadata may be found by: \code{help(utm.maas)}. All of the examples in this package may be run from this location in batch by \code{R CMD check GRASS}, to check for correct installation. The actual data may be accessed from R: \code{data(utm.maas)}.}


\seealso{\code{\link{krige}}, \code{\link{surf.gls}}, \code{\link{prmat}}, \code{\link{semat}}, \code{\link{vgram}}, \code{\link{Krig}}, \code{\link{predict.Krig}}, \code{\link{predict.se.Krig}}}


\examples{
if(length(ls(pat="Zn.o"))==0){example(utm.maas)}
if(length(ls(pat="G"))==0){example(gmeta)}
inregion <- (utm.maas$east >= G$w & utm.maas$east <= G$e) &
 (utm.maas$north >= G$s & utm.maas$north <= G$n)
if(all(!inregion))
 stop("None of the site locations are inside the current GRASS region")
if(any(!inregion))
 warning("Some site locations are outside the current GRASS region")
require(sgeostat)
maas.pts <- point(utm.maas, x="east", y="north")
maas.pairs <- pair(maas.pts, num.lags=10, maxdist=1000)
maas.evg <- est.variogram(maas.pts, maas.pairs, a1="Zn")
plot(maas.evg)
text(maas.evg$bins, maas.evg$classic/2, labels=maas.evg$n, pos=1)
abline(h=25000)
abline(h=170000)
maas.fit.exp <- fit.exponential(maas.evg, c0=24803.4, ce=158232,
 ae=361.604, plot.it=T, iterations=0)
cat("Using parameters from B&McD, p. 142 without fitting.\n")
res.G1 <- krige.G(maas.pts, "Zn", maas.fit.exp, G, maasmask)
summary(res.G1$zhat)
summary(res.G1$sehat)
plot(G, res.G1$zhat, breaks=round(seq(120,1660,length=9)), col=grey(9:2/9))
plot(G, ifelse(is.na(maasmask), 1, NA), col="wheat", add=T)
legend(c(269900, 270600), c(5652000, 5652900), bty="n", bg="wheat",
 legend=c(rev(legtext(round(seq(120,1660,length=9)))), "mask=NA"),
 fill=c(rev(grey(9:2/9)), "wheat"))
title("Ordinary kriging predictions")
}
\keyword{spatial}
\keyword{IO}
