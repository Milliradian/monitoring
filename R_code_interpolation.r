# Interpolation

# Steps for interpolation:
# step 1: explain to spatstat that you have coordinates: function ppp
# step 2: explain to spatstat that you have ecological data: function marks
# step 3: make the spatial map: function Smooth

# Download the 'dati_plot55_LAST3.csv' from the IOL website and put it directly into the lab folder
# the data set contains information about Beech Forest

# Set the working directory
setwd("~/lab/")
# setwd("/Users/username/lab") #mac
# setwd("C:/lab/") # windows

# require the library 
library(spatstat) # if you do not have the package, first install it with 'install.packages("spatstat")' and then require it

# import the data with 'read.table()' function
inp <- read.table("dati_plot55_LAST3.csv", sep=";", head=T)

# check the data with 'head()' function
head(inp)

# attach data frame by using 'attach()' function for easy navigation
attach(inp)

# plot the data by using 'plot()' function, include coordinates into the function
plot(X,Y)

# estimate canopy cover where it was not measured
# look at the maximum and minimum value of coordinates (X,Y)
# then use 'ppp()' function to introduce coordinates and their range
summary()
inppp <- ppp(x=X,y=Y,c(716000,718000),c(4859000,4861000))

# use 'marks()' for introducing ecological data to R
marks(inppp) <- Canopy.cov

# interpolate the data for not measured parts by using 'Smooth()' function
canopy <- Smooth(inppp)

# plot the density map
plot(canopy)
points(inppp, col="green")

# see the amount of lichens on trees
marks(inppp) <- cop.lich.mean
lichs <- Smooth(inppp)
plot(lichs)
points(inppp)

# plot canopy and lichnes
par(mfrow=c(1,2))
plot(canopy)
points(inppp)
plot(lichs)
points(inppp) 
# it might be the case that lichens is negatively related with the canopy amount 

# let's see the final output, density maps and the plot, to understand if there is a negative relationship
par(mfrow=c(1,3))
plot(canopy)
points(inppp)
plot(lichs)
points(inppp)
plot(Canopy.cov, cop.lich.mean, col="red", pch=19, cex=2)

####
# Download the 'dati_psammofile.csv' from the IOL website and put it directly into the lab folder
# the data set contains information about  psammophilous 

# import the data with 'read.table()' function
inp.psam <- read.table("dati_psammofile.csv", sep=";", head=T)

# attach data frame by using 'attach()' function for easy navigation
attach(inp.psam)

# have a look at the dataset
head(inp.psam)

# plot the dataset
plot(E,N) # you can observe clumped point pattern

# look at the maximum and minimum value of coordinates (E,N) (E stands for East, N stands for North)
# then use 'ppp()' function to introduce coordinates and their range
summary(inp.psam)
inp.psam.ppp <- ppp(x=E,y=N,c(356450,372240),c(5059800,5064150))

# C_org stands for organic carbon in the soil

# use 'marks()' for introducing ecological data to R
marks(inp.psam.ppp) <- C_org

# interpolate the data for not measured parts by using 'Smooth()' function
C <- Smooth(inp.psam.ppp)
# Warning message: Numerical underflow detected: sigma is probably too small - means that there are few numbers for some parts of the spatial data

# plot the density map
plot(C)
points(inp.psam.ppp, col="white")

