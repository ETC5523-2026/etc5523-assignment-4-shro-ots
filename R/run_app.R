#' Launch the Obesity Trend Quest app
#'
#' Open the Shiny app bundled with this package.
#'
#' @param ... Additional arguments passed to [shiny::runApp()].
#' @export
run_app <- function(...) {
  app_dir <- system.file("app", package = "obstrendquest")

  if (app_dir == "") {
    stop("Could not find the app installed with obstrendquest.")
  }

  shiny::runApp(app_dir, ...)
}
