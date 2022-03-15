# 
# ui <- fluidPage(
#   titlePanel(title = "gUESS THE CITY LOC"),
#   sidebarLayout(
#     sidebarPanel(
#       width = 3,
#       p(),
#       htmlOutput("ville"),
#       p(),
#       div(),
#       htmlOutput("x")
#     ),
#     mainPanel(
#       width=9,
#       leafletOutput("map", height='90vh', width="70vw"),
#     )
#   )
# )
# 





ui <- fluidPage(
  fluidRow(
    column(width = 12, 
           h4("Guess the city location"),
           htmlOutput("ville"),
           DTOutput('tatab2', width = "50vw"),
           htmlOutput("x")
    ),
    column(width = 12, 
           leafletOutput("map", height = "75vh"),
    )
  )
)

# 
# ui <- fluidPage(
#   titlePanel(title = "Guess the city position"),
#     mainPanel(
#       leafletOutput("map", height='90vh', width="90vw"),
#     
#   )
# )
