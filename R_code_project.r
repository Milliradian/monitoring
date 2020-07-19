################################### Monitoring of Caspian Sea ##############################

################################### Sea level ##############################################

setwd("~/Downloads/Casp/sealevel/")
library (rjson)
library(GGally)
caspj <- fromJSON(file = "c_gls_WL_202007081808_CASPIAN_ALTI_V2.1.0.json")
caspdata <- caspj[["data"]]
cp_df <- do.call(rbind.data.frame, caspdata)
cp_df$datetime <- as.Date(cp_df$datetime, "%Y/%m/%d")

ggplot(cp_df, aes(x = time, 
                  y=water_surface_height_above_reference_datum)) + 
  geom_point(col = "aquamarine3", size = 1.2) + 
  xlab(NULL) + ylab("meters (m)") + 
  labs(title = "Caspian Sea", 
       subtitle = "Observed Sea Level Change: 1992-2020", 
       caption = "(based on data from Copernicus Global Land Service)") + 
  theme_linedraw(base_size = 13) + 
  theme(axis.text = element_text(colour = "black", size = rel(0.9))) + 
  geom_hline(yintercept = min(cp_df$water_surface_height_above_reference_datum), 
             linetype = "dashed", color = "red") + 
  geom_smooth(method = "loess", ) + scale_x_continuous(n.breaks = 10) + 
  scale_y_continuous(n.breaks = 8) + 
  annotate(geom = "curve", x = 1998, y = -26, xend = 1995.538, yend = -25.87, 
           color = "indianred2", lwd=1.3,
           curvature = .4, arrow = arrow(length = unit(2, "mm"))) +
  annotate(geom = "text", x = 1998, y = -26, 
           label = "The highest level in last 50 years", 
           size=4.5, hjust = "left")


################################### Caspian time series ##############################################

library(dplyr)
library(lubridate)

cp_df2 = select(cp_df, -1, -2, -5)
colnames(cp_df2) <- c("date", "sealevel")

cp_df2$date <- floor_date(cp_df2$date, "month")
cp_df2$date <- as.Date(cp_df2$date, "%Y/%m/%d" )
cp_df3 <-aggregate( sealevel ~ date , cp_df2, mean )
ts1 <- ts(cp_df3$sealevel, start = c(1992, 9), frequency = 12)

plot(decompose(ts1)) 

################################### forecast ##############################################

library(forecast)
library(tseries)

autoArimaFit <- auto.arima(ts1, stationary = F, seasonal = T)

plot(forecast(autoArimaFit, h = 24),
     type = "l", col = "aquamarine4", lwd = 2,
     main = "CSL forecast for 2021-2022",
     col.main="gray2", font.main = 2, cex.main = 1.5,
     ylab = "meters (m)", xlab = "years")

legend("bottomleft", legend = c("Observed","Forecasted"), 
       col = c("aquamarine4", "blue"), text.font = 3, 
       bty = "n", lty = 1, lwd = 2, cex = 1)

grid(col = "gray", lty = "dotted")

################################### river level ##############################################

setwd("~/Downloads/Casp/riverlevel/")
library(rjson)
library(GGally)
volgaj<-fromJSON(file = "c_gls_WL_202007110030_0000000011934_ALTI_V2.1.0.json")
volgadata <- volgaj[["data"]]
vg_df <- do.call(rbind.data.frame, volgadata)
vg_df$datetime <- as.Date(vg_df$datetime, "%Y/%m/%d" )

ggplot(vg_df, aes(x = time, y = water_surface_height_above_reference_datum)) + 
  geom_line(col = "aquamarine4", size = 1.2) + 
  xlab(NULL) + ylab("meters (m)") + 
  labs(title = "Volga River", 
       subtitle = "Observed Water Level Change: 2008-2020", 
       caption = "(based on data from Copernicus Global Land Service)") +
  theme_linedraw(base_size = 13) + 
  theme(axis.text = element_text(colour = "black", size = rel(0.9))) + 
  geom_smooth(method = "lm", ) + 
  scale_x_continuous(n.breaks = 8) +
  scale_y_continuous(n.breaks = 8)
  
