% Copyright 1999-2000 by Roger S. Bivand
%
\name{gmeta}
\alias{gmeta}
\alias{east}
\alias{north}
\alias{obsno}
\alias{reverse}
\alias{hh}
%- Also NEED an `\alias' for EACH other topic documented here.
\title{Reads GRASS metadata from the current LOCATION}
\description{
GRASS LOCATION metadata are read into a list in R, and processed to provide other functions with parameters and structures they require.
}
\usage{
gmeta(interp=FALSE)
east(G)
north(G)
obsno(G)
reverse(G)
}
\arguments{
 \item{interp}{if interp is TRUE, the interface uses text transfer through \code{system()}}
 \item{G}{a grassmeta object returned by \code{gmeta}}
}
%- maybe also `usage' for other objects documented here.
\details{
The function retrieves metadata from the GRASS LOCATION from which R was started, and stores it in a list. The metadata is taken from the current, active region, and the implied resolution for raster layers. Next, this is used to create a number of auxilliary objects used by other interface routines. Other auxilliary objects may be constructed using the access functions \code{east}, \code{north}, \code{obsno}, and \code{reverse}. The function returns a list with class \code{grassmeta}:
}
\value{
  \item{LOCATION}{GRASS LOCATION name}
  \item{MAPSET}{GRASS MAPSET within the LOCATION}
  \item{proj}{GRASS projection description}
  \item{n}{Northern edge}
  \item{s}{Southern edge}
  \item{w}{Western edge}
  \item{e}{Eastern edge}
  \item{nsres}{North-South resolution in measurement units, typically metres}
  \item{ewres}{East-West resolution in measurement units, typically metres}
  \item{Nrow}{Number of rows of raster cells}
  \item{Ncol}{Number of columns of raster cells}
  \item{Ncells}{Number of raster cells}
  \item{xlim}{East-West range}
  \item{ylim}{North-South range}
  \item{xseq}{Sequence of raster cell East-West midpoint coordinates}
  \item{yseq}{Sequence of raster cell North-Soutb midpoint coordinates}
  \item{ryseq}{Reversed sequence of raster cell North-Soutb midpoint coordinates}
}
\references{\url{http://www.geog.uni-hannover.de/grass/statsgrasslist.html}, \url{http://www.baylor.edu/~grass}, Bivand, R. S., (2000) Using the R statistical data analysis language on GRASS 5.0 GIS data base files. Computers and Geosciences, 26, pp. 1043-1052.}
\author{Roger S. Bivand, Department of Geography, Norwegian School of Economics and Business Administration, Breiviksveien 40, N-5045 Bergen, Norway; e-mail: \email{Roger.Bivand@nhh.no.}}

\note{The functions in this package are intended to work with the GRASS geographical information system. The examples will only work if R is started from inside GRASS, choosing the location for the Maas bank soil pollution data. GRASS installations differ in permissions needed to establish a new location, and system administrator privileges may be needed to create the Maas location. Information about the necessary metadata may be found by: \code{help(utm.maas)}. All of the examples in this package may be run from this location in batch by \code{R CMD check GRASS}, to check for correct installation. The actual data may be accessed from R: \code{data(utm.maas)}.}

\seealso{\code{\link{summary.grassmeta}}, \code{\link{east}}, \code{\link{north}}, \code{\link{obsno}}, \code{\link{reverse}}}

\examples{
G <- gmeta()
summary(G)
}
\keyword{spatial}
\keyword{IO}
