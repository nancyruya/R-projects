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
  #fit1=lm(AllMortAdj~ATFRegWeapon*Poverty,data=dat1)
  #summary(fit1)
  #ggplot(dat1,aes(y=AllMortAdj,x=ATFRegWeapon,color=Poverty))+geom_point()+stat_smooth(method="lm",se=FALSE)

fit <- lm(AllMortAdj ~ ATFRegWeapon , data=dat1)
summary(fit)
fit <- lm(AllMortAdj ~ ATFFirearmLicense , data=dat1)
summary(fit)
fit <- lm(AllMortAdj ~ GiffordsRank , data=dat1)
summary(fit)
fit <- lm(AllMortAdj ~ GOwnerRates , data=dat1)
summary(fit)



#Beta Coefficient
install.packages("QuantPsyc")
library(QuantPsyc)
lm.beta(fit)


-----------------------------
> fit <- lm(AllMortAdj ~ ATFRegWeapon , data=dat1)
> summary(fit)

Call:
lm(formula = AllMortAdj ~ ATFRegWeapon, data = dat1)

Residuals:
    Min      1Q  Median      3Q     Max 
-7.8722 -2.4915 -0.3034  3.2527  7.8801 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)  1.102e+01  8.107e-01  13.597   <2e-16 ***
ATFRegWeapon 4.484e-06  8.273e-06   0.542     0.59    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 4.044 on 48 degrees of freedom
Multiple R-squared:  0.006082,	Adjusted R-squared:  -0.01462 
F-statistic: 0.2937 on 1 and 48 DF,  p-value: 0.5903

# All firearm mortality and ATF Registered Weapons
# R-squared:  0.006; p-value: 0.5903 not significant. We do not reject null hypothesis.

-----------------------------
> fit <- lm(AllMortAdj ~ ATFFirearmLicense , data=dat1)
> summary(fit)

Call:
lm(formula = AllMortAdj ~ ATFFirearmLicense, data = dat1)

Residuals:
    Min      1Q  Median      3Q     Max 
-8.0111 -2.3414 -0.1717  3.1680  7.6996 

Coefficients:
                    Estimate Std. Error t value Pr(>|t|)    
(Intercept)       11.5146774  0.9500578  12.120 3.25e-16 ***
ATFFirearmLicense -0.0000694  0.0002916  -0.238    0.813    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 4.054 on 48 degrees of freedom
Multiple R-squared:  0.001178,	Adjusted R-squared:  -0.01963 
F-statistic: 0.05663 on 1 and 48 DF,  p-value: 0.8129

# All firearm mortality and ATF Federal Firearm Licensees
# R-squared:  0.001; p-value: 0.8129 not significant. 
-----------------------------
> fit <- lm(AllMortAdj ~ GiffordsRank , data=dat1)
> summary(fit)

Call:
lm(formula = AllMortAdj ~ GiffordsRank, data = dat1)

Residuals:
    Min      1Q  Median      3Q     Max 
-5.2683 -2.0268  0.2815  1.8915  6.8215 

Coefficients:
             Estimate Std. Error t value Pr(>|t|)    
(Intercept)   6.35999    0.82155   7.741 5.43e-10 ***
GiffordsRank  0.19662    0.02826   6.958 8.53e-09 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 2.862 on 48 degrees of freedom
Multiple R-squared:  0.5021,	Adjusted R-squared:  0.4918 
F-statistic: 48.41 on 1 and 48 DF,  p-value: 8.53e-09

# All firearm mortality and Giffords Center Rankings
# R-squared:  0.502; p-value: 8.53e-09 significant. 
# Giffords Center Rankings explain 50.2% of the variability in All Firearm Mortality. We reject null hypothesis.
-----------------------------
> fit <- lm(AllMortAdj ~ GOwnerRates , data=dat1)
> summary(fit)

Call:
lm(formula = AllMortAdj ~ GOwnerRates, data = dat1)

Residuals:
    Min      1Q  Median      3Q     Max 
-9.8750 -1.2806  0.1723  1.6976  5.4270 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  4.60698    1.11315   4.139  0.00014 ***
GOwnerRates  0.20328    0.03118   6.520 4.01e-08 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 2.954 on 48 degrees of freedom
Multiple R-squared:  0.4697,	Adjusted R-squared:  0.4586 
F-statistic: 42.51 on 1 and 48 DF,  p-value: 4.005e-08

# All firearm mortality and Gun Ownership rates
# R-squared:  0.469; p-value: 4.005e-08 significant. 
# Gun Ownership rates explain 46.97% of the variability in All Firearm Mortality. We reject null hypothesis. 

