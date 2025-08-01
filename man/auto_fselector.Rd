% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/auto_fselector.R
\name{auto_fselector}
\alias{auto_fselector}
\title{Function for Automatic Feature Selection}
\usage{
auto_fselector(
  fselector,
  learner,
  resampling,
  measure = NULL,
  term_evals = NULL,
  term_time = NULL,
  terminator = NULL,
  store_fselect_instance = TRUE,
  store_benchmark_result = TRUE,
  store_models = FALSE,
  check_values = FALSE,
  callbacks = NULL,
  ties_method = "least_features",
  rush = NULL,
  id = NULL
)
}
\arguments{
\item{fselector}{(\link{FSelector})\cr
Optimization algorithm.}

\item{learner}{(\link[mlr3:Learner]{mlr3::Learner})\cr
Learner to optimize the feature subset for.}

\item{resampling}{(\link[mlr3:Resampling]{mlr3::Resampling})\cr
Resampling that is used to evaluated the performance of the feature subsets.
Uninstantiated resamplings are instantiated during construction so that all feature subsets are evaluated on the same data splits.
Already instantiated resamplings are kept unchanged.}

\item{measure}{(\link[mlr3:Measure]{mlr3::Measure})\cr
Measure to optimize. If \code{NULL}, default measure is used.}

\item{term_evals}{(\code{integer(1)})\cr
Number of allowed evaluations.
Ignored if \code{terminator} is passed.}

\item{term_time}{(\code{integer(1)})\cr
Maximum allowed time in seconds.
Ignored if \code{terminator} is passed.}

\item{terminator}{(\link[bbotk:Terminator]{bbotk::Terminator})\cr
Stop criterion of the feature selection.}

\item{store_fselect_instance}{(\code{logical(1)})\cr
If \code{TRUE} (default), stores the internally created \link{FSelectInstanceBatchSingleCrit} with all intermediate results in slot \verb{$fselect_instance}.
Is set to \code{TRUE}, if \code{store_models = TRUE}}

\item{store_benchmark_result}{(\code{logical(1)})\cr
Store benchmark result in archive?}

\item{store_models}{(\code{logical(1)}).
Store models in benchmark result?}

\item{check_values}{(\code{logical(1)})\cr
Check the parameters before the evaluation and the results for
validity?}

\item{callbacks}{(list of \link{CallbackBatchFSelect})\cr
List of callbacks.}

\item{ties_method}{(\code{character(1)})\cr
The method to break ties when selecting sets while optimizing and when selecting the best set.
Can be \code{"least_features"} or \code{"random"}.
The option \code{"least_features"} (default) selects the feature set with the least features.
If there are multiple best feature sets with the same number of features, one is selected randomly.
The \code{random} method returns a random feature set from the best feature sets.
Ignored if multiple measures are used.}

\item{rush}{(\code{Rush})\cr
If a rush instance is supplied, the optimization runs without batches.}

\item{id}{(\code{character(1)})\cr
Identifier for the new instance.}
}
\value{
\link{AutoFSelector}.
}
\description{
The \link{AutoFSelector} wraps a \link[mlr3:Learner]{mlr3::Learner} and augments it with an automatic feature selection.
The \code{\link[=auto_fselector]{auto_fselector()}} function creates an \link{AutoFSelector} object.
}
\details{
The \link{AutoFSelector} is a \link[mlr3:Learner]{mlr3::Learner} which wraps another \link[mlr3:Learner]{mlr3::Learner} and performs the following steps during \verb{$train()}:
\enumerate{
\item The wrapped (inner) learner is trained on the feature subsets via resampling.
The feature selection can be specified by providing a \link{FSelector}, a \link[bbotk:Terminator]{bbotk::Terminator}, a \link[mlr3:Resampling]{mlr3::Resampling} and a \link[mlr3:Measure]{mlr3::Measure}.
\item A final model is fit on the complete training data with the best-found feature subset.
}

During \verb{$predict()} the \link{AutoFSelector} just calls the predict method of the wrapped (inner) learner.
}
\section{Resources}{

There are several sections about feature selection in the \href{https://mlr3book.mlr-org.com}{mlr3book}.
\itemize{
\item Estimate Model Performance with \href{https://mlr3book.mlr-org.com/chapters/chapter6/feature_selection.html#sec-autofselect}{nested resampling}.
}

The \href{https://mlr-org.com/gallery.html}{gallery} features a collection of case studies and demos about optimization.
}

\section{Nested Resampling}{

Nested resampling can be performed by passing an \link{AutoFSelector} object to \code{\link[mlr3:resample]{mlr3::resample()}} or \code{\link[mlr3:benchmark]{mlr3::benchmark()}}.
To access the inner resampling results, set \code{store_fselect_instance = TRUE} and execute \code{\link[mlr3:resample]{mlr3::resample()}} or \code{\link[mlr3:benchmark]{mlr3::benchmark()}} with \code{store_models = TRUE} (see examples).
The \link[mlr3:Resampling]{mlr3::Resampling} passed to the \link{AutoFSelector} is meant to be the inner resampling, operating on the training set of an arbitrary outer resampling.
For this reason it is not feasible to pass an instantiated \link[mlr3:Resampling]{mlr3::Resampling} here.
}

\examples{
afs = auto_fselector(
  fselector = fs("random_search"),
  learner = lrn("classif.rpart"),
  resampling = rsmp("holdout"),
  measure = msr("classif.ce"),
  term_evals = 4)

afs$train(tsk("pima"))
}
