### Snow coverage from Copernicus Program

# setting the working directory: lab

# Windows users
# setwd("C:/lab/")
# Mac users
# setwd("/Users/yourname/lab/")
# Linux users
setwd("~/lab")

# install required packages 
install.packages("ncdf4")

# require libraries
library(ncdf4)
library(raster)

# import the downloaded file (from: https://land.copernicus.vgt.vito.be/PDF/portal/Application.html) and assign a name
snowmay <- raster("c_gls_SCE_202005260000_NHEMI_VIIRS_V1.0.1.nc")

# do not worry if you get the following warning message:

## Warning message:
# In .getCRSfromGridMap4(atts) : cannot process these parts of the CRS: spatial_ref=GEOGCS["WGS 84",DATUM["WGS_1984",SPHEROID["WGS 84",6378137,298.257223563,AUTHORITY["EPSG","7030"]],AUTHORITY["EPSG","6326"]],PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.0174532925199433,AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","4326"]] GeoTransform=-180 0.01 0 84 0 -0.01

# create a color ramp palette
cl <- colorRampPalette(c("darkblue","blue","light blue"))(100)

# Exercise: plot the snow cover with the color ramp palette
plot(snowmay, col=cl)


# see the characteristics of the image
snowmay

# Download the snow.zip from iol website 
# create a folder in the 'lab' folder called 'snow' and extract images directly to the 'snow' folder

# importing the downloaded images
#####
## slow manner

# first set the working directory to the 'snow' folder
setwd("C:/lab/snow/")

# first import the data with 'raster()' function
snow2000 <- raster("snow2000r.tif")
snow2005 <- raster("snow2005r.tif")
snow2010 <- raster("snow2010r.tif")
snow2015 <- raster("snow2015r.tif")
snow2020 <- raster("snow2020r.tif")

# then use 'par()' function to create multiframe graphs
par(mfrow=c(2,3))
plot(snow2000, col=cl)
plot(snow2005, col=cl)
plot(snow2010, col=cl)
plot(snow2015, col=cl)
plot(snow2020, col=cl)

#####
## quick manner of importing and plotting the data set

# first create list of files with similar pattern by using 'list.files()' function
rlist <- list.files(pattern = "snow")

# check the list
rlist

# use 'laplly()' function over a list of vector
import <- lapply(rlist, raster)

# create a stack of the rasters by using 'stack()' function
snow.multitemp <- stack(import)

# check the information
snow.multitemp

# plot the raster stack
plot(snow.multitemp, col=cl)

#####
## Predicting the 2025 snow cover
# go to the IOL website and download 'prediction.r' into the folder 'snow'
# use 'source()' function to run the 'prediction.r'
source("prediction.r")

plot(predicted.snow.2025.norm, col=cl)

#####
## Day 2

# setting the working directory: lab

# Windows users
setwd("C:/lab/snow/")
# Mac users
# setwd("/Users/yourname/lab/snow")
# Linux users
# setwd("~/lab/snow")


# Exercise: import all of the snow cover images altogether

# require libraries
library(raster)

# first create list of files with similar pattern by using 'list.files()' function
rlist <- list.files(pattern = "snow")

# check the list
rlist

# use 'laplly()' function over a list of vector
import <- lapply(rlist, raster)

# create a stack of the rasters by using 'stack()' function
snow.multitemp <- stack(import)

# check the information
snow.multitemp

# create a color ramp palette
cl <- colorRampPalette(c("darkblue","blue","light blue"))(100)

# plot the raster stack
plot(snow.multitemp, col=cl)

# in case it took too long to run the source code named 'prediction.r', download predicted.snow.2025.norm.tif from IOL website and put it into /lab/snow/
# import the image into the R by using 'raster()' function

prediction <- raster("predicted.2025.norm.tif")

plot(prediction, col=cl)

# export the output of the calculations to be able to send it in a form of a simple .tif file to anyone by using 'writeRaster()' function

writeRaster(prediction, "final.tif")

## you can also export a pdf with all of the data (snow.multitemp and prediction) 
# first create a final stack 
final.stack <- stack(snow.multitemp, prediction)

# then plot it
plot(final.stack, col=cl)

# now you can export it in a form of a .pdf/.png file
# pdf (exported pdf files will have a better resolution)
pdf("my_final_exciting_graph.pdf")
plot(final.stack, col=cl)
dev.off()

# png
## you can increase the resolution of png by using additional script (for more info search for 'png()' function in R documentation)
png("my_final_exciting_graph.png")
plot(final.stack, col=cl)
dev.off()

###### 
# 1:1 line with the snow data
# setwd("~/lab/snow/")
# setwd("/Users/utente/lab/snow/") #mac
setwd("C:/lab/snow/") # windows

# fast version of import and plot of many data
rlist <- list.files(pattern="snow")
rlist
import <- lapply(rlist, raster)
snow.multitemp <- stack(import)

# plot 2010 vs 2020
plot(snow.multitemp$snow2010r, snow.multitemp$snow2020r)
abline(0,1, col="red") # because data is simulated the plot is strange

# try 2000 vs 2020
plot(snow.multitemp$snow2010r, snow.multitemp$snow2020r)
abline(0,1, col="red") # in this case you can see the trend
