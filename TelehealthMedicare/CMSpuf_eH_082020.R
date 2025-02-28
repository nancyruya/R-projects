#https://data.cms.gov/Medicare-Physician-Supplier/Medicare-Provider-Utilization-and-Payment-Data-Phy/fs4p-t5eq
#https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Geographic-Variation/GV_PUF
# read.socrata("https://urldefense.proofpoint.com/v2/url?u=https-3A__data.cms.gov_resource_utc4-2Df9xp.json&d=DwIGAg&c=shNJtf5dKgNcPZ6Yh64b-A&r=aU_gC_gvZ4OZ799xunZC2xTqEtPSnwqeuUx57dck-iM&m=grokcQcbYLMuAEIYdyzUyhPWgGRl17f60sdkOBMcotM&s=TUxYc1f_XiGpoQJihnOkHMJSOHSJurUIK9pYJ5lJUTM&e= ", app_token = NULL, email = NULL, password = NULL,
#              stringsAsFactors = FALSE)

library(usmap)
library(dplyr)
library(ggplot2)
library(summarytools)
library(grid)
library(gridExtra)
library("ggpubr")
# library(RSocrata)

setwd ("C:/Users/bian/Documents/My SAS Files/CMS/CMS_eH/CMSpuf_eH_data")


##################### 2017 data ###########################################
dat1 <- read.csv("MedicareAllTelehealth2017-1.csv")
dat2 <- read.csv("MedicareAllTelehealth2017-2.csv")
dat3 <- read.csv("MedicareAllTelehealth2017-3.csv")
dat4 <- read.csv("MedicareAllTelehealth2017-4.csv")

dat0a <- rbind(dat1, dat2, dat3, dat4)
names(dat0a) <- c(
  "NPI","LastName","FirstName","MiddleInitial", "Credentials", 
  "Gender", "EntityType", "StAddress1", "StAddress2", "City",
  "Zip", "State", "Country", "ProviderType", "ParticiIndicator",
  "Place", "HCPCS","HDescription", "HDrug", "NumberServices",
  "NumberMediBeneficiaries", "NumberDistMediBeneficiaryPerDay", 
  "AveMediAllowedAmount", "AveMediChargeAmount"," AveMediPaymentAmount",
  "AveMediStandardAmount")

##check on unique vars;
length(unique(dat0a$State))
length(unique(dat0a$NPI))
length(unique(dat0a$ProviderType))
length(unique(dat0a$HCPCS))
length(unique(dat0a$HDescription))

##AGGREGATE data at state level#
eHstate <- as.data.frame(aggregate(NumberServices ~ State, dat0a, sum))
NPIstate <- summarize(group_by(dat0a, State), unique_NPI = n_distinct(NPI))
# eHstate <- aggNumServices[order(eHstate$NumberServices),]
eHNPIstate <- merge(eHstate, NPIstate, by="State")

eHNPItype17 <- as.data.frame(aggregate(NumberServices ~ ProviderType, dat0a, sum))
eHNPItype17$year <- "2017"

HCPCS17 <- as.data.frame(aggregate(NumberServices ~ HCPCS, dat0a, sum))
HCPCS17$year <- "2017"

HCPCStxt17 <- as.data.frame(aggregate(NumberServices ~ HDescription, dat0a, sum))
HCPCStxt17$year <- "2017"

dat0a$HCPCS3 <- ifelse(substr(dat0a$HCPCS,1,1)=="G", 
                       substr(dat0a$HCPCS,1,4), substr(dat0a$HCPCS,1,3))
head(dat0a$HCPCS3)
tail(dat0a$HCPCS3)
length(unique(dat0a$HCPCS3))
HCPCS317 <- as.data.frame(aggregate(NumberServices ~ HCPCS3, dat0a, sum))
HCPCS317$year <- "2017"

