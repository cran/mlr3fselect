#' @title Asynchronous Feature Selection Callback
#'
#' @description
#' Specialized [bbotk::CallbackAsync] for asynchronous feature selection.
#' Callbacks allow to customize the behavior of processes in mlr3fselect.
#' The [callback_async_fselect()] function creates a [CallbackAsyncFSelect].
#' Predefined callbacks are stored in the [dictionary][mlr3misc::Dictionary] [mlr_callbacks] and can be retrieved with [clbk()].
#' For more information on feature selection callbacks see [callback_async_fselect()].
#'
#' @export
CallbackAsyncFSelect = R6Class("CallbackAsyncFSelect",
  inherit = CallbackAsync,
  public = list(

    #' @field on_eval_after_xs (`function()`)\cr
    #' Stage called after xs is passed.
    #' Called in `ObjectiveFSelectAsync$eval()`.
    on_eval_after_xs = NULL,

    #' @field on_resample_begin (`function()`)\cr
    #' Stage called at the beginning of an evaluation.
    #' Called in `workhorse()` (internal).
    on_resample_begin = NULL,

    #' @field on_resample_before_train (`function()`)\cr
    #' Stage called before training the learner.
    #' Called in `workhorse()` (internal).
    on_resample_before_train = NULL,

    #' @field on_resample_before_predict (`function()`)\cr
    #' Stage called before predicting.
    #' Called in `workhorse()` (internal).
    on_resample_before_predict = NULL,

    #' @field on_resample_end (`function()`)\cr
    #' Stage called at the end of an evaluation.
    #' Called in `workhorse()` (internal).
    on_resample_end = NULL,

    #' @field on_eval_after_resample (`function()`)\cr
    #' Stage called after feature subsets are evaluated.
    #' Called in `ObjectiveFSelectAsync$eval()`.
    on_eval_after_resample = NULL,

    #' @field on_eval_before_archive (`function()`)\cr
    #' Stage called before performance values are written to the archive.
    #' Called in `ObjectiveFSelectAsync$eval()`.
    on_eval_before_archive = NULL,

    #' @field on_fselect_result_begin (`function()`)\cr
    #' Stage called before the results are written.
    #' Called in `FSelectInstance*$assign_result()`.
    on_fselect_result_begin = NULL
  )
)

