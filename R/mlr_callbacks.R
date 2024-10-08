#' @title Backup Benchmark Result Callback
#'
#' @include CallbackBatchFSelect.R
#' @name mlr3fselect.backup
#'
#' @description
#' This [CallbackBatchFSelect] writes the [mlr3::BenchmarkResult] after each batch to disk.
#'
#' @examples
#' clbk("mlr3fselect.backup", path = "backup.rds")
#'
#' # Run feature selection on the Palmer Penguins data set
#' instance = fselect(
#'   fselector = fs("random_search"),
#'   task = tsk("pima"),
#'   learner = lrn("classif.rpart"),
#'   resampling = rsmp ("holdout"),
#'   measures = msr("classif.ce"),
#'   term_evals = 4,
#'   callbacks = clbk("mlr3fselect.backup", path = tempfile(fileext = ".rds")))
NULL

load_callback_backup = function() {
  callback_batch_fselect("mlr3fselect.backup",
    label = "Backup Benchmark Result Callback",
    man = "mlr3fselect::mlr3fselect.backup",
    on_optimization_begin = function(callback, context) {
      if (is.null(callback$state$path)) callback$state$path = "bmr.rds"
      assert_path_for_output(callback$state$path)
    },

    on_optimizer_after_eval = function(callback, context) {
      if (file.exists(callback$state$path)) unlink(callback$state$path)
      saveRDS(context$instance$archive$benchmark_result, callback$state$path)
    }
  )
}

#' @title SVM-RFE Callback
#'
#' @include CallbackBatchFSelect.R
#' @name mlr3fselect.svm_rfe
#'
#' @description
#' Runs a recursive feature elimination with a [mlr3learners::LearnerClassifSVM].
#' The SVM must be configured with `type = "C-classification"` and `kernel = "linear"`.
#'
#' @source
#' `r format_bib("guyon2002")`
#'
#' @examples
#' clbk("mlr3fselect.svm_rfe")
#'
#' library(mlr3learners)
#'
#' # Create instance with classification svm with linear kernel
#' instance = fsi(
#'   task = tsk("sonar"),
#'   learner = lrn("classif.svm", type = "C-classification", kernel = "linear"),
#'   resampling = rsmp("cv", folds = 3),
#'   measures = msr("classif.ce"),
#'   terminator = trm("none"),
#'   callbacks = clbk("mlr3fselect.svm_rfe"),
#'   store_models = TRUE
#' )
#'
#' fselector = fs("rfe", feature_number = 5, n_features = 10)
#'
#' # Run recursive feature elimination on the Sonar data set
#' fselector$optimize(instance)
NULL

load_callback_svm_rfe = function() {
  callback_batch_fselect("mlr3fselect.svm_rfe",
    label = "SVM-RFE Callback",
    man = "mlr3fselect::mlr3fselect.svm_rfe",
    on_optimization_begin = function(callback, context) {
      requireNamespace("mlr3learners")
      learner = context$instance$objective$learner
      assert_class(learner, "LearnerClassifSVM", .var.name = "learner")
      params = learner$param_set$values

      if (isTRUE(params$type != "C-classification") || isTRUE(params$kernel != "linear")) {
        stop("Only SVMs with `type = 'C-classification'` and `kernel = 'linear'` are supported.")
      }

      LearnerClassifSVMRFE = R6Class("LearnerClassifSVMRFE", inherit = mlr3learners::LearnerClassifSVM,
        public = list(
          initialize = function() {
            super$initialize()
            self$properties = c(self$properties, "importance")
          },

          importance = function() {
            w = t(self$model$coefs) %*% self$model$SV
            x = w * w
            sort(x[1, ], decreasing = TRUE)
           }
      ))
      learner_rfe = LearnerClassifSVMRFE$new()
      learner_rfe$param_set$values = params
      learner_rfe$id = learner$id
      learner_rfe$predict_type = learner$predict_type

      fallback = learner$fallback
      if (packageVersion("mlr3") > "0.20.2") {
        method = unname(learner$encapsulation[1])
        learner_rfe$encapsulate(method, fallback)
      } else {
        learner_rfe$encapsulate = learner$encapsulate
        learner_rfe$fallback = fallback
      }
      learner_rfe$timeout = learner$timeout
      learner_rfe$parallel_predict = learner$parallel_predict
      context$instance$objective$learner = learner_rfe
    }
  )
}

#' @title One Standard Error Rule Callback
#'
#' @include CallbackBatchFSelect.R
#' @name mlr3fselect.one_se_rule
#'
#' @description
#' Selects the smallest feature set within one standard error of the best as the result.
#' If there are multiple such feature sets with the same number of features, the first one is selected.
#' If the sets have exactly the same performance but different number of features,
#' the one with the smallest number of features is selected.
#'
#' @source
#' `r format_bib("kuhn2013")`
#'
#' @examples
#' clbk("mlr3fselect.one_se_rule")
#'
#' # Run feature selection on the pima data set with the callback
#' instance = fselect(
#'   fselector = fs("random_search"),
#'   task = tsk("pima"),
#'   learner = lrn("classif.rpart"),
#'   resampling = rsmp ("cv", folds = 3),
#'   measures = msr("classif.ce"),
#'   term_evals = 10,
#'   callbacks = clbk("mlr3fselect.one_se_rule"))
#
#' # Smallest feature set within one standard error of the best
#' instance$result
NULL

load_callback_one_se_rule = function() {
  callback = callback_batch_fselect("mlr3fselect.one_se_rule",
    label = "One Standard Error Rule Callback",
    man = "mlr3fselect::mlr3fselect.one_se_rule",

    on_result = function(callback, context) {
      archive = context$instance$archive
      data = as.data.table(archive)
      data[, "n_features" := map(get("features"), length)]

      # standard error
      y = data[[archive$cols_y]]
      se = sd(y) / sqrt(length(y))

      columns_to_keep = setdiff(names(context$instance$result), "x_domain")
      if (se == 0) {
        # select smallest future set when all scores are the same
        context$instance$.__enclos_env__$private$.result =
          data[,columns_to_keep, with = FALSE][which.min(n_features)]
      } else {
        # select smallest future set within one standard error of the best
        best_y = context$instance$result_y
        context$instance$.__enclos_env__$private$.result =
          data[y > best_y - se & y < best_y + se, columns_to_keep, with = FALSE][which.min(n_features)]
      }
    }
  )
}
