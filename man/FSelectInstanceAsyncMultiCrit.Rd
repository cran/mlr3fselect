% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/FSelectInstanceAsyncMultiCrit.R
\name{FSelectInstanceAsyncMultiCrit}
\alias{FSelectInstanceAsyncMultiCrit}
\title{Multi-Criteria Feature Selection with Rush}
\description{
The \code{FSelectInstanceAsyncMultiCrit} specifies a feature selection problem for a \link{FSelectorAsync}.
The function \code{\link[=fsi_async]{fsi_async()}} creates a \link{FSelectInstanceAsyncMultiCrit} and the function \code{\link[=fselect]{fselect()}} creates an instance internally.
}
\section{Default Measures}{

If no measure is passed, the default measure is used.
The default measure depends on the task type.\tabular{lll}{
   Task \tab Default Measure \tab Package \cr
   \code{"classif"} \tab \code{"classif.ce"} \tab \CRANpkg{mlr3} \cr
   \code{"regr"} \tab \code{"regr.mse"} \tab \CRANpkg{mlr3} \cr
   \code{"surv"} \tab \code{"surv.cindex"} \tab \CRANpkg{mlr3proba} \cr
   \code{"dens"} \tab \code{"dens.logloss"} \tab \CRANpkg{mlr3proba} \cr
   \code{"classif_st"} \tab \code{"classif.ce"} \tab \CRANpkg{mlr3spatial} \cr
   \code{"regr_st"} \tab \code{"regr.mse"} \tab \CRANpkg{mlr3spatial} \cr
   \code{"clust"} \tab \code{"clust.dunn"} \tab \CRANpkg{mlr3cluster} \cr
}
}

\section{Analysis}{

For analyzing the feature selection results, it is recommended to pass the \link{ArchiveAsyncFSelect} to \code{as.data.table()}.
The returned data table contains the \link[mlr3:ResampleResult]{mlr3::ResampleResult} for each feature subset evaluation.
}

