library(shiny)

utils::data("obesity_data", package = "obstrendquest")

ui <- fluidPage(
  titlePanel("Adult obesity trends"),
  p("Explore how estimates change over time."),
  p(paste("Packaged data loaded:", nrow(obesity_data), "rows."))
)

server <- function(input, output, session) {}

shinyApp(ui = ui, server = server)
