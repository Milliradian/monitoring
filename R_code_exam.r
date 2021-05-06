####################################################################################
# R scripts of the Monitoring Ecosystem Changes and Functioning course (GCE&SDG)
####################################################################################

####################################################################################
# Table of contents                   5    - 24   
# Introduction                        1    - 3
# R_code_first.r                      26   - 71
# R_code_multipanel.r                 73   - 140
# R_code_spatial.r                    142  - 275
# R_code_point_pattern_analysis.r     277  - 398
# R_code_multivariate.r               400  - 467
# R_code_remote_sensing.r             469  - 636
# R_code_ecosystem_functions.r        638  - 763
# R_code_pca_remote_sensing.r         765  - 878
# R_code_radiance.r                   880  - 949
# R_code_faPAR.r                      951  - 1115
# R_code_EBVs.r                       1117 - 1269
# R_code_snow.r                       1271 - 1465
# R_code_no2.r                        1467 - 1542
# R_code_crop.r                       1544 - 1595
# R_code_interpolation.r              1598 - 1702
# R_code_sdm.r                        1704 - 1797
####################################################################################

####################################################################################
# R_code_first.r
# Introduction to the R Software and the Free and Open Source philosophy: 
# how to deal with R making your first code!
####################################################################################

# Install package "sp"
# "install.packages()" function is used to download and install packages from CRAN-like repositories or from local files
# "sp" package provides S4 classes for importing, manipulating and exporting spatial data in R
install.packages("sp")

# Require installed package
# "library()" or "require()" functions will load and attach add-on packages
library("sp")

# Call pre-loaded data set "meuse"
# "data()" function loads specified data sets, or list the available data sets
# "Meuse" data set gives locations and topsoil heavy metal concentrations, along with a number of soil and landscape variables at the observation locations, collected in a flood plain of the river Meuse, near the village of Stein (NL)
data(meuse)

# See how the meuse dataset is structured
meuse

# Look at the first 6 rows of the set
# "head()" function shows the head (first rows/columns)
head(meuse)  
# Use "tail()" for the last rows/columns

# With "attach()" function database is attached to the R search path 
# This means that the database is searched by R when evaluating a variable, so objects in the database can be accessed by simply giving their names
attach(meuse)

# Plot two variables to see if the zinc concentration is related to that of copper
# "plot()" is function for X-Y plotting of R objects
plot(zinc, copper) 

# Use "col = " argument to set a color to your plot
plot(zinc, copper, col = "green")

# change symbols with "pch = " argument. You can find numbers of different symbols online
plot(zinc, copper, col = "green", pch = 19)

# change the scale of symbols with "cex = " argument 
plot(zinc, copper, col = "green", pch = 19, cex = 2)

####################################################################################

####################################################################################
# R_code_multipanel.r
# Multipanel in R:
# Correlations between different environmental variables
####################################################################################

# Install package "sp" if not installed 
# "install.packages()" function is used to download and install packages from CRAN-like repositories or from local files
# "sp" package provides S4 classes for importing, manipulating and exporting spatial data in R
# install.packages("sp")

# install package "GGally"
# "GGally" extends "ggplot2" by adding several functions to reduce the complexity of combining geometric objects with transformed data. 
install.packages("GGally")

# Require installed package
# "library()" or "require()" functions will load and attach add-on packages
library(GGally)
library(sp) 

# Call pre-loaded data set "meuse"
# "data()" function loads specified data sets, or list the available data sets
# "Meuse" data set gives locations and topsoil heavy metal concentrations, along with a number of soil and landscape variables at the observation locations, collected in a flood plain of the river Meuse, near the village of Stein (NL)
data(meuse) 

# With "attach()" function database is attached to the R search path 
# This means that the database is searched by R when evaluating a variable, so objects in the database can be accessed by simply giving their names
# You can undo it with "detach()" if needed
attach(meuse)

# Exercise: see the names of the variables and plot cadmium versus zinc
names(meuse) 

# Look at the first 6 rows of the set
# "head()" function shows the head (first rows/columns)
head(meuse)  
# Use "tail()" for the last rows/columns

# Plot cadmium vs zinc
# "plot()" is function for X-Y plotting of R objects
plot(cadmium, zinc, pch = 15, col = "red", cex = 2)

# Exercise: make all the possible pairwise plots of the data set. 
# plot(x,cadmium)
# plot(x,zinc)
# plot....
# plot is not a good idea in this case. It takes too many lines to get the job done

# Use "pairs()" function instead
# "pairs()" function produces a matrix of scatterplots 
pairs(meuse) # in case you receive the error "the size is too large" just reshape the graph window with the mouse and relaunch the code

# Reduce the amount of variables
# "~" for grouping
pairs(~ cadmium + copper + lead + zinc, data = meuse) 

# "[" for creating subset, "," for from, ":" for to
pairs(meuse[,3:6])

# Exercise: pretify the graph
# You can use the same arguments that we used for "plot()" function in the previous script
pairs(meuse[,3:6], col = "red", pch = 18, cex = 1.5)

# GGally package for prettifying the graph works better than manually selecting all the features
# "ggpairs" function makes a matrix of plots with a given data set
ggpairs(meuse[,3:6])

####################################################################################

####################################################################################
# R_code_spatial.r
# Spatial view of points
####################################################################################

# install required packages for the session (no need to install packages that you already have in your workspace)
# install.packages("sp")

# The easiest way to get "ggplot2" is to install the whole "tidyverse"
# install.packages("tidyverse")

# Alternatively, install just "ggplot2"
install.packages("ggplot2")

# Or the development version from GitHub
# install.packages("devtools")
# devtools::install_github("tidyverse/ggplot2")
# "ggplot2" is a system for declaratively creating graphics, based on "The Grammar of Graphics"
# You provide the data, tell "ggplot2" how to map variables to aesthetics, what graphical primitives to use, and it takes care of the details

# require installed packages
library(sp)
library(ggplot2)

# Load the pre-loaded "meuse" data set
data(meuse)

# Check the first 6 rows of the data set
head(meuse)

# Set spatial coordinates to create a spatial object, or retrieve spatial coordinates from a spatial object with "coordinates()" function
coordinates(meuse) = ~ x + y   

# Plot the object
plot(meuse)

# "spplot()" function used for lattice (trellis) plot methods for spatial data with attributes
spplot(meuse, "zinc")

# Exercise: plot the spatial amount of copper and add the title "Copper concentration"
# "main = " argument is used to create an overall title for the plot
spplot(meuse, "copper", main = "Copper concentration")

# Create a bubble plot of spatial data. Size of the bubbles are directly related to the amount of concentration
# "bubble()" function creates a bubble plot of spatial data, with options for bicolor residual plots (xyplot wrapper)
bubble(meuse, "zinc")
bubble(meuse, "zinc", main = "Zinc concentration")

# Exercise: use "bubble()" function to plot copper, add red color to the bubbles
bubble(meuse, "copper", main = "Copper concentration", col = "red")

### Importing new data

# Download covid_agg.csv from our IOL website and build a folder called /lab/ into C: or directly into home folder in case of Linux based operation systems
# Put the covid_agg.csv file directly into the /lab/ folder

# Setting the working directory to the /lab/
# Windows
# setwd("C:/lab/")
# Mac users
# setwd("/Users/username/lab/")
# Linux users 
setwd("~/lab")

# Read downloaded table with "read.table()" function. 
# "read.table()" function reads a file in table format and creates a data frame from it
# "header" is set to "TRUE" if and only if the first row contains one fewer field than the number of columns
covid <- read.table("covid_agg.csv", head = TRUE)

# See the first 6 rows
head(covid)

# Attach the data frame
attach(covid)

# Plot the data frame
plot(country, cases) # or plot with "plot(covid$country, covid$cases)" if you don't want to attach the data frame

# Change the orientation of labels with "las = " argument
plot(country, cases, las = 0) # parallel labels
plot(country, cases, las = 1) # horizontal labels
plot(country, cases, las = 2) # perpendicular labels
plot(country, cases, las = 3) # vertical labels

