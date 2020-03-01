install.packages("spgwr")

library(sp)
library(spdep)
library(sf)
library(tmap)

setwd("/Users/ruyazhang/downloads/phil_tracts")
philly <- st_read("phil_tracts.shp")

fit.ols<-glm(usarea ~ lmhhinc   + lpop + pnhblk + punemp + pvac  + ph70 + lmhval + 
     phnew + phisp, data = philly) 
summary(fit.ols)
```{r}
Call:
glm(formula = usarea ~ lmhhinc + lpop + pnhblk + punemp + pvac + 
    ph70 + lmhval + phnew + phisp, data = philly)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-177.24   -34.81    -9.91    23.03   670.17  

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  534.491    164.270   3.254  0.00124 ** 
lmhhinc        2.462     12.176   0.202  0.83990    
lpop          -1.344      6.338  -0.212  0.83216    
pnhblk        21.158     18.077   1.170  0.24260    
punemp        -5.097     63.645  -0.080  0.93622    
pvac         371.699     58.427   6.362 5.96e-10 ***
ph70         -79.691     35.535  -2.243  0.02552 *  
lmhval       -45.668     10.458  -4.367 1.64e-05 ***
phnew         17.958    319.042   0.056  0.95514    
phisp        -56.308     30.695  -1.834  0.06741 .  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for gaussian family taken to be 4829.927)

    Null deviance: 2938287  on 375  degrees of freedom
Residual deviance: 1767753  on 366  degrees of freedom
AIC: 4268.4

Number of Fisher Scoring iterations: 2
```
library(spgwr)
philly.sp <- as(philly, "Spatial")

gwr.b1<-gwr.sel(usarea ~ lmhhinc   + lpop + pnhblk + punemp + pvac  + ph70 + 
                  lmhval + phnew + phisp, philly.sp)
gwr.b1

gwr.fit1<-gwr(usarea ~ lmhhinc   + lpop + pnhblk + punemp + pvac  + ph70 + lmhval + 
     phnew + phisp, data = philly.sp, bandwidth = gwr.b1, se.fit=T, hatmatrix=T)
gwr.fit1

gwr.b2<-gwr.sel(usarea ~ lmhhinc   + lpop + pnhblk + punemp + pvac  + ph70 + lmhval + 
     phnew + phisp, data = philly.sp, gweight = gwr.bisquare)

gwr.fit2<-gwr(usarea ~ lmhhinc   + lpop + pnhblk + punemp + pvac  + ph70 + lmhval + 
     phnew + phisp, data = philly.sp, bandwidth = gwr.b2, gweight = gwr.bisquare, se.fit=T, 
     hatmatrix=T)
     
gwr.b2

gwr.fit2

gwr.b3<-gwr.sel(usarea ~ lmhhinc   + lpop + pnhblk + punemp + pvac  + ph70 + 
                  lmhval + phnew + phisp, data = philly.sp, adapt = TRUE)
gwr.b3

gwr.fit3<-gwr(usarea ~ lmhhinc   + lpop + pnhblk + punemp + pvac  + ph70 + lmhval + 
     phnew + phisp, data = philly.sp, adapt=gwr.b3, se.fit=T, hatmatrix=T)
     
gwr.fit3

gwr.fit1$bandwidth

gwr.fit3$bandwidth

philly$bwadapt <- gwr.fit3$bandwidth
tm_shape(philly, unit = "mi") +
  tm_polygons(col = "bwadapt", style = "quantile",palette = "Reds", 
              border.alpha = 0, title = "") +
  tm_scale_bar(breaks = c(0, 1, 2), size = 1, position = c("right", "bottom")) +
  tm_compass(type = "4star", position = c("left", "top")) + 
  tm_layout(main.title = "GWR bandwidth",  main.title.size = 0.95, frame = FALSE, legend.outside = TRUE)


names(gwr.fit3$SDF)
> names(gwr.fit3$SDF)
 [1] "sum.w"               "X.Intercept."        "lmhhinc"            
 [4] "lpop"                "pnhblk"              "punemp"             
 [7] "pvac"                "ph70"                "lmhval"             
[10] "phnew"               "phisp"               "X.Intercept._se"    
[13] "lmhhinc_se"          "lpop_se"             "pnhblk_se"          
[16] "punemp_se"           "pvac_se"             "ph70_se"            
[19] "lmhval_se"           "phnew_se"            "phisp_se"           
[22] "gwr.e"               "pred"                "pred.se"            
[25] "localR2"             "X.Intercept._se_EDF" "lmhhinc_se_EDF"     
[28] "lpop_se_EDF"         "pnhblk_se_EDF"       "punemp_se_EDF"      
[31] "pvac_se_EDF"         "ph70_se_EDF"         "lmhval_se_EDF"      
[34] "phnew_se_EDF"        "phisp_se_EDF"        "pred.se.1"    

dfree<-gwr.fit3$results$edf
philly$pnhblk.t <- gwr.fit3$SDF$pnhblk/gwr.fit3$SDF$pnhblk_se
philly$pnhblk.t.p<-2*pt(-abs(philly$pnhblk.t), dfree)
breaks <- c(0,0.01,0.05,0.1,1)
tm_shape(philly, unit = "mi") +
  tm_polygons(col = "pnhblk.t.p",palette = "Reds", breaks = breaks,
              border.alpha = 0, title = "") +
  tm_scale_bar(breaks = c(0, 1, 2), size = 1, position = c("right", "bottom")) +
  tm_compass(type = "4star", position = c("left", "top")) + 
  tm_layout(main.title = "t-stat",  main.title.size = 0.95, frame = FALSE, legend.outside = TRUE)
  
#Multicollinearity
round(cor(as.data.frame(gwr.fit3$SDF[,2:11]), use ="complete.obs"),2)

pairs(as(gwr.fit3$SDF, "data.frame")[,2:11], pch=".")

#model fit
gwr.fit3$results$AICh
pairs(as(gwr.fit3$SDF, "data.frame")[,2:11], pch=".")

gwr.fit3$results$AICc

gwr.fit3$results$AICb

AIC(fit.ols)

BFC02.gwr.test(gwr.fit3)

BFC99.gwr.test(gwr.fit3)

LMZ.F1GWR.test(gwr.fit3)

LMZ.F2GWR.test(gwr.fit3)

LMZ.F3GWR.test(gwr.fit3)
