override_list <- function(original, ...){
  original <- substitute.list(original, list(...))
  original <- c(original, list(...))

  original[!duplicated(original)]
}


#' A helper function that tests whether an object is either NULL _or_
#' a list of NULLs
#'
#' @keywords internal
is.NullOb <- function(x) is.null(x) | all(sapply(x, is.null))

#' Recursively step down into list, removing all such objects
#'
#' @keywords internal
rmNullObs <- function(x) {
  x <- Filter(Negate(is.NullOb), x)
  lapply(x, function(x) if (is.list(x)) rmNullObs(x) else x)
}


#' Substitute in a (nested) list
#'
#' @param template A template named list
#' @param replace_me A similar named list with different values to substitute
#'
#' @return The template with the values substituted.
#' @keywords internal
#' If replace_me has list names not in template, the value stays the same.
substitute.list <- function(template, replace_me){

  ## remove possible NULL entries
  template <- rmNullObs(template)
  replace_me <- rmNullObs(replace_me)

  postwalk(template, function(x) replace.kv(x,replace_me))

}

#' Walk into a list
#'
#' If passed an object such as a nested list, will apply function
#'   on inner elements that are not lists.
#'
#' @param x what to check
#' @param func Function to apply if not a list
#' @keywords internal
#' @return the function acting on x or an inner element of x
postwalk <- function(x,func){
  if(is.list(x)){
    func(lapply(x,postwalk,func))
  } else {
    func(x)
  }
}

#' Create a modified list
#'
#' @param template a (nested) list with elements to replace
#' @param replace a subset of template with same names but replacement values
#' @keywords internal
#' @return a list like template but with values replace from replace
replace.kv <- function(template,replace) {
  if(!is.list(template)) return(template)

  i <- match(names(template),names(replace))
  w <- which(!is.na(i))

  replace(template,w,replace[i[w]])

}
