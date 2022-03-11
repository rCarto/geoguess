library(shiny)
library(leaflet)
library(sf)

dataa <- read.csv(file = "www/cities.csv")
icons = makeIcon(iconUrl = "www/pin.svg", iconHeight = 18,
                 iconWidth = 18, iconAnchorX = 9, iconAnchorY = 9)
icons2 = makeIcon(iconUrl = "www/pin2.svg", iconHeight = 18,
                  iconWidth = 18, iconAnchorX = 9, iconAnchorY = 9)