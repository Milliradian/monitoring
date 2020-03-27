### Multipanel in R: the second lecture of monitoring Ecosystems

install.packages("sp")
install.packages("GGally")
library(GGally)
library(sp) #r require(sp) will also do the job

data(meuse) # there is a dataset available named meuse


attach(meuse)

# Exercise: see the names of the variables and plot cadmium versus zinc
# There are two ways to see the names of the variables:
names(meuse)
head(meuse) # show only the first 6 lines
plot(cadmium,zinc,pch=15,col="red",cex=2)
# Exercise: make all the possible pairwise plots of the dataset
pairs(meuse)
# Reduce the amount of variables
# ~ for grouping
pairs(~cadmium+copper+lead+zinc,data=meuse)
# [ for creating subset, , for from, : for to
pairs(meuse[,3:6])

# Exercise: pretify the graph
pairs(meuse[,3:6],col="red",pch=18,cex=1.5)

# GGally package for prettifying the graph
ggpairs(meuse[,3:6])

