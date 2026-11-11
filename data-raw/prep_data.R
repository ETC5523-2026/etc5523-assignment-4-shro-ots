# source: https://ourworldindata.org/grapher/share-of-adults-defined-as-obese
# data license: CC BY-NC-SA 4.0
obs_raw <- read.csv("data-raw/share-of-adults-defined-as-obese.csv", check.names = FALSE)

aggregate_entities <- c(
  "Africa (WHO)",
  "Americas (WHO)",
  "Eastern Mediterranean (WHO)",
  "Europe (WHO)",
  "South-East Asia (WHO)",
  "Western Pacific (WHO)",
  "World"
)

obesity_data <- obs_raw[
  !(obs_raw$Entity %in% aggregate_entities),
  ,
  drop = FALSE
]

names(obesity_data) <- c(
  "entity",
  "code",
  "year",
  "obesity_pct",
  "region"
)

save(obesity_data, file = "data/obesity_data.rda")
