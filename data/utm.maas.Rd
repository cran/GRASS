% Copyright 1999-2000 by Roger S. Bivand
%
\name{utm.maas}
\alias{utm.maas}
\non_function{}
\title{Soil pollution data set}
\description{
The \code{utm.maas} data frame has 98 rows and 13 columns.
It records contamination of the environment by selected metals along the Dutch bank of the River Maas just north of Maastricht.
}
\format{
This data frame contains the following columns:
  \tabular{rlll}{
    [,1]  \tab east  \tab numeric  \tab UTM zone 32 eastings coordinates m\cr
    [,2]  \tab north   \tab numeric  \tab UTM zone 32 northings coordinates m\cr
    [,3]  \tab x   \tab numeric  \tab local coordinates m\cr
    [,4]  \tab y   \tab numeric  \tab coordinates m\cr
    [,5]  \tab elev   \tab numeric  \tab local elevation m\cr
    [,6]  \tab d.river   \tab numeric  \tab distance from main River Maas channel m\cr
    [,7]  \tab Cd   \tab numeric  \tab ppm\cr
    [,8]  \tab Cu   \tab numeric  \tab ppm\cr
    [,9]  \tab Pb   \tab numeric  \tab ppm\cr
    [,10]  \tab Zn   \tab numeric  \tab ppm\cr
    [,11]  \tab LOI   \tab numeric  \tab percentage organic matter loss on ignition\cr
    [,12]  \tab Flfd   \tab numeric  \tab flood frequency class\cr
    [,13]  \tab Soil   \tab numeric  \tab soil type\cr
  }
}
\details{
The original data were positioned in relation to local coordinates (TDN coordinates offset by x-178600, y-329700; TDN are stereographic projection, Bessel ellipsoid, origin at 5.387638889E, 52.156160556N, false origin x=155000, y=463000), and have been reprojected to UTM zone 32, using the WGS84 ellipsoid.
}
\source{
Burrough, P. & McDonnell, R. (1998) \emph{Principles of geographical information systems}, New York: Oxford, pp. 309--311.
}
\note{The functions in this package are intended to work with the GRASS geographical information system. The examples will only work if R is started from inside GRASS, choosing the location for the Maas bank soil pollution data. GRASS installations differ in permissions needed to establish a new location, and system administrator privileges may be needed to create the Maas location. Information about the necessary metadata are as follows. The actual data may be accessed from R: \code{data(utm.maas)}.
  \tabular{rl}{
    projection  \tab UTM\cr
    ellipsoid  \tab WGS84\cr
    zone  \tab 32\cr
    north  \tab 5652930\cr
    south  \tab 5650610\cr
    west  \tab 269870\cr
    east  \tab 272460,\cr
    nsres  \tab 10\cr
    ewres  \tab 10\cr
    rows  \tab 232\cr
    cols  \tab 259\cr
  }
}

\examples{
data(utm.maas)
data(maasmask)
Zn.o <- as.ordered(cut(utm.maas$Zn, labels=c("insignificant", "low",
"medium", "high", "crisis"), breaks=c(100, 200, 400, 700, 1000, 2000), 
include.lowest=T))
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
\keyword(datasets)