# Adjust the size of the axis label numbers/text with a numeric value with "cex.axis = " argument
plot(country, cases, las = 3, cex.axis = 0.5)
plot(country, cases, las = 3, cex.axis = 0.7)

# Save the .RData under the menu File
# For Windows users: save as "yourprefferredname.RData"

# Importing new data
# Set the working directory: /lab/
# Windows users
# setwd("C:/lab/")
# Mac users
# setwd("/Users/username/lab/")
# Linux users
setwd("~/lab")

# Load the previously saved workspace .RData
load(.RData) # load("C:/lab/.RData") for Windows

# Check the files: look for covid
# "ls()" function returns a vector of character strings giving the names of the objects in the specified environment
ls() 

# Require the previously installed library
library(ggplot2)

data(mpg) # data set contains a subset of the fuel economy data that the EPA makes available on http://fueleconomy.gov 

# See the first 6 rows
head(mpg)

# When using "ggplot()" function start with ggplot(), 
# supply a dataset and aesthetic mapping (with aes()).
# You then add on layers (like geom_point() or geom_histogram()), 
# scales (like scale_colour_brewer()), 
# faceting specifications (like facet_wrap()) and coordinate systems (like coord_flip())

# Key components in our plot: data, aes, geometry
ggplot(mpg, aes(x = displ, y = hwy)) + geom_point() # showing data in points
ggplot(mpg, aes(x = displ, y = hwy)) + geom_line() # showing data in lines
ggplot(mpg, aes(x = displ, y = hwy)) + geom_polygon() # showing data in polygons

# Check the previously downloaded "covid" data
head(covid)

# using the "ggplot()" function on the "covid" data, number of cases correlated to the size of points
ggplot(covid, aes(x = lon, y = lat, size = cases)) + geom_point()
## for more info about ggplot: https://ggplot2.tidyverse.org/index.html

####################################################################################

####################################################################################
# R_code_point_pattern_analysis.r
# Point Pattern Analysis: Density map
####################################################################################

# Set the working directory: /lab/
# Windows
# setwd("C:/lab/")
# Mac users
# setwd("/Users/username/lab/")
# Linux users
setwd("~/lab")

# Install packages "spatstat" and "rgdal"
# "spatstat" is mainly designed for analysing spatial point patterns
# "rgdal" provides bindings to the Geospatial Data Abstraction Library "(GDAL)" and access to projection/transformation operations from the "PROJ" library
install.packages(c("spatstat", "rgdal"))

# Require downloaded packages
library(spatstat)
library(rgdal)

# Import the data set 
covid <- read.table("covid_agg.csv", head = TRUE)

# Attach the data set
attach(covid)

# Check the first 6 lines (head) of the data
head(covid)

# Set the coordinates of the vectors in covids in relation to the global map (minimum and maximum latitude and longitude)
# "ppp()" creates an object of class "ppp" representing a point pattern dataset in the two-dimensional plane
covids <-ppp(lon, lat, c(-180, 180), c(-90, 90)) # c for clustering

# In case you do not want to attach the covid data set use the following script
# covids <- ppp(covid$lon, covid$lat, c(-180,180), c(-90,90))

# density plots are usually a much more effective way to view the distribution of a variable
## You can directly create the plot using plot(density())
d <- density(covids)

# plot the density map
plot(d)

# Draw a sequence of points of cases on the plot
points(covids)

### Part 2
# set the working directory: /lab/
# Windows
# setwd("C:/lab/")
# Mac users
# setwd("/Users/username/lab/")
# Linux users
setwd("~/lab")

# Load previous workspace
load(".RData")

# List all the objects
ls()

# covids: point pattern
# d: density map

# Require libraries
library(spatstat) 
library(rgdal) # in case you do no have the package, first install and then require it

# Plot the density map
plot(d)

# Add points on the plot
points(covids)

# Let’s input vector lines (x0y0, x1y1, x2y2..)
# Inputting the coastlines, download from the IOL website and then extract directly to your working directory
# Assign a name to the object and read it
# "readOGR()" function reads an OGR data source and layer into a suitable Spatial vector object
coastlines <- readOGR("ne_10m_coastline.shp")

# Add coastlines to the plot, argument "add = " is used in order not to delete precedent results
plot(coastlines, add = TRUE)

# Or you can do as following
# install.packages("rnaturalearth")
# library(rnaturalearth)
# coastlines <- rnaturalearth::ne_download(scale = 10, type = "coastline", category = "physical")

# Changing the colorRampPalette, assign the name for the object (cl as color) 
# then add colors respectively from lower number to higher number of cases
# 100 is the number of colors in between, for creating more consistent palette use higher numbers

cl <- colorRampPalette(c("yellow", "orange", "red"))(100)
plot(d, col = cl, main = "Densities of Covid-19")
points(covids)
plot(coastlines, add = TRUE)

# Exercise: create a new color palette
clr <- colorRampPalette(c("#2F2C62", "#42399B", "#4A52A7", "#59AFEA", "#7BCEB8", "#A7DA64","#EFF121", "#F5952D", "#E93131", "#D70131", "#D70131"))(100)
plot(d, col = clr, main = "Densities of Covid-19")
points(covids)
plot(coastlines, add = TRUE)

# Export pdf file. "pdf()" function starts the graphics device driver for producing PDF graphics
pdf("covid_density.pdf")
clr <- colorRampPalette(c("light green", "yellow", "orange", "violet")) (100)
plot(d, col = clr, main = "Densities of covid-19")
points(covids)
plot(coastlines, add = TRUE)
dev.off() # Shuts down a graphics device 

# Export png file 
png("covid_density.png")
clr <- colorRampPalette(c("light green", "yellow","orange","violet")) (100)
plot(d, col = clr, main = "Densities of covid-19")
points(covids)
plot(coastlines, add = TRUE)
dev.off()

####################################################################################

####################################################################################
# R_code_multivariate.r
# Multivariate analysis
####################################################################################

# Check/set working directory
getwd()
setwd("~/lab")

# Install vegetation analysis (vegan) package
# The "vegan" package provides tools for descriptive community ecology
# It has most basic functions of diversity analysis, community ordination and dissimilarity analysis 
install.packages("vegan")

# Require package
library(vegan) #or require(vegan)

# Import the data set and assign a name
# "header" is set to "TRUE" if and only if the first row contains one fewer field than the number of columns
# sep ="," in cvs file the variables are separated by comma, "biomes.cvs" is the data frame
biomes <- read.table("biomes.csv", header = TRUE, sep = ",")

# Take a look at the "biomes" data set
view(biomes) #or you can see the first 6 lines by using head(biomes)

# Multivariate analysis
# DEtrended CORrespondence ANAlysis (DCA-decorana) is a multivariate statistical technique widely used by ecologists 
# to find the main factors or gradients in large, species-rich but usually sparse data matrices that typify ecological community data
# "decorana()" function performs DCA and basic reciprocal averaging or orthogonal correspondence analysis
multivar <- decorana(biomes)

# See the details of the analysis
multivar

# Eigenvalues = the percentage of data that we are able to see from this perspective
#                   DCA1   DCA2    DCA3    DCA4
# Eigenvalues     0.5117 0.3036 0.12125 0.14267
# Decorana values 0.5360 0.2869 0.08136 0.04814
# Axis lengths    3.7004 3.1166 1.30055 1.47888

# DCA1=0.5117 + DCA2=0.3036,  51%+30%=81%

# Plot your multivariate analysis
plot(multivar)

# read "biomes_types" table
biomes_types <- read.table("biomes_types.csv", header = TRUE, sep = "," )

# See the first 6 lines of the biome_types
head(biomes_types)

# Attach the data set "biomes_types"
attach(biomes_types)


# Draw an ellipse to connect all the points of a certain biome type
# Function "ordiellipse()" draws lines or polygons for ellipses by groups
# "type" - for the column (type)
# "col = 1:4" - for assigning colors for each biome
# type of the graph is called - ehull (ellipse hull)
# dimension of the line - "lwd = 3"
ordiellipse(multivar, type, col = 1:4, kind = "ehull", lwd = 3)

