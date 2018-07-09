install.packages("XML")

library(dplyr)
library(zoo)
library(lubridate)
library(XML)
tripdata <- read.csv("R/input/2010-Q4-cabi-trip-history-data_2010-Q4-cabi-trip-history-data.csv")
# str(tripdata)
colnames(tripdata)
tripdata <- tripdata[!(is.na(tripdata$End.station) | tripdata$End.station==""), ]


tripdata$Start.station.number <- ifelse(grepl('[\\(\\)]', tripdata$Start.station),
                                        gsub(".*\\((.*)\\).*", "\\1", tripdata$Start.station),
                                        tripdata$Start.station.number)

tripdata$End.station.number <- ifelse(grepl('[\\(\\)]',tripdata$End.station),
                                      gsub(".*\\(.*)\\).*","\\1",tripdata$End.station),
                                      tripdata$End.station.number)

tripdata$Start.station.number <- as.numeric(tripdata$Start.station.number)
tripdata$End.station.number <- as.numeric(tripdata$End.station.number)


tripdata$Start.Station.name <- ifelse(grepl('[\\(\\)]', tripdata$Start.station),
                                  gsub("\\s*\\([^\\)]+\\)","", as.character(tripdata$Start.station)),
                                  tripdata$Start.station.name)

tripdata$End.station.name <- ifelse(grepl('[\\(\\)]', tripdata$End.station),
                                      gsub("\\s*\\([^\\)]+\\)","", as.character(tripdata$End.station)),
                                      tripdata$End.station.name)

# Date conversion
tripdata$Start.date.time <- as.POSIXct(tripdata$Start.date, format = "%m/%d/%Y %H:%M")
tripdata$End.date.time <- as.POSIXct(tripdata$End.date, format = "%m/%d/%Y %H:%M")
tripdata$duraton <- tripdata$End.date.time-tripdata$Start.date.time

View(tripdata)


xmlfile <- xmlTreeParse('http://feeds.capitalbikeshare.com/stations/stations.xml',useInternalNodes = TRUE)
saveXML(xmlfile,file = "R/input/stations.xml")

topxml <- xmlRoot(xmlfile)
topxml <- xmlSApply(topxml, function(x) xmlSApply(x, xmlValue))
station_data <- data.frame(t(topxml), row.names=NULL)
station_data$terminalName <- as.numeric(station_data$terminalName)
station_data$lat <- as.numeric(station_data$lat)
station_data$long <- as.numeric(station_data$long)
station_data$name <- as.character(station_data$name)

# str(station_data)
head(station_data)
# View(station_data)
unique(station_data$name)
unique(tripdata$Start.Station.name)
unique(tripdata$End.station.name)
View(tripdata)



