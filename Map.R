#!/usr/bin/env Rscript

####################################################################################################
#  Map data with maps library / high-res rworldxtra libraries
#  MC FONTAINE
#  Adapted to accept arguments from shell - by Vania E. Rivera-Leon and Xenia M. Lopes (28/jan/2016)
####################################################################################################

args <- commandArgs(TRUE)#enable comand line arguments

data <- read.table(args[1], header=TRUE) #Import data as an argument, tab-delimited with a header
#head(data$Lat)

attach(data)  #use the variable names. if you don't do this, you will need to used the notation data$Lat

#You you may need those libraries
# library(fields) # can be usefull for interpolated surfaces
library(maps)
library(mapdata)
library('rworldxtra') #Updated highres maps (http://www.naturalearthdata.com/downloads/10m-cultural-vectors/)
data(countriesHigh)

#define the geographic range of the map
exLong <- 5
xlim <- c(min(Long)-exLong,max(Long)+exLong)
ylim <- c(min(Lat)-exLong,max(Lat)+exLong)

# Plot the map
MapLatLon <- paste("Map", args[2], sep = "_")#output file name using an argument from Pipe.sh
pdf(MapLatLon)
map('world', fill=TRUE,col="grey90", xlim=xlim, ylim=ylim)
#plot(countriesHigh, fill=TRUE,col="grey90", xlim=xlim, ylim=ylim) # for high resolution
points(Long , Lat, pch=16, col="blue", cex=0.5)
map.axes(xlab="Long", ylab="Lat")
dev.off()

#END