dat0a$HCPCSgp <- ifelse(dat0a$HCPCS3 %in% c("907","908"), "Psych related services",
           ifelse(dat0a$HCPCS3 %in% c("909") | dat0a$HCPCS %in% c("90958") , "Esrd related services",
           ifelse(dat0a$HCPCS3 %in% c("961"), "hlth/behave",            
           ifelse(dat0a$HCPCS3 %in% c("978"), "Med nutrition",   
           ifelse(dat0a$HCPCS3 %in% c("992"), "Office/outpatient visit",
           ifelse(dat0a$HCPCS3 %in% c("992") & dat0a$HCPCS %in% c("99231","99232","99233"),
                  "Subsequent hospital care",
           ifelse(dat0a$HCPCS %in% c("99307","99308","99309","99310"), "Nursing fac care subseq",
           ifelse(dat0a$HCPCS %in% c("99354","99355","99356","99357"), "Prolonged service",
           ifelse(dat0a$HCPCS %in% c("99406","99407"), "Behav chng smoking",
           ifelse(dat0a$HCPCS %in% c("99495","99496"), "Trans care mgmt",
           ifelse(dat0a$HCPCS %in% c("99497","99498"), "Advncd care plan",
           ifelse(dat0a$HCPCS3 %in% c("G010"), "Diab manage trn",                  
           ifelse(dat0a$HCPCS3 %in% c("G039"), "Alcohol/subs interv",  
           ifelse(dat0a$HCPCS3 %in% c("G027"), "Medical nutrition therapy",  
           ifelse(dat0a$HCPCS3 %in% c("G039"), "Alcohol/subs interv",  
           ifelse(dat0a$HCPCS3 %in% c("G040"), "Inpt/tele follow up",  
           ifelse(dat0a$HCPCS3 %in% c("G040") & dat0a$HCPCS %in% c("G0420","G0421"), 
                  "Ed svc ckd",    
           ifelse(dat0a$HCPCS %in% c("G0425","G0426","G0427"), "Inpt/ed teleconsult",    
           ifelse(dat0a$HCPCS %in% c("G0436","G0437"), "Tobacco-use counsel", 
           ifelse(dat0a$HCPCS %in% c("G0438","G0439"), "Personalized prevention plan",        
           ifelse(dat0a$HCPCS %in% c("G0442","G0443"), "alcohol screen consel", 
           ifelse(dat0a$HCPCS %in% c("G0444"), "Depression screen annual", 
           ifelse(dat0a$HCPCS %in% c("G0445","G0446","G0447"), "intensive behavioral therapy", 
           ifelse(dat0a$HCPCS %in% c("G0459"), "Telehealth inpt pharm mgmt", 
           "Telehealt con ccare" 
))))))))))))))))))))))))
head(dat0a$HCPCSgp)
tail(dat0a$HCPCSgp)
length(unique(dat0a$HCPCSgp))
HCPCSgp17 <- as.data.frame(aggregate(NumberServices ~ HCPCSgp, dat0a, sum))
HCPCSgp17$year <- "2017"

############################
# read dataset from CMS for medicare benificiaries
dat0b <- read.csv("StateCountyFFS2017.csv")
names(dat0b) <- c("State","County","FIPS","FFS")
dat0b$FFS <- as.numeric(as.character(dat0b$FFS))
# State Total FFS population
FFSstate <- select(filter(dat0b, County == "STATE TOTAL"), c(State, FFS) )
# merge is a function in dplyr package, this merge reduced from 55 states in telehealth data to 53 states from FFS
df <- merge(x=FFSstate, y=eHNPIstate, by = "State")
#statepop is from "usmap" 
#library(usmap)
##reduce to the 51 states
df <- merge(statepop, df, by.x="abbr",by.y="State")

df17 <- df
df17$year <- "2017"

plot_usmap(data = df17, values = "NumberServices", color = "red") + 
  scale_fill_continuous(name = "telehealth Services (2017)", 
                        type = "viridis", label = scales::comma) + 
  theme(legend.position = "right")


##################### 2016 data ###########################################
#setwd ("C:/Users/bian/Documents/My SAS Files/CMS/CMS_eH/CMSpuf_eH_data")
dat1 <- read.csv("MedicareAllTelehealth2016-1.csv")
dat2 <- read.csv("MedicareAllTelehealth2016-2.csv")
dat3 <- read.csv("MedicareAllTelehealth2016-3.csv")
dat4 <- read.csv("MedicareAllTelehealth2016-4.csv")

dat0a <- rbind(dat1, dat2, dat3, dat4)
names(dat0a) <- c(
  "NPI","LastName","FirstName","MiddleInitial", "Credentials", 
  "Gender", "EntityType", "StAddress1", "StAddress2", "City",
  "Zip", "State", "Country", "ProviderType", "ParticiIndicator",
  "Place", "HCPCS","HDescription", "HDrug", "NumberServices",
  "NumberMediBeneficiaries", "NumberDistMediBeneficiaryPerDay", 
  "AveMediAllowedAmount", "AveMediChargeAmount"," AveMediPaymentAmount",
  "AveMediStandardAmount")

