# R Script to Load Yellow Legged Gull Data From Movebank 
# And perform basic filtering and quality control checks
# Author: Grant Rogers 2018 - grant.e.rogers@gmail.com

#### Import Movebank Data ####

#set to my local working directory (change accordingly)
setwd("C:/Users/grs/Box/IMEDEA/R")

GullDataFull = read.csv("../DATA/FROM_MOVEBANK/Yellow-legged Gull - Mallorca.csv")

#or download directly from movebank https://cran.r-project.org/web/packages/move/vignettes/browseMovebank.pdf

#### Remove unneeded columns ####

GullDataFiltered = GullDataFull

GullDataFiltered$event.id = NULL
GullDataFiltered$visible = NULL
GullDataFiltered$flt.switch = NULL
GullDataFiltered$gps.hdop = NULL
GullDataFiltered$gps.maximum.signal.strength = NULL
GullDataFiltered$gsm.mcc.mnc = NULL
GullDataFiltered$gps.satellite.count = NULL
GullDataFiltered$import.marked.outlier = NULL
GullDataFiltered$tag.local.identifier = NULL
GullDataFiltered$sensor.type = NULL
GullDataFiltered$individual.taxon.canonical.name = NULL
GullDataFiltered$tag.voltage = NULL
GullDataFiltered$study.name = NULL


#### Quality Control ####

#remove rows with no reported GPS locations
GullDataFiltered = GullDataFiltered[!is.na(GullDataFiltered$location.long),]

#Determine how many rows were removed for report
#NumberRowsRemoved = length(GullDataFull$location.long) - length(GullDataFiltered$location.long)

#TODO:remove low n values?
#TODO:remove ID 102 - milvus milvus - incorrectly labelled?
#TODO:high error values in location?

#### Reformat Data ####

# Create timestamp in numeric format (maybe not needed)
# GullDataFiltered$timestamp.numeric = as.numeric(as.POSIXct(as.character(GullDataFiltered$timestamp),format="%Y-%m-%d %H:%M:%S"))

# Format TimeStamp Column for POSIXlt 
GullDataFiltered$timestamp = strptime(as.character(GullDataFiltered$timestamp),format="%Y-%m-%d %H:%M:%OS",tz = "GMT")

# Rename local ID field (individual.local.identifier) to 'ID' for easy of reading
colnames(GullDataFiltered)[colnames(GullDataFiltered) == 'individual.local.identifier'] <- 'ID'

# Place ID column first in data frame
GullDataFiltered = GullDataFiltered[,c(which(colnames(GullDataFiltered)=="ID"),which(colnames(GullDataFiltered)!="ID"))]

#### Provide Useful MetaData ####

Min.Lon <- min(GullDataFiltered$location.long)
Max.Lon <- max(GullDataFiltered$location.long)
Min.Lat <- min(GullDataFiltered$location.lat)
Max.Lat <- max(GullDataFiltered$location.lat)