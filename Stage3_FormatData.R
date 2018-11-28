# R Script to Format and Add New Data for Yellow-legged Gull Study
# Author: Grant Rogers 2018 - grant.e.rogers@gmail.com

library(rgdal)
library(raster)
library(beepr)
library(maptools)

#TODO: Remove nocturnal locations ??
#TODO: Remove diurnal locations within 100 m ??
#TODO: Interpolate all locations?

# Extract Bounding Box for Entire Gull Set ####

Min.Lon <- min(GullDataFiltered$location.long)
Max.Lon <- max(GullDataFiltered$location.long)
Min.Lat <- min(GullDataFiltered$location.lat)
Max.Lat <- max(GullDataFiltered$location.lat)

# Calculate Time Difference between GPS locations (used by BBMM) ####

# Create Time Difference Vector
timediff <- vector()

# Loop over all unique Gull ID's
for (ID in unique(GullDataFiltered$ID))
{
  # Calculate Time Difference between successive rows
  timedifftemp = as.numeric(diff(GullDataFiltered[GullDataFiltered$ID==ID,]$timestamp),units="secs")
  # Insert 0 at first row for each Gull ID
  location_zero = which(GullDataFiltered$ID %in% 175)[1]-1
  # Add result for each ID to global timediff vector
  timedifftemp = append(timedifftemp, 0, location_zero)
  timediff = append(timediff,timedifftemp) 
}

# Attach Time Diff Vector to Datafram
GullDataFiltered$timediff = timediff
# Cleanup unused variables 
remove(timediff, timedifftemp)

# Reformat and add Gull WGS84 GPS Coordinates into UTM (Zone 31) Standard ####

# Extract Gull DataFrame Coordinate Columns
LatLong <- data.frame(X = GullDataFiltered$location.long, Y = GullDataFiltered$location.lat)
# Convert to Coordinate format for rgdal library
coordinates(LatLong) <- c("X","Y")
# Define Current CRS (WGS84)
proj4string(LatLong) <- CRS("+proj=longlat +datum=WGS84")
# Transform to UTM Zone 31
LatLongUTM <- spTransform(LatLong, CRS(paste("+proj=utm +zone=",31," ellps=WGS84",sep='')))
# Transform to DataFrame Format
LatLongUTM_DF <- as.data.frame(LatLongUTM)
# Attach UTM Coordinates to Gull Data Frame
GullDataFiltered$location.utm.long <- LatLongUTM_DF$X
GullDataFiltered$location.utm.lat <- LatLongUTM_DF$Y
# Cleanup unused variables
remove(LatLong,LatLongUTM,LatLongUTM_DF)

# Create Distance Travelled Between Locations Column ####

# library(geosphere)
# 
# library(data.table)
# 
# distances = cbind(GullDataForHR$location.long, GullDataForHR$location.lat)
# 
# for(i in 1:(length(GullDataForHR$ID)-1))
# {
#   GullDataForHR$distance[i] = distVincentySphere(distances[i,], distances[i+1,],r=6378137)
# }

# Interpolate Locations ####