##check on unique vars;
length(unique(dat0a$State))
length(unique(dat0a$NPI))
length(unique(dat0a$ProviderType))
length(unique(dat0a$HCPCS))


##AGGREGATE data number of services at state level#
eHstate <- as.data.frame(aggregate(NumberServices ~ State, dat0a, sum))
NPIstate <- summarize(group_by(dat0a, State), unique_NPI = n_distinct(NPI))
# eHstate <- aggNumServices[order(eHstate$NumberServices),]
eHNPIstate <- merge(eHstate, NPIstate, by="State")

eHNPItype16 <- as.data.frame(aggregate(NumberServices ~ ProviderType, dat0a, sum))
eHNPItype16$year <- "2016"

HCPCS16 <- as.data.frame(aggregate(NumberServices ~ HCPCS, dat0a, sum))
HCPCS16$year <- "2016"

HCPCStxt16 <- as.data.frame(aggregate(NumberServices ~ HDescription, dat0a, sum))
HCPCStxt16$year <- "2016"

dat0a$HCPCS3 <- ifelse(substr(dat0a$HCPCS,1,1)=="G", 
                       substr(dat0a$HCPCS,1,4), substr(dat0a$HCPCS,1,3))
head(dat0a$HCPCS3)
tail(dat0a$HCPCS3)
length(unique(dat0a$HCPCS3))
HCPCS316 <- as.data.frame(aggregate(NumberServices ~ HCPCS3, dat0a, sum))
HCPCS316$year <- "2016"

dat0a$HCPCSgp <- ifelse(dat0a$HCPCS3 %in% c("907","908"), "Psych related services",
                 ifelse(dat0a$HCPCS3 %in% c("909") | dat0a$HCPCS %in% c("90958") , "Esrd related services",
                 ifelse(dat0a$HCPCS3 %in% c("961"), "hlth/behave",            
                 ifelse(dat0a$HCPCS3 %in% c("978"), "Med nutrition",   
                 ifelse(dat0a$HCPCS3 %in% c("992"), "Office/outpatient visit",
                 ifelse(dat0a$HCPCS3 %in% c("992") & dat0a$HCPCS %in% c("99231","99232","99233"),
                 "Subsequent hospital care",
                 ifelse(dat0a$HCPCS %in% c("99307","99308","99309","99310"), "Nursing fac care subseq",
                 ifelse(dat0a$HCPCS %in% c("99354","99355","99356","99357"), "Prolonged service",
                 ifelse(dat0a$HCPCS %in% c("99406","99407"), "Behav chng smoking",
                 ifelse(dat0a$HCPCS %in% c("99495","99496"), "Trans care mgmt",
                 ifelse(dat0a$HCPCS %in% c("99497","99498"), "Advncd care plan",
                 ifelse(dat0a$HCPCS3 %in% c("G010"), "Diab manage trn",                  
                 ifelse(dat0a$HCPCS3 %in% c("G039"), "Alcohol/subs interv",  
                 ifelse(dat0a$HCPCS3 %in% c("G027"), "Medical nutrition therapy",  
                 ifelse(dat0a$HCPCS3 %in% c("G039"), "Alcohol/subs interv",  
                 ifelse(dat0a$HCPCS3 %in% c("G040"), "Inpt/tele follow up",  
                 ifelse(dat0a$HCPCS3 %in% c("G040") & dat0a$HCPCS %in% c("G0420","G0421"), 
                 "Ed svc ckd",    
                 ifelse(dat0a$HCPCS %in% c("G0425","G0426","G0427"), "Inpt/ed teleconsult",    
                 ifelse(dat0a$HCPCS %in% c("G0436","G0437"), "Tobacco-use counsel", 
                 ifelse(dat0a$HCPCS %in% c("G0438","G0439"), "Personalized prevention plan",        
                 ifelse(dat0a$HCPCS %in% c("G0442","G0443"), "alcohol screen consel", 
                 ifelse(dat0a$HCPCS %in% c("G0444"), "Depression screen annual", 
                 ifelse(dat0a$HCPCS %in% c("G0445","G0446","G0447"), "intensive behavioral therapy", 
                 ifelse(dat0a$HCPCS %in% c("G0459"), "Telehealth inpt pharm mgmt", 
                 "Telehealt con ccare" 
))))))))))))))))))))))))
head(dat0a$HCPCSgp)
tail(dat0a$HCPCSgp)
length(unique(dat0a$HCPCSgp))
HCPCSgp16 <- as.data.frame(aggregate(NumberServices ~ HCPCSgp, dat0a, sum))
HCPCSgp16$year <- "2016"


