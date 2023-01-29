
<!-- README.md is generated from README.Rmd. Please edit that file -->

# eaCatcheR

<!-- badges: start -->
<!-- badges: end -->

The eaCatcheR R package provides an interface to data from the
environment.data.gov.uk catchment planner, which is a resource for
various spatial and ecological datasets on waterbodies in England. The
package contains three main functions: `get_wb_rnag()`,
`get_wb_classification()`, and `get_wb_sf()`, each of which allows you
to access data based on geography type (e.g. RBD, MC, OC) and the name
of the geography you wish to search.

## Installation

To install the package, you can use the `install_github` function from
the `devtools` package:

``` r
devtools::install_github("natehseehan/eaCatcheR")
```

## Example

To use the package, you can use the following code to download data:

``` r
library(eaCatcheR)

# Get water body RBD data
wb_rnag <- get_wb_rnag("RBD","<water_body_name>")

# Get water body classification data
wb_classification <- get_wb_classification("MC","<water_body_name>")

# Get water body SF data
wb_sf <- get_wb_sf("OC","<water_body_name>")
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

## Documentation

For more information on the package and its functions, you can refer to
the package documentation:

``` r
?eaCatcheR
```

## Contributing

We welcome contributions to the package! If you would like to
contribute, please fork the repository and create a pull request.

## Data Source

The data for this package comes from the environment.data.gov.uk
website, which is maintained by the UK government. The website provides
access to a range of environmental data and information, including
information on water bodies and water quality.

## Contact

For questions or support, please open an issue on the GitHub repository
or contact the package maintainer at <nathanaelsheehan@gmail.com>
