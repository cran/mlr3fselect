% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sugar.R
\name{fs}
\alias{fs}
\title{Syntactic Sugar for FSelect Construction}
\usage{
fs(.key, ...)
}
\arguments{
\item{.key}{(\code{character(1)})\cr
Key passed to the respective \link[mlr3misc:Dictionary]{dictionary} to retrieve the object.}

\item{...}{(named \code{list()})\cr
Named arguments passed to the constructor, to be set as parameters in the \link[paradox:ParamSet]{paradox::ParamSet}, or to be set as public field.
See \code{\link[mlr3misc:dictionary_sugar_get]{mlr3misc::dictionary_sugar_get()}} for more details.}
}
\value{
\link{FSelector}.
}
\description{
This function complements \link{mlr_fselectors} with functions in the spirit
of \link[mlr3:mlr_sugar]{mlr3::mlr_sugar}.
}
\examples{
fs("sequential", max_features = 4)
}
