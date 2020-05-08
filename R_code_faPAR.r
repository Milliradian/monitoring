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




