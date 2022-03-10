library(shiny)
library(leaflet)
library(sf)

dataa <- read.csv(file = "cities.csv")

icons = makeIcon(iconUrl = "pin.svg", iconHeight = 18,
                 iconWidth = 18, iconAnchorX = 9, iconAnchorY = 9)
icons2 = makeIcon(iconUrl = "pin2.svg", iconHeight = 18,
                 iconWidth = 18, iconAnchorX = 9, iconAnchorY = 9)

ui <- fluidPage(
  titlePanel(title = "Guess the city position"),
  
  sidebarLayout(
    sidebarPanel(width = 3,
                 
                 p(),
                 htmlOutput("ville"),
                 p(),
                 div(),
                 htmlOutput("x")
    ),  
    mainPanel(width=9,
              leafletOutput("map",  height = "600px", width="600px" ),
    )
  )
)


server <- shinyServer(function(input, output, session) {
  vv <- sample(1:nrow(dataa), 20, replace =FALSE)
  dataa <- dataa[vv,]
  rv <- reactiveValues(n = 1, tot = 0)
  
  
  
  ## Make your initial map
  output$map <- renderLeaflet({
    leaflet(options = leafletOptions(minZoom = 2, maxZoom = 6)) %>%
      setView(lng = 0, lat = 40, zoom = 2) %>%
      addProviderTiles(provider = providers$Esri.WorldShadedRelief, 
                       options = providerTileOptions(noWrap = TRUE)) 
  })
  
  # initial text
  output$ville <- renderText({
    HTML(paste0("<b>", dataa[1,2], ", ", dataa[1, 1],
                "</b><br/><small>(", rv$n,"/20)</small>"))
  })
  
  
  
  ## Observe mouse clicks 
  observeEvent(input$map_click, {
    # restart session
    if(rv$n == 21 ){
      session$reload()
      return()
    }
    
    # update city & clean map
    output$ville <- renderText({ 
      HTML(paste0("<b>", dataa[rv$n,2], ", ", dataa[rv$n, 1], 
                  "</b><br/><small>(", rv$n,"/20)</small>"))
    })
    leafletProxy('map') %>% removeMarker(c("1", "2"))
    
    
    
    click <- input$map_click
    clat <- click$lat
    clng <- click$lng
    leafletProxy('map') %>% # use the proxy to save computation
      addMarkers(lng=clng, lat=clat, layerId = "1", icon = icons)
    
    leafletProxy('map') %>% # use the proxy to save computation
      addMarkers(lng=dataa[rv$n, 4], lat=dataa[rv$n, 3], layerId = "2", 
                 icon =icons2) 
    
    a <- st_as_sf(data.frame(x = clng,y = clat), 
                  coords = c("x", "y"), crs = 4326)
    b <- st_as_sf(data.frame(x = dataa[rv$n, 4], y = dataa[rv$n, 3]), 
                  coords = c("x", "y"), crs = 4326)
    x <- round(as.numeric(st_distance(a, b)/1000), 0)
    rv$tot <- rv$tot + x
    
    
    showNotification(HTML(paste0("<b>", dataa[rv$n,2],": " , x, " km</b>")), 
                     type = "message")
    
    
    rv$n <- rv$n+1
    
    if(rv$n == 21 ){
      output$x <- renderText({ 
        output$ville <- renderText({ ""})
        HTML(paste0("<h2>Total distance: ", rv$tot, 
                    "km</h2>", 
                    "</br></br>Click on the map to start a new session"))
      })
      
    }
    
    
  })
  
})

shinyApp(ui=ui, server=server)





