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



