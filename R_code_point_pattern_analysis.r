# Point Pattern Analysis: Density map

install.packages("spatstat")
library(spatstat) 

# attaching the dataset
attach(covid)

# check the first 6 lines (head) of the data
head(covid)

# 
covids <- ppp(lon, lat, c(-180,180), c(-90,90))

# without attaching the covid set
# covids <- ppp(covid$lon, covid$lat, c(-180,180), c(-90,90))

d <- density(covids)

plot(d)
points(covids)

