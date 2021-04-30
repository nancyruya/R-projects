# install.packages("dplyr")
# install.packages("ggplot2")
# install.packages("usmap")
# install.packages("scales")
# install.packages("gridExtra")
# install.packages("RSocrata")
# install.packages("ggpubr")

library(usmap)
library(dplyr)
library(ggplot2)
library(grid)
library(gridExtra)
# library(RSocrata)

# read.socrata("https://data.cms.gov/resource/utc4-f9xp.json", app_token = NULL, email = NULL, password = NULL,
#              stringsAsFactors = FALSE)

setwd ("/Users/ruyazhang/downloads")
dat1 <- read.csv("MedicareAllTelehealth2017-1.csv")
dat2 <- read.csv("MedicareAllTelehealth2017-2.csv")
dat3 <- read.csv("MedicareAllTelehealth2017-3.csv")
dat4 <- read.csv("MedicareAllTelehealth2017-4.csv")

# names(dat1)
names(dat1) <- c("NPI","LastName","FirstName","MiddleInitial", "Credentials", 
                 "Gender", "EntityType", "StAddress1", "StAddress2", "City",
                 "Zip", "State", "Country", "ProviderType", "ParticiIndicator",
                 "Place", "HCPCS","H-Description", "H-Drug", "NumberServices",
                 "NumberMediBeneficiaries", "NumberDistMediBeneficiaryPerDay", 
                 "AveMediAllowedAmount", "AveMediChargeAmount"," AveMediPaymentAmount",
                 "AveMediStandardAmount")
names(dat2) <- c("NPI","LastName","FirstName","MiddleInitial", "Credentials", 
                 "Gender", "EntityType", "StAddress1", "StAddress2", "City",
                 "Zip", "State", "Country", "ProviderType", "ParticiIndicator",
                 "Place", "HCPCS","H-Description", "H-Drug", "NumberServices",
                 "NumberMediBeneficiaries", "NumberDistMediBeneficiaryPerDay", 
                 "AveMediAllowedAmount", "AveMediChargeAmount"," AveMediPaymentAmount",
                 "AveMediStandardAmount")
names(dat3) <- c("NPI","LastName","FirstName","MiddleInitial", "Credentials", 
                 "Gender", "EntityType", "StAddress1", "StAddress2", "City",
                 "Zip", "State", "Country", "ProviderType", "ParticiIndicator",
                 "Place", "HCPCS","H-Description", "H-Drug", "NumberServices",
                 "NumberMediBeneficiaries", "NumberDistMediBeneficiaryPerDay", 
                 "AveMediAllowedAmount", "AveMediChargeAmount"," AveMediPaymentAmount",
                 "AveMediStandardAmount")
names(dat4) <- c("NPI","LastName","FirstName","MiddleInitial", "Credentials", 
                 "Gender", "EntityType", "StAddress1", "StAddress2", "City",
                 "Zip", "State", "Country", "ProviderType", "ParticiIndicator",
                 "Place", "HCPCS","H-Description", "H-Drug", "NumberServices",
                 "NumberMediBeneficiaries", "NumberDistMediBeneficiaryPerDay", 
                 "AveMediAllowedAmount", "AveMediChargeAmount"," AveMediPaymentAmount",
                 "AveMediStandardAmount")

dat.17 <- rbind(dat1, dat2, dat3, dat4)
names(dat.17)

aggNumServices <- aggregate(NumberServices ~ State, dat.17, sum)
aggNumServices[order(aggNumServices$NumberServices),]

# Summary statistic (mean, standard deviation, median, Interquartile Range(25th and 75th percentile), min,max)
# summary(aggNumServices)

# read dataset from CMS for medicare benificiaries
setwd ("/Users/ruyazhang/downloads")
dat.FFS17 <- read.csv("StateCountyFFS2017.csv")

