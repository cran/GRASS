% Copyright 1999-2002 by Roger S. Bivand and Markus Neteler
%
%
\name{utm.maas}
\alias{utm.maas}
\alias{maasmask}
\non_function{}
\title{Soil pollution data set}
\usage{data(utm.maas)}
\description{
The \code{utm.maas} data frame has 98 rows and 13 columns.
It records contamination of the environment by selected metals along the Dutch bank of the River Maas just north of Maastricht and contains the following columns (topsoil data were
collected as bulked samples in 1990 within a radius of 5m according to 
Burrough and McDonnell 1998: 102, 309):
}
\format{
  This data frame contains the following columns:
  \describe{
    \item{east}{a numeric vector - UTM zone 32 eastings coordinates m}
    \item{north}{a numeric vector - UTM zone 32 northings coordinates m}
    \item{x}{a numeric vector - local coordinates m}
    \item{y}{a numeric vector - local coordinates m}
    \item{elev}{a numeric vector - elevation above local reference level in meters}
    \item{d.river}{a numeric vector - distance from main River Maas channel in meters}
    \item{Cd}{a numeric vector - Cadmium in ppm}
    \item{Cu}{a numeric vector - Copper in ppm}
    \item{Pb}{a numeric vector - Lead in ppm}
    \item{Zn}{a numeric vector - Zinc in ppm}
    \item{LOI}{a numeric vector - percentage organic matter loss on ignition}
    \item{Fldf}{a numeric vector - flood frequency class, 1: annual, 2: 2-5 years, 3: every 5 years}
    \item{Soil}{a numeric vector - 3 unnamed soil types}
  }
}
\details{
Maas river bank soil pollution data

The Maas river bank soil pollution data (Limburg, The Netherlands) are
sampled along the Dutch bank of the river Maas (Meuse) north of Maastricht.
This is a flood plain of the river Maas, not far from where the Maas enters
the Netherlands (Borgharen, Itteren, about 3 to 5 km north of Maastricht).

The river Maas is at the north-west border of the project area, traversing
the area in north-east direction. Burrough et al. 1998 use a subset of the
same data set in their book (reduced area). The data have been re-projected
for the GRASS/R interface from the Dutch standard coordinate system (TDN
coordinates in stereographic projection) to UTM coordinate system zone 32,
on WGS84 ellipsoid. A GRASS LOCATION has to be defined with following
parameters: projection UTM, ellipsoid WGS84, zone 32, north 5652930, south
5650610, west 269870, east 272460, nsres 10, ewres 10, rows 232, cols 259.
The pre-defined location including the data stored column-wise in sites
lists can be downloaded from the GRASS web site.

Maas  river bank dat GRASS LOCATION,
\url{http://grass.itc.it/statsgrass/maas_grass_location.tar.gz}


}
\source{
 Burrough, P. & McDonnell, R. (1998) \emph{Principles of geographical information systems}, New York: Oxford, pp. 309--311; Rikken, M.G.J., Van Rijn, R.P.G., 1993. Soil pollution with heavy metals --
An Inquiry into Spatial Variation, Cost of Mapping and the Risk evaluation
of Copper, Cadmium, Lead and Zinc in the Floodplains of the Meuse West of
Stein, The Netherlands.  Doctoraalveldwerkverslag, Dept. of Physical
Geography, Utrecht University.
}
\note{The functions in this package are intended to work with the GRASS geographical information system. The examples will only work if R is started from inside GRASS, choosing the location for the Maas bank soil pollution data. GRASS installations differ in permissions needed to establish a new location, and system administrator privileges may be needed to create the Maas location. Information about the necessary metadata are as follows. The actual data may be accessed from R: \code{data(utm.maas)}.
  \describe{
    \item{projection}{UTM}
    \item{ellipsoid}{WGS84}
    \item{zone}{32}
    \item{north}{5652930}
    \item{south}{5650610}
    \item{west}{269870}
    \item{east}{272460}
    \item{nsres}{10}
    \item{ewres}{10}
    \item{rows}{232}
    \item{cols}{259}
  }
}

\examples{
data(utm.maas)
Zn.o <- as.ordered(cut(utm.maas$Zn, labels=c("insignificant", "low",
"medium", "high", "crisis"), breaks=c(100, 200, 400, 700, 1000, 2000), 
include.lowest=TRUE))
table(Zn.o)
plot(utm.maas$east, utm.maas$north, pch=codes(Zn.o), xlab="", ylab="", asp=1)
legend(x=c(269900, 270500), y=c(5652000, 5652700), pch=c(1:5), 
legend=levels(Zn.o))
cat("Burrough & McDonnell p. 107\n")
round(tapply(utm.maas$Zn, as.factor(utm.maas$Fldf), mean), 2)
round(tapply(utm.maas$Zn, as.factor(utm.maas$Fldf), sd), 2)
round(tapply(log(utm.maas$Zn), as.factor(utm.maas$Fldf), mean), 3)
round(tapply(log(utm.maas$Zn), as.factor(utm.maas$Fldf), sd), 3)
round(exp(round(tapply(log(utm.maas$Zn), as.factor(utm.maas$Fldf), mean), 3)), 2)
hist(utm.maas$Zn, breaks=seq(0,2000,100), col="grey")
hist(log(utm.maas$Zn), breaks=seq(3.5,8.5,0.25), col="grey")
library(ctest)
t.test(utm.maas$Zn[utm.maas$Fldf == 2], utm.maas$Zn[utm.maas$Fldf == 3])
cat("NB: B&McD p. 108, their relative variance is (1-(RSquared))\n")
anova(lm(Zn ~ as.factor(Fldf), data=utm.maas))
summary(lm(Zn ~ as.factor(Fldf), data=utm.maas))
anova(lm(log(Zn) ~ as.factor(Fldf), data=utm.maas))
summary(lm(log(Zn) ~ as.factor(Fldf), data=utm.maas))
}
\keyword{datasets}
