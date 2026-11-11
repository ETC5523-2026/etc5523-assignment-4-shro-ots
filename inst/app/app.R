library(shiny)

utils::data("obesity_data", package = "obstrendquest")

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      body {
        background: #FFFAF2;
        color: #33231D;
      }

      .container-fluid {
        max-width: 1200px;
      }

      .brand-banner {
        background: #4A0018;
        color: #FFFAF2;
        padding: 24px 30px;
        border-radius: 16px;
        margin: 24px 0;
      }

      .brand-banner h1 {
        color: #FFFAF2;
        margin: 0 0 8px;
      }

      .brand-kicker {
        color: #DCCB9B;
        text-transform: uppercase;
        letter-spacing: 0.12em;
        margin: 0 0 8px;
      }

      .brand-subtitle {
        color: #FFFAF2;
        margin: 0;
      }

      h2, h3 {
        color: #4A0018;
      }

      .well {
        background: #FFFAF2;
        border: 1px solid #D9C9AB;
        border-radius: 14px;
        box-shadow: 0 4px 16px rgba(74, 0, 24, 0.08);
      }

      .radio label {
        display: block;
        padding: 10px 12px;
        margin: 6px 0;
        border: 1px solid #D9C9AB;
        border-radius: 10px;
        background: #FFFAF2;
      }

      .radio label:hover {
        border-color: #59652D;
      }

      .radio input[type=radio] {
        accent-color: #59652D;
      }

      .form-control:focus,
      .selectize-input.focus {
        border-color: #59652D;
        box-shadow: 0 0 0 2px rgba(89, 101, 45, 0.15);
      }

      .btn-primary {
        background: #59652D;
        border-color: #59652D;
      }

      .btn-primary:hover {
        background: #4A0018;
        border-color: #4A0018;
      }

      .summary-list {
        padding-left: 1.4em;
        margin: 0;
      }

      .summary-item {
        padding: 6px 4px;
        margin: 6px 0;
      }

      .summary-item::marker {
        color: #59652D;
        font-size: 1.15em;
      }

      .text-muted {
        color: #6C6257 !important;
      }

      .app-message {
        padding: 12px 16px;
        margin-bottom: 16px;
        border-left: 4px solid #59652D;
        border-radius: 8px;
        background: #E9DFC9;
        color: #33231D;
      }

      .app-message.attention {
        border-left-color: #4A0018;
      }
    "))
  ),

  div(
    class = "brand-banner",
    p(class = "brand-kicker", "More Than Just Statistics"),
    h1("Obesity Trend Quest"),
    p(
      class = "brand-subtitle",
      "A visual guide to adult obesity trends across countries and continents."
    )
  ),

  sidebarLayout(
    sidebarPanel(
      radioButtons(
        "comparison_mode",
        "Choose a comparison",
        choices = c(
          "One country vs. the rest of its continent" = "country_vs_continent",
          "Compare countries/areas" = "countries",
          "Compare continents" = "continents"
        )
      ),

      conditionalPanel(
        condition = "input.comparison_mode == 'country_vs_continent'",
        selectInput(
          "country",
          "Choose a country/area",
          choices = sort(unique(obesity_data$entity))
        )
      ),

      conditionalPanel(
        condition = "input.comparison_mode == 'countries'",
        selectizeInput(
          "countries",
          "Choose 2–5 countries/areas",
          choices = sort(unique(obesity_data$entity)),
          multiple = TRUE,
          options = list(
            maxItems = 5,
            placeholder = "Search and choose countries/areas"
          )
        )
      ),

      conditionalPanel(
        condition = "input.comparison_mode == 'continents'",
        selectizeInput(
          "continents",
          "Choose 2–5 continents",
          choices = sort(unique(obesity_data$region)),
          multiple = TRUE,
          options = list(
            maxItems = 5,
            placeholder = "Choose continents"
          )
        )
      ),

      sliderInput(
        "year_range",
        "Year range",
        min = min(obesity_data$year),
        max = max(obesity_data$year),
        value = range(obesity_data$year),
        step = 1,
        sep = ""
      ),

      width = 4
    ),

    mainPanel(
      wellPanel(
        h3("Your comparison"),
        uiOutput("selection_message"),
        uiOutput("comparison_results")
      ),

      p(
        class = "text-muted",
        "Ready to explore? These figures are estimates, not a headcount. When we calculate a continent average, each country or area counts equally, so a small place has the same weight as a large one. This lets you compare places, but it does not represent the estimate for the average person in that continent. In the country comparison, your selected country is left out of the rest-of-continent average."
      ),

      width = 8
    )
  )
)

