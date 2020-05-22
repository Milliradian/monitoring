########

# Download the data from the iol website (image is aggregated, 10 times)

# Set working directory
# setwd("~/lab/")
# setwd("/Users/utente/lab") #mac
setwd("C:/lab/") # windows

# require libraries

library(raster)
library(RStoolbox)

# import the downloaded satellite image by the brick function
snt <- brick("snt_r10.tif")

snt # to see the characteristics of the image

# plot the image 

plot(snt)

# Bands
#B1: blue
#B2: green
#B3: red
#B4: NIR - Near Infrared

# plot rgb R3, G2, B1
plotRGB(snt,3,2,1, stretch="lin")

# put the NIR band on top of the red
plotRGB(snt,4,3,2, stretch="lin")

# relation between the bands

pairs(snt)

### PCA analysis

sntpca <- rasterPCA(snt)


sntpca


summary(sntpca$model) # 1st band has the highest amount of information, 70%

plot(sntpca$map) 


plotRGB(sntpca$map, 1,2,3, stretch="lin")


# set the moving window

window <- matrix(1, nrow = 5, ncol = 5) 

window 

sd_snt <- focal(sntpca$map$PC1, w=window, fun=sd) #w is the window that we are using, sd is the standard deviation

cl <- colorRampPalette(c("dark blue", "green", "orange", "red"))(100) # create colorramppalette

plot(sd_snt, col=cl)


dev.off()

par(mfrow=c(1,2))

plotRGB(snt,4,3,2, stretch="lin", main="the original image")

plot(sd_snt, col=cl, main="diversity")

# more diversity is observed on the borders of the different ecosystems
