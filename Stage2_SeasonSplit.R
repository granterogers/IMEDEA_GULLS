# R Script to Add Season Data to Yellow Legged Gull Data
# Author: Grant Rogers 2018 - grant.e.rogers@gmail.com

library(lubridate) #used to extract month information from data column

# Add Season Information to Dataframe ####

# season definitions by month number
# spring = 3,4,5
# summer = 6,7,8
# autumn = 9,10,11
# winter = 12,1,2

#Create month column in DataFrame for easy season extraction
GullDataFiltered$CaptureMonth = month(GullDataFiltered$timestamp, label=F, abbr=F)

#Create new column in Dataframe for Season of Data
GullDataFiltered$Season[GullDataFiltered$CaptureMonth=="3" | GullDataFiltered$CaptureMonth=="4" | GullDataFiltered$CaptureMonth=="5"] <- "Spring"
GullDataFiltered$Season[GullDataFiltered$CaptureMonth=="6" | GullDataFiltered$CaptureMonth=="7" | GullDataFiltered$CaptureMonth=="8"] <- "Summer"
GullDataFiltered$Season[GullDataFiltered$CaptureMonth=="9" | GullDataFiltered$CaptureMonth=="10" | GullDataFiltered$CaptureMonth=="11"] <- "Autumn"
GullDataFiltered$Season[GullDataFiltered$CaptureMonth=="12" | GullDataFiltered$CaptureMonth=="1" | GullDataFiltered$CaptureMonth=="2"] <- "Winter"

#remove unneeded capture month column
GullDataFiltered$CaptureMonth = NULL