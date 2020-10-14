#Dashboard Usage Association Rule Mining -- Market Basket Analysis

library(tidyverse)
library(readxl)
library(knitr)
library(ggplot2)
library(lubridate)
library(arules)
library(arulesViz)
library(plyr)
library (AMR)
library(dplyr)

iTwo_usage_data <- read.csv("Dashboards_hits_data_Raw.csv", header = TRUE)

iTwo_usage_data <- iTwo_usage_data[complete.cases(iTwo_usage_data), ] #All rows are complete- no missing values

#date from factor to date
iTwo_usage_data$Date <-as.POSIXct(iTwo_usage_data$Date, format = "%m/%d/%Y")

#remove cases with landing pages
iTwo_usage_data<-iTwo_usage_data[!(iTwo_usage_data$Category=="Landing Page"),]

#remove unnecessary columns: name column
iTwo_usage_data <- iTwo_usage_data[, -4]

#remove commas from dashboard names 
iTwo_usage_data$Dashboard.Page <- as.factor(gsub(",","",iTwo_usage_data$Dashboard.Page))

#closer look at data...
str(iTwo_usage_data)
glimpse(iTwo_usage_data)

####Descriptive statistics and initial data exploration####

iTwo_usage_data %>% summarize(n_distinct(Campus.ID))#158 distinct users
nrow(iTwo_usage_data)

iTwo_usage_data <- distinct(iTwo_usage_data)  #no dups
iTwo_usage_data %>% summarize(n_distinct(Department)) #23 departments
iTwo_usage_data %>% summarize(n_distinct(Dashboard.Page)) #94 dashboard pages
iTwo_usage_data %>% summarize(n_distinct(Category)) #5 dashboard categories

####Analysis for all individual-level use of dashboard####

#remove OAR department
iTwo_usage_data_noOAR<-iTwo_usage_data[!(iTwo_usage_data$Department=="Analytics & Reporting"),]

#Convert to transaction data from atomic form - unique 'Customer ID' ('Campus.ID') per record - 
    #items that are used together by one ID on the same day are in one unique tuple

#group by 'Campus.ID' and 'Date' per tuple, separated by comma
transaction_usage_data <- ddply(iTwo_usage_data_noOAR, c("Campus.ID", "Date"), function(df1)paste(df1$Dashboard.Page, collapse = ","))
glimpse(transaction_usage_data)

#remove unnecessary columns 
transaction_usage_data <- transaction_usage_data[, c("V1")]
as.data.frame(transaction_usage_data)
str(transaction_usage_data)

write.csv(transaction_usage_data, "C:/Users/ear5131/Liz-- Other Docs/ERS R_Code Repository/NoOAR_Transactions.csv", 
          row.names = FALSE, quote = FALSE)

tr_individuals <- read.transactions("C:/Users/ear5131/Liz-- Other Docs/ERS R_Code Repository/NoOAR_Transactions.csv", 
                                    format = 'basket', sep = ',')
tr_individuals
summary(tr_individuals)

# Create an item frequency plot for the top 20 items
    if(!require("RColorBrewer")){
        install.packages("RColorBrewer")
        library(RColorBrewer)
    }
itemFrequencyPlot(tr_individuals,topN=15,type="relative",col=brewer.pal(8,'Pastel2'), main="Relative Item Frequency Plot")

#generating rules with Apriori method-- confined threshold
association.rules <- apriori(tr_individuals, parameter = list(supp=0.005, conf=0.5, minlen = 2, maxlen=5, target="rules"))
summary(association.rules)

library(arulesViz)
subRules<-association.rules[quality(association.rules)$lift>1.0]
inspect(subRules)

#Plot SubRules
plotly_arules(subRules) #interactive plot
plot(subRules, method = "graph",  engine = "htmlwidget")
plot(subRules, method="paracoord")

#write rules
as(association.rules, "data.frame")
write(association.rules,
      file = "association_rules.csv",
      sep = ",",
      quote = TRUE,
      row.names = FALSE)

#### Analysis for specific unit ####

#keep only unit data
iTwo_usage_data_PPM<-iTwo_usage_data[(iTwo_usage_data$Department=="PP&M"),]

#Convert to transaction data from atomic form - unique 'Customer ID' ('Campus.ID') per record - 
#items that are used together by one ID on the same day are in one unique tuple

