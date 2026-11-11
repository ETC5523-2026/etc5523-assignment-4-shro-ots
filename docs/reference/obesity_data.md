# Adult obesity estimates by place and year

Ready to explore how adult obesity estimates vary from place to place?
This dataset gives you the yearly figures to get started.

## Usage

``` r
data(obesity_data)
```

## Format

A data frame with 8,955 rows and 5 columns:

- entity:

  The name of a country or area.

- code:

  The source's identifier for that country or area.

- year:

  The year the estimate refers to.

- obesity_pct:

  Crude estimated percentage of adults aged 18 or older with a BMI of 30
  or higher.

- region:

  The Our World in Data region grouping for the place.

## Source

Adult-obesity estimates: World Health Organization – Global Health
Observatory (2026), with minor processing by Our World in Data.
<https://ourworldindata.org/grapher/share-of-adults-defined-as-obese>

Region groupings: Our World in Data, “World region according to OWID”.

## Details

These are estimates, not a headcount. To make a continent line, the
package gives each included country or area equal weight. A small place
counts just as much as a large one, so the line is not the average for a
person living in that continent or an official WHO regional estimate.
When you compare one country with the rest of its continent, that
country is left out of the average. These trends can show what changed,
but they cannot tell us why.

The bundled source-data README lists the WHO data as CC BY-NC-SA 4.0.
The package's R code has a separate MIT licence.

## Examples

``` r
data("obesity_data", package = "obstrendquest")
head(obesity_data)
#>        entity code year obesity_pct region
#> 1 Afghanistan  AFG 1980   0.8342677   Asia
#> 2 Afghanistan  AFG 1981   0.8936012   Asia
#> 3 Afghanistan  AFG 1982   0.9585184   Asia
#> 4 Afghanistan  AFG 1983   1.0294502   Asia
#> 5 Afghanistan  AFG 1984   1.1064882   Asia
#> 6 Afghanistan  AFG 1985   1.1897680   Asia
```