############################
# read dataset from CMS for medicare benificiaries
dat0b <- read.csv("StateCountyFFS2016.csv")
names(dat0b) <- c("State","County","FIPS","FFS")
dat0b$FFS <- as.numeric(as.character(dat0b$FFS))
# State Total FFS population
FFSstate <- select(filter(dat0b, County == "STATE TOTAL"), c(State, FFS) )
# merge is a function in dplyr package, this merge reduced from 55 states in telehealth data to 53 states from FFS
df <- merge(x=FFSstate, y=eHNPIstate, by = "State")
#statepop is from "usmap" 
#library(usmap)
##reduce to the 51 states
df <- merge(statepop, df, by.x="abbr",by.y="State")

df16 <- df
df16$year <- "2016"

plot_usmap(data = df16, values = "NumberServices", color = "red") + 
  scale_fill_continuous(name = "telehealth Services (2016)", 
  type = "viridis", label = scales::comma) + 
  theme(legend.position = "right")


############### all 17 & 16 data #####################
df <- rbind(df16, df17)
df$eHperFFS <- round(df$NumberServices/df$FFS,2)
df$eHperNPI <- round(df$NumberServices/df$unique_NPI,2)
df$NPIperFFS <- df$unique_NPI/df$FFS
df$NPIperFFS <- round(df$NPIperFFS *1000,2)

#library(summarytools)
#https://cran.r-project.org/web/packages/summarytools/vignettes/Introduction.html
descr(df[,c(5:7,9:11)], stats="common", transpose = T) 

StatsByYear <- stby(data = df[,c(5:7,9:11)], 
     INDICES = df$year, 
     FUN = descr, stats = "common", transpose = TRUE)

view(StatsByYear, file = "StatsByYear.html")

StatsByYear <- stby(data = df[,c(5:7,9:11)],
                    INDICES = list(df$abbr, df$year),
                    FUN = descr, stats = "common", transpose = TRUE)

view(StatsByYear, file = "StatsByYear2.html")

# summary(df$eHperFFS)
# sd(df$eHperFFS)

######################
# Graph.1: Service/FFS
p1 <-
plot_usmap(data = df, values = "eHperFFS", color = "white") +
  scale_fill_continuous(name = "(a) Services/FFS, 2017",
                       low="light blue",high="dark blue", label = scales::comma) +
  theme(legend.position = "right")+
  theme(plot.margin = unit(c(0,0,0,0), "cm"))

p1

mybreaks <- round(quantile(df$eHperFFS, c(0.10, 0.25, 0.50, 0.75, 0.90, 0.95)),1) 
mybreaks
p1 <- 
  p1+  scale_fill_gradientn(name = "(a) Services/FFS, 2017",
                            colours = c("light blue", "dark blue"),
                            breaks  = c(mybreaks[[6]],mybreaks[[5]],mybreaks[[4]],
                                        mybreaks[[3]],mybreaks[[2]],mybreaks[[1]]),
                            guide = guide_legend(direction = "vertical"))

p1

# plot_usmap(data = df, values = "eHperFFS", color = "red") +
#   labs(title = "Serive per Fee for Service", subtitle = "") +
#   scale_fill_continuous(name = "Service/ 1000 FFS (2017)", 
#                         type = "viridis", label = scales::comma) +
#   theme(legend.position = "right")


# Graph.2: Service/Provider
p2 <-
  plot_usmap(data = df, values = "eHperNPI", color = "white") +
  scale_fill_continuous(name = "(b) Services/Provider, 2017", 
                        low="pink",high="red", label = scales::comma) +
  theme(legend.position = "right")+
  theme(plot.margin = unit(c(0,0,0,0), "cm"))

p2

mybreaks <- round(quantile(df$eHperNPI, c(0.10, 0.25, 0.50, 0.75, 0.90, 0.95)),0) 
mybreaks

p2 <- 
  p2+  scale_fill_gradientn(name = "(b) Services/Provider, 2017",
                            colours = c("pink", "red"),
                            breaks  = c(mybreaks[[6]],mybreaks[[5]],mybreaks[[4]],
                                        mybreaks[[3]],mybreaks[[2]],mybreaks[[1]]),
                            guide = guide_legend(direction = "vertical"))

p2


