\name{krige.G}
\alias{krige.G}
\alias{do.krige.G}
%- Also NEED an `\alias' for EACH other topic documented here.
\title{Kriging prediction for GRASS maps}
\description{
  The function is a modified and simplified version of the sgeostat \code{krige()} function, using the current GRASS region to generate points for ordinary kriging prediction. It runs very slowly, and does not allow for kriging only in the local neighbourhood.
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
  The function appears to correspond to Gstat (\url{http://www.geog.uu.nl/gstat}) ordinary kriging predictions for point locations, and the example below - which runs for a long time - agrees with the following Gstat command file:

data(zinc): 'bMcd.eas', x=1, y=2, v=3;\cr
variogram(zinc): 33254 Nug(0) + 151996 Exp(394);\cr
data(): 'loc.eas', x=1, y=2;\cr
set output = 'zinc.big.out';\cr

for the parameter values returned by \code{fit.exponential()}.

}
\value{
  The function returns a list of two components:
  \item{zhat}{kriging predictions}
  \item{sigma2hat}{variance}
  ...
}
\references{\url{http://www.geog.uni-hannover.de/grass/statsgrasslist.html}, \url{http://www.baylor.edu/~grass}, \url{http://www.gis.iastate.edu/SGeoStat/homepage.html}; Bivand, R. S., (2000) Using the R statistical data analysis language on GRASS 5.0 GIS data base files. Computers and Geosciences, 26, pp. 1043-1052.}
\author{Original \code{krige()}: as detailed in the sgeostat package documentation and Albrecht Gephardt, the package's R maintainer; adapted by Roger S. Bivand, Department of Geography, Norwegian School of Economics and Business Administration, Breiviksveien 40, N-5045 Bergen, Norway; e-mail: \email{Roger.Bivand@nhh.no.}}

\note{The functions in this package are intended to work with the GRASS geographical information system. The examples will only work if R is started from inside GRASS, choosing the location for the Maas bank soil pollution data. GRASS installations differ in permissions needed to establish a new location, and system administrator privileges may be needed to create the Maas location. Information about the necessary metadata may be found by: \code{help(utm.maas)}. All of the examples in this package may be run from this location in batch by \code{R CMD check GRASS}, to check for correct installation. The actual data may be accessed from R: \code{data(utm.maas)}.}


\seealso{\code{\link{krige}}}


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
maas.fit.exp <- fit.exponential(maas.evg, c0=25000, ce=170000-25000,
 ae=400, plot.it=T)
cat("Prediction starting: take a break ...\n")
res.G1 <- krige.G(maas.pts, "Zn", maas.fit.exp, G, maasmask)
summary(res.G1$zhat)
summary(res.G1$sigma2hat)
summary(sqrt(res.G1$sigma2hat))
plot(G, res.G1$zhat, breaks=round(seq(120,1660,length=9)), col=grey(9:2/9))
plot(G, ifelse(is.na(maasmask), 1, NA), col="wheat", add=T)
legend(c(269900, 270600), c(5652000, 5652900), bty="n", bg="wheat",
 legend=c(rev(legtext(round(seq(120,1660,length=9)))), "mask=NA"),
 fill=c(rev(grey(9:2/9)), "wheat"))
title("Ordinary kriging predictions")

}
\keyword{ ~keyword }%-- one or more ...
\keyword{GRASS, interface, spatial statistics}
