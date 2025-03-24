set.seed(32)
library(dplyr)
d <- 10
rates <- 1 / sample(1:25, size = d)
n <- 10
T <- 26
df <- data.frame(PatientID = c("asdf"),
                 Code = c("1"),
                 Time = c(0))

for (i in 1:n) {
  for (j in 1:d) {
    cur.time <- 0
    while(cur.time < T) {
      newtime <- rexp(n = 1, rate = rates[j])
      df <- rbind(df, data.frame(PatientID = paste0("Patient", i),
                                 Code = paste0("Code", j),
                                 Time = cur.time + newtime))
      cur.time <- cur.time + newtime
    }
  }
}
df <- df[-1,]
df <- filter(df, Time < T)

write.csv(x = df, file = "example.csv",row.names = FALSE)
