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


# Multiple regression model with two continuous predictor variables with or without interaction
fit1=lm(AllMortAdj~ATFRegWeapon*Poverty,data=dat1)
summary(fit1)
ggplot(dat1,aes(y=AllMortAdj,x=ATFRegWeapon,color=Poverty))+geom_point()+stat_smooth(method="lm",se=FALSE)

> fit <- lm(AllMortAdj ~ ATFRegWeapon + Poverty + Unemploy + PoorMH0 + PoorMH14ls + PoorMH14gt + StPoP, data=dat1)
> summary(fit)

Call:
lm(formula = AllMortAdj ~ ATFRegWeapon + Poverty + Unemploy + 
    PoorMH0 + PoorMH14ls + PoorMH14gt + StPoP, data = dat1)

Residuals:
    Min      1Q  Median      3Q     Max 
-7.1602 -1.4565 -0.0834  0.9936 10.1491 

Coefficients:
               Estimate Std. Error t value Pr(>|t|)    
(Intercept)  -7.498e+03  8.313e+03  -0.902 0.372207    
ATFRegWeapon  3.471e-05  1.047e-05   3.315 0.001894 ** 
Poverty       8.438e-01  2.000e-01   4.220 0.000128 ***
Unemploy      7.654e-02  4.168e-01   0.184 0.855184    
PoorMH0       7.493e+01  8.312e+01   0.901 0.372465    
PoorMH14ls    7.513e+01  8.317e+01   0.903 0.371533    
PoorMH14gt    7.500e+01  8.312e+01   0.902 0.372058    
StPoP        -4.724e-07  1.115e-07  -4.236 0.000121 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 2.805 on 42 degrees of freedom
Multiple R-squared:  0.5815,	Adjusted R-squared:  0.5118 
F-statistic: 8.339 on 7 and 42 DF,  p-value: 2.356e-06
