set.seed(32)
library(dplyr)
d <- 10
rates <- 15 / sample(1:25, size = d)
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
df$Time <- round(df$Time)

write.csv(x = df, file = "example_byPatient.csv",row.names = FALSE)

times <- unique(df$Time)
codes <- unique(df$Code)
patients <- unique(df$PatientID)
df.final <- data.frame(PatientID = c("asdf"), 
                       Code = c("1"),
                       Time = c(0),
                       nOccurrences = c(0))
for (i in patients){
for (t in times) {
  for (code in codes) {
    df.cur <- df[(df$Code == code) & (df$Time == t) & (df$PatientID == i),]
    if (nrow(df.cur) > 0)
      df.final <- rbind(df.final, data.frame(PatientID = i, Code = code, Time = t, 
                                             nOccurrences = nrow(df.cur)))
  }
}
}
df.final <- df.final[-1,]

write.csv(x = df.final, file = "example.csv", row.names = FALSE)

source("cooccurrence.R")
getCooccur(df.final)
