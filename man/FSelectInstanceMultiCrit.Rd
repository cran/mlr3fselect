% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/FSelectInstanceMultiCrit.R
\name{FSelectInstanceMultiCrit}
\alias{FSelectInstanceMultiCrit}
\title{Multi Criterion Feature Selection Instance}
\description{
Specifies a general feature selection scenario, including objective function
and archive for feature selection algorithms to act upon. This class stores
an \link{ObjectiveFSelect} object that encodes the black box objective function
which an \link{FSelector} has to optimize. It allows the basic operations of
querying the objective at feature subsets (\verb{$eval_batch()}), storing the
evaluations in the internal \link[bbotk:Archive]{bbotk::Archive} and accessing the final result
(\verb{$result}).

Evaluations of feature subsets are performed in batches by calling
\code{\link[mlr3:benchmark]{mlr3::benchmark()}} internally. Before a batch is evaluated, the
\link[bbotk:Terminator]{bbotk::Terminator} is queried for the remaining budget. If the available
budget is exhausted, an exception is raised, and no further evaluations can
be performed from this point on.

The \link{FSelector} is also supposed to store its final result, consisting
of the selected feature subsets and associated estimated performance values, by
calling the method \code{instance$assign_result()}.
}
\examples{
library(mlr3)
library(data.table)

# Objects required to define the performance evaluator
task = tsk("iris")
measures = msrs(c("classif.ce", "classif.acc"))
learner = lrn("classif.rpart")
resampling = rsmp("cv")
terminator = trm("evals", n_evals = 8)

inst = FSelectInstanceMultiCrit$new(
  task = task,
  learner = learner,
  resampling = resampling,
  measures = measures,
  terminator = terminator
)

# Try some feature subsets
xdt = data.table(
  Petal.Length = c(TRUE, FALSE),
  Petal.Width = c(FALSE, TRUE),
  Sepal.Length = c(TRUE, FALSE),
  Sepal.Width = c(FALSE, TRUE)
)

inst$eval_batch(xdt)

# Get archive data
as.data.table(inst$archive)
}
\section{Super classes}{
\code{\link[bbotk:OptimInstance]{bbotk::OptimInstance}} -> \code{\link[bbotk:OptimInstanceMultiCrit]{bbotk::OptimInstanceMultiCrit}} -> \code{FSelectInstanceMultiCrit}
}
\section{Active bindings}{
\if{html}{\out{<div class="r6-active-bindings">}}
\describe{
\item{\code{result_feature_set}}{(\code{list()} of \code{character()})\cr
Feature sets for task subsetting.}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{FSelectInstanceMultiCrit$new()}}
\item \href{#method-assign_result}{\code{FSelectInstanceMultiCrit$assign_result()}}
\item \href{#method-clone}{\code{FSelectInstanceMultiCrit$clone()}}
}
}
\if{html}{
\out{<details open ><summary>Inherited methods</summary>}
\itemize{
\item \out{<span class="pkg-link" data-pkg="bbotk" data-topic="OptimInstance" data-id="clear">}\href{../../bbotk/html/OptimInstance.html#method-clear}{\code{bbotk::OptimInstance$clear()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="bbotk" data-topic="OptimInstance" data-id="eval_batch">}\href{../../bbotk/html/OptimInstance.html#method-eval_batch}{\code{bbotk::OptimInstance$eval_batch()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="bbotk" data-topic="OptimInstance" data-id="format">}\href{../../bbotk/html/OptimInstance.html#method-format}{\code{bbotk::OptimInstance$format()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="bbotk" data-topic="OptimInstance" data-id="objective_function">}\href{../../bbotk/html/OptimInstance.html#method-objective_function}{\code{bbotk::OptimInstance$objective_function()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="bbotk" data-topic="OptimInstance" data-id="print">}\href{../../bbotk/html/OptimInstance.html#method-print}{\code{bbotk::OptimInstance$print()}}\out{</span>}
}
\out{</details>}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-new"></a>}}
\if{latex}{\out{\hypertarget{method-new}{}}}
\subsection{Method \code{new()}}{
Creates a new instance of this \link[R6:R6Class]{R6} class.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FSelectInstanceMultiCrit$new(
  task,
  learner,
  resampling,
  measures,
  terminator,
  store_models = FALSE,
  check_values = TRUE,
  store_benchmark_result = TRUE
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{task}}{(\link[mlr3:Task]{mlr3::Task})\cr
Task to operate on.}

\item{\code{learner}}{(\link[mlr3:Learner]{mlr3::Learner}).}

\item{\code{resampling}}{(\link[mlr3:Resampling]{mlr3::Resampling})\cr
Uninstantiated resamplings are instantiated during construction
so that all configurations are evaluated on the same data splits.}

\item{\code{measures}}{(list of \link[mlr3:Measure]{mlr3::Measure})\cr
Measures to optimize.
If \code{NULL}, \CRANpkg{mlr3}'s default measure is used.}

\item{\code{terminator}}{(\link[bbotk:Terminator]{bbotk::Terminator}).}

\item{\code{store_models}}{(\code{logical(1)}).
Store models in benchmark result?}

\item{\code{check_values}}{(\code{logical(1)})\cr
Check the parameters before the evaluation and the results for
validity?}

\item{\code{store_benchmark_result}}{(\code{logical(1)})\cr
Store benchmark result in archive?}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-assign_result"></a>}}
\if{latex}{\out{\hypertarget{method-assign_result}{}}}
\subsection{Method \code{assign_result()}}{
The \link{FSelector} object writes the best found feature subsets
and estimated performance values here. For internal use.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FSelectInstanceMultiCrit$assign_result(xdt, ydt)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{xdt}}{(\code{data.table::data.table()})\cr
x values as \code{data.table}. Each row is one point. Contains the value in
the \emph{search space} of the \link{FSelectInstanceMultiCrit} object. Can contain
additional columns for extra information.}

\item{\code{ydt}}{(\code{data.table::data.table()})\cr
Optimal outcomes, e.g. the Pareto front.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clone"></a>}}
\if{latex}{\out{\hypertarget{method-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FSelectInstanceMultiCrit$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