################################### Volga time series ##############################################

library(dplyr)
library(lubridate)
vg_df2 = select(vg_df, -1, -2, -5)
colnames(vg_df2) <- c("date", "riverlevel")

vg_df2$date <- floor_date(vg_df2$date, "month")
vg_df2$date <- as.Date(vg_df2$date, "%Y/%m/%d" )
vg_df3 <-aggregate( riverlevel ~ date , vg_df2, mean )
volts <- ts(vg_df3$riverlevel, start = c(2008, 7), frequency = 12)

plot(decompose(volts))

################################### Comparison ##############################################

library(readxl)
library(lubridate)
library(ggplot2)
library(ggpubr)

volga_df <- readxl::read_excel("~/Downloads/volgadata.xlsx")
casp_df <- readxl::read_excel("~/Downloads/caspdata.xlsx")
casp_df$datetime <- as.Date(casp_df$datetime, "%Y/%m/%d" )
volga_df$datetime <- as.Date(volga_df$datetime, "%Y/%m/%d" )

casp_df$datetime <- floor_date(casp_df$datetime, "month")
casp_df$datetime <- as.Date(casp_df$datetime, "%Y/%m/%d" )
volga_df$datetime <- floor_date(volga_df$datetime, "month")
volga_df$datetime <- as.Date(volga_df$datetime, "%Y/%m/%d" )

casp_agg <- aggregate(
  casp_df$water_surface_height_above_reference_datum ~ casp_df$datetime , 
  casp_df, mean)
volga_agg <- aggregate(
  volga_df$water_surface_height_above_reference_datum ~ volga_df$datetime , 
  volga_df, mean)

colnames(casp_agg) <- c("date", "waterlevelcasp")
colnames(volga_agg) <- c("date", "waterlevelvolga")

comb <- data.frame(casp_agg$date, 
                   casp_agg$waterlevelcasp, 
                   volga_agg$waterlevelvolga)
colnames(comb) <- c("date", "sealevel","riverlevel")

ggplot(comb, aes(x=date)) + 
  geom_line(aes(y = sealevel), color = "darkred") + 
  geom_line(aes(y = riverlevel), color="steelblue")+ 
  theme_linedraw(base_size = 13) + 
  theme(axis.text = element_text(colour = "black", size = rel(0.9)))+
  xlab("years") + ylab("meters (m)") + 
  labs(title = "Volga River and Caspian Sea", 
       subtitle = "Observed Water Level Change: 2008-2020", 
       caption = "(based on data from Copernicus Global Land Service)")
     

################################### Correlation ##############################################

ggscatter(comb, x = "sealevel", y = "riverlevel", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Caspian Sea", ylab = "Volga",
          main = "Correlation Analysis")
  
caspts <- ts(comb$sealevel, start = c(2009, 1), frequency = 12)
plot(decompose(caspts))

volgats <- ts(comb$riverlevel, start = c(2009, 1), requency = 12)
plot(decompose(volgats))

################################### SST ##############################################


setwd("~/Downloads/Casp/sst/")
library(raster)

ext <- c(46, 55, 36, 48) 

cl <- colorRampPalette(c("darkblue","blue1", "yellow", 
                         "red", "brown"))(100)

sst_list <- list.files(pattern = "MODISA")
sst <- lapply(sst_list, raster, full.names=T)

names(sst) <- c("Mean SST 2003", "Mean SST 2008", 
                "Mean SST 2013", "Mean SST 2018")

sst.multitemp <- stack(sst)
sst.mult.crop <- crop(sst.multitemp, ext)
plot(sst.mult.crop, col=cl)

cld <- colorRampPalette(c("mediumblue", "royalblue", "seagreen4", 
                          "lawngreen", "orange1", "orangered4" ))(100)
diff <- sst.mult.crop$SST.2018 - sst.mult.crop$SST.2003
plot(diff, col=cld, main = 
       "Difference between Mean Annual SST 2018-2003")
    
     
       