# State Total FFS population
stateBeneficiaries <- select(filter(dat.FFS17, County == "STATE TOTAL"), c(State, Beneficiaries) )
# print(stateBeneficiaries)
# merge is a function in dplyr package, this merge reduced from 55 states in telehealth data to 53 states from FFS
df <- merge(x=stateBeneficiaries, y=aggNumServices, by = "State")
# print(df)

#Culculation NumberServices/Beneficiaries and converted number to  numeric
df$ServicePerFFS <- df[,3]/as.numeric(as.character(df[,2]))
#print(df)

#write.csv(df, "stateAll.csv")
#setwd("/Users/ruyazhang/downloads")
#df <- read.csv("stateAll.csv")
#df <- df[,-1]
names(df) <- c("abbr","FFSpop","Service","ServicePerFFS")
df <- merge(statepop, df, by="abbr")
#df$ServicePerFFS <- df$ServicePerFFS *100
#print(df)

#Ploting for Service/FFS
#plot_usmap(data = df, values = "ServicePerFFS", color = "red") + 
#  scale_fill_continuous(name = "ServicePerFFS1k (2017)", 
#                        type = "viridis", 
#                        labels = paste(round(quantile(df$ServicePerFFS),2),
#                                       names(quantile(df$ServicePerFFS)), "")) + 
#  theme(legend.position = "right")

UniqueNPI <- summarize(group_by(dat.17, State), unique_NPI = n_distinct(NPI))
names(UniqueNPI) <- c("abbr","NumberOfProvider")
df <- merge(df, UniqueNPI, by="abbr")

# print(df)
# plot_usmap(data = df, values = "NumberOfProvider", color = "red") + 
#  scale_fill_continuous(name = "NumberOfProvider(2017)", type = "viridis", label = scales::comma) + 
#  theme(legend.position = "right")

df$ProviderPerFFS <- df[,8]/as.numeric(as.character(df[,5]))
df$ProviderPerFFS <- df$ProviderPerFFS *1000

#plot_usmap(data = df, values = "ProviderPerFFS", color = "red") + 
#  scale_fill_continuous(name = "ProviderPerFFS10k(2017)", type = "viridis", label = scales::comma) + 
#  theme(legend.position = "right")

df$ServicePerProvider <- df[,6]/as.numeric(as.character(df[,8]))

df$Year <- 2017

# summary(df$ServicePerFFS)
# sd(df$ServicePerFFS)

# Graph.1: Service/FFS
p1 <-
plot_usmap(data = df, values = "ServicePerFFS", color = "white") +
 scale_fill_continuous(name = "Services/FFS (2017)",
                       low="light blue",high="dark blue",
                       label = scales::comma) +
  theme(legend.position = "right")

plot_usmap(data = df, values = "ServicePerFFS", color = "red") +
  labs(title = "Serive Per Fee for Service", subtitle = "") +
  scale_fill_continuous(name = "Service Per 1000 FFS (2017)", type = "viridis", label = scales::comma) +
  theme(legend.position = "right")

# Graph.2: Provider/FFS
# df$ProviderPerFFS <- df$ProviderPerFFS /100
p2 <-
plot_usmap(data = df, values = "ProviderPerFFS", color = "white") +
 scale_fill_continuous(name = "Providers/1000 FFS (2017)", low="light green",high="dark green", label = scales::comma) +
 theme(legend.position = "right")

# Graph.3: Service/Provider
p3 <-
plot_usmap(data = df, values = "ServicePerProvider", color = "white") +
  scale_fill_continuous(name = "Services/Provider (2017)", low="pink",high="red", label = scales::comma) +
  theme(legend.position = "right")

grid.arrange(p1, p2, p3, ncol =1)




setwd ("/Users/ruyazhang/downloads")
dat5 <- read.csv("MedicareAllTelehealth2016-1.csv")
dat6 <- read.csv("MedicareAllTelehealth2016-2.csv")
dat7 <- read.csv("MedicareAllTelehealth2016-3.csv")
dat8 <- read.csv("MedicareAllTelehealth2016-4.csv")

