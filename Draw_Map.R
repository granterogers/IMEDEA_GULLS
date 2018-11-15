# R Script to Plot tracks and Home Ranges of of Yellow-legged Gull per Season
# Author: Grant Rogers 2018 - grant.e.rogers@gmail.com

library(OpenStreetMap)
library(ggplot2)

#Define the Map boundaries and rendering style
map_type <- openmap(c(Max.Lat,Min.Lon), c(Min.Lat,Max.Lon), type = "stamen-terrain")
#Define Coordinate Reference System
map_crs <- openproj(map_type, projection = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
#convert OSM map to GGplot format
FinalMap <- autoplot(map_crs) 
#Add GullData Per Season
FinalMap <- FinalMap + geom_point(data=GullDataFiltered, aes(x=location.long, y=location.lat)) 
#Display Results across 2x2 Grid
FinalMap <- FinalMap + facet_wrap(. ~ Season, ncol=2)

#Plot Map
FinalMap
