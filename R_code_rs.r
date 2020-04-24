# R code for remote sensing data analysis

# check/set working directory

getwd()
setwd("C:/lab/")

# install the package raster
install.packages("raster")
install.packages("RStoolbox")

# require packages
library(raster)
library(RStoolbox)

# function to import the satellite images and assign a name (p for path, r for row, in the name of the image. for ex: p224r63)

p224r63_2011<-brick("p224r63_2011_masked.grd")

# plot images

plot(p224r63_2011)

#change the colorramp palette

cl<-colorRampPalette(c("black", "grey", "light grey"))(100)

# exercise: plot the new image with the new color palette

plot(p224r63_2011, col=cl)

# bands of Landsat

#B1: blue
#B2: green
#B3: red
#B4: NIR

# multiframe of different plots (2 rows, 2 columns, for creating 4 plots for each bands)

par(mfrow=c(2,2))

#B1: blue

clb <-colorRampPalette(c("dark blue","blue", "light blue"))(100)

# sre means spectral reflectance

plot(p224r63_2011$B1_sre, col=clb)

#B2: green

clg <-colorRampPalette(c("dark green","green", "light green"))(100)

plot(p224r63_2011$B2_sre, col=clg)

#B3: red

clr <-colorRampPalette(c("dark red","red", "pink"))(100)

plot(p224r63_2011$B3_sre, col=clr)

#B4: NIR

cln <-colorRampPalette(c("red","orange", "yellow"))(100)

plot(p224r63_2011$B4_sre, col=cln)


# multiframe of different plots (4 rows, 1 column)

# par(mfrow=c(4,1))

dev.off()


# Plot RGB (stretch=for seeing the colors better by stretching, Lin=linear)

plotRGB(p224r63_2011, r=3, g=2, b=1, stretch="Lin")

# use NIR 

plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="Lin")

# exercise: put the NIR on top of the G component of the RGB

plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="Lin")


# the NIR on top of the B (in this case bare soil turns into yellow)

plotRGB(p224r63_2011, r=3, g=2, b=4, stretch="Lin")


########

# check/set working directory

getwd()
setwd("C:/lab/")

# load workspace

load("rs.RData")

library(raster)

# import the data from 1988 (path 224, row 63)

p224r63_1988 <- brick("p224r63_1988_masked.grd")

# plot the image from 1988

plot(p224r63_1988)


#PlotRGB
#B1: blue
#B2: green
#B3: red
#B4: NIR

# Comparison between 1988 and 2011 images (path 224 and row 63)
# Exercise: plot in visible RGB 321 both images

par(mfrow=c(2,1))

plotRGB(p224r63_1988, r=3, g=2, b=1, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch="Lin")

# Exercise: plot in false colour RGB 432 both images

par(mfrow=c(2,1))

plotRGB(p224r63_1988, r=4, g=3, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="Lin")

# enhance the noise! 
# Enhancing the noise helps to understand more about the difference. 
# In this case the noise were probably coming from the humidity levels

par(mfrow=c(2,1))

plotRGB(p224r63_1988, r=4, g=3, b=2, stretch="hist")
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="hist")


#PlotRGB
#B1: blue
#B2: green
#B3: red: B3_sre
#B4: NIR: B4_sre

# DVI for 2011

dvi2011 <- p224r63_2011$B4_sre - p224r63_2011$B3_sre
cldvi <- colorRampPalette(c("darkorchid3","light blue","lightpink4"))(100) 
plot(dvi2011,col=cldvi)

# DVI for 1988

dvi1988 <- p224r63_1988$B4_sre - p224r63_1988$B3_sre
cldvi <- colorRampPalette(c("darkorchid3","light blue","lightpink4"))(100) 
plot(dvi1988,col=cldvi)

# Difference in DVI between 2011 and 1988

diff <- dvi2011 - dvi1988
plot(diff)

# changing the grain with aggregate function ( factor is the amount of times that you increase the pixel size; res=resampling )
p224r63_2011res <- aggregate(p224r63_2011, fact=10)
p224r63_2011res100 <- aggregate(p224r63_2011, fact=100)

par(mfrow=c(3,1))
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="Lin")
plotRGB(p224r63_2011res, r=4, g=3, b=2, stretch="Lin")
plotRGB(p224r63_2011res100, r=4, g=3, b=2, stretch="Lin")

# for info about the image just type the name of the image
p224r63_2011 # resolution is 30 by 30 metres
p224r63_2011res100 # resolution is 3000 by 3000 metres



