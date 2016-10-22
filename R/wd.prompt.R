#'
#' Emulate bash prompt behavior in R console by replacing R's
#' default prompt of \code{> } the \code{getwd()} string. RStudio does
#' display the current working directory in the Console window title bar, but it
#' is not where I reflexively look.
#'
#'  If you prefer the default prompt, set `use_wd_prompt` to `FALSE`. The prompt is autmatically updated as the working directory is changed.  In RStudio, the ending `\n` is eaten.  In R (tested on OS X), it is honored.
#'
#' The global
#' environment can be cleared and the prompt behavior continues to work.
#'
#' The task callback is a copy of the \code{wd_prompt} function.  If the function changes,
#' the callback needs to be removed and then added to pickup the change.
#'
#' References:
#'    - https://stackoverflow.com/questions/4222476/r-display-a-time-clock-in-the-r-command-line
#'    - https://stackoverflow.com/questions/25136059/how-to-show-working-directory-in-r-prompt