### Point Pattern Analysis: Density map

# set the working directory: lab

# Windows
# setwd("C:/lab/")
# Mac users
# setwd("/Users/yourname/lab/")
# Linux users
setwd("~/lab")

# install packages
install.packages("spatstat")
install.packages("rgdal")

# require packages
library(spatstat)
library(rgdal)

# import the data set (head=T means that there is a column header)
covid <-read.table("covid_agg.csv",head=T)

# attach the data set
attach(covid)

# check the first 6 lines (head) of the data
head(covid)

# set the coordinates of the vectors in covids in relation to the global map
covids <-ppp(lon, lat,c(-180,180),c(-90,90)) # c for clustering

# without attaching the covid set
## covids <- ppp(covid$lon, covid$lat, c(-180,180), c(-90,90))

# density plots are usually a much more effective way to view the distribution of a variable. 
## Create the plot using plot(density())
d <- density(covids)

plot(d)

# draw a sequence of points 
points(covids)

#### Part 2
# set the working directory: lab

# Windows
# setwd("C:/lab/")
# Mac users
# setwd("/Users/yourname/lab/")
# Linux users
setwd("~/lab")

# load previous workspace
load("point_pattern.RData")

# display all the objects
ls()

# covids: point pattern
# d: density map

library(spatstat) 
library(rgdal) # in case you do no have the package, first install and then require it

# plot the density map
plot(d)

# putting points on the plot
points(covids)

# let’s input vector lines (x0y0, x1y1, x2y2..)
# inputing the coastlines (download from the iol website and then extract to your working directory)
# give the name to the object 
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

# export pdf file
pdf("covid_density.pdf")
clr <- colorRampPalette(c("light green", "yellow","orange","violet")) (100)
plot(d, col=clr, main="Densities of covid-19")
points(covids)
plot(coastlines, add=T)
dev.off()

# export png file
png("covid_density.png")
clr <- colorRampPalette(c("light green", "yellow","orange","violet")) (100)
plot(d, col=clr, main="Densities of covid-19")
points(covids)
plot(coastlines, add=T)
dev.off()





