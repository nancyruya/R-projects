install.packages("usmap")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("summarytools")
install.packages("gridExtra")

library(usmap)
library(dplyr)
library(ggplot2)
library(summarytools)
library(grid)
library(gridExtra)
library("ggpubr")

getwd()
setwd ("/Users/ruyazhang/downloads")

dat0a <- read.csv("homebase.csv")
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

eHNPItype18 <- as.data.frame(aggregate(NumberServices ~ ProviderType, dat0a, sum))
eHNPItype18$year <- "2018"

HCPCS18 <- as.data.frame(aggregate(NumberServices ~ HCPCS, dat0a, sum))
HCPCS18$year <- "2018"

HCPCStxt18 <- as.data.frame(aggregate(NumberServices ~ HDescription, dat0a, sum))
HCPCStxt18$year <- "2018"

dat0a$HCPCS3 <- ifelse(substr(dat0a$HCPCS,1,1)=="G", 
                       substr(dat0a$HCPCS,1,4), substr(dat0a$HCPCS,1,3))
head(dat0a$HCPCS3)
tail(dat0a$HCPCS3)
length(unique(dat0a$HCPCS3))
HCPCS318 <- as.data.frame(aggregate(NumberServices ~ HCPCS3, dat0a, sum))
HCPCS318$year <- "2018"

dat0a$HCPCSgp <- ifelse(dat0a$HCPCS3 %in% c("908"), "Psych related services",
                        ifelse(dat0a$HCPCS3 %in% c("110"), "Paring or cutting of benign hyperkeratotic lesion",
                               ifelse(dat0a$HCPCS %in% c("11719"), "Trimming of nondystrophic nails",
                                      ifelse(dat0a$HCPCS %in% c("99341","99342","99343","99344", "99345"), "New patient home visit",
                                             ifelse(dat0a$HCPCS %in% c("99347","99348","99349","99350"), "Established patient home visit",
                                                    ifelse(dat0a$HCPCS %in% c("99324","99325", "99326", "99327", "99328"), "New Patient domiciliary, rest home, or custodial care visit",
                                                           ifelse(dat0a$HCPCS %in% c("99334","99335", "99336", "99337"), "Established patient domiciliary, rest home, or custodial care visit",
                                                                  ifelse(dat0a$HCPCS %in% c("11720","11721"), "Debridement of nails",
                                                                         ifelse(dat0a$HCPCS3 %in% c("G012"), "Trimming of dystrophic nails", "Telehealt con ccare"                 
                                                                                                     )))))))))
head(dat0a$HCPCSgp)
tail(dat0a$HCPCSgp)
length(unique(dat0a$HCPCSgp))
HCPCSgp18 <- as.data.frame(aggregate(NumberServices ~ HCPCSgp, dat0a, sum))
HCPCSgp18$year <- "2018"