boxplot(sst.mult.crop, outline = F, 
        axes = T, las=1, main = "Mean Annual SST Variations")

plot(sst.mult.crop$Mean.SST.2003, sst.mult.crop$Mean.SST.2018, 
     xlab="SST 2003", ylab="SST 2018", main = "Plot Points Variation")
abline(0, 1, col = "red")

################################### SSS ##############################################

setwd("~/Downloads/Casp/sss/")
library(raster)
library(ncdf4)

ext <- c(47, 54, 37, 47) 
cl <- colorRampPalette(c("blue", "yellow", 
                         "red", "brown"))(100)
cld <- colorRampPalette(c("blue", "lightgreen", 
                          "red"))(100)
                          
# 2019
sal2019_list <- list.files(pattern = "SSS_L3_monthly_2019")
sal.2019 <- lapply(sal2018_list, raster, 
                   varname = "sss_smap", full.names=T)
sal.2019 <- stack(sal.2019)
mean.sal.2019 <- calc(sal.2019, fun = mean, na.rm = T)
mean.sal.2019.crop <- crop(mean.sal.2019, ext)
writeRaster(mean.sal.2019.crop, 
            "mean.sal.2019.crop.tif", overwrite = T)


par(mfrow=c(2,2))
plot(mean.sal.2016.crop, col = cld, main = "Mean SSS 2016")
plot(mean.sal.2017.crop, col = cld, main = "Mean SSS 2017")
plot(mean.sal.2018.crop, col = cld, main = "Mean SSS 2018")
plot(mean.sal.2019.crop, col = cld, main = "Mean SSS 2019")

plot(mean.sal.2019.crop - mean.sal.2016.crop, col = cl, 
     main = "Difference between Mean Annual SSS 2019-2016")
     
     
################################### Occurrence ##############################################


setwd("~/Downloads/")
library(easypackages)
libraries("rgdal", "gdalUtils", 
          "raster", "RStoolbox")

a <- c("occurrence_40E_50Nv1_1_2019.tif", 
       "occurrence_50E_50Nv1_1_2019.tif", 
       "occurrence_40E_40Nv1_1_2019.tif", 
       "occurrence_50E_40Nv1_1_2019.tif")

e <- extent(40, 60, 30, 50) 
template <- raster(e)
proj4string(template) <- CRS('+proj=longlat')
writeRaster(template, file = "Caspian.tif", 
            format = "GTiff", overwrite = T)
mosaic_rasters(gdalfile = a, 
               dst_dataset = "Caspian.tif", 
               of = "GTiff")

occurrence <- raster("Caspian.tif")
ext <- c(46, 55, 36, 48) 
occurrence.crop <- crop(occurrence, ext)
cl <- colorRampPalette(c("white", "red", 
                         "blue"))(100)
plot(occurrence.crop, col = cl)



################################### Sea level ##############################################


setwd("~/Downloads/Casp/sealevel/")
library (rjson)
library(GGally)
caspj <- fromJSON(file = "c_gls_WL_202007081808_CASPIAN_ALTI_V2.1.0.json")
caspdata <- caspj[["data"]]
cp_df <- do.call(rbind.data.frame, caspdata)
cp_df$datetime <- as.Date(cp_df$datetime, "%Y/%m/%d")

ggplot(cp_df, aes(x = time, 
                  y=water_surface_height_above_reference_datum)) + 
  geom_point(col = "aquamarine3", size = 1.2) + 
  xlab(NULL) + ylab("meters (m)") + 
  labs(title = "Caspian Sea", 
       subtitle = "Observed Sea Level Change: 1992-2020", 
       caption = "(based on data from Copernicus Global Land Service)") + 
  theme_linedraw(base_size = 13) + 
  theme(axis.text = element_text(colour = "black", size = rel(0.9))) + 
  geom_hline(yintercept = min(cp_df$water_surface_height_above_reference_datum), 
             linetype = "dashed", color = "red") + 
  geom_smooth(method = "loess", ) + scale_x_continuous(n.breaks = 10) + 
  scale_y_continuous(n.breaks = 8) + 
  annotate(geom = "curve", x = 1998, y = -26, xend = 1995.538, yend = -25.87, 
           color = "indianred2", lwd=1.3,
           curvature = .4, arrow = arrow(length = unit(2, "mm"))) +
  annotate(geom = "text", x = 1998, y = -26, 
           label = "The highest level in last 50 years", 
           size=4.5, hjust = "left")


