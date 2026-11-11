#' Compare adult obesity trends across countries and continents
#'
#' Compare one country or area with the rest of its continent, or compare
#' several countries, areas, or continents over a chosen year range.
#'
#' @param data The cleaned dataset, with `entity`, `region`, `year`, and
#'   `obesity_pct` columns.
#' @param comparison_mode Which view do you want? Choose `country_vs_continent`
#'   (one place versus the rest of its continent), `countries` (several places),
#'   or `continents` (several continents).
#' @param selections The place(s) or continent(s) to include. Choose one place
#'   for `country_vs_continent`, or 2–5 selections for the other views.
#' @param start_year The first year in your comparison.
#' @param end_year The last year in your comparison.
#' @return A tidy table with one row for each year and line, and columns for
#'   `year`, `series`, and `obesity_pct`.
#' @details For `country_vs_continent`, the selected place is left out, so
#'   “the rest” really means the other places in its continent. In a continent
#'   line, every entity gets equal weight, not every person. These are crude
#'   estimates, so treat the graph as a conversation starter for a briefing,
#'   not a policy report card.
#' @examples
#' data(obesity_data)
#' compare_obesity_trend(
#'   data = obesity_data,
#'   comparison_mode = "countries",
#'   selections = c("India", "Australia"),
#'   start_year = 1980,
#'   end_year = 1985
#' )
#' @export
compare_obesity_trend <- function(
    data,
    comparison_mode,
    selections,
    start_year,
    end_year
) {
  valid_modes <- c(
    "country_vs_continent",
    "countries",
    "continents"
  )

  if (!(comparison_mode %in% valid_modes)) {
    stop("Choose a valid comparison mode.")
  }
  if (start_year > end_year) {
    stop("start_year must be less than or equal to end_year.")
  }
  if (
    comparison_mode == "country_vs_continent" &&
    length(selections) != 1
  ) {
    stop("Choose exactly one country/area for this comparison.")
  }

  if (
    comparison_mode %in% c("countries", "continents") &&
    (length(selections) < 2 || length(selections) > 5)
  ) {
    stop("Choose between two and five selections.")
  }
  if (
    comparison_mode %in% c("country_vs_continent", "countries") &&
    any(!(selections %in% data$entity))
  ) {
    stop("Choose country/area names that appear in the data.")
  }

  if (
    comparison_mode == "continents" &&
    any(!(selections %in% data$region))
  ) {
    stop("Choose continent names that appear in the data.")
  }
  if (comparison_mode == "country_vs_continent") {
    selected_country <- selections[1]
    selected_region <- unique(data$region[data$entity == selected_country])

    country_data <- data[
      data$entity == selected_country &
        data$year >= start_year &
        data$year <= end_year,
      c("year", "obesity_pct")
    ]
    country_data$series <- selected_country

    rest_data <- data[
      data$region == selected_region &
        data$entity != selected_country &
        data$year >= start_year &
        data$year <= end_year,
      c("year", "obesity_pct")
    ]

    rest_mean <- stats::aggregate(
      obesity_pct ~ year,
      data = rest_data,
      FUN = mean
    )
    rest_mean$series <- paste("Rest of", selected_region)

    comparison_data <- rbind(
      country_data[c("year", "series", "obesity_pct")],
      rest_mean[c("year", "series", "obesity_pct")]
    )
    comparison_data <- comparison_data[
      order(comparison_data$year, comparison_data$series),
    ]
    comparison_data
  } else if (comparison_mode == "countries") {
    comparison_data <- data[
      data$entity %in% selections &
        data$year >= start_year &
        data$year <= end_year,
      c("year", "entity", "obesity_pct")
    ]
    names(comparison_data)[2] <- "series"
    comparison_data <- comparison_data[
      order(comparison_data$year, comparison_data$series),
    ]
    comparison_data
  } else if (comparison_mode == "continents") {
    continent_data <- data[
      data$region %in% selections &
        data$year >= start_year &
        data$year <= end_year,
      c("year", "region", "obesity_pct")
    ]

    continent_means <- stats::aggregate(
      obesity_pct ~ year + region,
      data = continent_data,
      FUN = mean
    )
    names(continent_means)[2] <- "series"
    comparison_data <- continent_means[
      order(continent_means$year, continent_means$series),
    ]
    comparison_data
  }
}
