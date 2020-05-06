# Set working directory
# setwd("~/lab/") # linux
# setwd("/Users/utente/lab") #mac
setwd("C:/lab/") # windows

# require libraries

library(raster)

library(RStoolbox)

library(ggplot2)

# import the images
p224r63_2011 <- brick("p224r63_2011_masked.grd")


# Bands in Landsat 7 

#B1: blue
#B2: green
#B3: red
#B4: Near Infrared
#B5: Short-wave Infrared
#B6: Thermal Infrared
#B7: Short-wave Infrared
#B8: Panchromatic 


# plot the image  RGB (mount NIR on 4th band (green component), )

plotRGB(p224r63_2011, r=5, g=4, b=3, stretch="Lin")

# plot the image ggplot (Medium infra red, NIR, red)

ggRGB(p224r63_2011,5,4,3)

# do the same with 1988 image

p224r63_1988 <- brick("p224r63_1988_masked.grd")

plotRGB(p224r63_1988, r=5, g=4, b=3, stretch="Lin")

ggRGB(p224r63_1988,5,4,3)

# compare 2 images

par(mfrow=c(1,2))

plotRGB(p224r63_2011, r=5, g=4, b=3, stretch="Lin")

plotRGB(p224r63_1988, r=5, g=4, b=3, stretch="Lin")

dev.off()


# names of the bands of the image 
# "B1_sre" "B2_sre" "B3_sre" "B4_sre" "B5_sre" "B6_bt"  "B7_sre"

names(p224r63_2011)

# Check the variable correlation (B1_sre, B3_sre)

plot(p224r63_2011$B1_sre, p224r63_2011$B3_sre)

# PCA (principal component analysis)

# check the information about the image

p224r63_2011

# decrease the resolution for PCA 

p224r63_2011_res <- aggregate(p224r63_2011, fact=10)

# use RStoolbox

p224r63_2011_pca <- rasterPCA(p224r63_2011_res)

# check the info ($call, $model, $map)

p224r63_2011_pca

# plot the map of p224r63_2011_pca

cl <- colorRampPalette(c('dark grey','grey','light grey'))(100) # 
plot(p224r63_2011_pca$map, col=cl) #see which image has the most amount of information (in this case PC1)

# call the summary of the model

summary(p224r63_2011_pca$model) #PC1 99.83% of the whole variation


# see the correlation

pairs(p224r63_2011)

# plot the pca map (assign the names of principal components to the RGB)

plotRGB(p224r63_2011_pca$map, r=1, g=2, b=3, stretch="Lin")


# do the same for 1988 image
p224r63_1988_res <- aggregate(p224r63_1988, fact=10)
p224r63_1988_pca <- rasterPCA(p224r63_1988_res) 
plot(p224r63_1988_pca$map, col=cl)

summary(p224r63_1988_pca$model) # also in this case there is a high correlation PC1

pairs(p224r63_1988)

# difference in the PCA 

difpca <- p224r63_2011_pca$map - p224r63_1988_pca$map

plot(difpca)

cldif <- colorRampPalette(c('blue','black','yellow'))(100) # color palette

plot(difpca$PC1,col=cldif)



