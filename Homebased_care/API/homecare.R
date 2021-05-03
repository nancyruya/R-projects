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




