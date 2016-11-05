#' init_wd
#'
#' @param enabled
#'
#' @param fullPath
#'
#' @param promptLen
#'
#' @return temp
#' @export
#'
init_wd <- function(enabled = TRUE, fullPath = TRUE, promptLen = 15) {
  options(
    "wdprompt.enabled" = enabled,
    "wdprompt.fullPath" = fullPath,
    "wdprompt.promptLen" = promptLen
    )
}

#' start_wd
#'
#' @return temp
#' @export
#'
start_wd <- function() {
  if (!"wd_prompt" %in% getTaskCallbackNames()) {
    options("wdprompt.enabled" = TRUE)
    suppressMessages(
      addTaskCallback(wd_prompt, data = getOption("prompt"), name = "wd_prompt")
    )
  }
}


#' stop_wd
#'
#' @return temp
#' @export
#'
stop_wd <- function() { options("wdprompt.enabled" = FALSE) }


#' wd_prompt
#'
#' There are no arguments because the options are used to control the behavior.
#'
#' @param ...
#'
#' @return TRUE
#'
wd_prompt <- function(...) {
  wd_enabled <- getOption("wdprompt.enabled")
  fullPath <- getOption("wdprompt.fullPath")
  promptLen <- c(getOption("wdprompt.promptLen"))

  if (is.null(wd_enabled) || is.null(fullPath) || is.null(promptLen)) {
    stop("wdprompt options are not properly configured.  Try running wd_init().")
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
#' @return temp
#' @export
#'
check_wd <- function() {
  lapply(
    c("enabled", "fullPath", "promptLen"),
    function (opt) {
      option <- paste("wdprompt.", opt, sep = "")
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
#' @return temp
#' @export
#'
remove_wd <- function() { removeTaskCallback("wd_prompt") }

#' default_prompt
#'
#' @return temp
#' @export
#'
default_prompt <- function() { options("prompt" = "> ") }
