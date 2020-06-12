# Species Distribution Modelling 

# install packages and require them
install.packages("sdm")
install.packages("raster")
install.packages("rgdal")
library(sdm)
library(raster)
library(rgdal)

# create a shape file
file <- system.file("external/species.shp", package="sdm") 
species <- shapefile(file) #Spatial Points Data Frame

# look at the properties of the species data frame
species 

# species data frame contains presence-absence (1-0) 
species$Occurence 

# Plot the data frame with a condition making a subset from Occurence == 1
plot(species[species$Occurrence == 1,],col='blue',pch=16)

# add absences to the plot 
points(species[species$Occurrence == 0,],col='red',pch=16)

# import the predictors (environmental and ecological variables that will help to predict species presence)
path <- system.file("external", package="sdm") 

# create a list of all the files inside the external folder (inside the sdm package folder in R) with ascii file extension
lst <- list.files(path=path,pattern='asc$',full.names = T)

# look at the list to identify the files
lst # they are as following: elevation, precipitation, temperature and vegetation

# create a stack of all the environmental variables
preds <- stack(lst)

# create a colorRampPalette and plot with new palette
cl <- colorRampPalette(c('blue','orange','red','yellow')) (100)
plot(preds, col=cl)

# let's see the plot with the species inside (first plot the environmental variables, then add species presence. In this way you will understand which environmental variables in which way affects the species distribution

# elevation + presence
plot(preds$elevation, col=cl)
points(species[species$Occurrence == 1,], pch=16)

# temperature + presence
plot(preds$temperature, col=cl)
points(species[species$Occurrence == 1,], pch=16)

# precipitation + presence
plot(preds$precipitation, col=cl)
points(species[species$Occurrence == 1,], pch=16)

# vegetation + presence
plot(preds$vegetation, col=cl)
points(species[species$Occurrence == 1,], pch=16)

# create a model with all the environmental variables. First explain to the package which data is which by using train - for species and predictors for environmental variables
d <- sdmData(train=species, predictors=preds)
d # have a look at the model

# create a generalized linear model with all the environmental variables and data set
m1 <- sdm(Occurrence ~ elevation + precipitation + temperature + vegetation, data=d, methods='glm') 

# create the prediction model
p1 <- predict(m1, newdata=preds)

# plot the prediction model and add the data about species
plot(p1, col=cl)
points(species[species$Occurrence == 1,], pch=16)

# create a stack with environmental variables and prediction model
s1 <- stack(preds,p1)
plot(s1, col=cl)

