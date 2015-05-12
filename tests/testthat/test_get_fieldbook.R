context("get_fieldbook")



test_that("get_fieldbook function operates well", {
 # skip_on_cran()
  #expect_that(get_study() == "Hello, world!", is_true())
  expect_true(all(get_crop() == c("cassava", "potato", "sweetpotato")))
}) 
