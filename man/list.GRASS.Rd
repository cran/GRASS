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
\note{The functions in this package are intended to work with the GRASS geographical information system. The examples for wrapper functions will will work whether or not R is running in GRASS, and whether or not the current location is that of the data set used for the examples. Examples of interface functions will however (from version 0.2-2) only work outside GRASS, to avoid possible overwriting of GRASS database locations and/or files.}

\seealso{\code{\link{gmeta}}}

\examples{
\dontrun{
print(list.GRASS("sites"))
}
}
\keyword{spatial}
\keyword{IO}
