add_enhanced_ecom <- function(payload_data, enhanced_ecom){
  if(!is.null(enhanced_ecom)){
    assertthat::assert_that(
      inherits(enhanced_ecom, "gmr_ee")
    )
    payload_data <- c(payload_data, enhanced_ecom)
  }
  payload_data
}



#' Build Enhanced Ecommerce hits
#'
#' A helper function to build enhanced ecommerce hits
#'
#' @param action The role of the products included in a hit. Required.
#' @param transaction_id An id for the transaction. Required.
#' @param revenue The total value of the transaction
#' @param product_sku A vector of product SKU
#' @param product_name A vector of product names
#' @param product_brand A vector of product brands
#' @param product_category A vector of product category
#' @param product_price A vector of product price
#'
#' @details
#'
#' This lets you more easily create enhanced ecommerce hits by
#'  creating an object you then pass into other hits such as \link{gmr_hit_event}
#'
#' The product arguments such as \link{product_sku} are vectors that will be turned into lists via \link{gmr_enhanced_index}.  If passing multiple arguments, they each must have the products in the same order and be the same length.
#'
#' If you want to pass your own indexed products, \link{gmr_enhanced_index} can be used to create a named list which you can then append to the paramters generated using \link{do.call}.  See examples.
#'
#' @return An \code{gmr_ee} object that can be passed to \code{gmr_hit_x} functions.
#'
#' @examples
#'
#' gmr_hit_page(url_path = "/checkout",
#'              enhanced_ecom = gmr_enhanced_ecom("purchase", transaction_id = "blah223", revenue = 4300.23, product_sku = c("sku4","sku23","sku7")))
#'
#' # Make your own hit
#' my_promotion_id <- gmr_enhanced_index(c("aff3","aff2","aff2"), prefix = "promo", suffix = "id")
#'
#' # make your own enhanced ecom obj
#' my_ee <- do.call(gmr_enhanced_ecom,
#'                  args = c(list(action = "purchase",
#'                               transaction_id = "2323",
#'                               product_sku = c("sku4","sku3","sku7")
#'                               ),
#'                          my_promotion_id)
#'                          )
#'
#' # register hit
#' gmr_hit_page(url_path = "/checkout-thanks", enhanced_ecom = my_ee)
#'
#' @export
gmr_enhanced_ecom <- function(action = c("purchase","detail","click",
                                         "add","remove","checkout",
                                         "checkout_option","purchase","refund"),
                              transaction_id,
                              revenue = NULL,
                              product_sku = NULL,
                              product_name = NULL,
                              product_brand = NULL,
                              product_category = NULL,
                              product_price = NULL,
                              ...){

  action <- match.arg(action)

  ecom_data <- list(
    pa = action,
    tr = revenue,
    ti = transaction_id
  )

  gmr_ee <- c(ecom_data,
              gmr_enhanced_index(product_sku, "pr", "id"),
              gmr_enhanced_index(product_name, "pr", "nm"),
              gmr_enhanced_index(product_brand, "pr", "br"),
              gmr_enhanced_index(product_category, "pr", "ca"),
              gmr_enhanced_index(product_price, "pr", "pr"),
              list(...))

  structure(rmNullObs(gmr_ee),
            class = c("gmr_ee","list"))

}

#' Create ecommerce index
#'
#' Enhanced e-commerce calls for product index's -
#'   this helps create them to pass to other calls such as \link{gmr_enhanced_ecom}
#'
#' @param prefix The parameter prefix
#' @param vector A vector of entries to send
#' @param suffix The parameter suffix
#'
#' Pass a list of items you want to create, they will be indexed in the same order as the vector.
#'
#' @examples
#'
#' gmr_enhanced_index(c("product1", "product2", "product3"), prefix = "pr", suffix = "id")
#'
#' @export
gmr_enhanced_index <- function(my_vector = NULL,
                               prefix = NULL,
                               suffix = NULL){

  if(is.null(my_vector)) return(NULL)

  assertthat::assert_that(
    is.vector(my_vector),
    assertthat::is.string(prefix),
    assertthat::is.string(suffix),
    length(my_vector) <= 200
  )

  i <- 1:length(my_vector)
  the_names <- paste0(prefix, i, suffix)
  names(my_vector) <- the_names

  as.list(my_vector)
}