################################### Caspian time series ##############################################

library(dplyr)
library(lubridate)

cp_df2 = select(cp_df, -1, -2, -5)
colnames(cp_df2) <- c("date", "sealevel")

cp_df2$date <- floor_date(cp_df2$date, "month")
cp_df2$date <- as.Date(cp_df2$date, "%Y/%m/%d" )
cp_df3 <-aggregate( sealevel ~ date , cp_df2, mean )
ts1 <- ts(cp_df3$sealevel, start = c(1992, 9), frequency = 12)

plot(decompose(ts1)) 

################################### forecast ##############################################

library(forecast)
library(tseries)

autoArimaFit <- auto.arima(ts1, stationary = F, seasonal = T)

plot(forecast(autoArimaFit, h = 24),
     type = "l", col = "aquamarine4", lwd = 2,
     main = "CSL forecast for 2021-2022",
     col.main="gray2", font.main = 2, cex.main = 1.5,
     ylab = "meters (m)", xlab = "years")

legend("bottomleft", legend = c("Observed","Forecasted"), 
       col = c("aquamarine4", "blue"), text.font = 3, 
       bty = "n", lty = 1, lwd = 2, cex = 1)

grid(col = "gray", lty = "dotted")

################################### river level ##############################################

setwd("~/Downloads/Casp/riverlevel/")
library(rjson)
library(GGally)
volgaj<-fromJSON(file = "c_gls_WL_202007110030_0000000011934_ALTI_V2.1.0.json")
volgadata <- volgaj[["data"]]
vg_df <- do.call(rbind.data.frame, volgadata)
vg_df$datetime <- as.Date(vg_df$datetime, "%Y/%m/%d" )

ggplot(vg_df, aes(x = time, y = water_surface_height_above_reference_datum)) + 
  geom_line(col = "aquamarine4", size = 1.2) + 
  xlab(NULL) + ylab("meters (m)") + 
  labs(title = "Volga River", 
       subtitle = "Observed Water Level Change: 2008-2020", 
       caption = "(based on data from Copernicus Global Land Service)") +
  theme_linedraw(base_size = 13) + 
  theme(axis.text = element_text(colour = "black", size = rel(0.9))) + 
  geom_smooth(method = "lm", ) + 
  scale_x_continuous(n.breaks = 8) +
  scale_y_continuous(n.breaks = 8)
  
################################### Volga time series ##############################################

library(dplyr)
library(lubridate)
vg_df2 = select(vg_df, -1, -2, -5)
colnames(vg_df2) <- c("date", "riverlevel")

vg_df2$date <- floor_date(vg_df2$date, "month")
vg_df2$date <- as.Date(vg_df2$date, "%Y/%m/%d" )
vg_df3 <-aggregate( riverlevel ~ date , vg_df2, mean )
volts <- ts(vg_df3$riverlevel, start = c(2008, 7), frequency = 12)

plot(decompose(volts))

################################### Comparison ##############################################

library(readxl)
library(lubridate)
library(ggplot2)
library(ggpubr)

volga_df <- readxl::read_excel("~/Downloads/volgadata.xlsx")
casp_df <- readxl::read_excel("~/Downloads/caspdata.xlsx")
casp_df$datetime <- as.Date(casp_df$datetime, "%Y/%m/%d" )
volga_df$datetime <- as.Date(volga_df$datetime, "%Y/%m/%d" )

casp_df$datetime <- floor_date(casp_df$datetime, "month")
casp_df$datetime <- as.Date(casp_df$datetime, "%Y/%m/%d" )
volga_df$datetime <- floor_date(volga_df$datetime, "month")
volga_df$datetime <- as.Date(volga_df$datetime, "%Y/%m/%d" )

