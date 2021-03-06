% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/defineDabomColNms.R
\name{defineDabomColNms}
\alias{defineDabomColNms}
\title{Define Column Names for DABOM matrix}
\usage{
defineDabomColNms(
  root_site = c("GRA", "PRA", "TUM", "PRO"),
  parent_child,
  configuration
)
}
\arguments{
\item{root_site}{determines which version of DABOM the user is running.}

\item{parent_child}{parent-child table. Could be created from `buildParentChild()` from `PITcleanr` package.}

\item{configuration}{configuration file. Could be created from `buildConfig()` from `PITcleanr` package.}
}
\description{
based on a parent-child table, this returns a vector of nodes to help create a consistent
series of DABOM input matrices.
}
\examples{
defineDabomColNms()
}
\author{
Kevin See
}
