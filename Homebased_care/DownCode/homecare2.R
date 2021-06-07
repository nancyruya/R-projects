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
dat0a <- dat0a[, -1] 
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
                ifelse(dat0a$HCPCS %in% c("11719", "11720", "11721", "G0127"), "Nails care",
                ifelse(dat0a$HCPCS %in% c("99341","99342","99343","99344", "99345"), "New patient home visit",
                ifelse(dat0a$HCPCS %in% c("99347","99348","99349","99350"), "Established patient home visit",
                ifelse(dat0a$HCPCS %in% c("99324","99325", "99326", "99327", "99328"), "New Patient domiciliary, rest home, or custodial care visit",
                ifelse(dat0a$HCPCS %in% c("99334","99335", "99336", "99337"), "Established patient domiciliary, rest home, or custodial care visit", "none"                 
                                                                                                     )))))))
table(dat0a$HCPCSgp)

check <- subset(dat0a, dat0a$HCPCSgp=="none")
head(check)

head(dat0a$HCPCSgp)
tail(dat0a$HCPCSgp)
length(unique(dat0a$HCPCSgp))
HCPCSgp18 <- as.data.frame(aggregate(NumberServices ~ HCPCSgp, dat0a, sum))
HCPCSgp18$year <- "2018"

############################
# read dataset from CMS for medicare benificiaries
dat0b <- read.csv("StateOver65FFS2018.csv")
names(dat0b) <- c("State","FIPS","FFS")
# table(dat0b$State)
# dat0b <- dat0b[-1, ] #first line is for National
dat0b <- subset(dat0b, is.na(dat0b$FIPS)==F) 
dat0b$FFS <- as.numeric(as.character(dat0b$FFS))
# State Total FFS population
#FFSstate <- select(filter(dat0b, County == "STATE TOTAL"), c(State, FFS) )
# gsub the State: remove value in parenthesis
dat0b$State <- gsub('\\([^()]*\\)','',dat0b$State)
dat0b$State <- gsub("[[:space:]]", "", dat0b$State)
# merge is a function in dplyr package, this merge reduced from 55 states in telehealth data to 53 states from FFS
df <- merge(dat0b, eHNPIstate, by = "State", all=TRUE)
#statepop is from "usmap" 
#library(usmap)
##reduce to the 51 states
df <- merge(statepop, df, by.x="abbr",by.y="State")

df18 <- df
df18$year <- "2018"

plot_usmap(data = df18, values = "NumberServices", color = "red") + 
  scale_fill_continuous(name = "Homebase Care Services (2018)", 
                        type = "viridis", label = scales::comma) + 
  theme(legend.position = "right")

####################
df18$eHperFFS <- round(df$NumberServices/df$FFS,2)
df18$eHperNPI <- round(df$NumberServices/df$unique_NPI,2)
df18$NPIperFFS <- round((df$unique_NPI/df$FFS) *1000,2)

p1 <-
plot_usmap(data = df18, values = "eHperFFS", color = "white") +
  scale_fill_continuous(name = "(a) Services/FFS, 2018",
                        low="light blue",high="dark blue", label = scales::comma) +
  theme(legend.position = "right")+
  theme(plot.margin = unit(c(0,0,0,0), "cm"))

p2 <-
  plot_usmap(data = df18, values = "eHperNPI", color = "white") +
  scale_fill_continuous(name = "(b) Services/Provider, 2018", 
                        low="pink",high="red", label = scales::comma) +
  theme(legend.position = "right")+
  theme(plot.margin = unit(c(0,0,0,0), "cm"))

p3 <-
  plot_usmap(data = df18, values = "NPIperFFS", color = "white") +
  scale_fill_continuous(name = "(c) Providers/1000 FFS, 2018", 
                        low="light green",high="dark green", label = scales::comma) +
  theme(legend.position = "right")+
  theme(plot.margin = unit(c(0,0,0,0), "cm"))

grid.arrange(p1, p2, p3, ncol =1)

##### county level
dat0a = n_distinct(dat0a$NPI, dat0a$StAddress1,dat0a$StAddress2,dat0a$City, dat0a$Zip, dat0a$State, dat0a$Country)
#uniquenpi <- summarize(group_by(dat0a, NPI), unique_StAddress1 = n_distinct(StAddress1))

unique <- dat0a %>% distinct(NPI, StAddress1, StAddress2, City, Zip, State, Country)
count(unique)

##### unique(NPI, address1, city, zip, state); column (A, H, I, J, K, L, M)
##### column (A, H, I, J, K, L, M)
# unique variable combinations in R

# https://www.census.gov/programs-surveys/geography/technical-documentation/complete-technical-documentation/census-geocoder.html
# upload unique date and dr. liu do geograph


##### 
reduce hcpcs code and redo
