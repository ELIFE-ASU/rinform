% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/binning.R
\name{series_range}
\alias{series_range}
\title{Series Range}
\usage{
series_range(series)
}
\arguments{
\item{series}{Vector giving the time series.}
}
\value{
List giving the range, the minimum and the maximum value of the
        series.
}
\description{
Compute the range, minimum and maximum values in a floating-point time
series \code{series}.
}
\examples{
series_range(c(0, 1, 2, 3, 4, 5))        # list(5, 0, 5)
series_range(c(-0.1, 8.5, 0.02, -6.3))   # list(14.8, -6.3, 8.5)

}