#' @title Create Asynchronous Feature Selection Callback
#'
#' @description
#' Function to create a [CallbackAsyncFSelect].
#' Predefined callbacks are stored in the [dictionary][mlr3misc::Dictionary] [mlr_callbacks] and can be retrieved with [clbk()].
#'
#' Feature selection callbacks can be called from different stages of the feature selection process.
#' The stages are prefixed with `on_*`.
#'
#' ```
#' Start Feature Selection
#'      - on_optimization_begin
#'     Start Worker
#'          - on_worker_begin
#'          Start Optimization on Worker
#'            - on_optimizer_before_eval
#'              Start Evaluation
#'                - on_eval_after_xs
#'                  Start Resampling Iteration
#'                    - on_resample_begin
#'                    - on_resample_before_train
#'                    - on_resample_before_predict
#'                    - on_resample_end
#'                  End Resampling Iteration
#'                - on_eval_after_resample
#'                - on_eval_before_archive
#'              End Evaluation
#'           - on_optimizer_after_eval
#'          End Optimization on Worker
#'          - on_worker_end
#'     End Worker
#'      - on_fselect_result_begin
#'      - on_result_begin
#'      - on_result_end
#'      - on_optimization_end
#' End Feature Selection
#' ```
#'
#' See also the section on parameters for more information on the stages.
#' A feature selection callback works with [ContextAsyncFSelect].
#'
#' @details
#' When implementing a callback, each function must have two arguments named `callback` and `context`.
#' A callback can write data to the state (`$state`), e.g. settings that affect the callback itself.
#' Feature selection callbacks access [ContextAsyncFSelect] and [mlr3::ContextResample].
#'
#' @param id (`character(1)`)\cr
#'  Identifier for the new instance.
#' @param label (`character(1)`)\cr
#'  Label for the new instance.
#' @param man (`character(1)`)\cr
#'  String in the format `[pkg]::[topic]` pointing to a manual page for this object.
#'  The referenced help package can be opened via method `$help()`.
#'
#' @param on_optimization_begin (`function()`)\cr
#'  Stage called at the beginning of the optimization.
#'  Called in `Optimizer$optimize()`.
#'  The functions must have two arguments named `callback` and `context`.
#' @param on_worker_begin (`function()`)\cr
#'  Stage called at the beginning of the optimization on the worker.
#'  Called in the worker loop.
#'  The functions must have two arguments named `callback` and `context`.
#' @param on_optimizer_before_eval (`function()`)\cr
#'  Stage called after the optimizer proposes points.
#'  Called in `OptimInstance$.eval_point()`.
#'  The functions must have two arguments named `callback` and `context`.
#'  The argument of `instance$.eval_point(xs)` and `xs_trafoed` and `extra` are available in the `context`.
#'  Or `xs` and `xs_trafoed` of `instance$.eval_queue()` are available in the `context`.
#' @param on_eval_after_xs (`function()`)\cr
#'  Stage called after xs is passed to the objective.
#'  Called in `ObjectiveFSelectAsync$eval()`.
#'  The functions must have two arguments named `callback` and `context`.
#'  The argument of `$.eval(xs)` is available in the `context`.
#' @param on_resample_begin (`function()`)\cr
#'  Stage called at the beginning of a resampling iteration.
#'  Called in `workhorse()` (internal).
#'  See also [mlr3::callback_resample()].
#'  The functions must have two arguments named `callback` and `context`.
#' @param on_resample_before_train (`function()`)\cr
#'  Stage called before training the learner.
#'  Called in `workhorse()` (internal).
#'  See also [mlr3::callback_resample()].
#'  The functions must have two arguments named `callback` and `context`.
#' @param on_resample_before_predict (`function()`)\cr
#'  Stage called before predicting.
#'  Called in `workhorse()` (internal).
#'  See also [mlr3::callback_resample()].
#'  The functions must have two arguments named `callback` and `context`.
#' @param on_resample_end (`function()`)\cr
#'  Stage called at the end of a resampling iteration.
#'  Called in `workhorse()` (internal).
#'  See also [mlr3::callback_resample()].
#'  The functions must have two arguments named `callback` and `context`.
#' @param on_eval_after_resample (`function()`)\cr
#'  Stage called after a feature subset is evaluated.
#'  Called in `ObjectiveFSelectAsync$eval()`.
#'  The functions must have two arguments named `callback` and `context`.
#'  The `resample_result` is available in the `context`.
#' @param on_eval_before_archive (`function()`)\cr
#'  Stage called before performance values are written to the archive.
#'  Called in `ObjectiveFSelectAsync$eval()`.
#'  The functions must have two arguments named `callback` and `context`.
#'  The `aggregated_performance` is available in `context`.
#' @param on_optimizer_after_eval (`function()`)\cr
#'  Stage called after points are evaluated.
#'  Called in `OptimInstance$.eval_point()`.
#'  The functions must have two arguments named `callback` and `context`.
#' @param on_worker_end (`function()`)\cr
#'  Stage called at the end of the optimization on the worker.
#'  Called in the worker loop.
#'  The functions must have two arguments named `callback` and `context`.
#' @param on_fselect_result_begin (`function()`)\cr
#'  Stage called at the beginning of the result writing.
#'  Called in `FSelectInstance*$assign_result()`.
#'  The functions must have two arguments named `callback` and `context`.
#'  The arguments of `$assign_result(xdt, y, extra)` are available in `context`.
#' @param on_result_begin (`function()`)\cr
#'  Stage called at the beginning of the result writing.
#'  Called in `OptimInstance$assign_result()`.
#'  The functions must have two arguments named `callback` and `context`.
#'  The arguments of `$.assign_result(xdt, y, extra)` are available in the `context`.
#' @param on_result_end (`function()`)\cr
#'  Stage called after the result is written.
#'  Called in `OptimInstance$assign_result()`.
#'  The functions must have two arguments named `callback` and `context`.
#'  The final result `instance$result` is available in the `context`.
#' @param on_result (`function()`)\cr
#'  Deprecated.
#'  Use `on_result_end` instead.
#'  Stage called after the result is written.
#'  Called in `OptimInstance$assign_result()`.
#' @param on_optimization_end (`function()`)\cr
#'   Stage called at the end of the optimization.
#'   Called in `Optimizer$optimize()`.
#'
#' @export
callback_async_fselect = function(
  id,
  label = NA_character_,
  man = NA_character_,
  on_optimization_begin = NULL,
  on_worker_begin = NULL,
  on_optimizer_before_eval = NULL,
  on_eval_after_xs = NULL,
  on_resample_begin = NULL,
  on_resample_before_train = NULL,
  on_resample_before_predict = NULL,
  on_resample_end = NULL,
  on_eval_after_resample = NULL,
  on_eval_before_archive = NULL,
  on_optimizer_after_eval = NULL,
  on_worker_end = NULL,
  on_fselect_result_begin = NULL,
  on_result_begin = NULL,
  on_result_end = NULL,
  on_result = NULL,
  on_optimization_end = NULL
  ) {
  stages = discard(set_names(list(
    on_optimization_begin,
    on_worker_begin,
    on_optimizer_before_eval,
    on_eval_after_xs,
    on_resample_begin,
    on_resample_before_train,
    on_resample_before_predict,
    on_resample_end,
    on_eval_after_resample,
    on_eval_before_archive,
    on_optimizer_after_eval,
    on_worker_end,
    on_fselect_result_begin,
    on_result_begin,
    on_result_end,
    on_result,
    on_optimization_end),
    c(
      "on_optimization_begin",
      "on_worker_begin",
      "on_optimizer_before_eval",
      "on_eval_after_xs",
      "on_resample_begin",
      "on_resample_before_train",
      "on_resample_before_predict",
      "on_resample_end",
      "on_eval_after_resample",
      "on_eval_before_archive",
      "on_optimizer_after_eval",
      "on_worker_end",
      "on_fselect_result_begin",
      "on_result_begin",
      "on_result_end",
      "on_result",
      "on_optimization_end")), is.null)

  if ("on_result" %in% names(stages)) {
    .Deprecated(old = "on_result", new = "on_result_end")
    stages$on_result_end = stages$on_result
    stages$on_result = NULL
  }

  walk(stages, function(stage) assert_function(stage, args = c("callback", "context")))
  callback = CallbackAsyncFSelect$new(id, label, man)
  iwalk(stages, function(stage, name) callback[[name]] = stage)
  callback
}

#' @title Assertions for Callbacks
#'
#' @description
#' Assertions for [CallbackAsyncFSelect] class.
#'
#' @param callback ([CallbackAsyncFSelect]).
#' @param null_ok (`logical(1)`)\cr
#'   If `TRUE`, `NULL` is allowed.
#'
#' @return [CallbackAsyncFSelect | List of [CallbackAsyncFSelect]s.
#' @export
assert_async_fselect_callback = function(callback, null_ok = FALSE) {
  if (null_ok && is.null(callback)) return(invisible(NULL))
  assert_class(callback, "CallbackAsyncFSelect")
  invisible(callback)
}

#' @export
#' @param callbacks (list of [CallbackAsyncFSelect]).
#' @rdname assert_async_fselect_callback
assert_async_fselect_callbacks = function(callbacks) {
  invisible(lapply(callbacks, assert_callback))
}
