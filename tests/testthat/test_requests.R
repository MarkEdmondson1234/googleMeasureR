context("Can make requests")
options(googleMeasureR.debug = TRUE)

test_that("Can make a request", {

  req <- gmr_post(list(t=2, tid = "UA-XXXXX-Y", cid = 1234567L))

  expect_false(req$hitParsingResult$valid)

})

test_that("Can make a page type request", {

  req <- gmr_hit_page("/hi-from-r-test", dp = "/bye-from-r-test")

  expect_true(req$hitParsingResult$valid)

})

test_that("My own cid", {
  my_cid <- gmr_uuid()

  req <- gmr_hit_page("/hi-from-r-cid", cid = my_cid)

  expect_true(req$hitParsingResult$valid)

})

test_that("Can do event hits", {

  req <- gmr_hit_event("Rcat","Raction","Rlabel",300)

  expect_true(req$hitParsingResult$valid)

})
