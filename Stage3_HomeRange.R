# R Script to Calculate Home Range Areas of Yellow-legged Gull
# Author: Grant Rogers 2018 - grant.e.rogers@gmail.com

library(BBMM)
library(rgdal)

# Format Data ####

#TODO: Remove nocturnal locations
#TODO: Remove diurnal locations within 100 m

# Create Time Difference vector between reported GPS locations for use in BBMM algorithm
timediff <- diff(GullDataFiltered$timestamp)
# Remove first row of Gull Dataframe to match size of timediff vector
GullDataFiltered <- GullDataFiltered[-1,]
# Catch any possible negative or NA Vales of timediff and add to Dataframe
GullDataFiltered$timediff = as.numeric(abs(timediff))
# Cleanup unused timediff variable
remove(timediff)

# Reformat WGS84 GPS Coordinates into UTM (Zone 31) Standard
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

#Test for Gull ID 175
Gull_175 <- subset(GullDataFiltered,GullDataFiltered$ID=="175")

#Run Brownian Bridge Algorithm ####
BBMM = brownian.bridge(x=Gull_175$location.utm.long, y=Gull_175$location.utm.lat, time.lag=Gull_175$timediff, location.error=34, cell.size=100)

#bbmm.summary(BBMM)

# #Plot results for all contours
contours = bbmm.contour(BBMM, levels=90, locations=Gull_175, plot=TRUE)
# # Print result
print(contours)