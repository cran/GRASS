krige.G <- function(point.obj, at, var.mod.obj, G, mask=NULL) 
{
    require(sgeostat)
    if (!inherits(point.obj, "point")) 
        stop("point.obj must be of class, \"point\".\n")
    if (!inherits(var.mod.obj, "variogram.model")) 
        stop("var.mod.obj must be of class, \"variogram.model\".\n")
    if (class(G) != "grassmeta") 
        stop("G not a grass object")
    at.val <- point.obj[[match(at, names(point.obj))]]
    if (!is.null(mask)) {
        if (length(mask) != G$Ncells)
            stop ("mask length does not equal grid size")
        s <- cbind(east(G)*mask, north(G)*mask)
    }
    else s <- cbind(east(G), north(G))
    res <- do.krige.G(s, point.obj, at.val, var.mod.obj)
    res
}
do.krige.G <- function(s, point.obj, at.val, var.mod.obj) 
{
    distance <- function(x1, y1, x2, y2) ((x1 - x2)^2 + (y1 - 
        y2)^2)^0.5
    distvect <- dist(cbind(point.obj$x, point.obj$y))
    n <- attr(distvect, "Size")
    distmtrx <- matrix(0, n, n)
    distmtrx[lower.tri(distmtrx)] <- distvect
    distmtrx <- distmtrx + t(distmtrx)
    GMatrix <- var.mod.obj$model(distmtrx, var.mod.obj$parameters)
    GMatrix <- cbind(GMatrix, rep(1, length = nrow(GMatrix)))
    GMatrix <- rbind(GMatrix, c(rep(1, length = nrow(GMatrix)), 0))
    GMatrix.inv <- solve(qr(GMatrix))
    ns <- length(s[,1])
    nr <- nrow(GMatrix.inv)
    zhat <- numeric(ns)
    sigma2hat <- numeric(ns)
    xvect <- point.obj$x
    yvect <- point.obj$y
    for (looper in 1:ns) {
        x <- s[looper, 1]
        y <- s[looper, 2]
        if (is.na(x)) {
            zhat[looper] <- NA
            sigma2hat[looper] <- NA
        }
        else {
            dst <- distance(xvect, yvect, x, y)
            gvector <- c(var.mod.obj$model(dst, var.mod.obj$parameters), 
                1)
            lambda.hat <- GMatrix.inv %*% gvector
            zhat[looper] <- sum(lambda.hat[1:(nr-1)] * at.val)
            sigma2hat[looper] <- sum(lambda.hat * gvector)
        }
    }
    return(list(zhat=zhat, sigma2hat=sigma2hat))
}