names(dat5) <- c("NPI","LastName","FirstName","MiddleInitial", "Credentials", 
                 "Gender", "EntityType", "StAddress1", "StAddress2", "City",
                 "Zip", "State", "Country", "ProviderType", "ParticiIndicator",
                 "Place", "HCPCS","H-Description", "H-Drug", "NumberServices",
                 "NumberMediBeneficiaries", "NumberDistMediBeneficiaryPerDay", 
                 "AveMediAllowedAmount", "AveMediChargeAmount"," AveMediPaymentAmount",
                 "AveMediStandardAmount")
names(dat6) <- c("NPI","LastName","FirstName","MiddleInitial", "Credentials", 
                 "Gender", "EntityType", "StAddress1", "StAddress2", "City",
                 "Zip", "State", "Country", "ProviderType", "ParticiIndicator",
                 "Place", "HCPCS","H-Description", "H-Drug", "NumberServices",
                 "NumberMediBeneficiaries", "NumberDistMediBeneficiaryPerDay", 
                 "AveMediAllowedAmount", "AveMediChargeAmount"," AveMediPaymentAmount",
                 "AveMediStandardAmount")
names(dat7) <- c("NPI","LastName","FirstName","MiddleInitial", "Credentials", 
                 "Gender", "EntityType", "StAddress1", "StAddress2", "City",
                 "Zip", "State", "Country", "ProviderType", "ParticiIndicator",
                 "Place", "HCPCS","H-Description", "H-Drug", "NumberServices",
                 "NumberMediBeneficiaries", "NumberDistMediBeneficiaryPerDay", 
                 "AveMediAllowedAmount", "AveMediChargeAmount"," AveMediPaymentAmount",
                 "AveMediStandardAmount")
names(dat8) <- c("NPI","LastName","FirstName","MiddleInitial", "Credentials", 
                 "Gender", "EntityType", "StAddress1", "StAddress2", "City",
                 "Zip", "State", "Country", "ProviderType", "ParticiIndicator",
                 "Place", "HCPCS","H-Description", "H-Drug", "NumberServices",
                 "NumberMediBeneficiaries", "NumberDistMediBeneficiaryPerDay", 
                 "AveMediAllowedAmount", "AveMediChargeAmount"," AveMediPaymentAmount",
                 "AveMediStandardAmount")

dat.16 <- rbind(dat5, dat6, dat7, dat8)
names(dat.16)


aggNumServices <- aggregate(NumberServices ~ State, dat.16, sum)
aggNumServices[order(aggNumServices$NumberServices),]

# summary(dat1$NumberServices)
# summary(dat3$NumberServices)
#Summary statistic (mean, standard deviation, median, Interquartile Range(25th and 75th percentile), min,max)
#summary(aggNumServices)

#read dataset from CMS for medicare benificiaries
setwd ("/Users/ruyazhang/downloads")
dat.FFS16 <- read.csv("StateCountyFFS2016.csv")

# State Total FFS population
stateBeneficiaries <- select(filter(dat.FFS16, County == "STATE TOTAL"), c(State, Beneficiaries) )

#merge is a function in dplyr package, this merge reduced from 55 states in telehealth data to 53 states from FFS
df2 <- merge(x=stateBeneficiaries, y=aggNumServices, by = "State")

#Culculation NumberServices/Beneficiaries and converted number to  numeric
df2$ServicePerFFS <- df2[,3]/as.numeric(as.character(df2[,2]))

#df2 <- df[,-1]
names(df2) <- c("abbr","FFSpop","Service","ServicePerFFS")
df2 <- merge(statepop, df2, by="abbr")
#df2$ServicePerFFS <- df$ServicePerFFS *100
#print(df2)

#Ploting for Service/FFS
#plot_usmap(data = df2, values = "ServicePerFFS", color = "red") + 
#  scale_fill_continuous(name = "ServicePerFFS1k (2016)", 
#                        type = "viridis", 
#                        labels = paste(round(quantile(df$ServicePerFFS),2),
#                                       names(quantile(df$ServicePerFFS)), "")) + 
#  theme(legend.position = "right")

