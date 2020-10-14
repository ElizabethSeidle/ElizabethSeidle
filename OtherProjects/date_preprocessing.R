#Usage Data preprocessing

#####Dashboard overall daily hits####
#read in raw data
i2_hits_data <- read.csv("Dashboard_hits_data_Raw.csv", header = T) 
i2_hits_data

#parse out time intervals
library(tidyr)
i2_hits_data <- i2_hits_data %>% separate(Date, c("month", "day", "year"), sep = "/", remove = FALSE)
head(i2_hits_data)
summary(i2_hits_data)

#Create new unique month variable identifier
library(zoo)
i2_hits_data$Year_Month <- as.factor(paste(as.character(i2_hits_data$year), as.character(i2_hits_data$month), sep="-"))

#Create unique week variable
str(i2_hits_data)
i2_hits_data$Date <- as.Date(i2_hits_data$Date, format = "%m/%d/%Y") #recoding Date variable type
i2_hits_data$week_num <- strftime(i2_hits_data$Date, format = "%V")
i2_hits_data$unique_week <- as.factor(paste(as.character(i2_hits_data$year), i2_hits_data$week_num, sep = "-", collapse = NULL))

#export processed data to csv
write.csv(i2_hits_data, "User_Daily_Processed.csv")

#####Dashboard daily hits####

#read in raw data
DashB_hits_data <- read.csv("Dashboards_hits_data_Raw.csv", header = T) 
DashB_hits_data

#parse out time intervals
library(tidyr)
DashB_hits_data <- DashB_hits_data %>% separate(Date, c("month", "day", "year"), sep = "/", remove = FALSE)
head(DashB_hits_data)
summary(DashB_hits_data)

#Create new unique month variable identifier
library(zoo)
DashB_hits_data$Year_Month <- as.factor(paste(as.character(DashB_hits_data$year), as.character(DashB_hits_data$month), sep="-"))

#Create unique week variable
str(DashB_hits_data)
DashB_hits_data$Date <- as.Date(DashB_hits_data$Date, format = "%m/%d/%Y") #recoding Date variable type
DashB_hits_data$week_num <- strftime(DashB_hits_data$Date, format = "%V")
DashB_hits_data$unique_week <- as.factor(paste(as.character(DashB_hits_data$year), DashB_hits_data$week_num, sep = "-", collapse = NULL))

#export processed data to csv
write.csv(DashB_hits_data, "User_Daily_Dashboards_Processed.csv")

