% Copyright 1999-2000 by Roger S. Bivand
%
\name{pcbs}
\alias{pcbs}
\non_function{}
\title{PCBs in an area of South Wales}
\description{
The \code{pcbs} data frame has 70 rows and 3 columns.
It records contamination of the environment with polychlorinated biphenyls around the site of a large plant for the incineration of chemical wastes near Pontypool, South Wales.
}
\format{
This data frame contains the following columns:
  \tabular{rlll}{
    [,1]  \tab east  \tab numeric  \tab UTM zone 30 eastings coordinates\cr
    [,2]  \tab north   \tab numeric  \tab UTM zone 30 northings coordinates\cr
    [,3]  \tab pcbs   \tab numeric  \tab standardised scores for seven types of PCB\cr
  }
}
\details{
The original data were positioned in relation to National Grid coordinates, and have been reprojected to UTM zone 30, using the WGS84 ellipsoid.
}
\source{
Bailey, T. C., Gatrell, A. C. 1995 Interactive Spatial Data Analysis (Longman, Harlow); pages 149-150, courtesy of Andrew Lovett, School of Environmental Sciences, University of East Anglia.
}
\note{This dataset will only work if R is started from inside GRASS, choosing the location for the Pontypool PCBs data. GRASS installations differ in permissions needed to establish a new location, and system administrator privileges may be needed to create the Pontypool location. Information about the necessary metadataare as follows. The actual data may be accessed from R: \code{data(pcbs)}.
  \tabular{rl}{
    projection  \tab UTM\cr
    ellipsoid  \tab WGS84\cr
    zone  \tab 30\cr
    north  \tab 77200\cr
    south  \tab 74500\cr
    west  \tab 68000\cr
    east  \tab 70200\cr
    nsres  \tab 25\cr
    ewres  \tab 25\cr
    rows  \tab 108\cr
    cols  \tab 88\cr
  }
}

\examples{
data(pcbs)
pcbs.o <- as.ordered(cut(pcbs$pcbs, labels=c("insignificant", "low",
"medium", "high", "crisis"), breaks=c(1,20,100,500,1000,5000),
include.lowest=T))
table(pcbs.o)
plot(pcbs$east, pcbs$north, pch=codes(pcbs.o), xlab="", ylab="", asp=1)
legend(x=c(67980, 68480), y=c(74710, 75180), pch=c(1:5), legend=levels(pcbs.o))
}
\keyword(datasets)
