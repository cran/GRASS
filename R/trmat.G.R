# GRASS adaptation Copyright 1999-2000 by Roger S. Bivand
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#

#
# trmat copyright 1994-9 W.N.Venables & B.D.Ripley
#
trmat.G <- function (obj, G, east=NULL, north=NULL) 
{
    if (!is.loaded("VR_frset")) library(spatial)
    if (!inherits(obj, "trls")) 
        stop("object not a fitted trend surface")
    if (class(G) != "grassmeta") 
        stop("Data not a grass object")
    if (is.null(east)) east <- east(G)
    if (is.null(north)) north <- north(G)
    .C("VR_frset", as.double(obj$rx[1]), as.double(obj$rx[2]), 
        as.double(obj$ry[1]), as.double(obj$ry[2]))
    n <- length(east)
    z <- .C("VR_valn", z = double(n), as.double(east), as.double(north), 
            as.integer(n), as.double(obj$beta), as.integer(obj$np))$z
    invisible(z)
}

fitted.trls <- function (obj) 
{
    if (!inherits(obj, "trls")) 
        stop("object not a fitted trend surface")
    obj$z - obj$wz
}

residuals.trls <- function(obj)
{
    if (!inherits(obj, "trls")) 
        stop("object not a fitted trend surface")
    obj$wz
}

deviance.trls <- function(obj)
{
    if (!inherits(obj, "trls")) 
        stop("object not a fitted trend surface")
    sum(residuals.trls(obj)^2)
}

extractAIC.trls <- function(obj, scale=0, k=2)
{
    if (!inherits(obj, "trls")) 
        stop("object not a fitted trend surface")
    n <- length(obj$z)
    edf <- df.residual.trls(obj)
    RSS <- deviance.trls(obj)
    dev <- n * log(RSS/n)
    c(edf, dev + k * edf)
}

df.residual.trls <- function(obj)
{
    if (!inherits(obj, "trls")) 
        stop("object not a fitted trend surface")
    length(obj$z) - length(obj$beta)
}

anova.trls <- function(obj, ...)
{
    if (length(list(obj, ...)) > 1) 
        return(anovalist.trls(obj, ...))
    if (!inherits(obj, "trls")) 
        stop("object not a fitted trend surface")
    rss <- deviance.trls(obj)
    rdf <- df.residual.trls(obj)
    n <- length(obj$z)
    edf <- n - rdf - 1
    tss <- var(obj$z) * (n-1)
    ess <- tss - rss
    ems <- ess/edf
    rms <- rss/rdf
    f <- ems/rms
    p <- 1 - pf(f, edf, rdf)
    table <- data.frame(c(format(ess), format(rss), format(tss)),
        c(format(edf), format(rdf), format(edf+rdf)),
        c(format(ems), format(rms), ""), c(format(f), "", ""), 
        c(format.pval(p), "", ""))
    dimnames(table) <- list(c("Regression", "Deviation", "Total"),
        c("Sum Sq", "Df", "Mean Sq", "F value", "Pr(>F)"))
    cat("Analysis of Variance Table\n", "Model: ")
    print(obj$call)
    table
}

anovalist.trls <- function(obj, ...)
{
    objs <- list(obj, ...)
    nmodels <- length(objs)
    for (i in 1:nmodels) {
        if (!inherits(objs[[i]], "trls")) 
            stop("object not a fitted trend surface")
    }
    if (nmodels == 1) 
        return(anova.trls(object))
    models <- as.character(lapply(objs, function(x) x$call))
    df.r <- unlist(lapply(objs, df.residual.trls))
    ss.r <- unlist(lapply(objs, deviance.trls))
    df <- c(NA, -diff(df.r))
    ss <- c(NA, -diff(ss.r))
    ms <- ss/df
    f <- p <- rep(NA, nmodels)
    for (i in 2:nmodels) {
        if (df[i] > 0) {
            f[i] <- ms[i]/(ss.r[i]/df.r[i])
            p[i] <- 1 - pf(f[i], df[i], df.r[i])
        }
        else if (df[i] < 0) {
            f[i] <- ms[i]/(ss.r[i - 1]/df.r[i - 1])
            p[i] <- 1 - pf(f[i], -df[i], df.r[i - 1])
        }
        else {
            ss[i] <- 0
        }
    }
    table <- data.frame(df.r, ss.r, df, ss, f, p)
    dimnames(table) <- list(1:nmodels, c("Res.Df", "Res.Sum Sq", 
        "Df", "Sum Sq", "F value", "Pr(>F)"))
    title <- "Analysis of Variance Table\n"
    topnote <- paste("Model ", format(1:nmodels), ": ", models, 
        sep = "", collapse = "\n")
    sss <- getOption("show.signif.stars")
    if (sss) options("show.signif.stars"=FALSE)
    print(structure(table, heading = c(title, topnote), class = c("anova", 
        "data.frame")))
    if (sss) options("show.signif.stars"=TRUE)
    invisible(structure(table, heading = c(title, topnote), class = c("anova", 
        "data.frame")))

}

