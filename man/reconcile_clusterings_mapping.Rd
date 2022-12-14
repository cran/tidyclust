% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/reconcile_clusterings.R
\name{reconcile_clusterings_mapping}
\alias{reconcile_clusterings_mapping}
\title{Relabels clusters to match another cluster assignment}
\usage{
reconcile_clusterings_mapping(
  primary,
  alternative,
  one_to_one = TRUE,
  optimize = "accuracy"
)
}
\arguments{
\item{primary}{A vector containing cluster labels, to be
matched}

\item{alternative}{Another vector containing cluster labels, to be
changed}

\item{one_to_one}{Boolean; should each alt cluster match only one primary
cluster?}

\item{optimize}{One of "accuracy" or "precision"; see description.}
}
\value{
A tibble with 3 columns; \code{primary}, \code{alt}, \code{alt_recoded}
}
\description{
When forcing one-to-one, the user needs to decide what to prioritize:
\itemize{
\item "accuracy": optimize raw count of all observations with the same label
across the two assignments
\item "precision": optimize the average percent of each alt cluster that
matches the corresponding primary cluster
}
}
\details{
Retains the cluster labels of the primary assignment, and relabel the
alternate assignment to match as closely as possible.  The user must decide
whether clusters are forced to be "one-to-one"; that is, are we allowed to
assign multiple labels from the alternate assignment to the same primary
label?
}
\examples{
\dontshow{if (rlang::is_installed("RcppHungarian")) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
factor1 <- c("Apple", "Apple", "Carrot", "Carrot", "Banana", "Banana")
factor2 <- c("Dog", "Dog", "Cat", "Dog", "Fish", "Fish")
reconcile_clusterings_mapping(factor1, factor2)

factor1 <- c("Apple", "Apple", "Carrot", "Carrot", "Banana", "Banana")
factor2 <- c("Dog", "Dog", "Cat", "Dog", "Fish", "Parrot")
reconcile_clusterings_mapping(factor1, factor2, one_to_one = FALSE)
\dontshow{\}) # examplesIf}
}
