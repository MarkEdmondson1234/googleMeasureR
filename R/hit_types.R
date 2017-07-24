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
#' @param enhanced_ecom A \code{gmr_ee} generated via \link{gmr_enhanced_ecom}
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
                         enhanced_ecom = NULL,
                         ...){


  payload_data <- list(
    ds = "googleMeasureR",
    cid = gmr_uuid(),
    dp = url_path,
    dh = url_host,
    dt = url_title
  )

  payload_data <- add_enhanced_ecom(payload_data, enhanced_ecom)
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
#' @inheritParams gmr_hit_page
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
                          enhanced_ecom = NULL,
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
  payload_data <- add_enhanced_ecom(payload_data, enhanced_ecom)
  payload_data <- override_list(payload_data, ...)

  gmr_post(payload_data, hittype = "event")

}

#' Send a timing type hit
#'
#' Suitable for tracking time lags
#'
#' @param category Specifies the timing category
#' @param name Specifies the timing name
#' @param time An integer in milliseconds
#' @param label Optional label
#' @param ... Other named arguments to pass in as payload data
#' @inheritParams gmr_hit_page
#'
#' @details
#'
#' Helper wrapper to send timing type hits.  Specify named arguments to also send those, including overriding the helper arguments.  E.g. set your own cid = "fixed-value" if you want to have hits to be recorded as coming from the same user.
#'
#' @examples
#'
#' gmr_hit_timing("R_app","shiny_loadtime",3000, label = "appname")
#'
#'
#' @seealso \url{https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters}
#'
#' @export
gmr_hit_timing <- function(category,
                           name,
                           time,
                           label = NULL,
                           enhanced_ecom = NULL,
                           ...){

  payload_data <- list(
    ds = "googleMeasureR",
    cid = gmr_uuid(),
    utc = category,
    utv = name,
    utt = time,
    utl = label
  )
  payload_data <- add_enhanced_ecom(payload_data, enhanced_ecom)
  payload_data <- override_list(payload_data, ...)

  gmr_post(payload_data, hittype = "timing")

}