# Graph.3: Provider/FFS
# df$NPIperFFS <- df$NPIperFFS /100
p3 <-
plot_usmap(data = df, values = "NPIperFFS", color = "white") +
  scale_fill_continuous(name = "(c) Providers/1000 FFS, 2017", 
                        low="light green",high="dark green", label = scales::comma) +
  theme(legend.position = "right")+
  theme(plot.margin = unit(c(0,0,0,0), "cm"))

p3

mybreaks <- round(quantile(df$NPIperFFS, c(0.10, 0.25, 0.50, 0.75, 0.90, 0.95)),1) 
mybreaks

p3 <- 
  p3+  scale_fill_gradientn(name = "(c) Providers/1000 FFS, 2017",
                            colours = c("light green", "dark green"),
                            breaks  = c(mybreaks[[6]],mybreaks[[5]],mybreaks[[4]],
                                        mybreaks[[3]],mybreaks[[2]],mybreaks[[1]]),
                            guide = guide_legend(direction = "vertical"))

p3


##save the plot##
#par(mar = c(0, 0, 0, 0)) # Set the margin on all sides to 6
tiff(filename="Fig_2017.tiff",
     res=300, compression='lzw',height=10, width=9, unit="in", pointsize=0.5)
  grid.arrange(p1, p2, p3, ncol =1)
dev.off()


### for tables ###
#library(summarytools)
#summary(df)
#descr(df[, 5:11], stats="common", transpose = T)  
descr(df[, 5:11], stats="all", transpose = T)  


#####################differences between 2016 and 2017 ###################3
# dfAllw <- cbind(df16, df17)
diff <- df[1:51,1:3]
diff$FFS <- df17$FFS - df16$FFS
diff$NumberServices <- df17$NumberServices - df16$NumberServices
diff$unique_NPI <- df17$unique_NPI - df16$unique_NPI
diff$eHperFFS <- (df[52:102,9] - df[1:51,9])*1000
diff$eHperNPI <- df[52:102,10] - df[1:51,10]
diff$NPIperFFS <- df[52:102,11] - df[1:51,11]

## for tables ##
#summary(diff)
#descr(diff[,4:9], stats="common", transpose = T) 
descr(diff[, 4:9], stats="all", transpose = T) 

########
#https://cran.r-project.org/web/packages/usmap/vignettes/advanced-mapping.html
#https://cran.r-project.org/web/packages/usmap/vignettes/mapping.html
#https://socviz.co/maps.html
#https://stackoverflow.com/questions/8069837/is-there-a-built-in-way-to-do-a-logarithmic-color-scale-in-ggplot2
## for tables ##
summary(diff)

# Graph.1: Service/FFS blue
summary(diff$eHperFFS)

p4 <-
  plot_usmap(data = diff, values = "eHperFFS", color = "grey50") +
  scale_fill_continuous(name = "Services/1000 FFS, change 2016-2017",
                        low="light blue",high="dark blue", label = scales::comma) +
  theme(legend.position = "right")+
  theme(plot.margin = unit(c(0,0,0,0), "cm"))

mybreaks <- round(quantile(diff$eHperFFS, c(0.01, 0.05, 0.10, 0.25, 0.50, 0.75, 0.90, 0.95)),2) 
mybreaks

p4 <- 
  p4+  scale_fill_gradientn(name = "(a) Services/1000 FFS, change 2016-2017",
            colours = c("darkgreen", "white", "darkred"),
            breaks  = c(mybreaks[[8]],mybreaks[[7]],mybreaks[[6]],mybreaks[[5]],
                        mybreaks[[4]],mybreaks[[3]],mybreaks[[2]],mybreaks[[1]]),
            guide = guide_legend(direction = "vertical"))

p4


p5 <-
  plot_usmap(data = diff, values = "eHperNPI", color = "grey50") +
  scale_fill_continuous(name = "Services/Provider, change 2016-2017",
                        low="light blue",high="dark blue", label = scales::comma) +
  theme(legend.position = "right")+
  theme(plot.margin = unit(c(0,0,0,0), "cm"))

mybreaks <- round(quantile(diff$eHperNPI, c(0.01, 0.05, 0.10, 0.25, 0.50, 0.75, 0.90, 0.95)),2) 
mybreaks
p5 <- 
  p5+  scale_fill_gradientn(name = "(b) Services/Provider, change 2016-2017",
            colours = c("darkgreen", "white", "darkred"),
            breaks  = c(mybreaks[[8]],mybreaks[[7]],mybreaks[[6]],mybreaks[[5]],
                        mybreaks[[4]],mybreaks[[3]],mybreaks[[2]],mybreaks[[1]]),
            guide = guide_legend(direction = "vertical"))

