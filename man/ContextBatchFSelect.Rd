% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ContextBatchFSelect.R
\name{ContextBatchFSelect}
\alias{ContextBatchFSelect}
\title{Evaluation Context}
\description{
The \link{ContextBatchFSelect} allows \link{CallbackBatchFSelect}s to access and modify data while a batch of feature sets is evaluated.
See the section on active bindings for a list of modifiable objects.
See \code{\link[=callback_batch_fselect]{callback_batch_fselect()}} for a list of stages that access \link{ContextBatchFSelect}.
}
\details{
This context is re-created each time a new batch of feature sets is evaluated.
Changes to \verb{$objective_fselect}, \verb{$design} \verb{$benchmark_result} are discarded after the function is finished.
Modification on the data table in \verb{$aggregated_performance} are written to the archive.
Any number of columns can be added.
}
\section{Super classes}{
\code{\link[mlr3misc:Context]{mlr3misc::Context}} -> \code{\link[bbotk:ContextBatch]{bbotk::ContextBatch}} -> \code{ContextBatchFSelect}
}
\section{Public fields}{
\if{html}{\out{<div class="r6-fields">}}
\describe{
\item{\code{auto_fselector}}{(\link{AutoFSelector})\cr
The \link{AutoFSelector} instance.}
}
\if{html}{\out{</div>}}
}
\section{Active bindings}{
\if{html}{\out{<div class="r6-active-bindings">}}
\describe{
\item{\code{xss}}{(list())\cr
The feature sets of the latest batch.}

\item{\code{design}}{(\link[data.table:data.table]{data.table::data.table})\cr
The benchmark design of the latest batch.}

\item{\code{benchmark_result}}{(\link[mlr3:BenchmarkResult]{mlr3::BenchmarkResult})\cr
The benchmark result of the latest batch.}

\item{\code{aggregated_performance}}{(\link[data.table:data.table]{data.table::data.table})\cr
Aggregated performance scores and training time of the latest batch.
This data table is passed to the archive.
A callback can add additional columns which are also written to the archive.}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-ContextBatchFSelect-clone}{\code{ContextBatchFSelect$clone()}}
}
}
\if{html}{\out{
<details open><summary>Inherited methods</summary>
<ul>
<li><span class="pkg-link" data-pkg="mlr3misc" data-topic="Context" data-id="format"><a href='../../mlr3misc/html/Context.html#method-Context-format'><code>mlr3misc::Context$format()</code></a></span></li>
<li><span class="pkg-link" data-pkg="mlr3misc" data-topic="Context" data-id="print"><a href='../../mlr3misc/html/Context.html#method-Context-print'><code>mlr3misc::Context$print()</code></a></span></li>
<li><span class="pkg-link" data-pkg="bbotk" data-topic="ContextBatch" data-id="initialize"><a href='../../bbotk/html/ContextBatch.html#method-ContextBatch-initialize'><code>bbotk::ContextBatch$initialize()</code></a></span></li>
</ul>
</details>
}}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ContextBatchFSelect-clone"></a>}}
\if{latex}{\out{\hypertarget{method-ContextBatchFSelect-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ContextBatchFSelect$clone(deep = FALSE)}\if{html}{\out{</div>}}
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
