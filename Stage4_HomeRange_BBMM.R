# R Script to Calculate Home Range Areas of Yellow-legged Gull
# Based upon Brownian Bridge Movement Model
# Author: Grant Rogers 2018 - grant.e.rogers@gmail.com

library(BBMM)
library(rgdal)
library(raster)
library(beepr)
library(maptools)

# Run Home Range Calculation ####

# Define ID or Season for Analysis
Gull.ID = "289" # 289 Stays around Mallorca
GullDataForBBMM <- subset(GullDataFiltered,GullDataFiltered$ID==Gull.ID)
#GullDataForBBMM <- subset(GullDataFiltered,GullDataFiltered$Season=="Spring")

# Run Brownian Bridge Algorithm 
start_time <- Sys.time()
BBMM = brownian.bridge(x=GullDataForBBMM$location.utm.long, y=GullDataForBBMM$location.utm.lat, time.lag=GullDataForBBMM$timediff, location.error=GullDataForBBMM$location.error.numerical, cell.size=200)
end_time <- Sys.time(); elapsed_time =end_time - start_time; beep() #log time elapsed and make a beep
remove(start_time,end_time)

# Consolidate BBMM Results into Data Frame
BBMM.DF = data.frame(x = BBMM$x, y = BBMM$y, probability = BBMM$probability)
# Convert Data Frame into Raster Format and define projection
BBMM.RASTER <- rasterFromXYZ(BBMM.DF,crs=CRS("+proj=utm +zone=31 +datum=WGS84"),digits=2)

# Extract Isopleth (50% & 95%)
contours.50 = bbmm.contour(BBMM, levels=50,plot=TRUE)
contours.95 = bbmm.contour(BBMM, levels=95,plot=TRUE)

# Create Contour Files
contour.50.spatial <- rasterToContour(BBMM.RASTER,levels=contours.50$Z)
contour.95.spatial <- rasterToContour(BBMM.RASTER,levels=contours.95$Z)

# Write Output to Shapefiles (if desired)
#writeOGR(obj=contour.50.spatial,dsn=".",layer="BBMM_50",driver="ESRI Shapefile",overwrite_layer=TRUE)
#writeOGR(obj=contour.95.spatial,dsn=".",layer="BBMM_95",driver="ESRI Shapefile",overwrite_layer=TRUE)

# Export an Ascii grid with probabilities (Utilisation Distribution) ####

# First delete any x and y coords that have probability of use < 0.00000001 so save space
x <- BBMM$x[BBMM$probability >= 0.00000001]
y <- BBMM$y[BBMM$probability >= 0.00000001]
z <- BBMM$probability[BBMM$probability >= 0.00000001]
# Create data frame
tmp <- data.frame(x, y, z)
# Make into Spatial Data Fram
out.ascii <- SpatialPixelsDataFrame(points = tmp[c("x", "y")], data=tmp)
out.ascii <- as(out.ascii, "SpatialGridDataFrame")
# Export to ASC File
write.asciigrid(out.ascii, "BBMM.asc", attr=3)
# Cleanup
remove(tmp,out.ascii,x,y,z)