\section{Resources}{

There are several sections about feature selection in the \href{https://mlr3book.mlr-org.com}{mlr3book}.
\itemize{
\item Getting started with \href{https://mlr3book.mlr-org.com/chapters/chapter6/feature_selection.html#sec-fs-wrapper}{wrapper feature selection}.
\item Do a \href{https://mlr3book.mlr-org.com/chapters/chapter6/feature_selection.html#sec-fs-wrapper-example}{sequential forward selection} Palmer Penguins data set.
}

The \href{https://mlr-org.com/gallery.html}{gallery} features a collection of case studies and demos about optimization.
\itemize{
\item Utilize the built-in feature importance of models with \href{https://mlr-org.com/gallery/optimization/2023-02-07-recursive-feature-elimination/}{Recursive Feature Elimination}.
\item Run a feature selection with \href{https://mlr-org.com/gallery/optimization/2023-02-01-shadow-variable-search/}{Shadow Variable Search}.
}
}

\section{Super classes}{
\code{\link[bbotk:OptimInstance]{bbotk::OptimInstance}} -> \code{\link[bbotk:OptimInstanceAsync]{bbotk::OptimInstanceAsync}} -> \code{\link[bbotk:OptimInstanceAsyncMultiCrit]{bbotk::OptimInstanceAsyncMultiCrit}} -> \code{FSelectInstanceAsyncMultiCrit}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-FSelectInstanceAsyncMultiCrit-new}{\code{FSelectInstanceAsyncMultiCrit$new()}}
\item \href{#method-FSelectInstanceAsyncMultiCrit-assign_result}{\code{FSelectInstanceAsyncMultiCrit$assign_result()}}
\item \href{#method-FSelectInstanceAsyncMultiCrit-clone}{\code{FSelectInstanceAsyncMultiCrit$clone()}}
}
}
\if{html}{\out{
<details open><summary>Inherited methods</summary>
<ul>
<li><span class="pkg-link" data-pkg="bbotk" data-topic="OptimInstance" data-id="format"><a href='../../bbotk/html/OptimInstance.html#method-OptimInstance-format'><code>bbotk::OptimInstance$format()</code></a></span></li>
<li><span class="pkg-link" data-pkg="bbotk" data-topic="OptimInstanceAsync" data-id="clear"><a href='../../bbotk/html/OptimInstanceAsync.html#method-OptimInstanceAsync-clear'><code>bbotk::OptimInstanceAsync$clear()</code></a></span></li>
<li><span class="pkg-link" data-pkg="bbotk" data-topic="OptimInstanceAsync" data-id="print"><a href='../../bbotk/html/OptimInstanceAsync.html#method-OptimInstanceAsync-print'><code>bbotk::OptimInstanceAsync$print()</code></a></span></li>
<li><span class="pkg-link" data-pkg="bbotk" data-topic="OptimInstanceAsync" data-id="reconnect"><a href='../../bbotk/html/OptimInstanceAsync.html#method-OptimInstanceAsync-reconnect'><code>bbotk::OptimInstanceAsync$reconnect()</code></a></span></li>
</ul>
</details>
}}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FSelectInstanceAsyncMultiCrit-new"></a>}}
\if{latex}{\out{\hypertarget{method-FSelectInstanceAsyncMultiCrit-new}{}}}
\subsection{Method \code{new()}}{
Creates a new instance of this \link[R6:R6Class]{R6} class.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FSelectInstanceAsyncMultiCrit$new(
  task,
  learner,
  resampling,
  measures,
  terminator,
  store_benchmark_result = TRUE,
  store_models = FALSE,
  check_values = FALSE,
  callbacks = NULL,
  rush = NULL
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{task}}{(\link[mlr3:Task]{mlr3::Task})\cr
Task to operate on.}

\item{\code{learner}}{(\link[mlr3:Learner]{mlr3::Learner})\cr
Learner to optimize the feature subset for.}

\item{\code{resampling}}{(\link[mlr3:Resampling]{mlr3::Resampling})\cr
Resampling that is used to evaluated the performance of the feature subsets.
Uninstantiated resamplings are instantiated during construction so that all feature subsets are evaluated on the same data splits.
Already instantiated resamplings are kept unchanged.}

\item{\code{measures}}{(list of \link[mlr3:Measure]{mlr3::Measure})\cr
Measures to optimize.
If \code{NULL}, \CRANpkg{mlr3}'s default measure is used.}

\item{\code{terminator}}{(\link[bbotk:Terminator]{bbotk::Terminator})\cr
Stop criterion of the feature selection.}

\item{\code{store_benchmark_result}}{(\code{logical(1)})\cr
Store benchmark result in archive?}

\item{\code{store_models}}{(\code{logical(1)}).
Store models in benchmark result?}

\item{\code{check_values}}{(\code{logical(1)})\cr
Check the parameters before the evaluation and the results for
validity?}

\item{\code{callbacks}}{(list of \link{CallbackBatchFSelect})\cr
List of callbacks.}

\item{\code{rush}}{(\code{Rush})\cr
If a rush instance is supplied, the optimization runs without batches.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FSelectInstanceAsyncMultiCrit-assign_result"></a>}}
\if{latex}{\out{\hypertarget{method-FSelectInstanceAsyncMultiCrit-assign_result}{}}}
\subsection{Method \code{assign_result()}}{
The \link{FSelectorAsync} object writes the best found points and estimated performance values here (probably the Pareto set / front).
For internal use.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FSelectInstanceAsyncMultiCrit$assign_result(xdt, ydt, extra = NULL, ...)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{xdt}}{(\code{data.table::data.table()})\cr
x values as \code{data.table}. Each row is one point. Contains the value in
the \emph{search space} of the \link{FSelectInstanceBatchMultiCrit} object. Can contain
additional columns for extra information.}

\item{\code{ydt}}{(\code{numeric()})\cr
Optimal outcomes, e.g. the Pareto front.}

\item{\code{extra}}{(\code{data.table::data.table()})\cr
Additional information.}

\item{\code{...}}{(\code{any})\cr
ignored.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FSelectInstanceAsyncMultiCrit-clone"></a>}}
\if{latex}{\out{\hypertarget{method-FSelectInstanceAsyncMultiCrit-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FSelectInstanceAsyncMultiCrit$clone(deep = FALSE)}\if{html}{\out{</div>}}
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
