### R code for spatial view of points

# install required packages for the session (no need to install packages that you already have in your workspace)

install.packages("sp")
install.packages("ggplot2") 
# If ggplot2 cannot be found by the software: install the devtools package and then install 
# install.packages("devtools")
# devtools::install_github("tidyverse/ggplot2")

# require installed packages
library(sp)
library(ggplot2)

# load the pre-loaded 'meuse' data set
data(meuse)

# check the first 6 rows of the data set
head(meuse)

# set spatial coordinates to create a spatial object, or retrieve spatial coordinates from a spatial object with 'coordinates()' fucntion
coordinates(meuse) = ~x+y      # alt+126

# plot the object
plot(meuse)

# with spplot it is easy to map several layers with a single legend for all maps
spplot(meuse, "zinc")

# Exercise: plot the spatial amount of copper and add the label 'Copper concentration'
spplot(meuse, "copper", main="Copper concentration")

# Create a bubble plot of spatial data. Size of the bubbles are directly related to the amount of concentration
bubble(meuse, "zinc")
bubble(meuse, "zinc", main="Zinc concentration")

# Exercise: use 'bubble()' function to plot copper, add red color to the bubbles
bubble(meuse, "copper", main="Copper concentration", col="red")

### Importing new data

# Download covid_agg.csv from our teaching website and build a folder called 'lab' into C: or directly into home folder in case of Linux based operation systems
# Put the covid_agg.csv file into the folder 'lab'

# setting the working directory: lab

# Windows
# setwd("C:/lab/")
# Mac users
# setwd("/Users/yourname/lab/")
# Linux users
setwd("~/lab")

# read downloaded table with 'read.table()' function. 
## This function reads a file in table format and creates a data frame from it, with cases corresponding to lines and variables to fields in the file.
covid <- read.table("covid_agg.csv", head=T)

# see the first 6 rows
head(covid)

# attach the data frame
attach(covid)

# plot the data frame
plot(country,cases) ## or plot with 'plot(covid$country, covid$cases)' if you don't want to attach the data frame

# add labels
plot(country, cases, las=0) # parallel labels
plot(country, cases, las=1) # horizontal labels
plot(country, cases, las=2) # perpendicular labels
plot(country, cases, las=3) # vertical labels

# adjust the size of the tick label numbers/text with a numeric value with 'cex.axis'
plot(country, cases, las=3, cex.axis=0.5)
plot(country, cases, las=3, cex.axis=0.7)


# save the .RData under the menu File
# for Windows users: save as "yourprefferredname.RData"

##### Part 2

# set the working directory: lab
# Windows users
## setwd("C:/lab/")
# Mac users
## setwd("/Users/yourname/lab/")
# Linux users
setwd("~/lab")

# load the previously saved .RData
load(spatial.RData) # load("C:/lab/spatial.RData") for Windows

# check the files: look for covid
ls() 

# require the previously installed library
library(ggplot2)

data(mpg) # data set from https://ggplot2.tidyverse.org/reference/mpg.html

# see the first 6 rows
head(mpg)

# key components: data, aes, geometry
ggplot(mpg, aes(x=displ,y=hwy)) + geom_point() # showing data in points
ggplot(mpg, aes(x=displ,y=hwy)) + geom_line() # showing data in lines
ggplot(mpg, aes(x=displ,y=hwy)) + geom_polygon() # showing data in polygons

# checking the covid data
head(covid)

# using the 'ggplot()' function on the covid data
ggplot(covid, aes(x=lon, y=lat, size=cases)) + geom_point()
## for more info about ggplot: https://ggplot2.tidyverse.org/index.html

