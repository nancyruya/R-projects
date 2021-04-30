#install.packages("usmap")

library(usmap)
library(ggplot2)

setwd("C:/Users/bian/Documents/My SAS Files/CMS")

df <- read.csv("state.csv")
df <- df[,-1]
names(df) <- c("abbr","FFSpop","Service","ServicePerFFS")
df <- merge(statepop, df, by="abbr")

plot_usmap(data = df, values = "FFSpop", color = "red") + 
  scale_fill_continuous(name = "Population (2015)", label = scales::comma) + 
  theme(legend.position = "right")

plot_usmap(data = df, values = "ServicePerFFS", color = "red") + 
  scale_fill_continuous(name = "Population (2015)", label = scales::comma) + 
  theme(legend.position = "right")



plot_usmap(data = statepop, values = "pop_2015", color = "red") + 
  scale_fill_continuous(name = "Population (2015)", label = scales::comma) + 
  theme(legend.position = "right")

str(statepop)

abbr, ffs, service, rate


plot_usmap(data = df, values = "rate", color = "red") + 
  scale_fill_continuous(name = "Population (2015)", label = scales::comma) + 
  theme(legend.position = "right")
