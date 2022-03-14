library(shiny)
library(leaflet)
library(sf)

dataa <- read.csv(file = "www/cities.csv")





icons = makeIcon(iconUrl = "www/pin.svg", iconHeight = 18,
                 iconWidth = 18, iconAnchorX = 9, iconAnchorY = 9)
icons2 = makeIcon(iconUrl = "www/pin2.svg", iconHeight = 18,
                  iconWidth = 18, iconAnchorX = 9, iconAnchorY = 9)

# land <- st_read("www/geo.gpkg", layer = "land")
# ocean <- st_read("www/geo.gpkg", layer = "ocean")
# lakes <- st_read("www/geo.gpkg", layer = "lakes")
# 
# crs <- leafletCRS(crsClass = "L.Proj.CRS", code = "ESRI:54030",
#                   proj4def = "+proj=robin +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs ",
#                   resolutions = 1.5^(25:15))