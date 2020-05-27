########
#1st Day

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

########
#2nd Day

#Download the cladonia_stellaris_calaita.JPG from the IOL website to the lab folder

# Set working directory
# setwd("~/lab/")
# setwd("/Users/utente/lab") #mac
setwd("C:/lab/") # windows

# require libraries
library(raster)
library(RStoolbox)

# brick the cladonia_stellaris_calaita.JPG and assign a name 
clad <- brick("cladonia_stellaris_calaita.JPG")

#plot the image by using plotRGB function 

plotRGB(clad, 1, 2, 3, stretch="lin") 



# use pairs to the relation
pairs(clad)

# PCA Analysis for the cladonia

cladpca <- rasterPCA(clad)

# see the information of the pca analysis

cladpca

# see the summary of the pca analysis
summary(cladpca$model) #98% by 1st component

# plot the map of cladpca
plotRGB(cladpca$map, 1, 2, 3, stretch="lin")



#put the focal function on top of the image to measure biodiversity

#build the moving window (3x3 matrix and set value for the pixel, in this case it is 1)

window <- matrix(1, nrow = 3, ncol = 3)

# check the window
window

# standard deviation of the clad

sd_clad <- focal(cladpca$map$PC1, w=window, fun=sd)

# you can also aggregate the cladpca and then do the calculation of the standard deviation to accelerate the process
PC1_agg <- aggregate(cladpca$map$PC1, fact=10)
sd_clad_agg <- focal(PC1_agg, w=window, fun=sd)

# create a colorramppalette 
cl <- colorRampPalette(c("yellow", "violet", "black"))(100)

# plot the calculations
par(mfrow=c(1,2))
plot(sd_clad, col=cl)
plot(sd_clad_agg, col=cl) # all of the microvariations in the structure of the cladonia can be seen in these images. 


# For comparison
par(mfrow=c(1,2))
cl <- colorRampPalette(c('yellow','violet','black'))(100) #
plotRGB(clad, 1,2,3, stretch="lin")
plot(sd_clad, col=cl) #or/ plot(sd_clad_agg, col=cl)