p5

##################

p6 <-
  plot_usmap(data = diff, values = "NPIperFFS", color = "grey50") +
  scale_fill_continuous(name = "Providers/1000 FFS, change 2016-2017",
                        low="light blue",high="dark blue", label = scales::comma) +
  theme(legend.position = "right")+
  theme(plot.margin = unit(c(0,0,0,0), "cm"))

mybreaks <- round(quantile(diff$NPIperFFS, c(0.01, 0.05, 0.10, 0.25, 0.50, 0.75, 0.90, 0.95)),2) 
mybreaks


p6 <- 
  p6+  scale_fill_gradientn(name = "(c) Providers/1000 FFS, change 2016-2017",
                            colours = c("darkgreen", "white", "darkred"),
                            breaks  = c(mybreaks[[8]],mybreaks[[7]],mybreaks[[6]],mybreaks[[5]],
                                        mybreaks[[4]],mybreaks[[3]],mybreaks[[2]],mybreaks[[1]]),
                            guide = guide_legend(direction = "vertical"))
p6


grid.arrange(p4, p5, p6, ncol =1)

##save the plot##
tiff(filename="Fig_diff.tiff",
     res=300, compression='lzw',height=10, width=9, unit="in", pointsize=0.5)
  grid.arrange(p4, p5, p6, ncol =1)
dev.off()



################# Morant test ####################
library(rgdal)
library(spdep)

#library(rgdal) for importing shape file
#shape file is from the Census
#https://www.census.gov/geographies/mapping-files/time-series/geo/carto-boundary-file.2017.html

map0 <- readOGR("cb_2017_us_state_500k.shp")
map0 <- subset(map0,!(map0$STUSPS %in% c("AK","HI","AS","GU","MP","PR","VI")))
#import data file
dat0 <- df[,-4]
dat0a <- subset(dat0, dat0$year=="2017")
dat0a <- subset(dat0a, !(dat0a$abbr %in% c("AK","HI")))
names(dat0a) <- c("abbr", "fips", "full", "FFS","eH","NPI", "year",
      "eHperFFS", "eHperNPI","NPIperFFS")

dat0 <- diff[,c(1,4:9)]
dat0b <- subset(dat0, !(dat0$abbr %in% c("AK","HI")))
names(dat0b) <- c("abbr", "diffFFS", "diffeH", "diffNPI",
      "diffeHperFFS", "diffeHperNPI", "diffNPIperFFS")

dat0ab <- merge(dat0a, dat0b, by="abbr")

#add varXs in to the spatial frame for contiguous US only
map0 <- merge(map0, dat0ab, by.x="STUSPS",by.y="abbr", all.x=T)

#construct neighbors List
mnb1 <- poly2nb(map0)
#generate spatial Weights; can change style to others, B,C,S..
mnb2 <- nb2listw(mnb1, style="W", zero.policy=TRUE)
#visualize neighbors
plot(mnb2,coords=coordinates(map0),pch=19, cex=0.1, col="gray")

#test global Moran for varX=total population
#could also do a Permutation test
#moran.mc(map0$FFS, mnb2, nsim=999)
moran.test(map0$eH, listw=mnb2, zero.policy=T)
moran.test(map0$FFS, listw=mnb2, zero.policy=T)
moran.test(map0$NPI, listw=mnb2, zero.policy=T)
moran.test(map0$eHperFFS, listw=mnb2, zero.policy=T)
moran.test(map0$eHperNPI, listw=mnb2, zero.policy=T)
moran.test(map0$NPIperFFS, listw=mnb2, zero.policy=T)

moran.test(map0$diffeH, listw=mnb2, zero.policy=T)
moran.test(map0$diffFFS, listw=mnb2, zero.policy=T)
moran.test(map0$diffNPI, listw=mnb2, zero.policy=T)
moran.test(map0$diffeHperFFS, listw=mnb2, zero.policy=T)
moran.test(map0$diffeHperNPI, listw=mnb2, zero.policy=T)
moran.test(map0$diffNPIperFFS, listw=mnb2, zero.policy=T)



################ eH by Provider Type ###############################3
#library("ggpubr")
eHNPItype17$pct <- round((eHNPItype17$NumberServices/sum(eHNPItype17$NumberServices))*100,4)
eHNPItype16$pct <- round((eHNPItype16$NumberServices/sum(eHNPItype16$NumberServices))*100,4)
eHNPItype <- rbind(eHNPItype17, eHNPItype16)

