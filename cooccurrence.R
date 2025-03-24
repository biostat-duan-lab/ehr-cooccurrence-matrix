### Compute the co-occurrence matrix
getCooccur <- function(df, window) {
  codes <- unique(df$Code)
  p <- length(codes)
  cooccur <- matrix(0, p, p)
  for (j in 1:(p - 1)) {
    codej <- codes[j]
    timesj <- df[df$Code == codej,]$Time
    for (jj in (j+1):p)
    {
      codejj <- codes[jj]
      timesjj <- df[df$Code == codejj,]$Time
      dist.mat <- outer(timesj, timesjj, FUN = function(x, y) {abs(x -
                                                                     y)}) 
      cooccur[j,jj] <- sum(dist.mat < window)
    }
    cooccur[j,j] <- length(timesj)
  }
  cooccur <- cooccur + t(cooccur)
  row.names(cooccur) <- codes
  colnames(cooccur) <- codes

  return(cooccur)
}