# To see with the labels of biomes
# Function "ordispider()" draws a spider diagram where each point is connected to the group centroid with segments
ordispider(multivar, type, col = 1:4, label = TRUE)

####################################################################################

####################################################################################
# R_code_remote_sensing.r
# Remote sensing and Principal Component Analysis
####################################################################################

# Set working directory: /lab/
# Windows
# setwd("C:/lab/")
# Mac users
# setwd("/Users/username/lab/")
# Linux users
setwd("~/lab")

# Install packages for the session
# install.packages("raster")
library(raster)

# "RStoolbox" is a package providing a wide range of tools for your every-day remote sensing processing needs
# Available tool-set covers many aspects from data import, pre-processing, data analysis, image classification and graphical display
install.packages("RStoolbox") 

# You can install multiple packages with following function
# install.packages(c("RStoolbox", "raster"))

# Require installed packages
library(RStoolbox)

# Use "RasterBrick" function to import the image
# It is used for importing  a multi-layer raster object. In this case multi-layer = different bands of reflectance
# (p for path, r for row, in the name of the image, for ex: p224r63)
p224r63_2011 <- brick("p224r63_2011_masked.grd")

# Plot the image
plot(p224r63_2011)

# Current image is from Landsat satellite explaining different bands and their wavelength
# You can use this as a reference
# Resolution of the image is 30 m
# Landsat 7 band designations
# Band 1 Visible blue (0.45 - 0.52 µm) 30 m
# Band 2 Visible green (0.52 - 0.60 µm) 30 m
# Band 3 Visible red (0.63 - 0.69 µm) 30 m
# Band 4 Near-Infrared (0.77 - 0.90 µm) 30 m
# Band 5 Near-Infrared (1.55 - 1.75 µm) 30 m
# Band 6 Thermal (10.40 - 12.50 µm) 60 m Low Gain / High Gain
# Band 7 Mid-Infrared (2.08 - 2.35 µm) 30 m
# Band 8 Panchromatic (PAN) (0.52 - 0.90 µm) 15 m

# Create a new color palette with "colorRampPalette()" function
# Function is useful for converting hand-designed sequential or diverging color schemes into continous color ramps
cl <- colorRampPalette(c("black", "grey", "light grey"))(100) 

# Plot image with the new color palette
plot(p224r63_2011, col = cl)

# Create a multiframe plot with "par()" function. Each band will be associated with different palette
# "par()" function can be used to set or query graphical parameters
# 2,2 means a 2x2 multiframe plot, where you will have 4 plots. You can set it as 4,1 as well
par(mfrow = c(2, 2)) # or par(mfrow=c(4,1))

# Create a new color palette
clb <- colorRampPalette(c("dark blue", "blue", "light blue"))(100) 

# Plot the 1st band with the latest color palette
# $B1_sre for linking layer 1 of the RasterBrick
plot(p224r63_2011$B1_sre, col = clb)

# Create a new color palette and plot the 2nd band
clg <- colorRampPalette(c("dark green", "green", "light green"))(100)
plot(p224r63_2011$B2_sre, col = clg)

# Do the same for 3rd and 4th band
clr <- colorRampPalette(c("dark red", "red", "pink"))(100)
plot(p224r63_2011$B3_sre, col = clr)

cln <- colorRampPalette(c("red", "orange", "yellow"))(100) 
plot(p224r63_2011$B4_sre, col = cln)

# Plot as human eyes perceive
# First close the multiframe graph using following function
dev.off()

# "plotRGB()" makes a Red-Green-Blue plot based on three layers (in a RasterBrick or RasterStack). 
# Three layers (sometimes referred to as "bands" because they may represent different bandwidths 
# in the electromagnetic spectrum) are combined such that they represent the red, green and blue channel
# R stands for "red", G for "green" and B (yeah you guessed it) for "blue"
# "stretch = " argument is an option to stretch the values to increase the contrast of the image: "lin" or "hist"
# Associate each band with RGB. Look at the reference to know the band values
plotRGB(p224r63_2011, r = 3, g = 2, b = 1, stretch = "Lin")


# In case if you want to use the NIR you have to shift bands, because function allows you to plot 3 components at a time
# Healthy vegetations reflect more NIR 
# Because NIR is on top of red component (r = 4), you see NIR as red. Stronger red color, means more vegetation
# Pinkish parts are agricultural fields. You can clearly see the deforestation in the plot
plotRGB(p224r63_2011, r = 4, g = 3, b = 2, stretch = "Lin")

# Exercise: mount NIR on top the green and blue components of RGB
plotRGB(p224r63_2011, r = 3, g = 4, b = 2, stretch = "Lin")
plotRGB(p224r63_2011, r = 3, g = 2, b = 4, stretch = "Lin")


# Import the 1988 image by brick function
p224r63_1988 <- brick("p224r63_1988_masked.grd")

# Create a multiframe graph and plot 2 images to compare. Mount NIR on top of red
# You clearly see the effect of human activity that lead to deforestation
par(mfrow = c(2, 1))
plotRGB(p224r63_1988, r = 4, g = 3, b = 2, stretch = "Lin")
plotRGB(p224r63_2011, r = 4, g = 3, b = 2, stretch = "Lin")

# Use "stretch = "hist"" argument to enhance the noise (clouds, humidity)
# High amount of noise/humidity is associated with high evapotranspiration
par(mfrow = c(2, 1))
plotRGB(p224r63_1988, r = 4, g = 3, b = 2, stretch = "hist")
plotRGB(p224r63_2011, r = 4, g = 3, b = 2, stretch = "hist")

# Vegetation Indices are some mathematical combination or transformation of spectral bands 
# that accentuates the spectral properties of green plants so that they appear distinct from other image features
# Calculate DVI (Difference Vegetation Index) for the two years: compare with a difference in time
# DVI is calculated by difference between NIR reflectance and Red reflectance ( DVI = NIR - RED)
# normalized difference vegetation index NDVI = (NIR - RED) / (NIR - RED)

dvi1988 <- p224r63_1988$B4_sre - p224r63_1988$B3_sre
dvi2011 <- p224r63_2011$B4_sre - p224r63_2011$B3_sre

# Create a multiframe graph and plot 2 images for comparison
par(mfrow = c(2, 1))
plot(dvi1988)
plot(dvi2011)

# Create a new palette and plot images
par(mfrow = c(2, 1))
cldvi <- colorRampPalette(c("red", "orange", "yellow"))(100)  
plot(dvi1988, col = cldvi)
plot(dvi2011, col = cldvi)


# Calculate the difference between 2011 and 1988 DVI
difdvi <- dvi2011 - dvi1988
cldif <- colorRampPalette(c("blue", "white", "red"))(100) 
plot(difdvi, col = cldif)

# Change in the resolution of the data can change the perception 
# High resolution data is not good for all cases. Sometimes high resolution data can provoke higher amount of noise which will create some errors
# Also high resolution data weighs more
# Resolution in remote sensing associated with the pixels. Grain is the dimensions of a pixel
# "aggregate()" function for lowering the resolution and resampling the pixel size by the factor of 10 and 100

p224r63_2011res <- aggregate(p224r63_2011, fact = 10)
p224r63_2011res100 <- aggregate(p224r63_2011, fact = 100)

# for info about the image just type the name of the image
p224r63_2011 # resolution is 30 by 30 metres
p224r63_2011res100 # resolution is 3000 by 3000 metres

# Now see the difference between aggregated and original image
par(mfrow = c(2, 1))
plotRGB(p224r63_2011, r = 4, g = 3, b = 2, stretch="Lin")
plotRGB(p224r63_2011res, r = 4, g = 3, b = 2, stretch="Lin")

# Exercise: plot original and resampled x10, x100
par(mfrow = c(3, 1))
plotRGB(p224r63_2011, r = 4, g = 3, b = 2, stretch = "Lin")
plotRGB(p224r63_2011res, r = 4, g = 3, b = 2, stretch = "Lin")
plotRGB(p224r63_2011res100, r = 4, g = 3, b = 2, stretch = "Lin")

