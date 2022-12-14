% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/translate.R
\name{translate_tidyclust}
\alias{translate_tidyclust}
\alias{translate_tidyclust.default}
\title{Resolve a Model Specification for a Computational Engine}
\usage{
translate_tidyclust(x, ...)

\method{translate_tidyclust}{default}(x, engine = x$engine, ...)
}
\arguments{
\item{x}{A model specification.}

\item{...}{Not currently used.}

\item{engine}{The computational engine for the model (see \code{?set_engine}).}
}
\value{
Prints translated code.
}
\description{
\code{translate_tidyclust()} will translate_tidyclust a model specification into a
code object that is specific to a particular engine (e.g. R package). It
translate tidyclust generic parameters to their counterparts.
}
\details{
\code{translate_tidyclust()} produces a \emph{template} call that lacks the
specific argument values (such as \code{data}, etc). These are filled in once
\code{fit()} is called with the specifics of the data for the model. The call
may also include \code{tune()} arguments if these are in the specification. To
handle the \code{tune()} arguments, you need to use the \href{https://tune.tidymodels.org/}{tune package}. For more information see
\url{https://www.tidymodels.org/start/tuning/}

It does contain the resolved argument names that are specific to the model
fitting function/engine.

This function can be useful when you need to understand how \code{tidyclust}
goes from a generic model specific to a model fitting function.

\strong{Note}: this function is used internally and users should only use it
to understand what the underlying syntax would be. It should not be used to
modify the cluster specification.
}
