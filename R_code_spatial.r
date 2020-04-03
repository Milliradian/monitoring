# R code for spatial view of points

install.packages("sp")
library(sp)

data(meuse)

head(meuse)

# coordinates
coordinates(meuse) = ~x+y      # alt+126

plot(meuse)

spplot(meuse, "zinc")

# Exercise: plot the spatial amount of copper
spplot(meuse, "copper", main="Copper concentration")

bubble(meuse, "zinc")
bubble(meuse, "zinc", main="Zinc concentration")

# Exercise: bubble copper in red
bubble(meuse, "copper", main="Cppoer concentration", col="red")

#### Importing new data

# download covid_agg.csv from our teaching site and build a folder called lab into C: 
# put the covid_agg.csv file into the folder lab

# setting the working directory: lab
# Windows
# setwd("C:/lab/")
# Mac users
# setwd("/Users/yourname/lab/")
# Linux users
setwd("~/lab")

covid <- read.table("covid_agg.csv", head=T)
head(covid)

attach(covid)
plot(country,cases)

# plot(covid$country,covid$cases)

plot(country, cases, las=0) # parallel labels
plot(country, cases, las=1) # horizontal labels
plot(country, cases, las=2) # perpendicular labels
plot(country, cases, las=3) # vertical labels

plot(country, cases, las=3, cex.axis=0.5)
plot(country, cases, las=3, cex.axis=0.7)

# ggplot2 package
install.packages("ggplot2")
library(ggplot2)  # require(ggplot2)
install.packages("ggplot2")

# If ggplot2 cannot be found by the software: install the devtools package and then install 
# install.packages("devtools")
# devtools::install_github("tidyverse/ggplot2")

# save the .RData under the menu File
# for Windows users: save as "yourprefferredname.RData"=
