% Copyright 1999-2000 by Roger S. Bivand
%
\name{sites.get}
\alias{sites.get}
%- Also NEED an `\alias' for EACH other topic documented here.
\title{Import GRASS sites file}
\description{
 \code{sites.get} moves one GRASS 5.0 sites file to a data frame, returning the filled object.
}
\usage{
sites.get(G, slist="", debug=FALSE)
}
%- maybe also `usage' for other objects documented here.
\arguments{
 \item{G}{GRASS metadata from \code{gmeta()}}
 \item{slist}{GRASS sites file name}
 \item{debug}{if TRUE, the temporary ASCII file used for transfer is not deleted on exit from the function}
}
\value{
  A data frame with columns: east, north, and var1, ..., varn, where n is the number of attributes held in the GRASS sites file, some of which may be factors, and which may include the site id number as var1.
}
\references{\url{http://www.geog.uni-hannover.de/grass/statsgrasslist.html}, \url{http://www.baylor.edu/~grass}, Bivand, R. S., (2000) Using the R statistical data analysis language on GRASS 5.0 GIS data base files. Computers and Geosciences, 26, pp. 1043-1052.}
\author{Roger S. Bivand, Department of Geography, Norwegian School of Economics and Business Administration, Breiviksveien 40, N-5045 Bergen, Norway; e-mail: \email{Roger.Bivand@nhh.no.}}

\note{The functions in this package are intended to work with the GRASS geographical information system. The examples will only work if R is started from inside GRASS, choosing the location for the Maas bank soil pollution data. GRASS installations differ in permissions needed to establish a new location, and system administrator privileges may be needed to create the Maas location. Information about the necessary metadata may be found by: \code{help(utm.maas)}. All of the examples in this package may be run from this location in batch by \code{R CMD check GRASS}, to check for correct installation. The actual data may be accessed from R: \code{data(utm.maas)}.}

\seealso{\code{\link{sites.put}}}

\examples{
if(length(ls(pat="G"))==0){example(gmeta)}
if(length(ls(pat="nameQ"))==0){example(sites.put)}
ex.Zn.log <- sites.get(G, slist="ex.Znlog.in")
mean(ex.Zn.log$var2 - log(utm.maas$Zn))
ex.Zn.cat <- sites.get(G, slist="ex.Zncat.in")
table(Zn.o, ex.Zn.cat$var2)
}
\keyword{spatial}
\keyword{IO}