summary.trls <- function(obj, digits = max(3, getOption("digits") - 3))
{
    if (!inherits(obj, "trls")) 
        stop("object not a fitted trend surface")
    print(anova.trls(obj))
    rdf <- df.residual.trls(obj)
    n <- length(obj$z)
    edf <- n - rdf - 1
    rss <- deviance.trls(obj)
    tss <- var(obj$z) * (n-1)
    ess <- tss - rss
    ems <- ess/edf
    rsquared <- ess/tss
    adj.rsquared <- 1 - (1 - rsquared) * ((n - 1)/rdf)
    cat("Multiple R-Squared:", formatC(rsquared, digits = digits))
    cat(",\tAdjusted R-squared:", formatC(adj.rsquared, 
        d = digits), "\n")
    AIC <- extractAIC.trls(obj)
    cat("AIC: (df = ", AIC[1], ") ", AIC[2], "\n", sep="")
    cat("Fitted:\n")
    if (rdf > 5) {
        nam <- c("Min", "1Q", "Median", "3Q", "Max")
        rq <- structure(quantile(fitted.trls(obj)), names = nam)
        print(rq, digits = digits)
    }
    else {
        print(fitted.trls(obj), digits = digits)
    }
    cat("Residuals:\n")
    if (rdf > 5) {
        nam <- c("Min", "1Q", "Median", "3Q", "Max")
        rq <- structure(quantile(residuals.trls(obj)), names = nam)
        print(rq, digits = digits)
    }
    else {
        print(residuals.trls(obj), digits = digits)
    }
}

trls.influence <- function(obj)
{
    if (!inherits(obj, "trls")) 
        stop("object not a fitted trend surface")
    nr <- length(obj$z)
    nc <- length(obj$beta)
    X <- matrix(obj$f, nrow=nr, ncol=nc)
    Z <- matrix(0, nrow=nc, ncol=nc)
    k <- 1
    kk <- as.vector(upper.tri(Z, diag=T))
    for (i in 1:length(kk)) {if (kk[i]) {Z[i] <- obj$r[k] ; k <- k + 1}}
    inv.Z <- chol2inv(Z)
    hii <- diag(X %*% inv.Z %*% t(X))
    s <- sqrt(deviance.trls(obj)/df.residual.trls(obj))
    r <- residuals.trls(obj)
    stresid <- r / (s*sqrt(1-hii))
    Di <- ((stresid^2)*hii) / (nc*(1-hii))
    invisible(list(r=r, hii=hii, stresid=stresid, Di=Di))
}

# function adapted from e-mail posting to R-help by Ross Ihaka, 2 Feb 1999
#
circles <- function(x, y, radius, col=NA, border=par("fg"))
{
    nmax <- max(length(x), length(y))
    if (length(x) < nmax) x <- rep(x, length=nmax)
    if (length(y) < nmax) y <- rep(y, length=nmax)
    if (length(col) < nmax) col <- rep(col, length=nmax)
    if (length(border) < nmax) border <- rep(border, length=nmax)

    if (length(radius) < nmax) radius <- rep(radius, length=nmax)

    theta <- 2* pi * seq(0, 355, by=5) / 360
    ct <- cos(theta)
    st <- sin(theta)
    for(i in 1:nmax)
        polygon(x[i] + ct * radius[i], y[i] + st * radius[i],
            col=col[i], border=border[i])
}

plot.trls <- function(obj, border="black", col=NA, pch=4, cex=0.6,
    add=FALSE, div=8) {
    if (!inherits(obj, "trls")) 
        stop("object not a fitted trend surface")
    infl <- trls.influence(obj)
    dx <- diff(range(obj$x))
    dy <- diff(range(obj$y))
    dxy <- (dx+dy)/2
    mDi <- max(infl$Di)
    sc <- (mDi*dxy)/div
    if (!add) plot(obj$x, obj$y, type="n", asp=1, xlab="", ylab="")
    circles(obj$x, obj$y, sc*infl$Di, border="red")
    points(obj$x, obj$y, pch=pch)
    title(main="Cook's statistic", xlab=paste("Surface order:", obj$np))
}