fooa <- eHNPItype17[order(-eHNPItype17$pct),]
fooa <- fooa[1:30,]
foob <- eHNPItype16[order(-eHNPItype16$pct),]
foob <- foob[1:30,]
foo<- rbind(fooa, foob)

p7 <- ggdotchart(foo, x = "ProviderType", y = "pct",
                  shape = "year", color = "year",
                  position = position_dodge(1),
                  sorting = "descending",                        
                  add = "segments",  
                  add.params = list(color = "lightgray", size = .5),
                  dot.size = 1.5,  
                  rotate=T,
                 #ggtheme = theme_gray()
                  ylab = "Top 30 telehealth services% by provider specialty")+
  theme(legend.position = "top")+
  theme(axis.title.x = element_text(size =14))+
  theme(axis.text=element_text(size=12, colour="black"))+
  theme(axis.title.y=element_blank())

p7


##save the plot##
tiff(filename="Fig_MDtype.tiff",
     res=300, compression='lzw',height=10, width=9, unit="in", pointsize=0.5)
p7
dev.off()


################ eH by HCPCS code ###############################3
#library("ggpubr")
#HCPCSgp17$pct <- round((HCPCSgp17$NumberServices/sum(HCPCSgp17$NumberServices))*100,3)
HCPCSgp17$pct <- round((HCPCSgp17$NumberServices/sum(HCPCSgp17$NumberServices))*100,4)
HCPCSgp16$pct <- round((HCPCSgp16$NumberServices/sum(HCPCSgp16$NumberServices))*100,4)
HCPCSgp <- rbind(HCPCSgp17, HCPCSgp16)

summary(HCPCSgp)

p8a <- ggdotchart(HCPCSgp, x = "HCPCSgp", y = "pct",
                  shape = "year", color="year",
                  position = position_dodge(1),
                  sorting = "descending",                        
                  add = "segments",  
                  add.params = list(color = "lightgray", size = .5),
                  dot.size = 1.5,  
                  #label = T,
                  rotate=T,
                  ylab = "Top 30 telehealth services% by HCPCS code groups",
                  #yscale="log2",
                  ggtheme = theme_pubr()) +
  theme(legend.position = "top")+
  theme(axis.title.x = element_text(size =14))+
  theme(axis.text=element_text(size=11, colour="black"))+
  theme(axis.title.y=element_blank())


p8a

##save the plot##
tiff(filename="Fig_HCPCSgp.tiff",
     res=300, compression='lzw',height=10, width=9, unit="in", pointsize=0.5)
p8a
dev.off()


################ eH by HCPCS code ###############################3
#library("ggpubr")
setwd ("C:/Users/bian/Documents/My SAS Files/CMS/CMS_eH/CMSpuf_eH_data")
dat0 <- read.csv("Hdescription_2017.csv")
dat0 <- dat0[,1:2]
names(dat0) <- c("HCPCS","Hshort")

HCPCS17$pct <- round((HCPCS17$NumberServices/sum(HCPCS17$NumberServices))*100,4)
HCPCS17 <- merge(HCPCS17, dat0, by="HCPCS")
HCPCS16$pct <- round((HCPCS16$NumberServices/sum(HCPCS16$NumberServices))*100,4)
HCPCS16 <- merge(HCPCS16, dat0, by="HCPCS")

HCPCS <- rbind(HCPCS17, HCPCS16)


fooa <- HCPCS17[order(-HCPCS17$pct),]
fooa <- fooa[1:30,]
foob <- HCPCS16[order(-HCPCS16$pct),]
foob <- foob[1:30,]
HCPCS<- rbind(fooa, foob)
summary(HCPCS)

p8c <- ggdotchart(HCPCS, x = "HCPCS", y = "pct",
                  shape = "year", color="year",
                  position = position_dodge(1),
                  sorting = "descending",                        
                  add = "segments",  
                  add.params = list(color = "lightgray", size = .5),
                  dot.size = 1.5,  
                  rotate=T,
                  #ylab = "Top 30 telehealth services% by HCPCS codes",
                  ggtheme = theme_pubr()) +
  theme(legend.position = "top")+
  theme(axis.title.x = element_text(size =14))+
  theme(axis.text=element_text(size=11, colour="black"))+
  theme(axis.title.y=element_blank())+
  scale_y_continuous(name="Top 30 telehealth services% by HCPCS codes",
                   breaks= seq(0,30,by=5),
                   limits=c(0, 30))


p8c

