
<!-- README.md is generated from README.Rmd. Please edit that file -->

# neogeonames <img src="man/figures/logo.png" align="right" width="120" />

<!-- badges: start -->

[![License:
MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://cran.r-project.org/web/licenses/MIT)
[![](https://img.shields.io/badge/devel%20version-0.0.0.9000-blue.svg)](https://github.com/dnanto/neogeonames)
<!-- badges: end -->

The goal of neogeonames is to provide a useful subset of the [GeoNames
Gazetteer Data](http://download.geonames.org/export/dump/) with
functions to infer [ISO3166](https://en.wikipedia.org/wiki/ISO_3166)
codes for place name queries in a hierarchical manner without a REST
API.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("dnanto/neogeonames")
```

## Example

This is a basic example which shows you how to standardize potentially
misspelled place name into a set of ISO3166 codes.

``` r
library(neogeonames)
geo <- neogeonames::adminify("USA: Fairfax County, Virginia", delim = "[:,]")
geo
#> $id
#>     ac0     ac1     ac2     ac3     ac4 
#> 6252001 6254928 4758041      NA      NA 
#> 
#> $ac
#>   ac0   ac1   ac2   ac3   ac4 
#>  "US"  "VA" "059"    NA    NA
paste(Filter(Negate(is.na), geo$ac), collapse = ".")
#> [1] "US.VA.059"
```

Here’s another example…

``` r
geo <- neogeonames::adminify("USA: Furfax County, Virginia", delim = "[:,]")
geo
#> $id
#>     ac0     ac1     ac2     ac3     ac4 
#> 6252001 6254928 4758041      NA      NA 
#> 
#> $ac
#>   ac0   ac1   ac2   ac3   ac4 
#>  "US"  "VA" "059"    NA    NA
```

Use the geonameid to get the coordinates.

``` r
# get the id that occurs before the first NA value
idx <- which(is.na(c(geo$id, NA)))[[1]] - 1
with(geoname, geoname[geonameid == geo$id[idx], c("longitude", "latitude")])
#>        longitude latitude
#> 403799 -77.27622 38.83469
```

Also, check out the `vignette("neogeonames")`.

## Data License

  - [GeoNames Gazetteer Data
    License](https://creativecommons.org/licenses/by/4.0/)
