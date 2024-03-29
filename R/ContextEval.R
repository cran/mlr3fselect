#' @title Evaluation Context
#'
#' @description
#' The [ContextEval] allows [CallbackFSelect]s to access and modify data while a batch of feature sets is evaluated.
#' See the section on active bindings for a list of modifiable objects.
#' See [callback_fselect()] for a list of stages that access [ContextEval].
#'
#' @details
#' This context is re-created each time a new batch of feature sets is evaluated.
#' Changes to `$objective_fselect`, `$design` `$benchmark_result` are discarded after the function is finished.
#' Modification on the data table in `$aggregated_performance` are written to the archive.
#' Any number of columns can be added.
#'
#' @export
ContextEval = R6Class("ContextEval",
  inherit = mlr3misc::Context,
  public = list(

    #' @field objective_fselect [ObjectiveFSelect].
    objective_fselect = NULL,

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    #'
    #' @param id (`character(1)`)\cr
    #'   Identifier for the new callback.
    #' @param objective_fselect [ObjectiveFSelect].
    initialize = function(objective_fselect) {
      self$objective_fselect = assert_r6(objective_fselect, "ObjectiveFSelect")
    }
  ),

  active = list(
    #' @field xss (list())\cr
    #'   The feature sets of the latest batch.
    xss = function(rhs) {
      if (missing(rhs)) {
        return(get_private(self$objective_fselect)$.xss)
      } else {
        get_private(self$objective_fselect)$.xss = rhs
      }
    },

    #' @field design ([data.table::data.table])\cr
    #'   The benchmark design of the latest batch.
    design = function(rhs) {
      if (missing(rhs)) {
        return(get_private(self$objective_fselect)$.design)
      } else {
        get_private(self$objective_fselect)$.design = rhs
      }
    },

    #' @field benchmark_result ([mlr3::BenchmarkResult])\cr
    #'   The benchmark result of the latest batch.
    benchmark_result = function(rhs) {
      if (missing(rhs)) {
        return(get_private(self$objective_fselect)$.benchmark_result)
      } else {
        get_private(self$objective_fselect)$.benchmark_result = rhs
      }
    },

    #' @field aggregated_performance ([data.table::data.table])\cr
    #'   Aggregated performance scores and training time of the latest batch.
    #'   This data table is passed to the archive.
    #'   A callback can add additional columns which are also written to the archive.
    aggregated_performance = function(rhs) {
      if (missing(rhs)) {
        return(get_private(self$objective_fselect)$.aggregated_performance)
      } else {
        get_private(self$objective_fselect)$.aggregated_performance = rhs
      }
    }
  )
)
