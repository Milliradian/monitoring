# NO2 levels - before and after the COVID-19
# Download NO2 data (EN.zip) from the IOL website
## create a folder called /no2 folder in the /lab folder and put all the extracted data into the /no2 folder

# setting the working directory: /no2

# Windows users
setwd("C:/lab/no2")
# Mac users
# setwd("/Users/yourname/lab/no2")
# Linux users
#setwd("~/lab/no2")

# require libraries
library(raster)


## quick manner of importing and plotting the data set

# first create list of files with similar pattern by using 'list.files()' function
rlist <- list.files(pattern = "EN")

# check the list
rlist

# use 'laplly()' function over a list of vector
import <- lapply(rlist, raster)

# use 'laplly()' function over a list of vector
import <- lapply(rlist, raster)

# create a stack of the rasters by using 'stack()' function
EN <- stack(import)

# check the information of the stack
EN

# create a colorRampPalette
cl <- colorRampPalette(c('red','orange','yellow'))(100)

# plot the raster stack
plot(EN, col=cl)

# plot the first and the last images (january and march)
# create multiframe graph with 'par()' function and then plot 
par(mfrow=c(1,2))

plot(EN$EN_0001, col=cl)
plot(EN$EN_0013, col=cl)

# RGB space (apply RGB to 3 images, EN_0001, EN_0007, EN_0013)
plotRGB(EN, r=1, g=7, b=13, stretch="lin")

# calculate and create a difference map between 1st and the last image
dif <- EN$EN_0013-EN$EN_0001

# create a new colorRampPalette
cld <- colorRampPalette(c('blue', 'white', 'red'))(100)

# plot the difference map
plot(dif, col=cld)

## quantitative estimate
# creating a boxplot
boxplot(EN)

# remove outliers
boxplot(EN, outline=F)

# make boxplots horizontal
boxplot(EN, outline=F, horizontal=T)

# add axes
boxplot(EN, outline=F, horizontal=T, axes=T)
# there is a decrease in the maximum values, but not in the median

# plot image 1 against image 13 (x = EN_0001, y = EN_0013)
plot(EN$EN_0001, EN$EN_0013)
abline(0,1, col='red')
# most of values for each pixel is decreased, that's why most of the points are under the abline