UniqueNPI <- summarize(group_by(dat.16, State), unique_NPI = n_distinct(NPI))
names(UniqueNPI) <- c("abbr","NumberOfProvider")
df2 <- merge(df2, UniqueNPI, by="abbr")

#plot_usmap(data = df2, values = "NumberOfProvider", color = "red") + 
#  scale_fill_continuous(name = "NumberOfProvider(2016)", type = "viridis", label = scales::comma) + 
#  theme(legend.position = "right")

df2$ProviderPerFFS <- df2[,8]/as.numeric(as.character(df2[,5]))
df2$ProviderPerFFS <- df2$ProviderPerFFS *1000

#plot_usmap(data = df2, values = "ProviderPerFFS", color = "red") + 
#  scale_fill_continuous(name = "ProviderPerFFS10k(2016)", type = "viridis", label = scales::comma) + 
#  theme(legend.position = "right")

df2$ServicePerProvider <- df2[,6]/as.numeric(as.character(df[,8]))

df2$Year <- 2016


dfAll <- rbind(df, df2)



# Graph.1: Provider/FFS
plot_usmap(data = dfAll, values = "ProviderPerFFS", color = "red") +   
  labs(title = "US Counties", subtitle = "Number Of Provider/FFS") +
  scale_fill_continuous(name = "", type = "viridis", label = scales::comma) + 
  theme(legend.position = "right") +
  facet_wrap(~Year)

plot_usmap(data = dfAll, values = "ProviderPerFFS", color = "red") + 
  scale_fill_continuous(name = "ProviderPerFFS", 
                        type = "viridis") + 
  theme(legend.position = "right") +
  facet_wrap(~Year)

#Ploting for Service/FFS
plot_usmap(data = dfAll, values = "ServicePerFFS", color = "red") + 
  scale_fill_continuous(name = "ServicePerFFS", 
                        type = "viridis") + 
  theme(legend.position = "right") +
  facet_wrap(~Year)

# Graph.3: Service/Provider
plot_usmap(data = dfAll, values = "ServicePerProvider", color = "red") + 
  scale_fill_continuous(name = "ServicePerProvider", type = "viridis", label = scales::comma) + 
  theme(legend.position = "right") +
  facet_wrap(~Year)

#gridExtra package
#grid.arrange(ProviderPerFFS, NumberOfProvider, ncol = 2)

# dfAllw <- cbind(df, df2)
# diff <- df$Service - df2$Service

# head(dfAll)
# head(df2)

sd(df$ServicePerFFS)

summary(df2$Service)
sd(df2$Service)
summary(df$Service)
sd(df$Service)
diffService <- df[,6]-df2[,6]
# df2$diffService <- df[,6]-df2[,6]
summary(diffService)
sd(diffService)

df2$FFSpop <- as.numeric(as.character(df2$FFSpop))
summary(df2$FFSpop)
sd(df2$FFSpop)
df$FFSpop <- as.numeric(as.character(df$FFSpop))
summary(df$FFSpop)
sd(df$FFSpop)
diffFFSPerState <- df[,5]-df2[,5]
# df2$diffFFSPerState <- as.numeric(as.character(df$FFSpop))-as.numeric(as.character(df2$FFSpop))
summary(diffFFSPerState)
sd(diffFFSPerState)

summary(df2$ServicePerFFS)
sd(df2$ServicePerFFS)
summary(df$ServicePerFFS)
sd(df$ServicePerFFS)
diffServicePerFFS <- df$ServicePerFFS - df2$ServicePerFFS
# df2$diffServicePerFFS <- df$ServicePerFFS - df2$ServicePerFFS
summary(diffServicePerFFS)
sd(diffServicePerFFS)

