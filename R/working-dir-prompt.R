original_prompt <- "uninitialized> "


#' init_wd
#'
#' @return
#' @export
#'
#' @examples
init_wd <- function() {
  options(
    "wd.prompt.enabled" = TRUE,
    "wd.prompt.fullPath" = TRUE,
    "wd.prompt.promptLen" = 15
  )
}


#' start_wd
#'
#' @return
#' @export
#'
#' @examples
start_wd <- function() {
  options("wd.prompt.enabled" = TRUE)
  if (!"wd_prompt" %in% getTaskCallbackNames()) {
    wd.prompt:::original_prompt <- getOption("prompt")
    sink("/dev/null") # suppress output
    addTaskCallback(wd_prompt, data = NULL, name = "wd_prompt")
#    wd_prompt() # Init prompt for first time
    sink()
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
#' @return
#' @export
#'
wd_prompt <- function() {
  #
  # Terminate the callback by returning FALSE.  This offers the advantage
  # of not having to know the id of the callback.  Yeah, having played around
  # with callbacks, it's entirely possible to get multiple instances.
  #
  if (getOption("wd.prompt.enabled") == FALSE) {
    options("prompt" = original_prompt)
    return( FALSE ) }

  fullPath <- getOption("wd.prompt.fullPath")
  promptLen <- c(getOption("wd.prompt.promptLen"))

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
    function(opt) {
      option <- paste("wd.prompt.", opt, sep = "")
      cat("  ", option, ":  ", getOption(option), "\n", sep = "")
    }
  )
  cat("  wd.prompt::orginal_prompt:  ", wd.prompt:::original_prompt, "\n")
  if ( "wd_prompt" %in% getTaskCallbackNames() ) {
    cat("  TaskCallback wd_prompt is running.")
  }
  else {
    cat("  No TaskCallback called wd_prompt found.")
  }
}


#' remove_wd
#'
#' @return
#' @export
#'
#' @examples
remove_wd <- function() { removeTaskCallback("wd_prompt") }

#' default_prompt
#'
#' @return
#' @export
#'
#' @examples
default_prompt <- function() {options("prompt" = "> ")}
