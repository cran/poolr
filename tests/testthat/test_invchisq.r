### library(poolr); library(testthat); Sys.setenv(NOT_CRAN="true")
library(poolr)

source("tolerances.r")

context("Checking invchisq() function")

test_that("invchisq() works correctly under independence.", {

  res <- invchisq(grid2ip.p)
  out <- capture.output(print(res))

  expect_equivalent(c(res$p), 4.447048e-09, tolerance = p_tol)
  expect_equivalent(c(res$statistic), 85.21864, tolerance = stat_tol)
  expect_equivalent(attributes(res$statistic)$df, 23, tolerance = df_tol)

})

test_that("invchisq() works correctly with effective number of tests.", {

  res_nyh <- invchisq(grid2ip.p, adjust = "nyholt", R = mvnconv(grid2ip.ld, target = "p", cov2cor = TRUE))
  res_lj  <- invchisq(grid2ip.p, adjust = "liji", R = mvnconv(grid2ip.ld, target = "p", cov2cor = TRUE))
  res_gao <- invchisq(grid2ip.p, adjust = "gao", R = mvnconv(grid2ip.ld, target = "p", cov2cor = TRUE))
  res_gal <- invchisq(grid2ip.p, adjust = "galwey", R = mvnconv(grid2ip.ld, target = "p", cov2cor = TRUE))
  
  out <- capture.output(print(res_nyh))
  out <- capture.output(print(res_lj))
  out <- capture.output(print(res_gao))
  out <- capture.output(print(res_gal))

  expect_equivalent(c(res_nyh$p), 9.116737e-09, tolerance = p_tol)
  expect_equivalent(c(res_nyh$statistic), 81.51348, tolerance = stat_tol)

  expect_equivalent(c(res_lj$p), 1.870575e-08, tolerance = p_tol)
  expect_equivalent(c(res_lj$statistic), 77.80832, tolerance = stat_tol)

  expect_equivalent(c(res_gao$p), 4.447048e-09, tolerance = p_tol)
  expect_equivalent(c(res_gao$statistic), 85.21864, tolerance = stat_tol)

  expect_equivalent(c(res_gal$p), 3.841594e-08, tolerance = p_tol)
  expect_equivalent(c(res_gal$statistic), 74.10316, tolerance = stat_tol)

})

test_that("invchisq() works correctly with empirically-derived null distributions.", {

  set.seed(1234)
  res <- invchisq(grid2ip.p, adjust = "empirical", R = grid2ip.ld)
  out <- capture.output(print(res))

  expect_equivalent(c(res$p), 0.00089991, tolerance = p_tol * emp_sca)
  expect_equivalent(c(res$statistic), 85.21864, tolerance = stat_tol * emp_sca)
  expect_equivalent(c(res$ci[1]), 0.0004115761, tolerance = p_tol * emp_sca)
  expect_equivalent(c(res$ci[2]), 0.001707619, tolerance = p_tol * emp_sca)
  expect_equivalent(attributes(res$statistic)$df, 23, tolerance = df_tol)

  set.seed(1234)
  res <- invchisq(grid2ip.p, adjust = "empirical", R = grid2ip.ld, size = 100000)
  out <- capture.output(print(res))

  expect_equivalent(c(res$p), 0.001059989, tolerance = p_tol * emp_sca)
  expect_equivalent(c(res$statistic), 85.21864, tolerance = stat_tol * emp_sca)
  expect_equivalent(c(res$ci[1]), 0.0008679115, tolerance = p_tol * emp_sca)
  expect_equivalent(c(res$ci[2]), 0.001281884, tolerance = p_tol * emp_sca)
  expect_equivalent(attributes(res$statistic)$df, 23, tolerance = df_tol)

  set.seed(1234)
  res <- invchisq(grid2ip.p, adjust = "empirical", R = grid2ip.ld, size = 1000000, batchsize = 1000)
  out <- capture.output(print(res))

  expect_equivalent(c(res$p), 0.001145999, tolerance = p_tol * emp_sca)
  expect_equivalent(c(res$statistic), 85.21864, tolerance = stat_tol * emp_sca)
  expect_equivalent(c(res$ci[1]), 0.001080636, tolerance = p_tol * emp_sca)
  expect_equivalent(c(res$ci[2]), 0.001214278, tolerance = p_tol * emp_sca)
  expect_equivalent(attributes(res$statistic)$df, 23, tolerance = df_tol)

  set.seed(1234)
  res <- invchisq(grid2ip.p, adjust = "empirical", R = grid2ip.ld, size = c(1000, 10000, 100000), threshold = c(0.10, 0.01))
  out <- capture.output(print(res))

  expect_equivalent(c(res$p), 0.001299987, tolerance = p_tol * emp_sca)
  expect_equivalent(c(res$statistic), 85.21864, tolerance = stat_tol * emp_sca)
  expect_equivalent(c(res$ci[1]), 0.001086246, tolerance = p_tol * emp_sca)
  expect_equivalent(c(res$ci[2]), 0.001543441, tolerance = p_tol * emp_sca)
  expect_equivalent(attributes(res$statistic)$df, 23, tolerance = df_tol)

})

test_that("invchisq() works correctly under multivariate theory.", {

  res1 <- invchisq(grid2ip.p, adjust = "generalized", R = mvnconv(grid2ip.ld, side = 1))
  out <- capture.output(print(res1))

  expect_equivalent(c(res1$p), 2.067614e-05, tolerance = p_tol)
  expect_equivalent(c(res1$statistic), 42.01508, tolerance = stat_tol)
  expect_equivalent(attributes(res1$statistic)$df, 11.33962, tolerance = df_tol)

  res2 <- invchisq(grid2ip.p, adjust = "generalized", R = mvnconv(grid2ip.ld, side = 2))
  out <- capture.output(print(res2))

  expect_equivalent(c(res2$p), 0.0003818601, tolerance = p_tol)
  expect_equivalent(c(res2$statistic), 27.43317, tolerance = stat_tol)
  expect_equivalent(attributes(res2$statistic)$df, 7.404048, tolerance = df_tol)

})
