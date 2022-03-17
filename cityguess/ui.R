
ui <- fluidPage(
  tags$style(type = 'text/css', 
             "footer{position: absolute; bottom:1%; left: 1%; padding:5px;}"
  ),
  fluidRow(
    column(width = 12, 
           h4("Guess the city location"),
           htmlOutput("ville"),
           htmlOutput("x")
    ),
    column(width = 12, 
           leafletOutput("map", height = "75vh"),
    ),
           HTML(
             "<footer>
        <a href='https://github.com/rCarto/geoguess/'><img src='github-brands.svg' width='20px'></a>
        <a href='https://riate.cnrs.fr'><img src='riate_blue_red.png' height='17px'></a>     
        <img src='bandologo.png' height='25px'>
       </footer>"
           )
    )
  
)

