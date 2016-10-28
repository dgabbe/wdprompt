#' wdprompt Console prompt follows current working directory like bash
#'
#' Emulate bash prompt behavior in R console by replacing R's
#' default prompt of \code{> } with the \code{getwd()} string. RStudio does
#' display the current working directory in the Console window title bar, but it
#' is not where I reflexively look.
#'
#' In RStudio, the ending `\n` is eaten.  In R (tested on OS X), it is honored.
#'
#' The global
#' environment can be cleared and the prompt behavior continues to work.
#'
#' @section References:
#' \itemize{
#'  \item \url{https://stackoverflow.com/questions/4222476/r-display-a-time-clock-in-the-r-command-line}
#'  \item \url{https://stackoverflow.com/questions/25136059/how-to-show-working-directory-in-r-prompt}
#' }
#' @docType package
#' @name wdprompt
NULL