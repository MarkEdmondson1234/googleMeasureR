#' Post data to Measurement Protocol
#'
#' @param payload_data A named list of paramters to send.  Some defaults are set, see details.
#' @param endpoint where to send the API hits
#' @param user_agent Is a formatted user agent string that is used to compute the following dimensions: browser, platform, and mobile capabilities.
#'
#' @details
#' Hits are sent via \code{httr::POST}
#'
#' The version argument is set for you:  \code{v=1L}
#'
#' \code{ip} is implicitly sent in the HTTP request and is used to compute all the geo / network dimensions in Google Analytics.  Override with \code{payload_data$uip = 1.2.3.4}
#'
#' The user_agent is that which is sent with the request.  You can override this for the measurement itself via \code{payload_data$ua = Opera%2F9.80%20%28Windows%20NT%206.0}
#'
#' @return A httr request object
#'
#' @seealso \url{https://developers.google.com/analytics/devguides/collection/protocol/v1/}
#' @export
gmr_post <- function(payload_data,
                     endpoint = c("collect","batch"),
                     user_agent = httr::user_agent(paste0("googleMeasureR/",
                                                          packageVersion("googleMeasureR")))){

  endpoint <- match.arg(endpoint)

  payload_data$v <- 1L

  assertthat::assert_that(
    is.list(payload_data),
    !is.null(payload_data$tid),
    !is.null(payload_data$v),
    !is.null(payload_data$t),
    !is.null(payload_data$cid)
  )

  ## encode payload_data
  payload_data <- lapply(payload_data, function(x) utils::URLencode(as.character(x), reserved = TRUE))

  req <- httr::POST(
    sprintf("https://www.google-analytics.com/%s", endpoint),
    body = payload_data,
    encode = "form",
    user_agent
  )

  if(req$status_code != 200L){
    stop("Error making request")
  }

  req

}
