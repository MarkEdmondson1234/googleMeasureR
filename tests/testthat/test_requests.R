context("Can make requests")

test_that("Can make a request", {

  req <- gmr_post(list(t=2, tid = "UA-XXXXX-Y", cid = 1234567L))

  expect_equal(req$status_code, 200L)

})
