% Copyright 1999-2000 by Roger S. Bivand
%
\name{list.GRASS}
\alias{list.GRASS}
\alias{breakup}
%- Also NEED an `\alias' for EACH other topic documented here.
\title{Interface to GRASS g.list}
\description{
 list.GRASS lists available GRASS data base files of the user-specified data type, returning a character vector. \code{breakup} is a utility function to process g.list output.
}
\usage{
list.GRASS(type="rast")
}
%- maybe also `usage' for other objects documented here.
\arguments{
 \item{type}{GRASS data base file type, such as "sites" or "rast"}
}
}
\details{
 The function returns the results invisibly, so \code{print(list.GRASS())} is needed to display them.
}
\value{
  a character vector with the names of the data base files found.
}
\references{\url{http://grass.itc.it/statsgrass/index.html}, Bivand, R. S., (2000) Using the R statistical data analysis language on GRASS 5.0 GIS data base files. Computers and Geosciences, 26, pp. 1043-1052.}
\author{Roger S. Bivand, e-mail: \email{Roger.Bivand@nhh.no.}}
\note{The functions in this package are intended to work with the GRASS geographical information system. The examples will only work if R is started from inside GRASS, choosing the location for the Maas bank soil pollution data. GRASS installations differ in permissions needed to establish a new location, and system administrator privileges may be needed to create the Maas location. Information about the necessary metadata may be found by: \code{help(utm.maas)}. All of the examples in this package may be run from this location in batch by \code{R CMD check GRASS}, to check for correct installation. The actual data may be accessed from R: \code{data(utm.maas)}.}

\seealso{\code{\link{gmeta}}}

\examples{
if(length(ls(pat="nameQ"))==0){example(sites.put)}
print(list.GRASS("sites"))
}
\keyword{spatial}
\keyword{IO}
