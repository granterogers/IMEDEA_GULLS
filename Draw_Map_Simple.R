# R Script to Plot tracks and Home Ranges of of Yellow-legged Gull per Season
# Simple Maps Outline Version
# Author: Grant Rogers 2018 - grant.e.rogers@gmail.com

library(ggplot2)
library(ggspatial)
library(ggmap)
library(maps)
library(mapdata)
library(rgdal)

# Define ID to plot
Gull.ID = "289"

# Grab Individual Gull Bounding Box & Add Small Buffer
map_buffer = 0.2
Min.Lon <- min(GullDataFiltered[GullDataFiltered$ID==Gull.ID,]$location.long)-map_buffer
Max.Lon <- max(GullDataFiltered[GullDataFiltered$ID==Gull.ID,]$location.long)+map_buffer
Min.Lat <- min(GullDataFiltered[GullDataFiltered$ID==Gull.ID,]$location.lat)-map_buffer
Max.Lat <- max(GullDataFiltered[GullDataFiltered$ID==Gull.ID,]$location.lat)+map_buffer

# Define GGplot object
mymap <- ggplot()
# draw world map outlnie
mymap <- mymap + geom_polygon(data =  map_data("world"), aes(x=long, y = lat, group = group), fill = NA, color = "red")
# add gull locations
mymap <- mymap + geom_point(data = GullDataFiltered[GullDataFiltered$ID==Gull.ID,], aes(x=location.long, y=location.lat)) 
# Transform Contour from UTM to WGS84
#contour.95.spatial.wgs84 = spTransform(contour.95.spatial,CRS("+proj=longlat +datum=WGS84"))
# Add Contour Layer
#mymap <- mymap + layer_spatial(data = contour.95.spatial.wgs84, fill = NA, colour = "black")
# Set map limits
mymap <- mymap + coord_sf(xlim = c(Min.Lon,Max.Lon),  ylim = c(Min.Lat,Max.Lat))
# Run plot
mymap