# R Script to Plot tracks and Home Ranges of of Yellow-legged Gull per Season
# Open Street Map Version
# Author: Grant Rogers 2018 - grant.e.rogers@gmail.com

library(OpenStreetMap)
library(ggplot2)

Gull.ID = "175"
#Gull.ID = "177"

# Grab Individual Gull Bounding Box & Add Small Buffer
map_buffer = 0.05
Min.Lon <- min(GullDataFiltered[GullDataFiltered$ID==Gull.ID,]$location.long)-map_buffer
Max.Lon <- max(GullDataFiltered[GullDataFiltered$ID==Gull.ID,]$location.long)+map_buffer
Min.Lat <- min(GullDataFiltered[GullDataFiltered$ID==Gull.ID,]$location.lat)-map_buffer
Max.Lat <- max(GullDataFiltered[GullDataFiltered$ID==Gull.ID,]$location.lat)+map_buffer

# Define the Map boundaries and rendering style
map_type <- openmap(c(Max.Lat,Min.Lon), c(Min.Lat,Max.Lon), type = "osm")
# Define Coordinate Reference System
map_crs <- openproj(map_type, projection = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
# Convert OSM map to GGplot format
FinalMap <- autoplot(map_crs) 

# Add Gull Locations
FinalMap <- FinalMap + geom_point(data= GullDataFiltered[GullDataFiltered$ID=="175",], aes(x=location.long, y=location.lat)) 

# Transform Contour from UTM to WGS84
contour.95.spatial.wgs84 = spTransform(contour.95.spatial,CRS("+proj=longlat +datum=WGS84"))
# Add Contour Layer
FinalMap <- FinalMap + layer_spatial(data = contour.95.spatial.wgs84, fill = NA, colour = "black")
# Set map limits
FinalMap <- FinalMap + coord_sf(xlim = c(Min.Lon,Max.Lon),  ylim = c(Min.Lat,Max.Lat))

# Display Results across 2x2 Grid
#FinalMap <- FinalMap + facet_wrap(. ~ Season, ncol=2)

# Plot Final Map
FinalMap
