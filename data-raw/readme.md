# Share of adults who are obese - Data package

This data package contains the data that powers the chart ["Share of adults who are obese"](https://ourworldindata.org/grapher/share-of-adults-defined-as-obese?v=1&csvType=full&useColumnShortNames=false) on the Our World in Data website.

### Active Filters

A filtered subset of the full data was downloaded. The following filters were applied:

## CSV structure

Each row is an observation for an entity (usually a country or region) at a timepoint.

- "Entity" — the name of the entity, e.g. "United States".
- "Code" — our internal entity code. For most countries this is the [ISO alpha-3](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3) code, e.g. "USA"; historical and other non-standard entities get a custom code.
- "Year" or "Day" — the timepoint. Annual data has a "Year" column holding an integer year; otherwise a "Day" column holds a date string in the form "YYYY-MM-DD".
- Every remaining column is a data column, each one a time series. Downloaded with the "full data" option each corresponds to one time series below; with "only selected data visible in the chart" they are transformed depending on the chart type, so the correspondence may be less direct.


## Metadata.json structure

The .metadata.json file contains metadata about the data package. The "charts" key contains information to recreate the chart, like the title, subtitle etc. The "columns" key contains information about each of the columns in the csv, like the unit, timespan covered, citation for the data etc.

## How we process data at Our World in Data

Our World in Data is almost never the original producer of the data - almost all of the data we use has been compiled by others. If you want to re-use data, it is your responsibility to ensure that you adhere to the sources' license and to credit them correctly. Please note that a single time series may have more than one source - e.g. when we stitch together data from different time periods by different producers or when we calculate per capita metrics using population data from a second source.

Preparing this data involves several processing steps. Depending on the data, this can include standardizing country names and world region definitions, converting units, calculating derived indicators such as per capita measures, as well as adding or adapting metadata such as the name or the description given to an indicator.
[Read about our data pipeline](https://docs.owid.io/projects/etl/).

## Detailed information about each time series


### Obesity among adults, BMI >= 30 kg/m2 (crude estimate) (%) - Sex: both sexes - Age group: 18+  years of age
Last updated: May 22, 2026  
Next expected update: May 2027  
Date range: 1980–2024  
Unit: %  
Source: World Health Organization – Global Health Observatory (2026) – with minor processing by Our World in Data  

#### How to cite this data

World Health Organization – Global Health Observatory (2026) – with minor processing by Our World in Data

#### How this data is described by its producers
#### Definition
Percentage of adults aged 18+ years with a body mass index (BMI) of 30 kg/m2 or higher.

#### Method of measurement
Based on measured height and weight.

#### Method of estimation
Input data and methods are described here: NCD-RisC. Worldwide trends in underweight and obesity from 1990 to 2022: a pooled analysis of 3663 population-representative studies with 222 million children, adolescents and adults.

Lancet 2024. DOI: https://doi.org/10.1016/ S0140-6736(23)02750-2

Statistical code is available here: https://doi.org/10.5281/zenodo.10534960


### World region according to OWID
Regions defined by Our World in Data, which are used in OWID charts and maps.
Last updated: January 1, 2023  
Date range: 2023–2023  
Source: Our World in Data  

#### How to cite this data

Our World in Data


## Sources

These are the sources behind the data in this package. Each time series above names the ones it draws on in its citation.

### World Health Organization – Global Health Observatory

The GHO data repository is WHO's gateway to health-related statistics for its 194 Member States. It provides access to over 1000 indicators on priority health topics including mortality and burden of diseases, the Millennium Development Goals (child nutrition, child health, maternal and reproductive health, immunization, HIV/AIDS, tuberculosis, malaria, neglected diseases, water and sanitation), non communicable diseases and risk factors, epidemic-prone diseases, health systems, environmental health, violence and injuries, equity among others.

Producer: World Health Organization  
Published: 2026-05-28  
Retrieved on: 2026-05-22  
Retrieved from: https://www.who.int/data/gho  
License: CC BY-NC-SA 4.0 (https://www.who.int/about/policies/publishing/copyright)  

Citation: World Health Organization. 2026. Global Health Observatory data repository. http://www.who.int/gho/en/.

### Our World in Data – Regions

Producer: Our World in Data  

    