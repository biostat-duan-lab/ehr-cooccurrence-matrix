### Compute the co-occurrence matrix
getCooccur <- function(df, window, byPatient = FALSE) {
  codes <- unique(df$Code)
  times <- unique(df$Time)
  p <- length(codes)
  cooccur <- matrix(0, p, p)
  
  if (byPatient) {
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
  
  }
  else { # | Code | Time | nOccurrences |
    for (j in 1:(p - 1)) {
      codej <- codes[j]
      for (jj in (j+1):p)
      {
        codejj <- codes[jj]
        n_cooccur_j.jj <- sapply(times, function(t){
          out <- min(df[df$Code %in% c(codej, codejj),]$nOccurrences)
          print(out)
          out <- ifelse(length(out) == 0, 0, out)
          return(out)
        })
        cooccur[j,jj] <- sum(n_cooccur_j.jj)
      }
      cooccur[j,j] <- sum(df[df$Code == codej, ]$nOccurrences)
    }
    cooccur[p,p] <- sum(df[df$Code == codes[p], ]$nOccurrences)
    
  }
  cooccur <- cooccur + t(cooccur)
  row.names(cooccur) <- codes
  colnames(cooccur) <- codes
  
  return(cooccur)
}
