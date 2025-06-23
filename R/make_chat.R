#' Make an ellmer chat object
#'
#' @param chat_fn Ellmer chat function, e.g., `chat_google_gemini`
#' @param ... Parameters of ellmer chat function
#'
#' @returns Ellmer chat object
make_chat <- function(chat_fn, ...) {
  chat_fn(...)
}
