% Copyright 1999-2000 by Roger S. Bivand
%
\name{interp.new.G}
\alias{interp.new.G}
%- Also NEED an `\alias' for EACH other topic documented here.
\title{Interpolation from sites to raster, Akima's new method}
\description{
 A wrapper function for \code{interp.new()} in the \code{akima} package.
}
\usage{
interp.new.G(G, x, y, z, extrap=FALSE, duplicate="error", dupfun=NULL,
	reverse=NULL)
}
%- maybe also `usage' for other objects documented here.
\arguments{
 \item{G}{GRASS metadata from gmeta()}
 \item{x}{Eastings of point locations}
 \item{y}{Northings of point locations}
 \item{z}{Observed point values to be interpolated}
 \item{extrap}{see \code{help(interp.new)}}
 \item{duplicate}{see \code{help(interp.new)}}
 \item{dupfun}{see \code{help(interp.new)}}
 \item{reverse}{see \code{help(reverse)}}
}

\value{
  A vector of \code{G$Ncells} values is returned, with the results of interpolation ordered as a GRASS raster file. NAs are inserted outside the convex hull of the data points.
}
\references{\url{http://www.geog.uni-hannover.de/grass/statsgrasslist.html}, \url{http://www.baylor.edu/~grass}, Bivand, R. S., (2000) Using the R statistical data analysis language on GRASS 5.0 GIS data base files. Computers and Geosciences, 26, pp. 1043-1052.}
\author{Original \code{interp.new()}: Albrecht Gebhardt as detailed in the akima package documentation; adapted by Roger S. Bivand, Department of Geography, Norwegian School of Economics and Business Administration, Breiviksveien 40, N-5045 Bergen, Norway; e-mail: \email{Roger.Bivand@nhh.no.}}
\note{The functions in this package are intended to work with the GRASS geographical information system. The examples will only work if R is started from inside GRASS, choosing the location for the Maas bank soil pollution data. GRASS installations differ in permissions needed to establish a new location, and system administrator privileges may be needed to create the Maas location. Information about the necessary metadata may be found by: \code{help(utm.maas)}. All of the examples in this package may be run from this location in batch by \code{R CMD check GRASS}, to check for correct installation. The actual data may be accessed from R: \code{data(utm.maas)}.}


\seealso{\code{\link{interp.new}}}

\examples{
if(length(ls(pat="Zn.o"))==0){example(utm.maas)}
if(length(ls(pat="G"))==0){example(gmeta)}
data <- cbind(utm.maas$elev, utm.maas$d.river, log(utm.maas$d.river),
    utm.maas$Zn, log(utm.maas$Zn))
colnames(data) <- c("Elevation", "Distance", "Ln(Distance)", "Zinc",
    "Ln(Zinc)")
pairs(data)
mod1 <- lm(log(Zn) ~ elev + log(d.river), data=utm.maas)
summary(mod1)
anova(mod1)
inregion <- (utm.maas$east >= G$w & utm.maas$east <= G$e) & (utm.maas$north >= G$s & utm.maas$north <= G$n)
if(all(!inregion)) stop("None of the site locations are inside the current GRASS region")
if(any(!inregion))
    warning("Some site locations are outside the current GRASS region")
require(akima)
elev.grid <- interp.new.G(G, utm.maas$east, utm.maas$north, utm.maas$elev,
    extrap=TRUE)
plot(G, elev.grid*maasmask, breaks=c(-10, seq(5.4, 10.6, 0.52), 100),
  col=c("yellow", grey(11:2/11), "red"))
plot(G, ifelse(is.na(maasmask), 1, NA), col="wheat", add=T)
title("Bicubic spline interpolation: local elevation")
legend(c(269900, 270600), c(5652000, 5652900), bty="n", bg="wheat",
   legend=c("> 10.6", rev(legtext(seq(5.4, 10.6, 0.52))), "< 5.4", "mask=NA"),
   fill=c("red", rev(grey(11:2/11)), "yellow", "wheat"))
nameR <- c("ex.mask")
namesG <- list.GRASS("rast")
if(any(match(nameR, namesG, nomatch=0) > 0)){
	for (i in 1:length(nameR)) if(match(nameR[i], namesG, nomatch=0) > 0)
		system(paste("g.remove rast=", nameR[i], sep=""))
}
rast.put(G, "ex.mask", as.factor(maasmask), cat=T)
system("r.mapcalc 'invmask = isnull(ex.mask)'")
system("r.grow input=invmask output=growmask")
system("r.mapcalc 'bank = (growmask - invmask) * int(ex.mask)'")
system("r.stats -1gn bank | s.in.ascii sites=bank")
system("r.mapcalc 'ten = 10'")
system("r.cost input=ten output=d.river start_sites=bank")
bank <- rast.get(G, "d.river")
new <- data.frame(elev=elev.grid*maasmask, d.river=(bank$d.river*maasmask)+5)
pr.mod1 <- predict(mod1, new, se.fit=TRUE)
rm(new, elev.grid, bank)
v.pr <- rep(NA, G$Ncells)
v.pr[as.integer(names(pr.mod1$fit))] <- pr.mod1$fit
summary(v.pr)
summary(exp(v.pr))
plot(G, exp(v.pr), breaks=c(-200, round(seq(142, 1154, length=9)), 5000),
  col=c("yellow", grey(9:2/9), "red"))
plot(G, ifelse(is.na(maasmask), 1, NA), col="wheat", add=T)
title("Regression predictions of Zn levels, (B&McD p. 113)")
legend(c(269900, 270600), c(5652000, 5652900), bty="n", bg="wheat",
   legend=c("> 1154", rev(legtext(round(seq(142, 1154, length=9)))), "< 142",
   "mask=NA"), fill=c("red", rev(grey(9:2/9)), "yellow", "wheat"))
v.pr[as.integer(names(pr.mod1$se.fit))] <- pr.mod1$se.fit
plot(G, exp(v.pr), col=grey(16:2/16))
plot(G, ifelse(is.na(maasmask), 1, NA), col="wheat", add=T)
points(utm.maas$east, utm.maas$north, pch=18)
title("Standard error of predictions")
Zn.grid <- interp.new.G(G, utm.maas$east, utm.maas$north, utm.maas$Zn,
    extrap=TRUE)
plot(G, Zn.grid*maasmask, breaks=c(-500, round(seq(15,1994,length=9)), 3000),
  col=c("yellow", grey(9:2/9), "red"))
plot(G, ifelse(is.na(maasmask), 1, NA), col="wheat", add=T)
title(xlab="B&McD p. 118", main="Bicubic spline interpolation: Zn ppm")
legend(c(269900, 270600), c(5652000, 5652900), bty="n", bg="wheat",
   legend=c("> 1994", rev(legtext(round(seq(15,1994,length=9)))), "< 15",
   "mask=NA"), fill=c("red", rev(grey(9:2/9)), "yellow", "wheat"))
nameQ <- c("ex.Zn.in")
namesG <- list.GRASS("sites")
if(any(match(nameQ, namesG, nomatch=0) > 0)){
	for (i in 1:length(nameQ)) if(match(nameQ[i], namesG, nomatch=0) > 0)
		system(paste("g.remove sites=", nameQ[i], sep=""))
}
sites.put(G, lname=nameQ[1], east=utm.maas$east, north=utm.maas$north, var=utm.maas$Zn)
system("s.surf.idw input=ex.Zn.in output=Zn.idw npoints=98")
idw <- rast.get(G, "Zn.idw")
plot(G, idw$Zn.idw*maasmask, breaks=c(-100, round(seq(15,1994,length=9)), 3000),
  col=c("yellow", grey(9:2/9), "red"))
plot(G, ifelse(is.na(maasmask), 1, NA), col="wheat", add=T)
title(xlab="B&McD p. 118",
  main="Inverse squared distance interpolation: Zn ppm")
legend(c(269900, 270600), c(5652000, 5652900), bty="n", bg="wheat",
   legend=c("> 1994", rev(legtext(round(seq(15,1994,length=9)))), "< 15",
   "mask=NA"), fill=c("red", rev(grey(9:2/9)), "yellow", "wheat"))
}
\keyword{spatial}
\keyword{IO}
