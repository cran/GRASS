utm.maas <- read.table("utm.maas.txt", header=TRUE)
maasmask <- scan(gzfile("maasmask.gz", "r"), what=integer(0))
