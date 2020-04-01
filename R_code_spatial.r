########## R spatial

# spatial frame
class(meuse)

# coordinates
coordinates(meuse) = ~x+y
class(meuse)

plot(meuse)

spplot(meuse, "zinc", main = "zinc concentrations (ppm)")

# Exercise: Plot Copper as a spplot

    
#### Spatial plots
             
bubble(meuse, "zinc")

bubble(meuse, "zinc", col="blue", main = "zinc concentrations (ppm)")

# EXERCISE: bubble copper in red


################ covid data
# https://services.arcgis.com/5T5nSi527N4F7luB/arcgis/rest/services/COVID_19_HistoricCasesByCountry(pt)View/FeatureServer
library(ggplot2)

setwd("~/lab")
# setwd("/Users/utente/lab") #mac
# setwd("C:/lab/") # windows

covid <- read.table("covid_agg.csv", head=T)


# importare dati
covid <- read.table("covid_agg.csv", head=T)

head(covid)

plot(covid$country,covid$cases) 
# attach(covid) 
# plot(country,cases)

plot(covid$country,covid$cases,las=0) # parallel labels
plot(covid$country,covid$cases,las=1) # horizontal labels
plot(covid$country,covid$cases,las=2) # perpendicular labels
plot(covid$country,covid$cases,las=3) # vertical labels

plot(covid$country,covid$cases,las=3,cex.lab=0.5, cex.axis=0.5) # vertical labels


# ggplot2
data(mpg)
head(mpg)

# data
# aes
# tipo di geometria
ggplot(mpg,aes(x=displ,y=hwy)) + geom_point()
ggplot(mpg,aes(x=displ,y=hwy)) + geom_line()
ggplot(mpg,aes(x=displ,y=hwy)) + geom_polygon()

# ggplot di covid
ggplot(covid,aes(x=lon,y=lat,size=cases)) + geom_point()

# density
# create dataset for spatstat
attach(covid)
covids <- ppp(lon, lat, c(-180,180), c(-90,90))

d <- density(covids)

plot(d)
points(covids)
