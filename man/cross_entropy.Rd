% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/crossentropy.R
\name{cross_entropy}
\alias{cross_entropy}
\title{Cross Entropy}
\usage{
cross_entropy(ps, qs)
}
\arguments{
\item{ps}{Vector specifying a time series drawn from
the true distribution.}

\item{qs}{Vector specifying a time series drawn from
the unnatural distribution.}
}
\value{
Numeric giving the cross entropy.
}
\description{
Compute the cross entropy between the "true" and "unnatural" distributions
\code{p} and \code{q} from associated time series \code{ps} and \code{qs},
respectively. Cross entropy’s local variant is equivalent to the
self-information of \code{q}, and as such is implemented by the local block
entropy.
}
\examples{
ps <- c(0, 1, 1, 0, 1, 0, 0, 1, 0, 0)
qs <- c(0, 0, 0, 0, 0, 1, 1, 0, 0, 1)
cross_entropy(ps, qs)      # 1.003530
cross_entropy(qs, ps)      # 0.912454
}
