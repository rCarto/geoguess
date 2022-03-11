


server <- function(input, output, session) {
  
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
    leafletProxy('map') %>% 
      addMarkers(lng=clng, lat=clat, layerId = "1", icon = icons)
    leafletProxy('map') %>%
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
}