p8c <- 
  p8c + geom_text(data=HCPCS, label=HCPCS$Hshort, y=20, color="black", size=3.3)

p8c


##save the plot##
tiff(filename="Fig_HCPCS.tiff",
     res=300, compression='lzw',height=10, width=9, unit="in", pointsize=0.5)
p8c
dev.off()


# ##save the plots##
# summary(HCPCSgp$pct)
# 
# p8a2 <- ggdotchart(HCPCSgp, x = "HCPCSgp", y = "pct",
#            shape = "year", color="year",
#            position = position_dodge(1),
#            sorting = "descending",                        
#            add = "segments",  
#            add.params = list(color = "lightgray", size = .5),
#            dot.size = 1.5,  
#            #label = T,
#            #label.rectangle=T,
#            rotate=T,
#            ylab = "(a) Top 30 telehealth services% by HCPCS code groups",
#            #yscale="log2",
#            ggtheme = theme_pubr()) +
#   theme(legend.position = "none")+
#   theme(axis.title.x = element_text(size =16))+
#   theme(axis.text=element_text(size=14, colour="black"))+
#   # scale_y_continuous(name="(a) Top 30 telehealth services% by HCPCS code groups",
#   #                    breaks= seq(0,30,by=5),
#   #                    limits=c(0, 30))+
#   theme(axis.title.y=element_blank())
# 
# p8a2
# 
# # log2 scaling of the y axis (with visually-equal spacing)
# library(scales)  
# 
# p8a2+  scale_y_continuous(trans=log2_trans(),
#                          #breaks = trans_breaks("log2", function(x) 2^x),
#   labels = scales::number_format(accuracy = 0.01,
#                                  decimal.mark = '.'))
# head(HCPCSgp$pct)
#   
# 
# 
# p8c2 <- ggdotchart(HCPCS, x = "HCPCS", y = "pct",
#                   shape = "year", color="year",
#                   position = position_dodge(1),
#                   sorting = "descending",                        
#                   add = "segments",  
#                   add.params = list(color = "lightgray", size = .5),
#                   dot.size = 1.5,  
#                   rotate=T,
#                   ylab = "(b) Top 30 telehealth services% by HCPCS codes",
#                   ggtheme = theme_pubr()) +
#   theme(legend.position = "top")+
#   theme(axis.title.x = element_text(size =16))+
#   theme(axis.text=element_text(size=14, colour="black"))+
#   # scale_y_continuous(name="Top 30 telehealth services% by HCPCS codes",
#   #                    breaks= seq(0,30,by=5),
#   #                    limits=c(0, 30))+
#   theme(axis.title.y=element_blank())
# 
# p8c2 <- 
#   p8c2 + geom_text(data=HCPCS, label=HCPCS$Hshort, y=20, color="black", size=3.3)+
#   scale_y_continuous(trans=log2_trans(),
#                           #breaks = trans_breaks("log2", function(x) 2^x),
#                           labels = scales::number_format(accuracy = 0.01,
#                                                          decimal.mark = '.'))
# 
# 
# tiff(filename="Fig_HCPCS_HCPCSgp.tiff",
#      res=300, compression='lzw',height=15, width=14, unit="in", pointsize=0.5)
# grid.arrange(p8a2, p8c2, ncol =1)
# dev.off()


#https://rstudio-pubs-static.s3.amazonaws.com/235467_5abd31ab564a43c9ae0f18cdd07eebe7.html
#https://egret.psychol.cam.ac.uk/statistics/R/graphs1.html
#https://rpubs.com/edwardhust/axis-breaks
#library(plotrix)
#http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/



# twogrp<-c(rnorm(10)+4,rnorm(10)+20)
# gap.barplot(twogrp,gap=c(8,16),xlab="Index",ytics=c(3,6,17,20),
#             ylab="Group values",main="Barplot with gap")
# gap.barplot(twogrp,gap=c(8,60),xlab="Index",ytics=c(0,3,7,61,80),
#             ylab="Group values",horiz=TRUE,main="Horizontal barplot with gap")


# twogrp <- HCPCSgp17[order(-HCPCSgp17$pct),]
# twogrp <- twogrp$pct
# gap.barplot(twogrp,gap=c(8,80),xlab="Index",ytics=c(0.001,1,4,8,80),
#             ylab="Group values",main="Barplot with gap")
# gap.barplot(twogrp,gap=c(5,75),xlab="Index",ytics=c(1,4,70,80),
#             ylab="Group values",horiz=TRUE,main="Horizontal barplot with gap")
