#' Generate a UUID
#'
#' Suitable for cid parameters
#'
#' @return A UUID for use in \code{payload_data$cid}
#'
#' @export
gmr_uuid <- function(){
  uuid::UUIDgenerate(TRUE)
}

#' Send a page type hit
#'
#' Suitable for tracking pages
#'
#' @param url_path The path portion of the page URL, should start with \code{/}
#' @param url_host Specifies the hostname from which content was hosted
#' @param url_title The title of the page or document.
#' @param ... Other named arguments to pass in as payload data
#'
#' @details
#'
#' Helper wrapper to send page type hits.  Specify named arguments to also send those, including overriding the helper arguments.  E.g. set your own cid = "fixed-value" if you want to have hits to be recorded as coming from the same user.
#'
#' @examples
#'
#' # send hit as a page
#' gmr_hit_page("/hi-from-r-example")
#'
#' # override the dp argument (page path)
#' gmr_hit_page("/hi-from-r-test", dp = "/bye-from-r-test")
#'
#' # set other arguments
#' my_cid <- gmr_uuid()
#' gmr_hit_page("/hi-from-r-test", cid = my_cid)
#'
#' @seealso \url{https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters}
#'
#' @export
gmr_hit_page <- function(url_path = NULL,
                         url_host = NULL,
                         url_title = NULL,
                         ...){


  payload_data <- list(
    ds = "googleMeasureR",
    cid = gmr_uuid(),
    dp = url_path,
    dh = url_host,
    dt = url_title
  )

  payload_data <- override_list(payload_data, ...)

  gmr_post(payload_data, hittype = "pageview")

}

#' Send a event type hit
#'
#' Suitable for tracking general events
#'
#' @param category Specifies the event category
#' @param action Specifies the event action.
#' @param label Optional label
#' @param value Optional value
#' @param interaction Whether hit is interactive with page (affecting bounce rate)
#' @param ... Other named arguments to pass in as payload data
#'
#' @details
#'
#' Helper wrapper to send event type hits.  Specify named arguments to also send those, including overriding the helper arguments.  E.g. set your own cid = "fixed-value" if you want to have hits to be recorded as coming from the same user.
#'
#' @examples
#'
#' gmr_hit_event("R_cat","R_action","R_label",300)
#'
#'
#' @seealso \url{https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters}
#'
#' @export
gmr_hit_event <- function(category,
                          action,
                          label = NULL,
                          value = NULL,
                          interaction = TRUE,
                          ...){

  payload_data <- list(
    ds = "googleMeasureR",
    cid = gmr_uuid(),
    ec = category,
    ea = action,
    el = label,
    ev = value,
    dp = "/event",
    ni = if(interaction) 0L else 1L # is 1 if NOT interactive...
  )

  payload_data <- override_list(payload_data, ...)

  gmr_post(payload_data, hittype = "event")

}
