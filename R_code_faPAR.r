# How to look at a chemical cycling from a satellite

# Set working directory
# setwd("~/lab/")
# setwd("/Users/utente/lab") #mac
setwd("C:/lab/") # windows

# require libraries

library(raster)
library(rasterVis)
library(rasterdiv)

plot(copNDVI)

# Reclassify the copNDVI for removing the blue part (water)
copNDVI <- reclassify(copNDVI, cbind(253:255, NA))

plot(copNDVI)

levelplot(copNDVI)

# import the data (aggregated already)
faPAR10 <- raster("faPAR10.tif")

levelplot(faPAR10)


#export PDF

pdf("copNDVI.pdf")
levelplot(copNDVI)
dev.off()

pdf("faPAR10.pdf")
levelplot(faPAR10)
dev.off()

#############################

#2nd day

# Set working directory
# setwd("~/lab/")
# setwd("/Users/utente/lab") #mac
setwd("C:/lab/") # windows

# load the workspace

load(".RData")

ls()

faPAR10

#require libraries

library(raster)

library(rasterdiv)

library(rasterVis)

# the original file of fapar from Copernicus is 2 GB

# let's see how much space is needed for 8-BIT set


# see the range of file copNDVI

copNDVI 

# write a raster file

writeRaster(copNDVI, "copNDVI.tif") #5.3 MB, that's why we are using this files instead of original radiance files

levelplot(faPAR10)

######################
#3rd day

# regression model between faPAR and NDVI

# create 2 variables
erosion <- c(12, 14, 16, 24, 26, 40, 55, 67) # kg per square meter
hm <- c(30, 100, 150, 200, 260, 340, 460, 600) # ppm

plot(erosion, hm, col="red", pch=19, xlab ="erosion", ylab = "heavy metals", cex=2)


# see the relation by using the linear model

model1 <- lm(hm ~ erosion)


summary(model1) # to check the r squared, p-value and etc.


# include the linear model into the plot

abline(model1)

# Set working directory
# setwd("~/lab/")
# setwd("/Users/utente/lab") #mac
setwd("C:/lab/") # windows

# load the workspace

load(".RData")


#require libraries

library(raster)

library(rasterdiv)

library(rasterVis)

library(sf)


# plot the faPAR10

plot(faPAR10)

# plot the copNDVI 

plot(copNDVI)

# check the number of cells in the faPAR10
faPAR10

# random points from the image

random.points <- function(x,n)
{
  lin <- rasterToContour(is.na(x))
  pol <- as(st_union(st_polygonize(st_as_sf(lin))), 'Spatial') # st_union to dissolve geometries
  pts <- spsample(pol[1,], n, type = 'random')
}

# generate random points from the image

pts <- random.points(faPAR10, 1000)

plot(faPAR10)

points(pts, col="red", pch=19)

# passing values from the map to the sample

copNDVIp <- extract(copNDVI, pts)
faPAR10p <- extract(faPAR10, pts)

copNDVIp # to see the 1000 random points

faPAR10p 

dev.off()

# build the model
# photosynthesis vs biomass

model2 <- lm(faPAR10p ~ copNDVIp)

# summary of the model

summary(model2)

plot(copNDVIp, faPAR10p, col="green", xlab="biomass", ylab="photosynthesis")
abline(model2, col="red")
# plot shows the previous patterns that we observed (check the levelplots of copNDVI and faPAR for more information)

levelplot(copNDVI)
levelplot(faPAR10)


