# R Script to Load Yellow Legged Gull Data From Movebank 
# And perform basic filtering and quality control checks
# Author: Grant Rogers 2018 - grant.e.rogers@gmail.com

# Import Movebank Data ####

#set to my local working directory (change accordingly)
setwd("C:/Users/grs/Box/IMEDEA/R")

#TODO: Download directly from movebank https://cran.r-project.org/web/packages/move/vignettes/browseMovebank.pdf

GullDataFull <- read.csv("../DATA/FROM_MOVEBANK/Yellow-legged Gull - Mallorca.csv")

# Remove unneeded columns from data frame ####

GullDataFiltered <- GullDataFull

GullDataFiltered$event.id = NULL
GullDataFiltered$visible = NULL
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


# Quality Control ####

# Calculate how many rows to be removed based on no reported GPS locations
NumberTotalRows <- length(GullDataFull$location.long)
NumberRowsZeroLocations <- length(which(is.na(GullDataFiltered$location.long)))

# Remove rows with no reported GPS locations
GullDataFiltered <- GullDataFiltered[!is.na(GullDataFiltered$location.long),]

# Calculate how many rows to be removed based on flt:switch 77 value
NumberRowsFLT77 <- length(which(GullDataFiltered$flt.switch=="77"))

# Remove Rows where flt:Switch value is 77 - Indicating no GPS Fix 
GullDataFiltered <- GullDataFiltered[!GullDataFiltered$flt.switch=="77",]

# Remove Duplicate Rows (if any)
NumberDuplicateRows <- length(which(duplicated(GullDataFiltered)==TRUE))
GullDataFiltered <- GullDataFiltered[!duplicated(GullDataFiltered), ]
# Remove Duplicate Rows of TimeStamp
NumberDuplicateTimestamp <- length(which(duplicated(GullDataFiltered[,c("timestamp")]))==TRUE)
GullDataFiltered <- GullDataFiltered[!duplicated(GullDataFiltered[,c("timestamp")]),]

#TODO:remove low n values?
#TODO:remove ID 102 - milvus milvus - incorrectly labelled?
#TODO:add duplicate row check (redundent but useful)

# Reformat Key Columns ####

# Create timestamp in numeric format (maybe not needed)
# GullDataFiltered$timestamp.numeric = as.numeric(as.POSIXct(as.character(GullDataFiltered$timestamp),format="%Y-%m-%d %H:%M:%S"))

# Format TimeStamp Column for POSIXlt 
GullDataFiltered$timestamp = strptime(as.character(GullDataFiltered$timestamp),format="%Y-%m-%d %H:%M:%OS",tz = "GMT")

# Rename local ID field (individual.local.identifier) to 'ID' for easy of reading
colnames(GullDataFiltered)[colnames(GullDataFiltered) == 'individual.local.identifier'] <- 'ID'

# Place ID column first in data frame
GullDataFiltered = GullDataFiltered[,c(which(colnames(GullDataFiltered)=="ID"),which(colnames(GullDataFiltered)!="ID"))]

# Rebuild Index: Row Numbers Reset
rownames(GullDataFiltered) <- 1:nrow(GullDataFiltered)