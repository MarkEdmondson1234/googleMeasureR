#' Post data to Measurement Protocol
#'
#' Send data to the Google Analytics API endpoint.
#'
#' @param payload_data A named list of paramters to send.
#' @param tid Tracking ID.  By default from the Sys environment \code{MP_TRACKING_ID}, overwritten if tid also sent in \code{payload_data}
#' @param hittype Either specify in argument \code{payload_data$t} or here.
#'
#' @details
#' Hits are sent via \code{httr::POST} and are URL encoded.
#'
#' The version argument is set for you:  \code{v=1L}
#'
#' \code{ip} is implicitly sent in the HTTP request and is used to compute all the geo / network dimensions in Google Analytics.  Override with \code{payload_data$uip = 1.2.3.4}
#'
#' Set options("googleMeasureR.debug" = TRUE) to activate debug mode.
#'
#'
#' @return TRUE if successful
#'
#' @seealso \url{https://developers.google.com/analytics/devguides/collection/protocol/v1/}
#' @export
gmr_post <- function(payload_data,
                     tid = Sys.getenv("MP_TRACKING_ID"),
                     hittype = c("pageview",
                                 "screenview",
                                 "event",
                                 "transaction",
                                 "item",
                                 "social",
                                 "exception",
                                 "timing")){
  hittype <- match.arg(hittype)

  assertthat::assert_that(
    is.list(payload_data),
    assertthat::is.string(tid)
  )

  payload_data$v <- 1L

  if(is.null(payload_data[["tid"]])){
    payload_data[["tid"]] <- tid
  }

  if(is.null(payload_data[["t"]])){
    payload_data[["t"]] <- hittype
  }

  ## encode payload_data
  payload_data <- lapply(payload_data,
                         function(x) utils::URLencode(as.character(x), reserved = TRUE))

  debug <- getOption("googleMeasureR.debug", default = FALSE)

  if(debug){
    message("Debug mode")
    str(payload_data)
    req <- httr::POST(
      "https://www.google-analytics.com/debug/collect",
      body = rmNullObs(payload_data),
      encode = "form",
      httr::verbose()
    )
    return(jsonlite::fromJSON(httr::content(req, as = "text")))
  } else {
    req <- httr::POST(
      "https://www.google-analytics.com/collect",
      body = rmNullObs(payload_data),
      encode = "form"
    )
  }



  if(req$status_code != 200L){
    stop("Error making request")
  }

  TRUE

}
