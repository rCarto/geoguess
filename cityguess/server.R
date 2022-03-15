server <- function(input, output, session) {
  
  # data init
  ncity=20
  vv <- sample(1:nrow(dataa), nrow(dataa), replace = FALSE)
  dataa <- dataa[vv,]
  ad <- paste0(dataa$name, ", ", dataa$ctry)
  ga <- substr(dataa$GAWC, 1,1)
  x <- aggregate(ad, by = list(ga), head, 4)
  x <- unlist(x$x)
  x <- as.vector(x)
  dataa <- dataa[ad %in% x, ][1:ncity,]
  rv <- reactiveValues(
    n = 1, 
    tot = 0,   
    res = data.frame(City = paste0(dataa$name, ", ", dataa$ctry), Distance=NA)
  )
  
  # Display map
  output$map <- renderLeaflet({
    leaflet(options = leafletOptions(minZoom = 2, maxZoom = 6)) %>%
      setView(lng = 0, lat = 40, zoom = 4) %>%
      addProviderTiles(provider = providers$Esri.WorldShadedRelief,
                       options = providerTileOptions(noWrap = TRUE))
  })
  
  # First city
  output$ville <- renderText({
    HTML(paste0("<b>", dataa[1,2], ", ", dataa[1, 1],
                " </b><small><small>(", rv$n,"/",ncity,")</small></small>"))
  })
  
  ## Observe mouse clicks 
  observeEvent(input$map_click, {
    # update city 
    output$ville <- renderText({ 
      HTML(paste0("<b>", dataa[rv$n,2], ", ", dataa[rv$n, 1], 
                  " </b><small><small>(", rv$n,"/",ncity,")</small></small>"))
    })
    # clean map
    leafletProxy('map') %>% removeMarker(c("1", "2")) 
    
    # update map
    click <- input$map_click
    clat <- click$lat
    clng <- click$lng
    leafletProxy('map') %>% 
      addMarkers(lng=clng, lat=clat, layerId = "1", icon = icons)
    leafletProxy('map') %>%
      addMarkers(lng=dataa[rv$n, 4], lat=dataa[rv$n, 3], layerId = "2", 
                 icon =icons2) 
    # compute distance
    a <- st_as_sf(data.frame(x = clng,y = clat), 
                  coords = c("x", "y"), crs = 4326)
    b <- st_as_sf(data.frame(x = dataa[rv$n, 4], y = dataa[rv$n, 3]), 
                  coords = c("x", "y"), crs = 4326)
    x <- round(as.numeric(st_distance(a, b)/1000), 0)
    rv$tot <- rv$tot + x
    # Display distance
    showNotification(HTML(paste0("<b>", dataa[rv$n,2],": " , x, " km</b>")), 
                     type = "message")
    # store distance
    rv$res[rv$n, "Distance"] <- x
    row.names(rv$res) <- rv$res$City
    
    # next city
    rv$n <- rv$n + 1
    
    if(rv$n == ncity + 1 ){
      # Display
      output$x <- renderText({ 
        showModal(
          modalDialog(
            footer = actionButton("rst", "New Game", icon = icon("globe") ),
            title = HTML(paste0("<b>Total distance: ", rv$tot,"km !</b>")),
            size = "m", 
            easyClose = FALSE,
            fade = FALSE,
            label ="resultats",
            renderDT(datatable(
              rv$res[,2,drop=F],
              options = list(lengthChange = FALSE,
                             pageLength = 5,dom="tp", 
                             order = list(list(1, 'asc')))
            ))
          ))
        output$ville <- renderText({""})
        HTML(paste0(""))
      })
    }
    
    observeEvent(input$rst, {
      session$reload()
      return()
    })
    
    
  })
}