casp_agg <- aggregate(
  casp_df$water_surface_height_above_reference_datum ~ casp_df$datetime , 
  casp_df, mean)
volga_agg <- aggregate(
  volga_df$water_surface_height_above_reference_datum ~ volga_df$datetime , 
  volga_df, mean)

colnames(casp_agg) <- c("date", "waterlevelcasp")
colnames(volga_agg) <- c("date", "waterlevelvolga")

comb <- data.frame(casp_agg$date, 
                   casp_agg$waterlevelcasp, 
                   volga_agg$waterlevelvolga)
colnames(comb) <- c("date", "sealevel","riverlevel")

ggplot(comb, aes(x=date)) + 
  geom_line(aes(y = sealevel), color = "darkred") + 
  geom_line(aes(y = riverlevel), color="steelblue")+ 
  theme_linedraw(base_size = 13) + 
  theme(axis.text = element_text(colour = "black", size = rel(0.9)))+
  xlab("years") + ylab("meters (m)") + 
  labs(title = "Volga River and Caspian Sea", 
       subtitle = "Observed Water Level Change: 2008-2020", 
       caption = "(based on data from Copernicus Global Land Service)")
     

################################### Correlation ##############################################

ggscatter(comb, x = "sealevel", y = "riverlevel", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Caspian Sea", ylab = "Volga",
          main = "Correlation Analysis")
  
caspts <- ts(comb$sealevel, start = c(2009, 1), frequency = 12)
plot(decompose(caspts))

volgats <- ts(comb$riverlevel, start = c(2009, 1), requency = 12)
plot(decompose(volgats))

################################### SST ##############################################


setwd("~/Downloads/Casp/sst/")
library(raster)

ext <- c(46, 55, 36, 48) 

cl <- colorRampPalette(c("darkblue","blue1", "yellow", 
                         "red", "brown"))(100)

sst_list <- list.files(pattern = "MODISA")
sst <- lapply(sst_list, raster, full.names=T)

names(sst) <- c("Mean SST 2003", "Mean SST 2008", 
                "Mean SST 2013", "Mean SST 2018")

sst.multitemp <- stack(sst)
sst.mult.crop <- crop(sst.multitemp, ext)
plot(sst.mult.crop, col=cl)

cld <- colorRampPalette(c("mediumblue", "royalblue", "seagreen4", 
                          "lawngreen", "orange1", "orangered4" ))(100)
diff <- sst.mult.crop$SST.2018 - sst.mult.crop$SST.2003
plot(diff, col=cld, main = 
       "Difference between Mean Annual SST 2018-2003")
    
     
       
boxplot(sst.mult.crop, outline = F, 
        axes = T, las=1, main = "Mean Annual SST Variations")

plot(sst.mult.crop$Mean.SST.2003, sst.mult.crop$Mean.SST.2018, 
     xlab="SST 2003", ylab="SST 2018", main = "Plot Points Variation")
abline(0, 1, col = "red")

################################### SSS ##############################################

setwd("~/Downloads/Casp/sss/")
library(raster)
library(ncdf4)

ext <- c(47, 54, 37, 47) 
cl <- colorRampPalette(c("blue", "yellow", 
                         "red", "brown"))(100)
cld <- colorRampPalette(c("blue", "lightgreen", 
                          "red"))(100)
                          
# 2019
sal2019_list <- list.files(pattern = "SSS_L3_monthly_2019")
sal.2019 <- lapply(sal2018_list, raster, 
                   varname = "sss_smap", full.names=T)
sal.2019 <- stack(sal.2019)
mean.sal.2019 <- calc(sal.2019, fun = mean, na.rm = T)
mean.sal.2019.crop <- crop(mean.sal.2019, ext)
writeRaster(mean.sal.2019.crop, 
            "mean.sal.2019.crop.tif", overwrite = T)


