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

 #r2 = round(summary(x)$r.squared, digits = 2)

fit <- lm(AllMortAdj ~ ATFRegWeapon + Poverty + Unemploy + PoorMH0 + PoorMH14ls + PoorMH14gt + StPoP, data=dat1)
summary(fit)

# Multiple regression model with two continuous predictor variables with or without interaction
fit1=lm(AllMortAdj~ATFRegWeapon*Poverty,data=dat1)
summary(fit1)
ggplot(dat1,aes(y=AllMortAdj,x=ATFRegWeapon,color=Poverty))+geom_point()+stat_smooth(method="lm",se=FALSE)

fit2=lm(AllMortAdj~ATFRegWeapon*Unemploy,data=dat1)
summary(fit2)
ggplot(dat1,aes(y=AllMortAdj,x=ATFRegWeapon,color=Unemploy))+geom_point()+stat_smooth(method="lm",se=FALSE)

fit3=lm(AllMortAdj~ATFRegWeapon*PoorMH0,data=dat1)
summary(fit3)
ggplot(dat1,aes(y=AllMortAdj,x=ATFRegWeapon,color=PoorMH0))+geom_point()+stat_smooth(method="lm",se=FALSE)

fit4=lm(AllMortAdj~ATFRegWeapon*PoorMH14ls,data=dat1)
summary(fit4)
ggplot(dat1,aes(y=AllMortAdj,x=ATFRegWeapon,color=PoorMH14ls))+geom_point()+stat_smooth(method="lm",se=FALSE)

fit5=lm(AllMortAdj~ATFRegWeapon*PoorMH14gt,data=dat1)
summary(fit5)
ggplot(dat1,aes(y=AllMortAdj,x=ATFRegWeapon,color=PoorMH14gt))+geom_point()+stat_smooth(method="lm",se=FALSE)

fit6=lm(AllMortAdj~ATFRegWeapon*StPoP,data=dat1)
summary(fit6)
ggplot(dat1,aes(y=AllMortAdj,x=ATFRegWeapon,color=StPoP))+geom_point()+stat_smooth(method="lm",se=FALSE)

