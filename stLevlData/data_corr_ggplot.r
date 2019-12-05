install.packages("ggplot2")
library(ggplot2)

setwd ("C:/Users/zhangr07/Desktop/Project")
dat1 <- read.csv("stLevelData.csv")

ggplot(dat1, aes(x=ATFRegWeapon, y=AllMortAdj)) +
  geom_point(size=3, shape=1, color='red')+
  geom_text(aes(label=''),hjust=0, vjust=0) +
  facet_grid(.~ 1)+
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)

# ggplot(dat1, aes(x=ATFRegWeapon, y=AllMortAdj)) +
 # geom_point(size=3, shape=1, color='red')+
 # geom_text(aes(label='State'),hjust=0, vjust=0) +
 # facet_grid(.~ 'state level data')+
 # geom_smooth(method=lm, se=FALSE, fullrange=TRUE) +
 # theme(strip.text = element_text(size=15))
