#' ---
#' title: "Data Processing"
#' output: html_document
#' ---

#' this script contains code for restructuring the data as it currently
#' exists in the excel file we received last week. 

#' ### Data directory 
#' This is configured locally in order to avoid putting data
#' on github:
data_dir <- "C:/Users/Warner/Desktop/Big Deal/Pivot Health/"

#' ### Load packages and read data
library(tidyverse)
library(readxl)


#' State file for use later
states <- read_csv("states.csv")

#' ### **Extract data from STM Web Sales Summary Tab**
### Web data needs reformatting to be a dataframe
# web sales data sheet
web <- read_excel(paste0(data_dir,
                         "2017 Sales Summary.xlsx"),
                  sheet = "STM Web Sales Summary",
                  col_names = F)

#' Web data should be split to 2 tables:
#' Daily site activity and daily websales by state
web[is.na(web)] <- 0
names(web) <- web[2,] %>% unlist
names(web)[names(web)=="0"] <- unlist(web[1,])[names(web)=="0"]

web <- web[-(1:2),]

web <- web %>% select(-TOTALS, -`0`, -TOTAL)

#' Date column needs to be cleaned up
web$Date <- as.numeric(web$Date)
web <- web[!is.na(web$Date),]

web$Date <- as.Date(web$Date,
                     origin = "1899-12-30")


#' **Create website table by year**
state_cols <- names(web)[(names(web) %in% states$Abbreviation)]

web_state <- web %>% 
             select_(.dots = c("Date",state_cols))

#' Table before melt
glimpse(web_state)

#' gather/melt to long format
web_state <- web_state %>%
             gather_(key = "State",
                     value = "Sales",
                     state_cols)

#' Table after melt
glimpse(web_state)

#' Final touches to web states data
web_state$Sales <- as.numeric(web_state$Sales)
web_state <- web_state %>%
             filter(Sales != 0) %>%
             mutate(Tab = "web") %>%# new col
             arrange(Date) #sort 
  

#' **Create table for plan by year**
#' 
#' To mitigate dplyr select issue
names(web) <- gsub("4 x 3", "Yearly", names(web))

plan_cols <- names(web)[!(names(web) %in% state_cols)]


web_plans <- web[plan_cols]

#' create web_traffic table
web_traffic <- web_plans[10:16]

#' Web sales table
web_plans <- web_plans[1:9]
  
web_plans[-1] <- map(web_plans[-1], as.numeric)
     
#' Table before melt
glimpse(web_plans)

#' Melt/gather
plan_cols2 <- names(web_plans)[names(web_plans) != "Date"]
web_plans <- web_plans %>%
             gather_(key = "Plan",
                     value = "Sales",
                     plan_cols2)

#' table after melt
glimpse(web_plans)

#' Final touches to web states data
web_plans <-  web_plans %>%
              filter(Sales != 0) %>%
              mutate(Tab = "web") %>%# new col
              arrange(Date) #sort 


#' **Plan duration column - a flag for yearly or 90 day
web_plans$Duration <- ifelse(grepl("Yearly", web_plans$Plan),
                             "Yearly", "90 Day")

#' ----------------------------------------------

#' ### **Extract data from Adroit sales tab *** 
adroit <- read_excel(paste0(data_dir,
                     "2017 Sales Summary.xlsx"),
                     sheet = "Adroit Sales Summary",
                     col_names = F)

adroit[is.na(adroit)] <- 0
names(adroit) <- adroit[2,] %>% unlist
names(adroit)[names(adroit)=="0"] <- unlist(adroit[1,])[names(adroit)=="0"]

adroit <- adroit[-(1:2),]

names(adroit)[duplicated(names(adroit))] <- 
  paste(names(adroit)[duplicated(names(adroit))], "Yearly")

adroit <- adroit %>% select(-TOTALS, -TOTAL)


#' Date column needs to be cleaned up
adroit$Date <- as.numeric(adroit$Date)
adroit <- adroit[!is.na(adroit$Date),]

adroit$Date <- as.Date(adroit$Date,
                    origin = "1899-12-30")


#' **Create adroitsite table by year**
state_cols <- names(adroit)[(names(adroit) %in% states$Abbreviation)]

adroit_state <- adroit %>% 
  select_(.dots = c("Date",state_cols))

#' Table before melt
glimpse(adroit_state)

#' gather/melt to long format
adroit_state <- adroit_state %>%
                gather_(key = "State",
                value = "Sales",
                state_cols)

#' Table after melt
glimpse(adroit_state)

#' Final touches to adroit states data
adroit_state$Sales <- as.numeric(adroit_state$Sales)
adroit_state <- adroit_state %>%
                filter(Sales != 0) %>%
                mutate(Tab = "adroit") %>%# new col
                arrange(Date) #sort 


#' **Create table for plan by year**
#' 
#' To mitigate dplyr select issue
names(adroit) <- gsub("4 x 3", "Yearly", names(adroit))

plan_cols <- names(adroit)[!(names(adroit) %in% state_cols)]


adroit_plans <- adroit[plan_cols]


adroit_plans[-1] <- map(adroit_plans[-1], as.numeric)

#' Table before melt
glimpse(adroit_plans)

#' Melt/gather
plan_cols2 <- names(adroit_plans)[names(adroit_plans) != "Date"]
adroit_plans <- adroit_plans %>%
                gather_(key = "Plan",
                value = "Sales",
                plan_cols2)

#' table after melt
glimpse(adroit_plans)

#' Final touches to adroit states data
adroit_plans <-  adroit_plans %>%
                 filter(Sales != 0) %>%
                 mutate(Tab = "adroit") %>%# new col
                 arrange(Date) #sort 


#' **Plan duration column - a flag for yearly or 90 day
adroit_plans$Duration <- ifelse(grepl("Yearly", adroit_plans$Plan),
                             "Yearly", "90 Day")

#' Remove these for now until interpretation makes sense
adroit_plans <- adroit_plans %>%
                filter(!(Plan %in% c("Coverage Term'd","Net Inforce")))

#' ### **Join Adroit and Sales data together as state and plan tables
plan_table <- full_join(adroit_plans, web_plans)
state_table <- full_join(adroit_state, web_state)


#' ----------------------------------------------

#' ### **Extract data from Asst Agencies tab *** 
web <- read_excel(paste0(data_dir,
                         "2017 Sales Summary.xlsx"),
                  sheet = "Asst Agencies",
                  col_names = F)
