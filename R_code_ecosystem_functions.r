# R code to view biomass over the world and calculate changes in ecosystem functions

# energy
# chemical cycling
# proxies

install.packages("rasterdiv")
install.packages("rasterVis")

library("rasterdiv")
library("rasterVis")

# data

data("copNDVI")

plot(copNDVI)

# remove the values (blue part of the plot)

copNDVI <- reclassify(copNDVI, cbind(253:255, NA), right=TRUE)

# use levelplot
levelplot(copNDVI)

# change the grain size 10 times

copNDVI10 <- aggregate(copNDVI, fact=10)
levelplot(copNDVI10)

# 100 times

copNDVI100 <- aggregate(copNDVI, fact=100)
levelplot(copNDVI100)

# result: lower resolution, smoother the graph

########
# additional script (not included in the lecture)

# library(ggplot2)

# myPalette <- colorRampPalette(c('white','green','dark green')) 
# sc <- scale_colour_gradientn(colours = myPalette(100), limits=c(1, 8))


# ggR(copNDVI, geom_raster = TRUE) + scale_fill_gradientn(name = "NDVI", colours = myPalette(100))+ labs(x="Longitude",y="Latitude", fill="")+ theme(legend.position = "bottom") +  NULL + ggtitle("NDVI")


########

# download data (defor images 1 and 2) from the iol website (defor-deforestation)

setwd("C:/lab/")

library(raster)

# import

defor1<-brick("defor1_.jpg.png")

defor2<-brick("defor2_.jpg.png")

# band1: NIR, defor1_.1
# band2: red, defor1_.2
# band3: green

# Plot RGB of both images

plotRGB(defor1, r=1, g=2, b=3, stretch="Lin")

plotRGB(defor2, r=1, g=2, b=3, stretch="Lin")

# create multiframe for better comparison

par(mfrow=c(1,2))
plotRGB(defor1, r=1, g=2, b=3, stretch="Lin")
plotRGB(defor2, r=1, g=2, b=3, stretch="Lin")


# DVI calculation for each band and each image

# band1: NIR, defor1_.1, defor2_.1
# band2: red, defor1_.2, defor2_.2
# band3: green

dvi1 <- defor1$defor1_.jpg.1 - defor1$defor1_.jpg.2
dvi2 <- defor2$defor2_.jpg.1 - defor2$defor2_.jpg.2

cldefor <- colorRampPalette(c('darkblue','yellow','red','black'))(100) # specifying a color scheme

# plot DVI calcs

par(mfrow=c(1,2))
plot(dvi1, col=cldefor)
plot(dvi2, col=cldefor)

# difference in DVI between dvi1 and dvi2

difdvi <- dvi1 - dvi2

dev.off()

cld <- colorRampPalette(c('blue','white','red'))(100) 

plot(difdvi, col=cld)


# plot the histrogram functionf of the difference of the DVI

hist(difdvi)


