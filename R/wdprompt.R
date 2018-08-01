#' Initializes all 3 options that control prompt behavior.
#'
#' If you want to try different options after \code{start_wd} is called, call
#' this again function with your parameter values.
#'
#' @param enabled \code{TRUE} to keep wdprompt active. \code{FALSE} to stop it
#' and revert back to the static prompt when \code{start_wd} was called.
#'
#' @param fullPath \code{TRUE} to display the full path returned by
#'   [base::getwd()]. `FALSE` to truncate to the last \code{promptLen}
#'   characters of the path.
#'
#' @param promptLen A number specifying the length of the prompt string.
#' Only used if \code{wdprompt.fullPath} is \code{FALSE}.
#'
#' @export
init_wd <- function(enabled = TRUE, fullPath = TRUE, promptLen = 15) {
  options(
    "wdprompt.enabled" = enabled,
    "wdprompt.fullPath" = fullPath,
    "wdprompt.promptLen" = promptLen
    )
}


#' Starts the new behavior for the console prompt.
#'
#' If it is not already running for an interactive session.
#'
#' @return TRUE if prompt started. FALSE otherwise.
#'
#' @export
start_wd <- function() {
  if (!"wd_prompt" %in% getTaskCallbackNames() && interactive()) {
    init_wd()
    suppressMessages(
      addTaskCallback(wd_prompt, data = getOption("prompt"), name = "wd_prompt")
    )
    wd_prompt() # Set prompt before first top-level task is executed.
    return(TRUE)
  } else {
    return(FALSE)
  }
}


#' Stop this prompt.
#'
#' And revert back to the prompt in effect when \code{start_wd} was executed.
#'
#' @export
stop_wd <- function() { options("wdprompt.enabled" = FALSE) }


#' The real prompt function.
#'
#' @param ... A taskCallback function can be called with 4 or 5 parameters. If
#' \code{data} is specified, it is always the 5th argument.  Seemed pointless to
#' declare explicit parameters that would never be used.
#'
#' @seealso \link{addTaskCallback}
#'
#' @return TRUE to continue the taskCallback.  FALSE will delete the taskCallback.
#'
#' @export
wd_prompt <- function(...) {
  enabled <- getOption("wdprompt.enabled")
  fullPath <- getOption("wdprompt.fullPath")
  promptLen <- c(getOption("wdprompt.promptLen"))

  if (is.null(enabled) || is.null(fullPath) || is.null(promptLen)) {
    stop("wdprompt options are not properly configured.  Try running wd_init().")
  }

  #
  # Terminate the callback by returning FALSE.  This offers the advantage
  # of not having to know the id of the callback.  Yeah, having played around
  # with callbacks, it's entirely possible to get multiple instances.
  #
  if (enabled == FALSE) {
    options("prompt" = as.character(utils::tail(list(...), 1)))
    return(FALSE)
  }


  curDir <- getwd()
  if (fullPath) {
    # Mirror the behavior by my bash prompt.
    options("prompt" = paste(curDir, "> \n", sep = ""))
  } else {
    if (nchar(curDir) <= promptLen) {
      options("prompt" = paste(curDir, "> ", sep = ""))
    } else {
      options(
        "prompt" = paste("...", substring(curDir, nchar(curDir) - 15), "> ", sep = "")
      )
    }
  }
  TRUE
}


#' Diagnostic to display complete status.
#'
#' @examples
#' wdprompt::check_wd()
#'
#' @export
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


#' Brute force removal of the taskCallback.
#'
#' @export
remove_wd <- function() { removeTaskCallback("wd_prompt") }


#' Reset to R's default prompt.
#'
#' @export
default_prompt <- function() { options("prompt" = "> ") }
