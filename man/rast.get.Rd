% Copyright 1999-2000 by Roger S. Bivand
%
\name{rast.get}
\alias{rast.get}
%- Also NEED an `\alias' for EACH other topic documented here.
\title{Import GRASS raster files}
\description{
\code{rast.get()} moves one or more GRASS 5.0 raster files to a list, returning the filled object. Setting \code{catlabels} elements, corresponding to the files named in rlist, to TRUE, imports category labels instead of codes yielding an ordered factor rather than a numeric vector, and requires more memory.
}
\usage{
rast.get(G, rlist="", catlabels=NULL, debug=FALSE, interp=FALSE)
}
\details{
\code{rast.get()} assumes firstly that the region of the GRASS LOCATION has not been changed since gmeta() was last run, secondly that resolutions of the requested map layers and the GRASS LOCATION are in accord, and thirdly that the data cover the selected region. If the second or third assumptions are not met for the interpreted version, the GRASS program \code{r.stats} run through \code{system()} will read from the underlying map layers according to the new region setting, yielding cell values at the current resolution, and inserting NAs in areas for which there are no data. For the compiled version, the user is required to work within a given map region at the same resolution.
}
%- maybe also `usage' for other objects documented here.
\arguments{
 \item{G}{GRASS metadata from \code{gmeta()}}
 \item{rlist}{character vector of GRASS raster file names}
 \item{catlabels}{logical vector of length \code{length(rlist)}: if TRUE, GRASS category raster layers are imported as ordered factors, if FALSE, as numeric only}
 \item{debug}{if TRUE, the temporary ASCII file used for transfer is not deleted on exit from the function}
 \item{interp}{if TRUE, the interpreted version of the function is used instead of the loaded compiled version}
}
\value{
  A list is returned with \code{length(rlist)} vectors and \code{G$Ncells} values in each vector; the columns are named using the names of the imported GRASS raster files. Those imported with category labels are ordered factors, and their names are suffixed with \code{.f}
}
\references{\url{http://www.geog.uni-hannover.de/grass/statsgrasslist.html}, \url{http://www.baylor.edu/~grass}, Bivand, R. S., (2000) Using the R statistical data analysis language on GRASS 5.0 GIS data base files. Computers and Geosciences, 26, pp. 1043-1052.}
\author{Roger S. Bivand, Department of Geography, Norwegian School of Economics and Business Administration, Breiviksveien 40, N-5045 Bergen, Norway; e-mail: \email{Roger.Bivand@nhh.no.}}

\note{The functions in this package are intended to work with the GRASS geographical information system. The examples will only work if R is started from inside GRASS, choosing the location for the Maas bank soil pollution data. GRASS installations differ in permissions needed to establish a new location, and system administrator privileges may be needed to create the Maas location. Information about the necessary metadata may be found by: \code{help(utm.maas)}. All of the examples in this package may be run from this location in batch by \code{R CMD check GRASS}, to check for correct installation. The actual data may be accessed from R: \code{data(utm.maas)}.}

\seealso{\code{\link{rast.put}}}

\examples{
if(length(ls(pat="Zn.o"))==0){example(utm.maas)}
if(length(ls(pat="G"))==0){example(gmeta)}
if(length(ls(pat="nameQ"))==0){example(sites.put)}
if(length(ls(pat="nameR"))==0){example(rast.put)}
system("s.surf.rst input=ex.Zn.in elev=ex.Zn.rst tension=100 smooth=0.0 segmax=700")
exget <- rast.get(G, rlist=c("ex.Zn.grid.in", "ex.tr3.in",
  "ex.Zn.grid.o.in", "ex.Zn.rst"), catlabels=as.logical(c(F,F,T,F)))
oldpar <- par(mfrow=c(2,2))
plot(G, exget$ex.Zn.grid.in)
points(utm.maas$east, utm.maas$north, pch=18)
title("Bicubic spline interpolation")
plot(G, exget$ex.tr3.in)
points(utm.maas$east, utm.maas$north, pch=18)
title("Cubic trend surface")
plot(G, exget$ex.Zn.rst*maasmask)
points(utm.maas$east, utm.maas$north, pch=18)
title("Regularized spline with tension")
par(oldpar)
system("r.report ex.Zn.grid.o.in units=c,h")
table(exget$ex.Zn.grid.o.in)
}
\keyword{spatial}
\keyword{IO}
