# Introduction to the R Software and the Free and Open Source philosophy: how to deal with R making your first code!

# install package 'sp'
install.packages("sp")

# require installed package
library("sp")

# call pre-loaded data set
data(meuse)

# See how the meuse dataset is structured
meuse

# Look at the first 6 rows of the set
head(meuse)

# Plot two variables
# See if the zinc concentration is related to that of copper
attach(meuse)
plot(zinc,copper)

# set color to your plot by 'col' function
plot(zinc,copper,col="green")

# change symbols with 'pch' function
plot(zinc,copper,col="green",pch=19)

# change the scale of symbols with 'cex' function
plot(zinc,copper,col="green",pch=19,cex=2)