summary(df2$NumberOfProvider)
sd(df2$NumberOfProvider)
summary(df$NumberOfProvider)
sd(df$NumberOfProvider)
diffProviderPerState <- df[,8]-df2[,8]
# df2$diffProviderPerState<- df[,8]-df2[,8]
summary(diffProviderPerState)
sd(diffProviderPerState)

summary(df2$ProviderPerFFS)
sd(df2$ProviderPerFFS)
summary(df$ProviderPerFFS)
sd(df$ProviderPerFFS)
diffProviderPerFFS <- df$ProviderPerFFS - df2$ProviderPerFFS
summary(diffProviderPerFFS)
sd(diffProviderPerFFS)

summary(df2$ServicePerProvider)
sd(df2$ServicePerProvider)
summary(df$ServicePerProvider)
sd(df$ServicePerProvider)
diffServicePerProvider <- df$ServicePerProvider - df2$ServicePerProvider
summary(diffServicePerProvider)
sd(diffServicePerProvider)



df2$diffServicePerFFS <- df$ServicePerFFS - df2$ServicePerFFS
df2$diffServicePerFFS <- df2$diffServicePerFFS * 1000
summary(df2$diffServicePerFFS)
sd(df2$diffServicePerFFS)
# Graph.1: Service/FFS blue
p4 <-
  plot_usmap(data = df2, values  = "diffServicePerFFS", color = "dark gray") +
  scale_fill_gradientn(name    = "Services/1000 FFS (2017-2016)", 
                       colours = c("purple", "white", "orange"),
                       breaks  = c(-750, -500, -250, 0, 250),
                       label   = scales::comma) +
  theme(legend.position = "right")

plot_usmap(data = df2, values = "diffServicePerFFS", color = "white") +
  scale_fill_continuous(name = "Service Per 1000 FFS (2017-2016)",
                        low="light blue",high="dark blue", label = scales::comma) +
  theme(legend.position = "right")


plot_usmap(data = df, values = "diffServicePerFFS", color = "red") +
  labs(title = "Serive Per Fee for Service", subtitle = "") +
  scale_fill_continuous(name = "ServicePerFFS (2017)", type = "viridis", label = scales::comma) +
  theme(legend.position = "right")

df2$diffProviderPerFFS <- df$ProviderPerFFS - df2$ProviderPerFFS
# Graph.2: Provider/FFS green
# df$ProviderPerFFS <- df$ProviderPerFFS /100
p5 <-
  plot_usmap(data = df2, values  = "diffProviderPerFFS", color = "dark gray") +
  scale_fill_gradientn(name    = "Providers/1000 FFS(2017-2016)", 
                       colours = c("purple", "white", "orange"),
                       breaks  = c(-0.2, 0, 0.2, 0.4),
                       label   = scales::comma) +
  theme(legend.position = "right")

plot_usmap(data = df2, values = "diffProviderPerFFS", color = "white") +
  scale_fill_continuous(name = "Provider Per 1000 FFS (2017-2016)", low="light green",high="dark green", label = scales::comma) +
  theme(legend.position = "right")


df2$diffServicePerProvider <- df$ServicePerProvider - df2$ServicePerProvider
# Graph.3: Service/Provider red
p6 <-
  plot_usmap(data = df2, values  = "diffServicePerProvider", color = "dark gray") +
  scale_fill_gradientn(name    = "Services/Provider (2017-2016)", 
                       colours = c("purple", "white", "orange"),
                       breaks  = c(-75, -50, -25, 0, 25),
                       label   = scales::comma) +
  theme(legend.position = "right")
  
plot_usmap(data = df2, values = "diffServicePerProvider", color = "white") +
  scale_fill_continuous(name = "Service Per Provider (2017-2016)", low="pink",high="red", label = scales::comma) +
  theme(legend.position = "right")

grid.arrange(p4, p5, p6, ncol =1)

--------------
library(ggplot2)
library(ggpubr)

library(usmap)
library(dplyr)
library(ggplot2)
library(grid)
library(gridExtra)