####################################################################################

####################################################################################
# R_code_ecosystem_functions.r
# R code to view biomass over the world and calculate changes in ecosystem functions
####################################################################################

# Today we will need several packages, so as a lazy person I will use a shortcut for installing and requiring them
# "easypackages" package makes it easy to load by "libraries()" or install by "packages()" function multiple packages in R
install.packages("easypackages")
library(easypackages)

# Now we can move onto the second part
# Install and require multiple packages for the session
# "rasterdiv" provides functions to calculate indices of diversity on numerical matrices based on information theory
# "rasterVis" provides methods for enhanced visualization and interaction with raster data
# It also provides methods to display spatiotemporal rasters, and vector fields
# "lattice" is a powerful and elegant high-level data visualization system inspired by Trellis graphics, with an emphasis on multivariate data

packages("rasterdiv", "rasterVis", "lattice")
libraries("rasterdiv", "rasterVis", "lattice")

# Use the pre-loaded data (dataset is the Copernicus Long-term (1999-2017) average Normalise Difference Vegetation Index (copNDVI))
data("copNDVI")

# Plot the pre-loaded data
plot(copNDVI)

# Remove the values (blue part of the plot) with "reclassify()" function, which (re)classifies groups of values to other values
# Water pixels 253, 255, NA are removed by using cbind argument
copNDVI <- reclassify(copNDVI, cbind(253:255, NA), right = TRUE)

# Plot an impressive grapg usin "levelplot()" which Level and contour plots of Raster objects with lattice methods and marginal plots with grid objects
levelplot(copNDVI)

# Aggregate the object by factor of 10
copNDVI10 <- aggregate(copNDVI, fact = 10)
levelplot(copNDVI10)

# Aggregate 100 times
copNDVI100 <- aggregate(copNDVI, fact=100)
levelplot(copNDVI100)

# Result: lower resolution, smoother graph

### An impressive map 
# additional script (not necessary for the lecture)
# library(ggplot2)
# myPalette <- colorRampPalette(c("white","green","dark green")) 
# sc <- scale_colour_gradientn(colours = myPalette(100), limits=c(1, 8))
# ggR(copNDVI, geom_raster = TRUE) + scale_fill_gradientn(name = "NDVI", colours = myPalette(100))+ labs(x="Longitude",y="Latitude", fill="")+ theme(legend.position = "bottom") +  NULL + ggtitle("NDVI")
###

# Download the "defor1", "defor2" from the IOL website (Deforestation in the Amazon forest)

# Setting the working directory to the /lab/
# Windows
# setwd("C:/lab/")
# Mac users
# setwd("/Users/username/lab/")
# Linux users 
setwd("~/lab")

# Require the library
library(raster)

# Import downloaded images by using "brick()" function
# You can find info about the function/s in the previous scripts (use Ctrl+F to search)
defor1<-brick("defor1_.jpg.png")

defor2<-brick("defor2_.jpg.png")

# Band1: NIR; image layer: defor1_.1/defor2_.1
# Band2: red; image layer: defor1_.2/defor2_.2
# Band3: green

# Plot RGB of both images
# You can find info about the function/s in the previous scripts (use Ctrl+F to search)
plotRGB(defor1, r = 1, g = 2, b = 3, stretch = "Lin")

plotRGB(defor2, r = 1, g = 2, b = 3, stretch = "Lin")

# Create multiframe graph for side to side comparison
# Now you can see the deforestation clearly

par(mfrow = c(1, 2))
plotRGB(defor1, r = 1, g = 2, b = 3, stretch = "Lin")
plotRGB(defor2, r = 1, g = 2, b = 3, stretch = "Lin")


# DVI calculation for each image
# If you write defor1 or defor2 in console you will have information about the objects
# Look at the names: section, this shows the layers which are associated with bands
# Bands for each image as following
# band1: NIR, defor1_.1, defor2_.1
# band2: red, defor1_.2, defor2_.2
# band3: green defor1_.3, defor2_.3
# $ sign to link layers (bands)
# You can find info about the function/s in the previous scripts (use Ctrl+F to search)
dvi1 <- defor1$defor1_.jpg.1 - defor1$defor1_.jpg.2
dvi2 <- defor2$defor2_.jpg.1 - defor2$defor2_.jpg.2

# Create a new color palette for having better visualization 
cldefor <- colorRampPalette(c("darkblue", "yellow", "red", "black"))(100) 

# plot DVI calculations
par(mfrow = c(1, 2))
plot(dvi1, col = cldefor)
plot(dvi2, col = cldefor)

# difference in DVI between dvi1 and dvi2

difdvi <- dvi1 - dvi2

dev.off()  # close the graphical device

# New color palette
cld <- colorRampPalette(c("blue", "white", "red"))(100) 

# Plot the difference in DVI of 2 images with the latest color palette
plot(difdvi, col = cld) # Now you can observe the loss of vegetation which is related to the ecosystem functions


# Plot the histrogram of the difference in DVI to see the loss
# Function "hist()" computes a histogram of the given data values
hist(difdvi)

####################################################################################

####################################################################################
# R_code_pca_remote_sensing.r
# Multivariate analysis in remote sensing
####################################################################################

# Setting the working directory to the /lab/
# Windows
# setwd("C:/lab/")
# Mac users
# setwd("/Users/username/lab/")
# Linux users 
setwd("~/lab")

# Require libraries for the session. You already should have all of the packages installed
library(raster)
library(RStoolbox)
library(ggplot2)


# Import the image with "brick()" function. It is already in the lab folder. We used it in previous lectures
p224r63_2011 <- brick("p224r63_2011_masked.grd")


# Landsat 7 band designations
# Band 1 Visible blue (0.45 - 0.52 µm) 30 m
# Band 2 Visible green (0.52 - 0.60 µm) 30 m
# Band 3 Visible red (0.63 - 0.69 µm) 30 m
# Band 4 Near-Infrared (0.77 - 0.90 µm) 30 m
# Band 5 Near-Infrared (1.55 - 1.75 µm) 30 m
# Band 6 Thermal (10.40 - 12.50 µm) 60 m Low Gain / High Gain
# Band 7 Mid-Infrared (2.08 - 2.35 µm) 30 m
# Band 8 Panchromatic (PAN) (0.52 - 0.90 µm) 15 m

# Plot the image RGB (mount NIR/4th band on green component)
# You should be familiar with the function and arguments. If not, check previous scripts (Ctrl+F)
plotRGB(p224r63_2011, r = 5, g = 4, b = 3, stretch = "Lin")

# Plot the image ggplot2
# "ggRGB()" calculates RGB color composite raster for plotting with ggplot2
# Use Landsat 7 bands designation as a reference
ggRGB(p224r63_2011, 5, 4, 3)

# Do the same with 1988 image: import, plotRGB, ggRGB
p224r63_1988 <- brick("p224r63_1988_masked.grd")
plotRGB(p224r63_1988, r = 5, g = 4, b = 3, stretch = "Lin")
ggRGB(p224r63_1988, 5, 4, 3)

# Now create a multiframe graph for side to side comparison
# For info about function search the previous scripts 
par(mfrow = c(1, 2))
plotRGB(p224r63_2011, r = 5, g = 4, b = 3, stretch = "Lin")
plotRGB(p224r63_1988, r = 5, g = 4, b = 3, stretch = "Lin")
dev.off()

# PCA (principal component analysis)
# Reducing dimensions (nlayers)

# Check the names of the bands of the image 
# "B1_sre" "B2_sre" "B3_sre" "B4_sre" "B5_sre" "B6_bt"  "B7_sre"
names(p224r63_2011)

# Check the correlation between variables (B1_sre, B3_sre)
# "pairs()" function can be used as well
plot(p224r63_2011$B1_sre, p224r63_2011$B3_sre)

# Check the information about the image
p224r63_2011

# Decrease the resolution for PCA by "aggregate()" function (fact = 10)
# It is done for faster calculation
p224r63_2011_res <- aggregate(p224r63_2011, fact = 10)

