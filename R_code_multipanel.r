### Multipanel in R: the second lecture. Correlations about different environmental variables 

# install package 'sp'. This package provides S4 classes for importing, manipulating and exporting spatial data in R
# install package 'GGally'. 'GGally' extends 'ggplot2' by adding several functions to reduce the complexity of combining geometric objects with transformed data. 
install.packages("sp")
install.packages("GGally")

# you can require packages by using one of these functions: library(), require()
library(GGally)
library(sp) 

# load pre-loaded 'meuse' data set.
# The meuse is a classical geostatistical data set used frequently by the creator of the gstat package to demonstrate various geostatistical analysis steps. 
data(meuse) 

# attach database to the R search path by using 'attach()' function. You can undo it with 'detach()' if needed
attach(meuse)

# Exercise: see the names of the variables and plot cadmium versus zinc
# There are two ways to see the names of the variables
names(meuse)
head(meuse) # shows only the first 6 lines

# Plot cadmium vs zinc
plot(cadmium,zinc,pch=15,col="red",cex=2)

# Exercise: make all the possible pairwise plots of the dataset. 
# plot(x,cadmium)
# plot(x,zinc)
# plot....
# plot is not a good idea in this case. It takes too many lines to get the job done.

# use 'pairs()' function instead
# 'pairs()' function produces a matrix of scatterplots 
pairs(meuse) # in case you receive the error "the size is too large" just reshape the graph window with the mouse and relaunch the code

# Reduce the amount of variables
# '~' for grouping
pairs(~cadmium+copper+lead+zinc,data=meuse) 

# '[' for creating subset, ',' for from, ':' for to
pairs(meuse[,3:6])

# Exercise: pretify the graph
pairs(meuse[,3:6],col="red",pch=18,cex=1.5)

# GGally package for prettifying the graph works better than manually selecting all the features
# 'ggpairs()' function makes a matrix of plots with a given data set
ggpairs(meuse[,3:6])

