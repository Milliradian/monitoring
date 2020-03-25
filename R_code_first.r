install.packages("sp")

library("sp")
data(meuse)

# Let's see how the meuse dataset is structured:
meuse

# Let's look at the first rows of the set
head(meuse)

# Let's plot two variables
# Let's see if the zinc concentration is related to that of copper
attach(meuse)
plot(zinc,copper)
plot(zinc,copper,col="green")
plot(zinc,copper,col="green",pch=19)
plot(zinc,copper,col="green",pch=19,cex=2)
