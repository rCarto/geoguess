
ui <- fluidPage(
  titlePanel(title = "Guess the city position"),
  sidebarLayout(
    sidebarPanel(
      width = 3,
      p(),
      htmlOutput("ville"),
      p(),
      div(),
      htmlOutput("x")
    ),  
    mainPanel(
      width=9,
      leafletOutput("map", height = "600px", width="600px" ),
    )
  )
)
