install.packages("ggplot2")
library(ggplot2)
setwd ("/Users/ruyazhang/projects/R-project")
dat1 <- read.csv("stLevelData.csv")

ggplot(dat1, aes(x=ATFRegWeapon, y=Mort24lsAdj)) +
geom_point(size=2, shape=1, color='red')+
geom_text(aes(label=''),hjust=0, vjust=0) +
facet_grid(.~ 'state level data')+
geom_smooth(method=lm, se=FALSE, fullrange=TRUE) +
theme(strip.text = element_text(size=15))

ggplot(dat1, aes(x=Poverty, y=Mort24lsAdj)) +
  geom_point(size=2, shape=1, color='red')+
  geom_text(aes(label=''),hjust=0, vjust=0) +
  facet_grid(.~ 'state level data')+
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE) +
  theme(strip.text = element_text(size=15))

ggplot(dat1, aes(x=Unemploy, y=Mort24lsAdj)) +
  geom_point(size=2, shape=1, color='red')+
  geom_text(aes(label=''),hjust=0, vjust=0) +
  facet_grid(.~ 'state level data')+
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE) +
  theme(strip.text = element_text(size=15))

ggplot(dat1, aes(x=PoorMH0, y=Mort24lsAdj)) +
  geom_point(size=2, shape=1, color='red')+
  geom_text(aes(label=''),hjust=0, vjust=0) +
  facet_grid(.~ 'state level data')+
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE) +
  theme(strip.text = element_text(size=15))

ggplot(dat1, aes(x=PoorMH14ls, y=Mort24lsAdj)) +
  geom_point(size=2, shape=1, color='red')+
  geom_text(aes(label=''),hjust=0, vjust=0) +
  facet_grid(.~ 'state level data')+
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE) +
  theme(strip.text = element_text(size=15))

ggplot(dat1, aes(x=PoorMH14gt, y=Mort24lsAdj)) +
  geom_point(size=2, shape=1, color='red')+
  geom_text(aes(label=''),hjust=0, vjust=0) +
  facet_grid(.~ 'state level data')+
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE) +
  theme(strip.text = element_text(size=15))

ggplot(dat1, aes(x=StPoP, y=Mort24lsAdj)) +
  geom_point(size=2, shape=1, color='red')+
  geom_text(aes(label=''),hjust=0, vjust=0) +
  facet_grid(.~ 'state level data')+
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE) +
  theme(strip.text = element_text(size=15))

fit <- lm(Mort24lsAdj ~ ATFRegWeapon , data=dat1)
summary(fit)
fit <- lm(Mort24lsAdj ~ ATFFirearmLicense , data=dat1)
summary(fit)
fit <- lm(Mort24lsAdj ~ GiffordsRank , data=dat1)
summary(fit)
fit <- lm(Mort24lsAdj ~ GOwnerRates , data=dat1)
summary(fit)


fit <- lm(Mort24lsAdj ~ ATFRegWeapon + Poverty + Unemploy + PoorMH0 + PoorMH14ls + PoorMH14gt + StPoP, data=dat1)
summary(fit)
fit <- lm(Mort24lsAdj ~ ATFFirearmLicense + Poverty + Unemploy + PoorMH0 + PoorMH14ls + PoorMH14gt + StPoP, data=dat1)
summary(fit)
fit <- lm(Mort24lsAdj ~ GiffordsRank + Poverty + Unemploy + PoorMH0 + PoorMH14ls + PoorMH14gt + StPoP, data=dat1)
summary(fit)
fit <- lm(Mort24lsAdj ~ GOwnerRates + Poverty + Unemploy + PoorMH0 + PoorMH14ls + PoorMH14gt + StPoP, data=dat1)
summary(fit)


fit <- lm(Mort24lsAdj ~ ATFRegWeapon + StPoP, data=dat1)
summary(fit)

fit <- lm(Mort24lsAdj ~ ATFRegWeapon + Unemploy + PoorMH0 + PoorMH14ls + PoorMH14gt, data=dat1)
summary(fit)


fit3=lm(Mort24lsAdj~ATFRegWeapon*Poverty,data=dat1)
summary(fit3)
ggplot(dat1,aes(y=Mort24lsAdj,x=ATFRegWeapon,color=Poverty))+geom_point()+stat_smooth(method="lm",se=FALSE)

fit3=lm(Mort24lsAdj~ATFRegWeapon*Unemploy,data=dat1)
summary(fit3)
ggplot(dat1,aes(y=Mort24lsAdj,x=ATFRegWeapon,color=Unemploy))+geom_point()+stat_smooth(method="lm",se=FALSE)

fit3=lm(Mort24lsAdj~ATFRegWeapon*PoorMH0,data=dat1)
summary(fit3)
ggplot(dat1,aes(y=Mort24lsAdj,x=ATFRegWeapon,color=PoorMH0))+geom_point()+stat_smooth(method="lm",se=FALSE)

fit3=lm(Mort24lsAdj~ATFRegWeapon*PoorMH14ls,data=dat1)
summary(fit3)
ggplot(dat1,aes(y=Mort24lsAdj,x=ATFRegWeapon,color=PoorMH14ls))+geom_point()+stat_smooth(method="lm",se=FALSE)

fit3=lm(Mort24lsAdj~ATFRegWeapon*PoorMH14gt,data=dat1)
summary(fit3)
ggplot(dat1,aes(y=Mort24lsAdj,x=ATFRegWeapon,color=PoorMH14gt))+geom_point()+stat_smooth(method="lm",se=FALSE)

fit3=lm(Mort24lsAdj~ATFRegWeapon*StPoP,data=dat1)
summary(fit3)
ggplot(dat1,aes(y=Mort24lsAdj,x=ATFRegWeapon,color=StPoP))+geom_point()+stat_smooth(method="lm",se=FALSE)




install.packages("devtools")
devtools::install_github("cardiomoon/ggiraphExtra")

fit4=lm(AllMortAdj~ATFRegWeapon*Poverty*Unemploy,data=dat1)
summary(fit4)
ggPredict(fit4,interactive = TRUE)



