# Compare adult obesity trends across countries and continents

Compare one country or area with the rest of its continent, or compare
several countries, areas, or continents over a chosen year range.

## Usage

``` r
compare_obesity_trend(data, comparison_mode, selections, start_year, end_year)
```

## Arguments

- data:

  The cleaned dataset, with `entity`, `region`, `year`, and
  `obesity_pct` columns.

- comparison_mode:

  Which view do you want? Choose `country_vs_continent` (one place
  versus the rest of its continent), `countries` (several places), or
  `continents` (several continents).

- selections:

  The place(s) or continent(s) to include. Choose one place for
  `country_vs_continent`, or 2–5 selections for the other views.

- start_year:

  The first year in your comparison.

- end_year:

  The last year in your comparison.

## Value

A tidy table with one row for each year and line, and columns for
`year`, `series`, and `obesity_pct`.

## Details

For `country_vs_continent`, the selected place is left out, so “the
rest” really means the other places in its continent. In a continent
line, every entity gets equal weight, not every person. These are crude
estimates, so treat the graph as a conversation starter for a briefing,
not a policy report card.

## Examples

``` r
data(obesity_data)
compare_obesity_trend(
  data = obesity_data,
  comparison_mode = "countries",
  selections = c("India", "Australia"),
  start_year = 1980,
  end_year = 1985
)
#>      year    series obesity_pct
#> 496  1980 Australia   7.5439787
#> 3871 1980     India   0.2782146
#> 497  1981 Australia   7.9656506
#> 3872 1981     India   0.3032421
#> 498  1982 Australia   8.4189000
#> 3873 1982     India   0.3307577
#> 499  1983 Australia   8.9046700
#> 3874 1983     India   0.3609213
#> 500  1984 Australia   9.4176610
#> 3875 1984     India   0.3940604
#> 501  1985 Australia   9.9489520
#> 3876 1985     India   0.4304292
```
