% Copyright 1999-2000 by Roger S. Bivand
%
\name{summary.grassmeta}
\alias{summary.grassmeta}
%- Also NEED an `\alias' for EACH other topic documented here.
\title{Display GRASS metadata}
\description{
 \code{summary.grassmeta()} displays the metadata collected by gmeta().
}
\usage{
summary.grassmeta(G)
}
%- maybe also `usage' for other objects documented here.
\arguments{
 \item{G}{GRASS metadata from \code{gmeta()}}
}
\references{\url{http://www.geog.uni-hannover.de/grass/statsgrasslist.html}, \url{http://www.baylor.edu/~grass}, Bivand, R. S., (2000) Using the R statistical data analysis language on GRASS 5.0 GIS data base files. Computers and Geosciences, 26, pp. 1043-1052.}
\author{Roger S. Bivand, Department of Geography, Norwegian School of Economics and Business Administration, Breiviksveien 40, N-5045 Bergen, Norway; e-mail: \email{Roger.Bivand@nhh.no.}}

\note{The functions in this package are intended to work with the GRASS geographical information system. The examples will only work if R is started from inside GRASS, choosing the location for the Maas bank soil pollution data. GRASS installations differ in permissions needed to establish a new location, and system administrator privileges may be needed to create the Maas location. Information about the necessary metadata may be found by: \code{help(utm.maas)}. All of the examples in this package may be run from this location in batch by \code{R CMD check GRASS}, to check for correct installation. The actual data may be accessed from R: \code{data(utm.maas)}.}

\seealso{\code{\link{gmeta}}}

\examples{
G <- gmeta()
summary(G)
}
\keyword{GRASS, interface, spatial statistics}%-- one or more ...