par(mfrow=c(2,2))
plot(mean.sal.2016.crop, col = cld, main = "Mean SSS 2016")
plot(mean.sal.2017.crop, col = cld, main = "Mean SSS 2017")
plot(mean.sal.2018.crop, col = cld, main = "Mean SSS 2018")
plot(mean.sal.2019.crop, col = cld, main = "Mean SSS 2019")

plot(mean.sal.2019.crop - mean.sal.2016.crop, col = cl, 
     main = "Difference between Mean Annual SSS 2019-2016")
     
     
################################### Occurrence ##############################################


setwd("~/Downloads/")
library(easypackages)
libraries("rgdal", "gdalUtils", 
          "raster", "RStoolbox")

a <- c("occurrence_40E_50Nv1_1_2019.tif", 
       "occurrence_50E_50Nv1_1_2019.tif", 
       "occurrence_40E_40Nv1_1_2019.tif", 
       "occurrence_50E_40Nv1_1_2019.tif")

e <- extent(40, 60, 30, 50) 
template <- raster(e)
proj4string(template) <- CRS('+proj=longlat')
writeRaster(template, file = "Caspian.tif", 
            format = "GTiff", overwrite = T)
mosaic_rasters(gdalfile = a, 
               dst_dataset = "Caspian.tif", 
               of = "GTiff")

occurrence <- raster("Caspian.tif")
ext <- c(46, 55, 36, 48) 
occurrence.crop <- crop(occurrence, ext)
cl <- colorRampPalette(c("white", "red", 
                         "blue"))(100)
plot(occurrence.crop, col = cl)


setwd("~/Downloads/Casp/sealevel/")
library (rjson)
library(GGally)
caspj <- fromJSON(file = "c_gls_WL_202007081808_CASPIAN_ALTI_V2.1.0.json")
caspdata <- caspj[["data"]]
cp_df <- do.call(rbind.data.frame, caspdata)
cp_df$datetime <- as.Date(cp_df$datetime, "%Y/%m/%d")

ggplot(cp_df, aes(x = time, 
                  y=water_surface_height_above_reference_datum)) + 
  geom_point(col = "aquamarine3", size = 1.2) + 
  xlab(NULL) + ylab("meters (m)") + 
  labs(title = "Caspian Sea", 
       subtitle = "Observed Sea Level Change: 1992-2020", 
       caption = "(based on data from Copernicus Global Land Service)") + 
  theme_linedraw(base_size = 13) + 
  theme(axis.text = element_text(colour = "black", size = rel(0.9))) + 
  geom_hline(yintercept = min(cp_df$water_surface_height_above_reference_datum), 
             linetype = "dashed", color = "red") + 
  geom_smooth(method = "loess", ) + scale_x_continuous(n.breaks = 10) + 
  scale_y_continuous(n.breaks = 8) + 
  annotate(geom = "curve", x = 1998, y = -26, xend = 1995.538, yend = -25.87, 
           color = "indianred2", lwd=1.3,
           curvature = .4, arrow = arrow(length = unit(2, "mm"))) +
  annotate(geom = "text", x = 1998, y = -26, 
           label = "The highest level in last 50 years", 
           size=4.5, hjust = "left")


################################### Caspian time series ##############################################

library(dplyr)
library(lubridate)

cp_df2 = select(cp_df, -1, -2, -5)
colnames(cp_df2) <- c("date", "sealevel")

cp_df2$date <- floor_date(cp_df2$date, "month")
cp_df2$date <- as.Date(cp_df2$date, "%Y/%m/%d" )
cp_df3 <-aggregate( sealevel ~ date , cp_df2, mean )
ts1 <- ts(cp_df3$sealevel, start = c(1992, 9), frequency = 12)

plot(decompose(ts1)) 

################################### forecast ##############################################

library(forecast)
library(tseries)

autoArimaFit <- auto.arima(ts1, stationary = F, seasonal = T)

plot(forecast(autoArimaFit, h = 24),
     type = "l", col = "aquamarine4", lwd = 2,
     main = "CSL forecast for 2021-2022",
     col.main="gray2", font.main = 2, cex.main = 1.5,
     ylab = "meters (m)", xlab = "years")

