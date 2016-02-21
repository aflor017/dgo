`%>%` <- magrittr::`%>%`
`%<>%` <- magrittr::`%<>%`

na_to_zero <- function(x) {
  replace(x, is.na(x), 0)
}

nan_to_na <- function(x) {
  replace(x, is.nan(x), NA)
}

any_not_na <- function(x) {
  any(!is.na(x))
}

"%c%" <- function(...) paste0(unlist(list(...)))
"%c+%" <- function(...) paste(unlist(list(...)))
"%c+%" <- function(...) paste(unlist(list(...)), collapse = " + ", sep = " + ")
"%c,%" <- function(...) paste(unlist(list(...)), collapse = ", ", sep = ", ")
"%c|%" <- function(...) paste(unlist(list(...)), collapse = " | ", sep = " | ")
"%c~%" <- function(...) paste(unlist(list(...)), collapse = " ~ ", sep = " ~ ")