# "RStoolbox" now needed for PCA
# "rasterPCA" calculates R-mode PCA for RasterBricks or RasterStacks and returns a RasterBrick with multiple layers of PCA scores
# Principal component analysis (PCA) is a technique for reducing the dimensionality of such datasets, 
# increasing interpretability but at the same time minimizing information loss. 
# It does so by creating new uncorrelated variables that successively maximize variance
p224r63_2011_pca <- rasterPCA(p224r63_2011_res)

# Check the info ($call, $model, $map)
p224r63_2011_pca

# Plot the map of p224r63_2011_pca
# To see which image has the most amount of information (in this case PC1)
cl <- colorRampPalette(c("dark grey", "grey", "light grey"))(100) 
plot(p224r63_2011_pca$map, col = cl) 

# Call the summary of the model
summary(p224r63_2011_pca$model) #PC1 99.83% of the whole variation

# See the correlation
pairs(p224r63_2011)

# Plot the PCA map (assign each principal component to the RGB)
plotRGB(p224r63_2011_pca$map, r = 1, g = 2, b = 3, stretch = "Lin")


# Do the same for 1988 image
p224r63_1988_res <- aggregate(p224r63_1988, fact = 10)
p224r63_1988_pca <- rasterPCA(p224r63_1988_res) 
plot(p224r63_1988_pca$map, col = cl)
summary(p224r63_1988_pca$model) # also in this case there is a high correlation PC1
pairs(p224r63_1988)

# Calculate the difference in the PCA to see the changes
difpca <- p224r63_2011_pca$map - p224r63_1988_pca$map
plot(difpca)


# With the final plot you can see the highest variation
cldif <- colorRampPalette(c("blue", "black", "yellow"))(100) 
plot(difpca$PC1, col = cldif)

####################################################################################

####################################################################################
# R_code_radiance.r
# Coding ecosystems" reflectances 
####################################################################################

# Bit example

# Require libraries
library(raster)

# Create a new raster: 2 columns x 2 rows and assign a name
toy <- raster(ncol = 2, nrow = 2, xmn = 1, xmx = 2, ymn = 1, ymx = 2)

# Assign values to the each cell
values(toy) <- c(1.13, 1.44, 1.55, 3.4)

# Plot the raster and add label with "toy()" function and 
# "digits = " argument for indicating numbers after decimal
plot(toy)
text(toy, digits = 2)

# Use "stretch()" function, which provides the desired output range (minv and maxv) 
# and the lower and upper bounds in the original data
toy2bits <- stretch(toy, minv = 0, maxv = 3)

# Set the type or storage mode of the object. In our case it is integer
# With decimal numbers satellite images can weigh a lot
storage.mode(toy2bits[]) = "integer"

# Now plot and add information as we did
plot(toy2bits)
text(toy2bits, digits = 2)

# Now 4 bits
toy4bits <- stretch(toy, minv = 0, maxv = 15)
storage.mode(toy4bits[]) = "integer"
plot(toy4bits)
text(toy4bits, digits = 2)

# 8 bits
toy8bits <- stretch(toy, minv = 0, maxv = 255)
storage.mode(toy8bits[]) = "integer"
plot(toy8bits)
text(toy8bits, digits = 2)

# More bits, more the diversity between pixels

# Create a multiframe graph and plot altogether
par(mfrow = c(1, 4))

plot(toy)
text(toy, digits = 2)

plot(toy2bits)
text(toy2bits, digits = 2)

plot(toy4bits)
text(toy4bits, digits = 2)

plot(toy8bits)
text(toy8bits, digits = 2)

dev.off() # close the graphical device

# Additional information
library(rasterdiv)
plot(copNDVI)
copNDVI # values are ranging from 0 - 255, so data is stored in 8 bits

####################################################################################

####################################################################################
# R_code_faPAR.r
# Look at a chemical cycling from a satellite
####################################################################################

# Set working directory
setwd("~/lab/")

# Require already installed libraries
library(raster)
library(rasterVis)
library(rasterdiv)

# Plot pre-loaded dataset. You should be familiar with it from previous scripts
plot(copNDVI)

# Remove the values (blue part of the plot) with "reclassify()" function, which (re)classifies groups of values to other values
# Water pixels 253, 255, NA are removed by using cbind argument
copNDVI <- reclassify(copNDVI, cbind (253:255, NA))

# Plot reclassified image
plot(copNDVI)

# Plot an impressive graph usin "levelplot()" which Level and contour plots of Raster objects with lattice methods and marginal plots with grid objects
# "levelplot()" creates the average of the values on the horizontal and the vertical line of pixels and plots it as a graph on the side
levelplot(copNDVI)

# Import the data (already aggregated)
# faPAR: Fraction of Absorbed Photosynthetically Active Radiation. 
# It is a proxy of carbon dioxide assimilation and canopy"s energy absorption capacity
faPAR10 <- raster("faPAR10.tif")

# Levelplot
# Structure of the forests around the equator is a lot complex than the forests in the northern part of the world (like taigas)
# This complex structure explains why the levelplot done with faPAR is different from the NDVI levelplot 
# In the northern forests the most of the light is absorbed by soil because of the poor structure of the forest (no vertical structure complexity)
levelplot(faPAR10)


# Export PDF
pdf("copNDVI.pdf")
levelplot(copNDVI)
dev.off()

pdf("faPAR10.pdf")
levelplot(faPAR10)
dev.off()

# Day 2

# Set working directory
setwd("~/lab/")

# Load the workspace
load(".RData")

# List all the objects in the workspace
ls()

# The original faPAR file from Copernicus is 2 GB, let"s see how smaller is the file faPAR10 (aggregated)
faPAR10

#require libraries
library(raster)
library(rasterdiv)
library(rasterVis)

# Let"s see how much space is needed for 8-BIT set
# First check the range of dataset copNDVI
copNDVI 

# Write a raster data to file
# "writeRaster()" writes an entire Raster* object to a file, using one of the many supported formats (in this cas .tif)
# TIF file contains an image saved in the Tagged Image File Format (TIFF), a high-quality graphics format 
# It is often used for storing images with many colors, typically digital photos, and includes support for layers and multiple pages
writeRaster(copNDVI, "copNDVI.tif") #5.3 MB, that"s why we are using this files instead of original radiance files


# Day 3

# Regression model between faPAR and NDVI

# Create 2 variables: erosion of soil (kg / m2) and heavy metals (ppm)
erosion <- c(12, 14, 16, 24, 26, 40, 55, 67) 
hm <- c(30, 100, 150, 200, 260, 340, 460, 600) 

# Plot a generic plot and prettify it
# You should be familiar with this function and its" arguments from the 1st scripts 
plot(erosion, hm, col = "red", pch = 19, xlab = "erosion", ylab = "heavy metals", cex = 2)

# See the relation by using the linear model
# "lm()" can be used to carry out regression, single stratum analysis of variance and analysis of covariance 
# "lm(y ~ x)" - hm is y axis, and erosion x axis
model1 <- lm(hm ~ erosion)

# Call summary of the model to check the r-squared, p-value and etc.
summary(model1) 

# Linear model -> y=bx+a, b - is the slope, a - is the intercept
# R-squared is higher when the relation between the variables is higher (far from being random)
# p-value means how many times is it a random situation. If p is lower 0.01 means there is a lower probability that the pattern is random

# Include the linear model into the plot
# "abline()" adds one or more straight lines through the current plot
abline(model1)

# Set the working directory
setwd("~/lab/")

# Load the workspace
load(".RData")

# Require libraries
library(raster)
library(rasterdiv)
library(rasterVis)

# Install and require "sf" package to encode spatial vector data
install.packages("sf")
library(sf)

# Plot the "faPAR10" and "copNDVI"
plot(faPAR10)
plot(copNDVI)

# Check the number of cells in the "faPAR10"
faPAR10

# Random points from the image
# x is the raster file, n is the number of the random points
random.points <- function(x, n)
{
  lin <- rasterToContour(is.na(x))
  pol <- as(st_union(st_polygonize(st_as_sf(lin))), "Spatial") # st_union to dissolve geometries
  pts <- spsample(pol[1,], n, type = "random")
}

