library(shiny)

ui <- fluidPage(
  titlePanel("Adult obesity trends"),
  p("Explore how estimates change over time.")
)

server <- function(input, output, session) {}

shinyApp(ui = ui, server = server)
