# R code for multivariate analysis

# check/set working directory

getwd()
setwd("C:/lab/")

# instal vegetation analysis (vegan) package
install.packages("vegan")

# require package
library(vegan) #or require(vegan)

# import the dataset and assign a name 

biomes <- read.table("biomes.csv", header = T, sep=",")


# take a look at the biomes dataset

View(biomes) #or you can see the first 6 lines by using head(biomes)

# multivariate analysis
# DEtrended CORrespondence ANAlysis
multivar <- decorana(biomes)

# see the details of the analysis
multivar

# Eigenvalues show the amount of the perception of each dimension

# plot your multivariate analysis

plot(multivar)

# read biomes_types table

biomes_types <- read.table("biomes_types.csv", header = T, sep="," )

# see the first 6 lines of the biome_types
head(biomes_types)

# attach the dataset biomes_types
attach(biomes_types)

# draw an ellipse to connect all the points of a certain biome type
# type - for the column (type)
# col=1:4 - for assigning colors for each biome
# type of the graph is called - ehull (ellipse hull)
# dimension of the line - lwd=3
ordiellipse(multivar, type, col=1:4, kind = "ehull", lwd=3)

# to see with the labels of biomes
ordispider(multivar, type, col=1:4, label = T)