# Generate 1000 random points from the image, plot and add the points
pts <- random.points(faPAR10, 1000)
plot(faPAR10)
points(pts, col = "red", pch = 19)

# Passing values from the map to the sample
copNDVIp <- extract(copNDVI, pts)
faPAR10p <- extract(faPAR10, pts)

copNDVIp # to see the 1000 random points
faPAR10p 
dev.off()

# Photosynthesis vs Biomass
# Build a linear model between copNDVIp and faPAR10 (copNDVIp because the calculation is faster with less values)
# The line is calculated by reducing the distance between the points (x;y) in the graph
model2 <- lm(faPAR10p ~ copNDVIp)

# Call the summary of the model
summary(model2)

plot(copNDVIp, faPAR10p, col = "green", xlab = "biomass", ylab = "photosynthesis")
abline(model2, col = "red")
# Plot shows the previous patterns that we observed (check the levelplots of copNDVI and faPAR for more information)
levelplot(copNDVI)
levelplot(faPAR10)

####################################################################################

####################################################################################
# R_code_EBVs.r
# Dealing with Essential Biodiversity Variables
####################################################################################


# Download the data "snt_r10.tif" from the iol website (image is aggregated, 10 times)

# Set the working directory
setwd("~/lab/")

# Require libraries
library(raster)
library(RStoolbox)

# Import the downloaded satellite image by the brick function
# More info about the function is in the previous scripts
snt <- brick("snt_r10.tif")

snt # to see the characteristics of the image

# Plot the image (location: Boa Vista Brazil)
plot(snt)

# Current image is from Landsat satellite explaining different bands and their wavelength
# You can use this as a reference
# Resolution of the image is 30 m
# Landsat 7 band designations
# Band 1 Visible blue (0.45 - 0.52 µm) 30 m
# Band 2 Visible green (0.52 - 0.60 µm) 30 m
# Band 3 Visible red (0.63 - 0.69 µm) 30 m
# Band 4 Near-Infrared (0.77 - 0.90 µm) 30 m
# Band 5 Near-Infrared (1.55 - 1.75 µm) 30 m
# Band 6 Thermal (10.40 - 12.50 µm) 60 m Low Gain / High Gain
# Band 7 Mid-Infrared (2.08 - 2.35 µm) 30 m
# Band 8 Panchromatic (PAN) (0.52 - 0.90 µm) 15 m

# PlotRGB 
plotRGB(snt, 3, 2, 1, stretch = "lin")

# Put the NIR band on top of the red component
plotRGB(snt, 4, 3, 2, stretch = "lin")

# To see relations between different bands
pairs(snt)

### PCA 
# "rasterPCA" calculates R-mode PCA for RasterBricks or RasterStacks and returns a RasterBrick with multiple layers of PCA scores
# Principal component analysis (PCA) is a technique for reducing the dimensionality of such datasets, 
# increasing interpretability but at the same time minimizing information loss. 
# It does so by creating new uncorrelated variables that successively maximize variance
sntpca <- rasterPCA(snt)

# Information about the output of the model, in other words the percentage of variance related to the components
summary(sntpca$model) # 1st band has the highest amount of information, 70%

# Plot the map
plot(sntpca$map) 
plotRGB(sntpca$map, 1, 2, 3, stretch = "lin")

# Set the moving window 5x5
# Calculte the standard deviation using a moving window (5x5)
# A matrix that moves by 5x5 pixel and the result is 1 final pixel. It reduces the calculation of focal function
window <- matrix(1, nrow = 5, ncol = 5) 
window 

# "focal()" function uses values in a neighborhood of cells around a focal cell 
# and computes a value that is stored in the focal cell of the output RasterLayer (in our case the standard deviation)
sd_snt <- focal(sntpca$map$PC1, w = window, fun = sd) # w is the window that we are using, sd is the standard deviation

# Create a color palette
cl <- colorRampPalette(c("dark blue", "green", "orange", "red"))(100)

# Plot the result
plot(sd_snt, col = cl)
dev.off()

# Create a multiframe graph to make comparison
par(mfrow = c(1, 2))
plotRGB(snt, 4, 3, 2, stretch = "lin", main = "the original image")
plot(sd_snt, col = cl, main = "diversity")
# More diversity is observed on the borders of the different ecosystems

# Day 2

# Download the "cladonia_stellaris_calaita.JPG" from the IOL website to the lab folder

# Set working directory
setwd("~/lab/")

# Require libraries
library(raster)
library(RStoolbox)

# Brick the cladonia_stellaris_calaita.JPG and assign a name 
clad <- brick("cladonia_stellaris_calaita.JPG")

# Plot the image by using plotRGB function. Image will be plotted as we see it in real life
plotRGB(clad, 1, 2, 3, stretch = "lin") 

# Use pairs to see the relation
pairs(clad)

# PCA Analysis for the cladonia
# "rasterPCA" calculates R-mode PCA for RasterBricks or RasterStacks and returns a RasterBrick with multiple layers of PCA scores
# Principal component analysis (PCA) is a technique for reducing the dimensionality of such datasets, 
# increasing interpretability but at the same time minimizing information loss. 
# It does so by creating new uncorrelated variables that successively maximize variance
cladpca <- rasterPCA(clad)

# See the information of the PCA analysis
cladpca

# See the summary of the pca analysis
summary(cladpca$model) #98% by 1st component

# Plot the map of cladpca
plotRGB(cladpca$map, 1, 2, 3, stretch = "lin")

# Put the focal function on top of the image to measure biodiversity
# Build the moving window (3x3 matrix and set value for the pixel, in this case it is 1)
window <- matrix(1, nrow = 3, ncol = 3)

# Check the window
window

# Focal function can be applied also to an image directly taken in field: cladonia.jpg
# Standard deviation of the clad
# "focal()" function uses values in a neighborhood of cells around a focal cell 
# and computes a value that is stored in the focal cell of the output RasterLayer (in our case the standard deviation)
# w is the window that we are using, sd is the standard deviation
sd_clad <- focal(cladpca$map$PC1, w = window, fun = sd)

# You can also aggregate the "cladpca" andthen do the calculation of the standard deviation to accelerate the process
PC1_agg <- aggregate(cladpca$map$PC1, fact = 10)
sd_clad_agg <- focal(PC1_agg, w = window, fun = sd)

# Create a colorramppalette 
cl <- colorRampPalette(c("yellow", "violet", "black"))(100)

# Plot the calculations in multiframe graph
# All of the microvariations in the structure of the cladonia can be seen in these images 
par(mfrow = c(1, 2))
plot(sd_clad, col = cl)
plot(sd_clad_agg, col = cl) 


# For comparison create a multiframe graph and plot the image and SD
par(mfrow = c(1, 2))
plotRGB(clad, 1, 2, 3, stretch = "lin")
plot(sd_clad, col = cl) #or/ plot(sd_clad_agg, col = cl)

####################################################################################

####################################################################################
# R_code_snow.r
# Snow coverage from Copernicus Program
####################################################################################

# Set the working directory: lab
setwd("~/lab")

# Install packages 
# Using this package, netCDF files (either version 4 or "classic" version 3) can be opened and data sets read in easily. 
# It is also easy to create new netCDF dimensions, variables, and files, in either version 3 or 4 format, and manipulate existing netCDF files.
install.packages("ncdf4")

# Require libraries
library(ncdf4)
library(raster)

# Import the downloaded file (from: https://land.copernicus.vgt.vito.be/PDF/portal/Application.html) and assign a name
snowmay <- raster("c_gls_SCE_202005260000_NHEMI_VIIRS_V1.0.1.nc")

# Do not worry if you get the following warning message:
## Warning message:
# In .getCRSfromGridMap4(atts) : cannot process these parts of the CRS: 
# spatial_ref=GEOGCS["WGS 84",DATUM["WGS_1984",SPHEROID["WGS 84",6378137,298.257223563,AUTHORITY["EPSG","7030"]],
# AUTHORITY["EPSG","6326"]],PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.0174532925199433,
# AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","4326"]] GeoTransform=-180 0.01 0 84 0 -0.01