legend("bottomleft", legend = c("Observed","Forecasted"), 
       col = c("aquamarine4", "blue"), text.font = 3, 
       bty = "n", lty = 1, lwd = 2, cex = 1)

grid(col = "gray", lty = "dotted")

################################### river level ##############################################

setwd("~/Downloads/Casp/riverlevel/")
library(rjson)
library(GGally)
volgaj<-fromJSON(file = "c_gls_WL_202007110030_0000000011934_ALTI_V2.1.0.json")
volgadata <- volgaj[["data"]]
vg_df <- do.call(rbind.data.frame, volgadata)
vg_df$datetime <- as.Date(vg_df$datetime, "%Y/%m/%d" )

ggplot(vg_df, aes(x = time, y = water_surface_height_above_reference_datum)) + 
  geom_line(col = "aquamarine4", size = 1.2) + 
  xlab(NULL) + ylab("meters (m)") + 
  labs(title = "Volga River", 
       subtitle = "Observed Water Level Change: 2008-2020", 
       caption = "(based on data from Copernicus Global Land Service)") +
  theme_linedraw(base_size = 13) + 
  theme(axis.text = element_text(colour = "black", size = rel(0.9))) + 
  geom_smooth(method = "lm", ) + 
  scale_x_continuous(n.breaks = 8) +
  scale_y_continuous(n.breaks = 8)
  
################################### Volga time series ##############################################

library(dplyr)
library(lubridate)
vg_df2 = select(vg_df, -1, -2, -5)
colnames(vg_df2) <- c("date", "riverlevel")

vg_df2$date <- floor_date(vg_df2$date, "month")
vg_df2$date <- as.Date(vg_df2$date, "%Y/%m/%d" )
vg_df3 <-aggregate( riverlevel ~ date , vg_df2, mean )
volts <- ts(vg_df3$riverlevel, start = c(2008, 7), frequency = 12)

plot(decompose(volts))

################################### Comparison ##############################################

library(readxl)
library(lubridate)
library(ggplot2)
library(ggpubr)

volga_df <- readxl::read_excel("~/Downloads/volgadata.xlsx")
casp_df <- readxl::read_excel("~/Downloads/caspdata.xlsx")
casp_df$datetime <- as.Date(casp_df$datetime, "%Y/%m/%d" )
volga_df$datetime <- as.Date(volga_df$datetime, "%Y/%m/%d" )

casp_df$datetime <- floor_date(casp_df$datetime, "month")
casp_df$datetime <- as.Date(casp_df$datetime, "%Y/%m/%d" )
volga_df$datetime <- floor_date(volga_df$datetime, "month")
volga_df$datetime <- as.Date(volga_df$datetime, "%Y/%m/%d" )

casp_agg <- aggregate(
  casp_df$water_surface_height_above_reference_datum ~ casp_df$datetime , 
  casp_df, mean)
volga_agg <- aggregate(
  volga_df$water_surface_height_above_reference_datum ~ volga_df$datetime , 
  volga_df, mean)

colnames(casp_agg) <- c("date", "waterlevelcasp")
colnames(volga_agg) <- c("date", "waterlevelvolga")

comb <- data.frame(casp_agg$date, 
                   casp_agg$waterlevelcasp, 
                   volga_agg$waterlevelvolga)
colnames(comb) <- c("date", "sealevel","riverlevel")

ggplot(comb, aes(x=date)) + 
  geom_line(aes(y = sealevel), color = "darkred") + 
  geom_line(aes(y = riverlevel), color="steelblue")+ 
  theme_linedraw(base_size = 13) + 
  theme(axis.text = element_text(colour = "black", size = rel(0.9)))+
  xlab("years") + ylab("meters (m)") + 
  labs(title = "Volga River and Caspian Sea", 
       subtitle = "Observed Water Level Change: 2008-2020", 
       caption = "(based on data from Copernicus Global Land Service)")
     

################################### Correlation ##############################################

ggscatter(comb, x = "sealevel", y = "riverlevel", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Caspian Sea", ylab = "Volga",
          main = "Correlation Analysis")
  
