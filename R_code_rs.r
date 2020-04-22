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

# function to import the satellite images and assign a name

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

#B!: blue

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






