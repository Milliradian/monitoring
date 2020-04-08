# Point Pattern Analysis: Density map

install.packages("spatstat")
library(spatstat) 

# attaching the dataset
attach(covid)

# check the first 6 lines (head) of the data
head(covid)

# 
covids <- ppp(lon, lat, c(-180,180), c(-90,90))

# without attaching the covid set
# covids <- ppp(covid$lon, covid$lat, c(-180,180), c(-90,90))

d <- density(covids)

plot(d)
points(covids)

setwd("C:/lab")

load(".RData")

ls()

# covids: point pattern
# d: density map

library(spatstat)

# in case you do no have the package, first instal it with install.packages("spatstat") and then require it

# plot a density map

plot(d)

# putting points on the plot
points(covids)

# inputing the coastlines (download from the iol website and then extract to your working directory)

install.packages("rgdal") 
library("rgdal")

# giving the name to the object and asigning the function and inputing the vector lines (x0y0, x1y1, x2y2..)
coastlines <- readOGR("ne_10m_coastline.shp")

# add coastlines to the plot
plot(coastlines, add=T)

# changing the color, assign the name for the object (cl as color) and then add colors from lower number to higher number of cases
# 100 is the number of colors in between, for creating more consistent palette use higher numbers

cl <- colorRampPalette(c("yellow","orange","red"))(100)
plot(d, col=cl, main="Densities of Covid-19")
points(covids)
plot(coastlines, add=T)

# Exercise: create a new color palette
clr<-colorRampPalette(c('#2F2C62', '#42399B', '#4A52A7', '#59AFEA', '#7BCEB8', '#A7DA64','#EFF121', '#F5952D', '#E93131', '#D70131', '#D70131'))(100)
plot(d, col=cl, main="Densities of Covid-19")
points(covids)
plot(coastlines, add=T)

# export pdf
pdf("covid_density.pdf")
clr <- colorRampPalette(c("light green", "yellow","orange","violet")) (100)
plot(d, col=clr, main="Densities of covid-19")
points(covids)
plot(coastlines, add=T)
dev.off()

# export png
png("covid_density.png")
clr <- colorRampPalette(c("light green", "yellow","orange","violet")) (100)
plot(d, col=clr, main="Densities of covid-19")
points(covids)
plot(coastlines, add=T)
dev.off()