-----------------------------
fit <- lm(AllMortAdj ~ GiffordsRank + Poverty + Unemploy + PoorMH0 + PoorMH14ls + PoorMH14gt + StPoP, data=dat1)
summary(fit)
> fit <- lm(AllMortAdj ~ GiffordsRank + Poverty + Unemploy + PoorMH0 + PoorMH14ls + PoorMH14gt + StPoP, data=dat1)
> summary(fit)

Call:
lm(formula = AllMortAdj ~ GiffordsRank + Poverty + Unemploy + 
    PoorMH0 + PoorMH14ls + PoorMH14gt + StPoP, data = dat1)

Residuals:
   Min     1Q Median     3Q    Max 
-5.813 -1.426 -0.241  1.654  5.706 

Coefficients:
               Estimate Std. Error t value Pr(>|t|)    
(Intercept)  -6.163e+03  7.634e+03  -0.807    0.424    
GiffordsRank  1.607e-01  3.503e-02   4.588    4e-05 ***
Poverty       3.341e-01  2.145e-01   1.557    0.127    
Unemploy      4.286e-01  3.949e-01   1.085    0.284    
PoorMH0       6.159e+01  7.633e+01   0.807    0.424    
PoorMH14ls    6.166e+01  7.638e+01   0.807    0.424    
PoorMH14gt    6.181e+01  7.633e+01   0.810    0.423    
StPoP        -5.192e-08  6.413e-08  -0.810    0.423    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 2.572 on 42 degrees of freedom
Multiple R-squared:  0.6483,	Adjusted R-squared:  0.5897 
F-statistic: 11.06 on 7 and 42 DF,  p-value: 7.866e-08

# R-squared:  0.6483; 


-----------------------------
fit <- lm(AllMortAdj ~ ATFRegWeapon + Poverty + Unemploy + PoorMH0 + PoorMH14ls + PoorMH14gt + StPoP, data=dat1)
summary(fit)

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

# Global Null Hypothesis
# When testing the null hypothesis that there is linear association between All Firearm Mortality, ATF Registered Weapons,
# poverty, unemployment, Poor Mental Health 0 days, poor mental health 1-14 days, poor mental health >14 days, statewide population.
# explain 58.15% of the variability in All Firearm Mortality.
# Significant p-value: ATFRegWeapon (p-value = 0.189), Poverty (p-value = 0.013), StPop (p-value = 0.012)

-----------------------------
> fit <- lm(AllMortAdj ~ ATFRegWeapon + Poverty + StPoP, data=dat1)
> summary(fit)

Call:
lm(formula = AllMortAdj ~ ATFRegWeapon + Poverty + StPoP, data = dat1)

Residuals:
    Min      1Q  Median      3Q     Max 
-6.7416 -1.4802 -0.2369  1.1582 10.4254 

Coefficients:
               Estimate Std. Error t value Pr(>|t|)    
(Intercept)  -7.856e-02  1.867e+00  -0.042  0.96662    
ATFRegWeapon  3.324e-05  9.762e-06   3.405  0.00138 ** 
Poverty       8.287e-01  1.304e-01   6.357 8.44e-08 ***
StPoP        -4.457e-07  9.709e-08  -4.590 3.42e-05 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 2.723 on 46 degrees of freedom
Multiple R-squared:  0.568,	Adjusted R-squared:  0.5398 
F-statistic: 20.16 on 3 and 46 DF,  p-value: 1.74e-08

# Global Null Hypothesis
# When testing the null hypothesis that there is linear association between All Firearm Mortality, ATF Registered Weapons,
# Poverty, and statewide population. ATF Registered weapons, poverty, and statewide polulation explain 56.8% of the
# variability in All Firearm Mortality.
# Main Effects Hypothesis
# When testing the null hypothesis that there is linear association between All Firearm Morality and ATF Registered Weapons
# after adjusting for poverty and statewide population, we reject the null hypothesis (t = 3.405, df = 46, p-value = 0.00138).
# for a one unit change in ATF Registered Weapons, on average, the All Firearm Mortality increases by 3.3e-05, after adjusting
# for poverty and statewide population.




> fit <- lm(AllMortAdj ~ ATFFirearmLicense + Poverty + Unemploy + PoorMH0 + PoorMH14ls + PoorMH14gt + StPoP, data=dat1)
> summary(fit)

Call:
lm(formula = AllMortAdj ~ ATFFirearmLicense + Poverty + Unemploy + 
    PoorMH0 + PoorMH14ls + PoorMH14gt + StPoP, data = dat1)

Residuals:
    Min      1Q  Median      3Q     Max 
-7.1004 -1.6484  0.0184  1.0667 10.1337 

Coefficients:
                    Estimate Std. Error t value Pr(>|t|)    