# aggPT <- aggregate(NPI ~ ProviderType, dat.16, sum)
# aggPT[order(aggPT$unique_PT17),]
# print(aggPT)

UniquePT17 <- summarize(group_by(dat.17, ProviderType), unique_PT = sum(NumberServices))
# sum(UniquePT17[,2])
# UniquePT17[order(UniquePT17$unique_PT17),]
UniquePT17$year <- 2017
UniquePT16 <- summarize(group_by(dat.16, ProviderType), unique_PT = sum(NumberServices))
UniquePT16$year <- 2016
sum(dat.16[,20])
sum(dat.17[,20])
PTmerge <- merge(UniquePT17, UniquePT16, by="ProviderType", all = TRUE)

UniquePT17$frequency <- UniquePT17$unique_PT/sum(dat.17[,20])*100
UniquePT16$frequency <- UniquePT16$unique_PT/sum(dat.16[,20])*100
# sum(UniquePT16[,2])

PTstack <- rbind(UniquePT17, UniquePT16)

#foo <- (dfPT, header=T)
PTstack$type <- ifelse(PTstack$HCPCS=="G0296","SDMC","LDCT")
PTstack$Group <- paste(PTstack$year, foo$type)
PTstack$Year <- as.factor(PTstack$year)

fooA <- subset(foo, foo$Percent>=5)

#library("ggpubr")
p1 <- ggbarplot(fooA, "PrvType", "Percent", fill="Year", palette="npg", na.rm=T,
                order=c("Pulmonary Disease",
                        "Clinical nurse specialist",
                        "Family Practice",
                        "Physician Assistant",
                        "Internal Medicine",
                        "Diagnostic Radiology"),
                position = position_dodge(0.8),
                legend.title = "Year", font.legend = c(8))+
  coord_flip()+
  xlab("Provider Specialty")+  ylab("Proportion(%)")+
  theme(axis.title=element_text(size=13, face="bold", colour="black"))+
  theme(axis.text=element_text(size=12,face="bold", colour="black"))+
  theme(legend.justification=c(0.5,0.5),legend.position =c(0.88,0.88),
        legend.text = element_text(size=10, face="bold"),
        legend.title = element_text(size=12, face="bold"))+
  facet_wrap(~type)+
  theme(strip.text = element_text(size=13,face="bold"))


##save the plot##
tiff(filename="Fig1_prvBar.tiff",res=300,
     compression='lzw',height=6, width=9, unit="in", pointsize=0.5)
p1
dev.off()
##save the plot##

------
library(rgdal)
library(spdep)

#library(rgdal) for importing shape file
#shape file is from the Census
#https://www.census.gov/geographies/mapping-files/time-series/geo/carto-boundary-file.html
setwd ("/Users/ruyazhang/downloads/cb_2017_us_state_500k")
mnb <- readOGR("cb_2017_us_state_500k.shp")
mnb <- subset(mnb,!(mnb$STUSPS %in% c("AK","HI","AS","GU","MP","PR","VI")))
#import data file
dat0 <- df
dat0 <- subset(dat0, !(dat0$abbr %in% c("AK","HI")))
#add varXs in to the spatial frame for contiguous US only
mnb.df <- merge(mnb, dat0, by.x="STUSPS",by.y="abbr", all.x=T)

#construct neighbors List
mnb1 <- poly2nb(mnb.df)
#generate spatial Weights; can change style to others, B,C,S..
mnb2 <- nb2listw(mnb1, style="W", zero.policy=TRUE)
#visualize neighbors
plot(mnb2,coords=coordinates(mnb),pch=19, cex=0.1, col="gray")

#test global Moran for varX=total population
moran.test(mnb.df$MFtot, listw=mnb2, zero.policy=T)
#could also do a Permutation test
moran.mc(mnb.df$MFtot, mnb2, nsim=999)

##In the above example, total population across the 49 states (48+DC) did not show autocorrelation, p=0.3857 or p=0.346.




