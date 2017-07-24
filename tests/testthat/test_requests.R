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

test_that("Can do timing hits", {

  req <- gmr_hit_timing("R_app","shiny_loadtime",3000, label = "appname")
  expect_true(req$hitParsingResult$valid)

})

test_that("Can create enhanced ecom index", {

  ee <- gmr_enhanced_index(c("product1", "product2", "product3"), prefix = "pr", suffix = "id")
  expect_equal(ee, list(pr1id = "product1", pr2id = "product2", pr3id = "product3"))
})


test_that("Can make a valid ecommerce hit", {

  ee <- gmr_enhanced_ecom("purchase",
                          transaction_id = "rerer",
                          revenue = 4300.23,
                          product_sku = c("sku4","sku23","sku7"))

  req <- gmr_hit_page(url_path = "/checkout",
                      enhanced_ecom = ee)
  expect_true(req$hitParsingResult$valid)
})

test_that("Make your own ee hit", {

  my_promotion_id <- gmr_enhanced_index(c("aff3","aff2","aff2"), prefix = "promo", suffix = "id")

  my_ee <- do.call(gmr_enhanced_ecom,
                   args = c(list(action = "purchase",
                            transaction_id = "2323",
                            product_sku = c("sku4","sku3","sku7")),
                            my_promotion_id))

  req <- gmr_hit_page(url_path = "/checkout-thanks",
                      enhanced_ecom = my_ee)
  expect_true(req$hitParsingResult$valid)
})
