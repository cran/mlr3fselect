test_that("ArchiveAsyncTuningFrozen works", {
  skip_on_cran()
  skip_if_not_installed("rush")
  flush_redis()
  on.exit({
    mirai::daemons(0)
    flush_redis()
  })

  mirai::daemons(2)
  rush::rush_plan(n_workers = 2, worker_type = "remote")

  instance = fsi_async(
    task = tsk("pima"),
    learner = lrn("classif.rpart"),
    resampling = rsmp("cv", folds = 3),
    measures = msr("classif.ce"),
    terminator = trm("evals", n_evals = 20),
    store_benchmark_result = TRUE
  )
  fselector = fs("async_random_search")
  fselector$optimize(instance)

  archive = instance$archive
  frozen_archive = ArchiveAsyncFSelectFrozen$new(archive)

  expect_data_table(frozen_archive$data)
  expect_data_table(frozen_archive$queued_data)
  expect_data_table(frozen_archive$running_data)
  expect_data_table(frozen_archive$finished_data)
  expect_data_table(frozen_archive$failed_data)
  expect_number(frozen_archive$n_queued)
  expect_number(frozen_archive$n_running)
  expect_number(frozen_archive$n_finished)
  expect_number(frozen_archive$n_failed)
  expect_number(frozen_archive$n_evals)
  expect_benchmark_result(frozen_archive$benchmark_result)

  expect_data_table(as.data.table(frozen_archive))
  expect_rush_reset(instance$rush)
})