# Create a color ramp palette
cl <- colorRampPalette(c("darkblue","blue","light blue"))(100)

# Exercise: plot the snow cover with the color ramp palette
plot(snowmay, col = cl)

# See the characteristics of the image
snowmay

# Download the snow.zip from IOL website 
# Create a folder in the "lab" folder called "snow" and extract images directly to the "snow" folder

# Import the downloaded images
# There are 2 manners to do it
## slow manner

# First set the working directory to the "snow" folder
setwd("~/lab/snow/")

# Import the data with "raster()" function. One by one
# This function is used to create a RasterLayer object
snow2000 <- raster("snow2000r.tif")
snow2005 <- raster("snow2005r.tif")
snow2010 <- raster("snow2010r.tif")
snow2015 <- raster("snow2015r.tif")
snow2020 <- raster("snow2020r.tif")

# Then use "par()" function to create multiframe graphs and plot all the rasters
# 2 rows and 3 columns as we have 5 rasters to plot
par(mfrow = c(2, 3))
plot(snow2000, col = cl)
plot(snow2005, col = cl)
plot(snow2010, col = cl)
plot(snow2015, col = cl)
plot(snow2020, col = cl)

###
# Quick manner of importing and plotting the data set

# First create list of files with similar pattern by using "list.files()" function
# In this case similar pattern can be "snow20" as it is used for each image
# "list.files()" produce a character vector of the names of files or directories in the named directory
rlist <- list.files(pattern = "snow20")

# Check the list
rlist

# Use "laplly()" function over a list of vector to import them
import <- lapply(rlist, raster)

# Create a stack of the rasters for multitemporal analysis by using "stack()" function
# This function creates 1 layer raster from several
snow.multitemp <- stack(import)

# Check the information
snow.multitemp

# Plot the raster stack
plot(snow.multitemp, col = cl)

###
# Predicting the 2025 snow cover
# Go to the IOL website and download "prediction.r" into the folder "snow"
# Use "source()" function to run the "prediction.r"
source("prediction.r")

# or do it manually
# prediction
# Require libraries
# require(raster)
# require(rgdal)

# define the extent
# ext <- c(-180, 180, -90, 90)
# extension <- crop(snow.multitemp, ext)

# make a time variable (to be used in regression)
# time <- 1:nlayers(snow.multitemp)

# run the regression
# fun <- function(x) {if (is.na(x[1])){ NA } else {lm(x ~ time)$coefficients[2] }} 
# predicted.snow.2025 <- calc(extension, fun) # time consuming: make a pause!
# predicted.snow.2025.norm <- predicted.snow.2025*255/53.90828

# Plot the predicted snow cover for 2025
plot(predicted.snow.2025.norm, col = cl)

# Day 2

# Set the working directory: lab
setwd("~/lab/snow")

# Exercise: import all of the snow cover images altogether

# Require libraries
library(raster)

# First create list of files with similar pattern by using "list.files()" function
rlist <- list.files(pattern = "snow20")

# Check the list
rlist

# Use "laplly()" function over a list of vector
import <- lapply(rlist, raster)

# Create a stack of the rasters by using "stack()" function
snow.multitemp <- stack(import)

# Check the information
snow.multitemp

# Create a color ramp palette 
cl <- colorRampPalette(c("darkblue", "blue", "light blue"))(100)

# Plot the raster stack
plot(snow.multitemp, col = cl)

# If it took too long to run the source code named "prediction.r", download predicted.snow.2025.norm.tif from IOL website and put it into /lab/snow/
# Import the image into the R by using "raster()" function
prediction <- raster("predicted.2025.norm.tif")
plot(prediction, col=cl)

# Export the output of the calculations to be able to send it in a form of a simple .tif file to anyone by using "writeRaster()" function
# Write a raster data to file
# "writeRaster()" writes an entire Raster* object to a file, using one of the many supported formats (in this cas .tif)
# TIF file contains an image saved in the Tagged Image File Format (TIFF), a high-quality graphics format 
# It is often used for storing images with many colors, typically digital photos, and includes support for layers and multiple pages
writeRaster(prediction, "final.tif")

# You can also export a pdf with all of the data (snow.multitemp and prediction) 
# First create a final stack 
final.stack <- stack(snow.multitemp, prediction)

# Then plot it
plot(final.stack, col = cl)

# Now you can export it in a form of a .pdf/.png file
# Pdf (exported pdf files will have a better resolution)
pdf("my_final_exciting_graph.pdf")
plot(final.stack, col = cl)
dev.off()

# png
# You can increase the resolution of png by using additional arguments (for more info search for "png()" function in R documentation)
png("my_final_exciting_graph.png")
plot(final.stack, col = cl)
dev.off()

#### 
# 1:1 line with the snow data
setwd("~/lab/snow/")

# Fast version of import and plot of several images
rlist <- list.files(pattern = "snow20")
rlist
import <- lapply(rlist, raster)
snow.multitemp <- stack(import)

# Plot 2010 vs 2020
plot(snow.multitemp$snow2010r, snow.multitemp$snow2020r)
abline(0, 1, col = "red") # Because data is simulated the plot is strange

# Try 2000 vs 2020
plot(snow.multitemp$snow2010r, snow.multitemp$snow2020r)
abline(0, 1, col = "red") # In this case you can see the trend

####################################################################################

####################################################################################
# R_code_no2.r
# NO2 levels - before and after the COVID-19
####################################################################################

# Download NO2 data (EN.zip) from the IOL website
# Create a folder called /no2 folder in the /lab folder and put all the extracted data into the /no2 folder

# Set the working directory: /no2
setwd("~/lab/no2")

# Require libraries
library(raster)

# Quick manner of importing and plotting the data set

# First create list of files with similar pattern by using "list.files()" function
rlist <- list.files(pattern = "EN")

# Check the list
rlist

# Use "laplly()" function over a list of vector
import <- lapply(rlist, raster)

# Create a stack of the rasters by using "stack()" function
EN <- stack(import)

# Check the information of the stack
EN

# Create a colorRampPalette
cl <- colorRampPalette(c("red", "orange", "yellow"))(100)

# Plot the raster stack
plot(EN, col = cl)

# Plot the first and the last images (Jan and Mar)
# Create multiframe graph with "par()" function and then plot 
par(mfrow = c(1, 2))
plot(EN$EN_0001, col = cl)
plot(EN$EN_0013, col = cl)

# RGB space (apply RGB to 3 images, each image represent a period, EN_0001, EN_0007, EN_0013)
plotRGB(EN, r = 1, g = 7, b = 13, stretch = "lin")

# Calculate and create a difference map between first and the last image
dif <- EN$EN_0013-EN$EN_0001

# Create a new colorRampPalette
cld <- colorRampPalette(c("blue", "white", "red"))(100)

# Plot the difference map
plot(dif, col = cld)

# Quantitative estimate
# Creating a boxplot
# "boxplot()" function produces box-and-whisker plot(s) of the given (grouped) values
boxplot(EN)

# Remove outliers
boxplot(EN, outline = F)

# Make boxplots horizontal
boxplot(EN, outline = F, horizontal = T)

# Add axes
boxplot(EN, outline = F, horizontal = T, axes = T)
# There is a decrease in the maximum values, but not in the median

# Plot image 1 against image 13 (x = EN_0001, y = EN_0013)
plot(EN$EN_0001, EN$EN_0013)
abline(0, 1, col = "red")
# Most of values for each pixel is decreased, that's why most of the points are under the abline

####################################################################################

####################################################################################
# R_code_crop.r
# Change the extension of a raster image by using zoom or crop functions
####################################################################################

# Set the working directory
setwd("~/lab/")

# Require the libraries 
library(raster)
library(ncdf4) 

# Import the image and assign a name
snow <- raster("c_gls_SCE500_202005180000_CEURO_MODIS_V1.0.1.nc")

