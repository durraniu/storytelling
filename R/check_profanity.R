#' @title Check for profanity in a string (from One4All package)
#'
#' @description This function checks if the input string contains any profane words.
#'
#' @param x A character string to check for profanity.
#' @return A logical value indicating whether the input string contains no profane words.
#' @import lexicon
#' @import stringr
check_profanity <- function(x) {
  # Get unique bad words and convert to lowercase
  bad_words <- unique(tolower(c(
    lexicon::profanity_alvarez,
    lexicon::profanity_arr_bad,
    lexicon::profanity_banned,
    lexicon::profanity_zac_anger,
    lexicon::profanity_racist
  )))

  # Escape any special characters in the bad words list
  bad_words_escaped <- stringr::str_replace_all(bad_words, "([.\\+*?\\[\\^\\]$(){}=!<>|:-])", "\\\\\\1")

  # Create regex patterns for whole word matching
  patterns <- paste0("\\b(", paste(bad_words_escaped, collapse = "|"), ")\\b")

  # Check if any bad words are found in the input string
  any(stringr::str_detect(tolower(x), patterns))
}

