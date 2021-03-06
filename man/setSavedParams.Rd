% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/setSavedParams.R
\name{setSavedParams}
\alias{setSavedParams}
\title{Set Saved Parameters}
\usage{
setSavedParams(model_file = NULL, time_varying = F)
}
\arguments{
\item{model_file}{file path to the JAGS model text file}

\item{time_varying}{Should the initial movement probabilities be time-varying? Default value is \code{FALSE}}
}
\description{
Returns a character vector of parameters to be saved by JAGS for a DABOM model
}
\examples{
setSavedParams()
}
\author{
Kevin See
}
