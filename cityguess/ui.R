
ui <- fluidPage(
  fluidRow(
    column(width = 12, 
           h4("Guess the city location"),
           htmlOutput("ville"),
           htmlOutput("x")
    ),
    column(width = 12, 
           leafletOutput("map", height = "75vh"),
    )
  ),
  fluidRow(
    HTML("</br><br><a href='https://github.com/rCarto/geoguess/'><img src='github-brands.svg' width='15px'></a>")
  )
)

