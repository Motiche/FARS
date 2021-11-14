require(testthat)
library(dplyr)
library(FARS)
test_that("testing make_filename", {
  expect_that(make_filename(2013), is_identical_to("accident_2013.csv.bz2"))})