#group by 'Campus.ID' and 'Date' per tuple, separated by comma
transaction_usage_data <- ddply(iTwo_usage_data_PPM, c("Campus.ID", "Date"), function(df1)paste(df1$Dashboard.Page, collapse = ","))
glimpse(transaction_usage_data)

#remove unnecessary columns 
transaction_usage_data <- transaction_usage_data[, c("V1")]
as.data.frame(transaction_usage_data)
str(transaction_usage_data)

write.csv(transaction_usage_data, "C:/Users/ear5131/Liz-- Other Docs/ERS R_Code Repository/PPM_Transactions.csv", 
          row.names = FALSE, quote = FALSE)

tr_individuals <- read.transactions("C:/Users/ear5131/Liz-- Other Docs/ERS R_Code Repository/PPM_Transactions.csv", 
                                    format = 'basket', sep = ',')
tr_individuals
summary(tr_individuals)

# Create an item frequency plot for the top 10 items
if(!require("RColorBrewer")){
    install.packages("RColorBrewer")
    library(RColorBrewer)
}

itemFrequencyPlot(tr_individuals,topN=10, type="relative",col=brewer.pal(8,'Pastel2'), main="Relative Item Frequency Plot")

#generating rules with Apriori method-- confined threshold
association.rules <- apriori(tr_individuals, parameter = list(supp=0.005, conf=0.5, minlen = 2, maxlen=5, target="rules"))
summary(association.rules)

library(arulesViz)
subRules<-association.rules[quality(association.rules)$lift>1.0]
inspect(subRules)

#Plot SubRules
plot(subRules, method = "graph",  engine = "htmlwidget")
plot(subRules, method="paracoord")

#write rules
as(subRules, "data.frame")
write(subRules,
      file = "association_rules.csv",
      sep = ",",
      quote = TRUE,
      row.names = FALSE)

########################################################################
#Analysis for Marketing Strategy and Brand only

#keep only MSB data
iTwo_usage_data_MSB<-iTwo_usage_data[(iTwo_usage_data$Department=="Marketing Strategy and Brand"),]

#Convert to transaction data from atomic form - unique 'Customer ID' ('Campus.ID') per record - 
#items that are used together by one ID on the same day are in one unique tuple

library(plyr)
library(dplyr)

#group by 'Campus.ID' and 'Date' per tuple, separated by comma
transaction_usage_data <- ddply(iTwo_usage_data_MSB, c("Campus.ID", "Date"), function(df1)paste(df1$Dashboard.Page, collapse = ","))
glimpse(transaction_usage_data)

#remove unnecessary columns 
transaction_usage_data <- transaction_usage_data[, c("V1")]
as.data.frame(transaction_usage_data)
str(transaction_usage_data)

write.csv(transaction_usage_data, "C:/Users/ear5131/Liz-- Other Docs/ERS R_Code Repository/MSB_Transactions.csv", 
          row.names = FALSE, quote = FALSE)

library(arules)
tr_individuals <- read.transactions("C:/Users/ear5131/Liz-- Other Docs/ERS R_Code Repository/MSB_Transactions.csv", 
                                    format = 'basket', sep = ',')
tr_individuals
summary(tr_individuals)

# Create an item frequency plot for the top 10 items
if(!require("RColorBrewer")){
    install.packages("RColorBrewer")
    library(RColorBrewer)
}

itemFrequencyPlot(tr_individuals,topN=10, type="relative",col=brewer.pal(8,'Pastel2'), main="Relative Item Frequency Plot")

#generating rules with Apriori method-- confined threshold
association.rules <- apriori(tr_individuals, parameter = list(supp=0.005, conf=0.5, minlen = 2, maxlen=5, target="rules"))
summary(association.rules)

subRules<-association.rules[quality(association.rules)$lift>1.0]
inspect(subRules)

#Plot SubRules
plot(subRules, method = "graph",  engine = "htmlwidget")
plot(subRules, method="paracoord")

#write rules
as(subRules, "data.frame")
write(subRules,
      file = "association_rules.csv",
      sep = ",",
      quote = TRUE,
      row.names = FALSE)

#####General Information####

#top 100 rules by confidence, support and lift> 1
top100subRules <- head(subRules, n = 100, by = c("confidence", "lift"))
inspect(top100subRules)
#top 20 rules by confidence
top20subRules <- head(top100subRules, n = 20, by = c("support", "confidence", "lift"))
inspect(top20subRules)
plot(top20subRules, method = "grouped")

#Note - if experiencing issues with frequency plot run: 
dev.off()