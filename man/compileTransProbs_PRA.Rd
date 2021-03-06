% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/compileTransProbs_PRA.R
\name{compileTransProbs_PRA}
\alias{compileTransProbs_PRA}
\title{Compile Transition Probabilities - PRA}
\usage{
compileTransProbs_PRA(dabom_mod = NULL, parent_child = NULL)
}
\arguments{
\item{dabom_mod}{An MCMC.list}

\item{parent_child}{data frame with at least `parent` and `child` columns.
Can be created with `buildParentChild()` function in the `PITcleanr` package.}
}
\description{
Extracts the MCMC posteriors of transition probabilities for a DABOM model, and multiplies them appropriately. This function is specific to the Priest Rapids version of DABOM.
}
\examples{
compileTransProbs_PRA()
}
\author{
Kevin See
}