# Create a color palette
cl <- colorRampPalette(c("darkblue", "blue", "light blue"))(100)

# You can either crop or zoom into the focus part
# First, we need to specify which extent we want to zoom in, in the data/image
# (here we wanted to zoom in on Italy - so the numbers correspond to the size of Italy)
# The first two numbers are ranging in longitude
# The last two numbers are ranging in latitude
# Assign it the name: ext
ext <- c(0, 20, 35, 50) 

# Now make use of the function: zoom() - specify a region of a plot for expansion
# State which image you want to zoom
# The one we previously imported: snow
# State the extension: ext = (same name as the extension you previously made) ext
zoom(snow, ext = ext)

# Now make use of the function: crop() - image cropping from the center
# Assign it a name: snowitaly
# State which image you want to apply the function onto: snow
# State the previously made extension: ext
snowitaly <- crop(snow, ext)

# Now we should plot the image: plot()
# State the name of the image we want to plot: snowitaly
# Make use of the color ramp palette we created
plot(snowitaly, col = cl)

# Another example with the function zoom
# Instead of putting the previously made extension
# We will draw an extension: ext=drawExtent()
zoom(snow, ext = drawExtent())

# Click on a certain point in the image and draw your own rectangular
# This will be the zoom you make 

####################################################################################

####################################################################################
# R_code_interpolation.r
# Interpolation of field data
####################################################################################

# Steps for interpolation:
# step 1: explain to "spatstat" that you have coordinates: function "ppp"
# step 2: explain to "spatstat" that you have ecological data: function "marks"
# step 3: make the spatial map: function "Smooth"

# Download the "dati_plot55_LAST3.csv" from the IOL website and put it directly into the lab folder
# The data set contains information about Beech Forest

# Set the working directory
setwd("~/lab/")

# require the library 
library(spatstat) # if you do not have the package, first install it with "install.packages("spatstat")" and then require it

# Import the data with "read.table()" function
inp <- read.table("dati_plot55_LAST3.csv", sep = ";", head = T)

# Check the data with "head()" function
head(inp)

# Attach data frame by using "attach()" function for easy navigation
attach(inp)

# Plot the data by using "plot()" function, include coordinates into the function
plot(X,Y)

# Estimate canopy cover where it was not measured
# Look at the maximum and minimum value of coordinates (X, Y)
# Then use "ppp()" function to introduce coordinates and their range
summary()
inppp <- ppp(x = X, y = Y, c(716000, 718000), c(4859000, 4861000))

# Use "marks()" for introducing ecological data to R
marks(inppp) <- Canopy.cov

# Interpolate the data for not measured parts by using "Smooth()" function
# "Smooth()" is a generic function to perform spatial smoothing of spatial data
canopy <- Smooth(inppp)

# Plot the density map
plot(canopy)
points(inppp, col = "green")

# See the amount of lichens on trees / lichens can be related to the air quality
marks(inppp) <- cop.lich.mean
lichs <- Smooth(inppp)
plot(lichs)
points(inppp)

# Plot canopy and lichens in a multiframe graph
par(mfrow = c(1, 2))
plot(canopy)
points(inppp)
plot(lichs)
points(inppp) 
# It might be the case that lichens is negatively related with the canopy amount 

# Let's see the final output, density maps and the plot, to understand if there is a negative relationship
par(mfrow = c(1, 3))
plot(canopy)
points(inppp)
plot(lichs)
points(inppp)
plot(Canopy.cov, cop.lich.mean, col = "red", pch = 19, cex = 2)

# Second data set
# Download the "dati_psammofile.csv" from the IOL website and put it directly into the lab folder
# The data set contains information about  psammophilous 

# Import the data with "read.table()" function
inp.psam <- read.table("dati_psammofile.csv", sep = ";", head = T)

# Attach data frame by using "attach()" function for easy navigation
attach(inp.psam)

# Have a look at the dataset
head(inp.psam)

# Plot the dataset
plot(E, N) # you can observe clumped point pattern

# Look at the maximum and minimum value of coordinates (E, N) (E stands for East, N stands for North)
# then use "ppp()" function to introduce coordinates and their range
summary(inp.psam)
inp.psam.ppp <- ppp(x = E, y = N, c(356450, 372240), c(5059800, 5064150))

# C_org stands for organic carbon in the soil
# Higher organic carbon in the soil means higher amount of organisms
# Use "marks()" for introducing ecological data to R
marks(inp.psam.ppp) <- C_org

# Interpolate the data for not measured parts by using "Smooth()" function
C <- Smooth(inp.psam.ppp)
# Warning message: Numerical underflow detected: sigma is probably too small - means that there are few numbers for some parts of the spatial data

# Plot the density map
plot(C)
points(inp.psam.ppp, col = "white")

####################################################################################

####################################################################################
# R_code_sdm.r
# Species Distribution Modelling 
####################################################################################

# Install packages and require them
# "sdm" package is for developing species distribution models using individual 
# and community-based approaches, generate ensembles of models, evaluate the models, 
# and predict species potential distributions in space and time
install.packages(c("sdm", "raster", "rgdal"))
library(sdm)
library(raster)
library(rgdal)
# Use a shapefile containing presence=absence records for a species as spatial points (species.shp)
# and four raster datasets (in Ascii format) as explanatory variables (predictors). 
# The files are in the sdm library, so we can directly read them from the library folder.
# Get the location of the species shapefile 
file <- system.file("external/species.shp", package = "sdm") 

# Read the species shapefile using the function shapefile
species <- shapefile(file) #Spatial Points Data Frame

# Look at the properties of the species data frame
species 

# Species data frame contains presence-absence (1-0) information
species$Occurence 

# We can plot presence and absence points separately with different colours
# Plot the data frame with a condition making a subset from Occurence == 1
# condition starts with [] , == equal to , comma for ending the condition
plot(species[species$Occurrence == 1,], col = "blue", pch = 16)

# Add absences to the plot: Occurence == 0
points(species[species$Occurrence == 0,], col = "red", pch = 16)

# Import the predictors (environmental and ecological variables that will help to predict species presence)
path <- system.file("external", package = "sdm") 

# Create a list of all the files inside the external folder (inside the "sdm" package folder in R) with "ascii" file extension
lst <- list.files(path = path, pattern = "asc$", full.names = T)

# Look at the list to identify the files
lst # they are as following: elevation, precipitation, temperature and vegetation

# Create a stack of all the environmental variables
preds <- stack(lst)

# Create a color palette and plot with new palette
cl <- colorRampPalette(c("blue", "orange", "red", "yellow")) (100)
plot(preds, col = cl)

# Let's see the plot with the species inside 
# First plot the environmental variables, then add species presence. 
# In this way you will understand which environmental variables in which way affects the species distribution

# elevation + presence
plot(preds$elevation, col = cl)
points(species[species$Occurrence == 1,], pch = 16) # low elevation

# temperature + presence
plot(preds$temperature, col = cl)
points(species[species$Occurrence == 1,], pch = 16) # high temperature

# precipitation + presence
plot(preds$precipitation, col = cl) 
points(species[species$Occurrence == 1,], pch = 16) # medium precipitation

# vegetation + presence
plot(preds$vegetation, col = cl)
points(species[species$Occurrence == 1,], pch = 16) # medium vegetation

# Model fitting
# Create a model with all the environmental variables 
# First explain to the package which data is which by using train - for species and predictors for environmental variables
d <- sdmData(train = species, predictors = preds)
d # have a look at the model

# Create a generalized linear model with all the environmental variables and data set
m1 <- sdm(Occurrence ~ elevation + precipitation + temperature + vegetation, data = d, methods = "glm") 

# Create the prediction model
# Predict the distribution of the species. Predicting sdm using the method set m1 using the object preds
p1 <- predict(m1, newdata = preds)

# Plot the prediction model and add the data about species
plot(p1, col = cl)
points(species[species$Occurrence == 1,], pch = 16)

# Create a stack with environmental variables and prediction model and plot to see the relation
s1 <- stack(preds, p1)
plot(s1, col = cl)

####################################################################################
