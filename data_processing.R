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
library(reshape2)

#' ### **Data processing function**
#' This function is used to convert the 3 main excel tabs
#' to dataframes for R. It is highly dependent on how the
#' spreadsheet is organized/structured currently
proc_data <- function(data){
  data[is.na(data)] <- 0
  names(data) <- data[2,] %>% unlist
  names(data)[names(data)=="0"] <- unlist(data[1,])[names(data)=="0"]
  
  data <- data[-(1:2),]
  
  #' Date column needs to be cleaned up
  data$Date <- as.numeric(data$Date)
  data <- data[!is.na(data$Date),]
  
  data$Date <- as.Date(data$Date,
                       origin = "1899-12-30")
  
  if('0' %in% names(data)){
    data <- data %>% select(-TOTALS, -`0`, -TOTAL)
  } else{
    names(data)[duplicated(names(data))] <- paste(names(data)[duplicated(names(data))], "4 x 3")
    
    data <- data %>% select(-TOTALS, -TOTAL)
    
  }
  
  melt_cols1 <- names(data)[!(names(data) %in% states$Abbreviation)]
  data <- melt(data, id.vars = melt_cols1)
  
  data <- data %>%
    filter(value != 0) %>%
    select(-value)
  names(data)[names(data)=="variable"] <- "State"
  names(data) <- trimws(names(data))
  
  # should be a better way to do this
  fuck_it <- c(grep("Deluxe", names(data)),
               grep("Standard", names(data)),
               grep("Economy", names(data)),
               grep("Choice", names(data)))
  
  data <- melt(data, id.vars = names(data)[-fuck_it])
  data <- data %>%
    filter(value != 0) %>%
    select(-value)
  names(data)[names(data)=="variable"] <- "Plan"
  #' **Plan duration column - a flag for yearly or 90 day
  data$Duration <- ifelse(grepl("4 x 3", data$Plan),
                               "Yearly", "90 Day")
  
  #' clean up plan column now that duration flag exists
  data$Plan <- gsub("4 x 3", "", data$Plan) %>% trimws
  
  data
}

#' State file for use later
states <- read_csv("states.csv")

#' ### **STM Web Sales Summary Tab**
### Web data needs reformatting to be a dataframe
# web sales data sheet
web <- read_excel(paste0(data_dir,
                         "2017 Sales Summary.xlsx"),
                  sheet = "STM Web Sales Summary",
                  col_names = F)

#' Web data should be split to 2 tables:
#' Daily site activity and daily websales by state
web <- proc_data(web)

#' #### **Web Sales table**
web_sales <- web %>%
             select(Date, State, Plan, Duration)

#' #### **Web traffic table**
web_traffic <- web %>%
               select(-State, -Plan)


#' ### **Adroit Sales Summary Tab**
adroit <- read_excel(paste0(data_dir,
                            "2017 Sales Summary.xlsx"),
                     sheet = "Adroit Sales Summary",
                     col_names = F)

adroit <- proc_data(adroit)

#' Remove summary columns for now
adroit <- adroit %>% select(-`Net Inforce`, -`Coverage Term'd`)

#' ### **Asst Agencies Tab**
asst <- read_excel(paste0(data_dir,
                          "2017 Sales Summary.xlsx"),
                   sheet = "Asst Agencies",
                   col_names = F)

agencies <- asst[1,] %>% unlist 
agencies <- agencies[!is.na(agencies)]
agencies <- agencies[-c(length(agencies), 
                        length(agencies)-1)]
agencies <- rep(agencies, each = 4)


#' Write flat files
write_csv(web_sales, paste0(data_dir, "web_sales.csv"))
write_csv(web_traffic, paste0(data_dir, "web_traffic.csv"))
write_csv(adroit, paste0(data_dir, "adroit_sales.csv"))