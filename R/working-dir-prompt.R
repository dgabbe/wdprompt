#' init_wd
#'
#' @param enabled
#' @param fullPath
#' @param promptLen
#'
#' @return
#' @export
#'
#' @examples
init_wd <- function(enabled = TRUE, fullPath = TRUE, promptLen = 15) {
  options(
    "wd.prompt.enabled" = enabled,
    "wd.prompt.fullPath" = fullPath,
    "wd.prompt.promptLen" = promptLen
  )
}


#' start_wd
#'
#' @return
#' @export
#'
#' @examples
start_wd <- function() {
  if (!"wd_prompt" %in% getTaskCallbackNames()) {
    options("wd.prompt.enabled" = TRUE)
    suppressMessages(
      addTaskCallback(wd_prompt, data = getOption("prompt"), name = "wd_prompt")
    )
  }
}


#' stop_wd
#'
#' @return
#' @export
#'
#' @examples
stop_wd <- function() {
  options(
    "wd.prompt.enabled" = FALSE
#    "prompt" = original_prompt
    )
}


#' wd_prompt
#'
#'There are no arguments because the options are used to control the behavior.
#'
#' @param ...
#'
#' @return
#' @export
#'
wd_prompt <- function(...) {
  wd_enabled <- getOption("wd.prompt.enabled")
  fullPath <- getOption("wd.prompt.fullPath")
  promptLen <- c(getOption("wd.prompt.promptLen"))

  if (is.null(wd_enabled) || is.null(fullPath) || is.null(promptLen)) {
    stop("wd.prompt options are not properly configured.  Try running wd_init().")
  }

  #
  # Terminate the callback by returning FALSE.  This offers the advantage
  # of not having to know the id of the callback.  Yeah, having played around
  # with callbacks, it's entirely possible to get multiple instances.
  #
  if (wd_enabled == FALSE) {
    options("prompt" = as.character(tail(list(...), 1)))
    return(FALSE)
  }

  curDir <- getwd()
  if (fullPath) {
    # Mirror the behavior by my bash prompt.
    options("prompt" = paste(curDir, "> \n", sep = ""))
  } else {
    if (nchar(curDir) <= promptLen) {
      options("prompt" = paste(curDir,"> ", sep = ""))
    } else {
      options("prompt" = paste("...", substring(curDir, nchar(curDir) - 15), "> ", sep = ""))
    }
  }
  TRUE
}


#' check_wd
#'
#' @return
#' @export
#'
#' @examples
check_wd <- function() {
  lapply(
    c("enabled", "fullPath", "promptLen"),
    function (opt) {
      option <- paste("wd.prompt.", opt, sep = "")
      message("  Option ", option, ":  ", getOption(option))
    }
  )
  if ( "wd_prompt" %in% getTaskCallbackNames() ) {
    message("  TaskCallback 'wd_prompt' is running.")
  }
  else {
    message("  No TaskCallback 'wd_prompt' found.")
  }
}


#' remove_wd
#'
#' @return
#' @export
#'
remove_wd <- function() { removeTaskCallback("wd_prompt") }

#' default_prompt
#'
#' @return
#' @export
#'
default_prompt <- function() {options("prompt" = "> ")}