(Intercept)       -7.615e+03  9.175e+03  -0.830 0.411295    
ATFFirearmLicense  6.471e-04  4.851e-04   1.334 0.189378    
Poverty            8.250e-01  2.205e-01   3.741 0.000549 ***
Unemploy           1.549e-04  4.586e-01   0.000 0.999732    
PoorMH0            7.612e+01  9.174e+01   0.830 0.411363    
PoorMH14ls         7.620e+01  9.180e+01   0.830 0.411211    
PoorMH14gt         7.621e+01  9.174e+01   0.831 0.410854    
StPoP             -3.356e-07  1.428e-07  -2.349 0.023592 *  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 3.086 on 42 degrees of freedom
Multiple R-squared:  0.4935,	Adjusted R-squared:  0.4091 
F-statistic: 5.846 on 7 and 42 DF,  p-value: 8.928e-05


> fit <- lm(AllMortAdj ~ ATFFirearmLicense + Poverty + StPoP, data=dat1)
> summary(fit)

Call:
lm(formula = AllMortAdj ~ ATFFirearmLicense + Poverty + StPoP, 
    data = dat1)

Residuals:
    Min      1Q  Median      3Q     Max 
-6.9851 -1.6196  0.0009  1.0945 10.1478 

Coefficients:
                    Estimate Std. Error t value Pr(>|t|)    
(Intercept)       -3.184e-01  2.045e+00  -0.156  0.87693    
ATFFirearmLicense  6.922e-04  4.583e-04   1.510  0.13783    
Poverty            8.382e-01  1.436e-01   5.837 5.07e-07 ***
StPoP             -3.477e-07  1.287e-07  -2.702  0.00962 ** 
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 2.975 on 46 degrees of freedom
Multiple R-squared:  0.4846,	Adjusted R-squared:  0.451 
F-statistic: 14.42 on 3 and 46 DF,  p-value: 9.347e-07







> fit <- lm(AllMortAdj ~ GiffordsRank + Poverty + Unemploy + PoorMH0 + PoorMH14ls + PoorMH14gt + StPoP, data=dat1)
> summary(fit)

Call:
lm(formula = AllMortAdj ~ GiffordsRank + Poverty + Unemploy + 
    PoorMH0 + PoorMH14ls + PoorMH14gt + StPoP, data = dat1)

Residuals:
   Min     1Q Median     3Q    Max 
-5.813 -1.426 -0.241  1.654  5.706 

Coefficients:
               Estimate Std. Error t value Pr(>|t|)    
(Intercept)  -6.163e+03  7.634e+03  -0.807    0.424    
GiffordsRank  1.607e-01  3.503e-02   4.588    4e-05 ***
Poverty       3.341e-01  2.145e-01   1.557    0.127    
Unemploy      4.286e-01  3.949e-01   1.085    0.284    
PoorMH0       6.159e+01  7.633e+01   0.807    0.424    
PoorMH14ls    6.166e+01  7.638e+01   0.807    0.424    
PoorMH14gt    6.181e+01  7.633e+01   0.810    0.423    
StPoP        -5.192e-08  6.413e-08  -0.810    0.423    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 2.572 on 42 degrees of freedom
Multiple R-squared:  0.6483,	Adjusted R-squared:  0.5897 
F-statistic: 11.06 on 7 and 42 DF,  p-value: 7.866e-08

> fit <- lm(AllMortAdj ~ GOwnerRates + Poverty + Unemploy + PoorMH0 + PoorMH14ls + PoorMH14gt + StPoP, data=dat1)
> summary(fit)

Call:
lm(formula = AllMortAdj ~ GOwnerRates + Poverty + Unemploy + 
    PoorMH0 + PoorMH14ls + PoorMH14gt + StPoP, data = dat1)

Residuals:
    Min      1Q  Median      3Q     Max 
-7.2809 -1.3044  0.3207  1.6842  4.6360 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept) -6.994e+03  7.501e+03  -0.932   0.3564    
GOwnerRates  1.578e-01  3.283e-02   4.808 1.98e-05 ***
Poverty      3.719e-01  2.055e-01   1.809   0.0775 .  
Unemploy     3.486e-01  3.837e-01   0.908   0.3688    
PoorMH0      6.991e+01  7.499e+01   0.932   0.3566    
PoorMH14ls   6.986e+01  7.505e+01   0.931   0.3573    
PoorMH14gt   7.019e+01  7.499e+01   0.936   0.3546    
StPoP       -7.403e-08  6.116e-08  -1.210   0.2329    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 2.531 on 42 degrees of freedom
Multiple R-squared:  0.6594,	Adjusted R-squared:  0.6027 
F-statistic: 11.62 on 7 and 42 DF,  p-value: 4.167e-08