caspts <- ts(comb$sealevel, start = c(2009, 1), frequency = 12)
plot(decompose(caspts))

volgats <- ts(comb$riverlevel, start = c(2009, 1), requency = 12)
plot(decompose(volgats))

################################### SST ##############################################


setwd("~/Downloads/Casp/sst/")
library(raster)

ext <- c(46, 55, 36, 48) 

cl <- colorRampPalette(c("darkblue","blue1", "yellow", 
                         "red", "brown"))(100)

sst_list <- list.files(pattern = "MODISA")
sst <- lapply(sst_list, raster, full.names=T)

names(sst) <- c("Mean SST 2003", "Mean SST 2008", 
                "Mean SST 2013", "Mean SST 2018")

sst.multitemp <- stack(sst)
sst.mult.crop <- crop(sst.multitemp, ext)
plot(sst.mult.crop, col=cl)

cld <- colorRampPalette(c("mediumblue", "royalblue", "seagreen4", 
                          "lawngreen", "orange1", "orangered4" ))(100)
diff <- sst.mult.crop$SST.2018 - sst.mult.crop$SST.2003
plot(diff, col=cld, main = 
       "Difference between Mean Annual SST 2018-2003")
    
     
       
boxplot(sst.mult.crop, outline = F, 
        axes = T, las=1, main = "Mean Annual SST Variations")

plot(sst.mult.crop$Mean.SST.2003, sst.mult.crop$Mean.SST.2018, 
     xlab="SST 2003", ylab="SST 2018", main = "Plot Points Variation")
abline(0, 1, col = "red")

################################### SSS ##############################################

setwd("~/Downloads/Casp/sss/")
library(raster)
library(ncdf4)

ext <- c(47, 54, 37, 47) 
cl <- colorRampPalette(c("blue", "yellow", 
                         "red", "brown"))(100)
cld <- colorRampPalette(c("blue", "lightgreen", 
                          "red"))(100)
                          
# 2019
sal2019_list <- list.files(pattern = "SSS_L3_monthly_2019")
sal.2019 <- lapply(sal2018_list, raster, 
                   varname = "sss_smap", full.names=T)
sal.2019 <- stack(sal.2019)
mean.sal.2019 <- calc(sal.2019, fun = mean, na.rm = T)
mean.sal.2019.crop <- crop(mean.sal.2019, ext)
writeRaster(mean.sal.2019.crop, 
            "mean.sal.2019.crop.tif", overwrite = T)


par(mfrow=c(2,2))
plot(mean.sal.2016.crop, col = cld, main = "Mean SSS 2016")
plot(mean.sal.2017.crop, col = cld, main = "Mean SSS 2017")
plot(mean.sal.2018.crop, col = cld, main = "Mean SSS 2018")
plot(mean.sal.2019.crop, col = cld, main = "Mean SSS 2019")

plot(mean.sal.2019.crop - mean.sal.2016.crop, col = cl, 
     main = "Difference between Mean Annual SSS 2019-2016")
     
     
################################### Occurrence ##############################################


setwd("~/Downloads/")
library(easypackages)
libraries("rgdal", "gdalUtils", 
          "raster", "RStoolbox")

a <- c("occurrence_40E_50Nv1_1_2019.tif", 
       "occurrence_50E_50Nv1_1_2019.tif", 
       "occurrence_40E_40Nv1_1_2019.tif", 
       "occurrence_50E_40Nv1_1_2019.tif")

e <- extent(40, 60, 30, 50) 
template <- raster(e)
proj4string(template) <- CRS('+proj=longlat')
writeRaster(template, file = "Caspian.tif", 
            format = "GTiff", overwrite = T)
mosaic_rasters(gdalfile = a, 
               dst_dataset = "Caspian.tif", 
               of = "GTiff")

occurrence <- raster("Caspian.tif")
ext <- c(46, 55, 36, 48) 
occurrence.crop <- crop(occurrence, ext)
cl <- colorRampPalette(c("white", "red", 
                         "blue"))(100)
plot(occurrence.crop, col = cl)
