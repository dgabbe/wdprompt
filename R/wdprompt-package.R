#' Console prompt follows current working directory
#'
#' Emulate bash prompt behavior in R console by replacing R's default prompt of
#' \code{> } with the [base::getwd()] string. RStudio does display the current
#' working directory in the Console window title bar, but it is not where I
#' normally look. The global environment can be cleared without affecting the prompt
#' behavior.
#'
#' A \code{\\n} is appended to the prompt. In RStudio, the \code{\\n} is eaten.
#' In R (tested on OS X), it is honored.
#'
#' @section Installation:
#'
#' \code{
#' devtools::install_github("dgabbe/wdprompt@Current")
#' }
#'
#' To start manually:
#' \preformatted{
#' wdprompt::start_wd()
#' }
#'
#' To start automatically, add these lines to \code{\link{.First}} in \code{Rprofile.site}:
#' \preformatted{
#' if (interactive()) {
#'   #
#'   # wdprompt::stop_wd() if you want to turn off the prompt.
#'   #
#'   if ( length(find.package("wdprompt", quiet = TRUE)) != 0 ) {
#'     wdprompt::start_wd()
#'   }
#' }
#' }
#'
#' @section Removal:
#' To stop the prompt and revert back to the prompt before wdprompt was started:
#'
#' \code{
#' wdprompt::stop_wd()
#' }
#'
#' @section Options:
#' \describe{
#'   \item{\strong{\code{wdprompt.enabled}}}{\code{TRUE} to use the prompt.
#'   \code{FALSE} to stop the prompt and revert back to a static prompt.
#'   See \code{\link{start_wd}} for the string that is used.}
#'
#'   \item{\strong{\code{wdprompt.fullPath}}}{\code{TRUE} to display the full path name.
#'   \code{FALSE} to to show a truncated prompt. See \code{\link{wd_prompt}} for the details.}
#'
#'   \item{\strong{\code{wdprompt.promptLen}}}{\code{number} that determines the
#'   length of truncated prompt.}
#' }
#'
#' @section R Triva:
#' The taskCallback is invoked at the \emph{end} of each top-level task.
#' Roughly translated, that means when R successfully evaluates an expression
#' typed in the console. \code{start_wd} adds the taskCallback, passing in the
#' current prompt and then executes \code{wd_prompt} to set the prompt to be
#' this new one.
#'
#' @section Random Thoughts:
#'
#' My motivation for having the console prompt act the same as my bash prompt
#' was creating a uniform command line environment.  Experience has taught me
#' that many problems with a build or deploy can be traced back to simply issuing
#' the wrong command in the wrong directory.
#'
#' Unfortunately R does not provide this behavior by default and simply setting
#' the \code{prompt} option in one of the R init files is brittle.  A better solution
#' is creating a \code{taskCallback}.  There's enough code that I pulled it out
#' of \code{Rprofile.site}. The taskCallbackManager creates a copy of your code
#' so one of the only ways to control it is with \code{\link{options}}.  During
#' development, I discovered it's very easy to instantiate multiple instances of
#' a callback so having the code check an option for when to stop made it simple
#' to terminate all instances.
#'
#' @section References:
#' \itemize{
#'  \item \url{https://stackoverflow.com/questions/4222476/r-display-a-time-clock-in-the-r-command-line}
#'  \item \url{https://stackoverflow.com/questions/25136059/how-to-show-working-directory-in-r-prompt}
#' }
#' @docType package
#' @name wdprompt-package
#' @keywords internal
"_PACKAGE"
NULL