server <- function(input, output, session) {
  selected_selections <- reactive({
    switch(
      input$comparison_mode,
      country_vs_continent = input$country,
      countries = input$countries,
      continents = input$continents
    )
  })

  selection_problem <- reactive({
    selections <- selected_selections()
    mode <- input$comparison_mode

    if (is.null(mode)) {
      return("Choose a comparison to get started.")
    }

    if (mode == "country_vs_continent" && length(selections) != 1) {
      return("Choose one country or area to compare.")
    }

    if (mode == "countries" && length(selections) < 2) {
      return("Choose at least two countries or areas to compare.")
    }

    if (mode == "continents" && length(selections) < 2) {
      return("Choose at least two continents to compare.")
    }

    if (
      mode %in% c("countries", "continents") &&
      length(selections) > 5
    ) {
      return("Choose no more than five selections.")
    }

    NULL
  })

  comparison_data <- reactive({
    if (!is.null(selection_problem())) {
      return(NULL)
    }

    req(input$year_range)

    obstrendquest::compare_obesity_trend(
      data = obesity_data,
      comparison_mode = input$comparison_mode,
      selections = selected_selections(),
      start_year = input$year_range[1],
      end_year = input$year_range[2]
    )
  })

  output$selection_message <- renderUI({
    message <- selection_problem()

    if (!is.null(message)) {
      return(div(class = "app-message attention", message))
    }

    result <- comparison_data()

    if (is.null(result) || nrow(result) == 0) {
      return(
        div(
          class = "app-message attention",
          "No estimates were found for those choices and years. Try a different selection."
        )
      )
    }

    div(
      class = "app-message",
      paste(
        "All set! Showing",
        length(unique(result$series)),
        "comparison lines across",
        length(unique(result$year)),
        "years."
      )
    )
  })

  output$comparison_results <- renderUI({
    result <- comparison_data()

    if (is.null(result) || nrow(result) == 0) {
      return(NULL)
    }

    tagList(
      plotOutput("trend_plot", height = "420px"),
      h4("A quick read on the change"),
      uiOutput("change_summary")
    )
  })

  output$trend_plot <- renderPlot({
    result <- comparison_data()

    if (is.null(result) || nrow(result) == 0) {
      return(invisible(NULL))
    }

    series_names <- unique(result$series)
    marker_shapes <- c(16, 17, 15, 18, 8)
    is_country_vs_continent <- input$comparison_mode == "country_vs_continent"

    if (is_country_vs_continent) {
      selected_country <- selected_selections()
      line_colours <- ifelse(
        series_names == selected_country,
        "#4A0018",
        "#3E6B35"
      )
    } else {
      line_palette <- c("#4A0018", "#59652D", "#0072B2", "#D55E00", "#009E73")
      line_colours <- line_palette[seq_along(series_names)]
    }

    line_types <- rep(1, length(series_names))
    point_shapes <- if (is_country_vs_continent) {
      ifelse(series_names == selected_country, 16, 17)
    } else {
      marker_shapes[seq_along(series_names)]
    }

    year_range <- range(result$year)
    x_limits <- year_range

    if (diff(x_limits) == 0) {
      x_limits <- x_limits + c(-0.5, 0.5)
    }

    x_ticks <- unique(c(round(pretty(year_range)), year_range))

    value_range <- range(result$obesity_pct, finite = TRUE)
    y_limits <- value_range

    if (diff(y_limits) == 0) {
      y_limits <- y_limits + c(-0.5, 0.5)
    }

    y_ticks <- pretty(y_limits)

    par(
      bg = "#FFFAF2",
      mar = c(4.5, 5, 1, 1),
      col.axis = "#33231D",
      col.lab = "#33231D"
    )

    plot(
      result$year,
      result$obesity_pct,
      type = "n",
      xlim = x_limits,
      ylim = y_limits,
      xlab = "Year",
      ylab = "Adult obesity estimate (%)",
      axes = FALSE,
      bty = "n"
    )

    abline(h = y_ticks, col = "#E9DFC9")

    axis(
      1,
      at = x_ticks,
      col = "#D9C9AB",
      col.axis = "#33231D"
    )

    axis(
      2,
      at = y_ticks,
      las = 1,
      col = "#D9C9AB",
      col.axis = "#33231D"
    )

    for (i in seq_along(series_names)) {
      series_data <- result[
        result$series == series_names[i],
        ,
        drop = FALSE
      ]
      series_data <- series_data[order(series_data$year), ]

      lines(
        series_data$year,
        series_data$obesity_pct,
        col = line_colours[i],
        lwd = 3,
        lty = line_types[i]
      )

      points(
        series_data$year,
        series_data$obesity_pct,
        col = line_colours[i],
        pch = point_shapes[i],
        cex = 0.8
      )
    }

    legend(
      "topleft",
      legend = series_names,
      col = line_colours[seq_along(series_names)],
      lwd = 3,
      lty = line_types[seq_along(series_names)],
      pch = point_shapes,
      bty = "n"
    )
  })

  output$change_summary <- renderUI({
    result <- comparison_data()

    if (is.null(result) || nrow(result) == 0) {
      return(NULL)
    }

    series_names <- unique(result$series)

    summary_items <- lapply(series_names, function(series_name) {
      series_data <- result[
        result$series == series_name,
        ,
        drop = FALSE
      ]
      series_data <- series_data[order(series_data$year), ]

      first_value <- series_data$obesity_pct[1]
      last_value <- series_data$obesity_pct[nrow(series_data)]
      first_year <- series_data$year[1]
      last_year <- series_data$year[nrow(series_data)]
      change <- last_value - first_value

      if (nrow(series_data) == 1) {
        sentence <- sprintf(
          "%s is at %.1f%% in %s.",
          series_name,
          first_value,
          first_year
        )
      } else if (change > 0) {
        sentence <- sprintf(
          "%s rose from %.1f%% in %s to %.1f%% in %s, an increase of %.1f percentage points.",
          series_name,
          first_value,
          first_year,
          last_value,
          last_year,
          change
        )
      } else if (change < 0) {
        sentence <- sprintf(
          "%s fell from %.1f%% in %s to %.1f%% in %s, a decrease of %.1f percentage points.",
          series_name,
          first_value,
          first_year,
          last_value,
          last_year,
          abs(change)
        )
      } else {
        sentence <- sprintf(
          "%s stayed around %.1f%% from %s to %s.",
          series_name,
          first_value,
          first_year,
          last_year
        )
      }

      tags$li(class = "summary-item", sentence)
    })

    tags$ul(
      class = "summary-list",
      do.call(tagList, summary_items)
    )
  })
}

shinyApp(ui = ui, server = server)
