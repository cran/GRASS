% Copyright 1999-2000 by Roger S. Bivand
%
\name{sites.put}
\alias{sites.put}
%- Also NEED an `\alias' for EACH other topic documented here.
\title{Export GRASS sites file}
\description{
 \code{sites.put} moves a single numeric or character vector site to GRASS, using the metadata from \code{gmeta()}.
}
\usage{
sites.put(G, lname="", east, north, var, debug=FALSE)
}
%- maybe also `usage' for other objects documented here.
\arguments{
 \item{G}{GRASS metadata from \code{gmeta()}}
 \item{lname}{Name for new GRASS sites file}
 \item{east}{Eastings of points}
 \item{north}{Northings of points}
 \item{var}{numeric or character vector of attribute values at these points for export}
 \item{debug}{if TRUE, the temporary ASCII file used for transfer is not deleted on exit from the function}
}
\value{
  none
}
\references{\url{http://grass.itc.it/statsgrass/index.html}, Bivand, R. S., (2000) Using the R statistical data analysis language on GRASS 5.0 GIS data base files. Computers and Geosciences, 26, pp. 1043-1052.}
\author{Roger S. Bivand, e-mail: \email{Roger.Bivand@nhh.no.}}

\note{The functions in this package are intended to work with the GRASS geographical information system. The examples will only work if R is started from inside GRASS, choosing the location for the Maas bank soil pollution data. GRASS installations differ in permissions needed to establish a new location, and system administrator privileges may be needed to create the Maas location. Information about the necessary metadata may be found by: \code{help(utm.maas)}. All of the examples in this package may be run from this location in batch by \code{R CMD check GRASS}, to check for correct installation. The actual data may be accessed from R: \code{data(utm.maas)}.}

\seealso{\code{\link{sites.get}}}

\examples{
data(utm.maas)
Zn.o <- as.ordered(cut(utm.maas$Zn, labels=c("insignificant", "low",
"medium", "high", "crisis"), breaks=c(100, 200, 400, 700, 1000, 2000), 
include.lowest=TRUE))
G <- gmeta()
nameQ <- c("ex.Zn.in", "ex.Znlog.in", "ex.Zncat.in")
namesG <- list.GRASS("sites")
if(any(match(nameQ, namesG, nomatch=0) > 0)){
	for (i in 1:3) if(match(nameQ[i], namesG, nomatch=0) > 0)
		system(paste("g.remove sites=", nameQ[i], sep=""))
}
sites.put(G, lname=nameQ[1], east=utm.maas$east, north=utm.maas$north, var=utm.maas$Zn)
sites.put(G, lname=nameQ[2], east=utm.maas$east, north=utm.maas$north, var=log(utm.maas$Zn))
sites.put(G, lname=nameQ[3], east=utm.maas$east, north=utm.maas$north, var=Zn.o)
for (i in 1:3) system(paste("s.info sites=", nameQ[i], sep=""))
}
\keyword{spatial}
\keyword{IO}
