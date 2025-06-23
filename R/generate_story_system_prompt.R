#' Generate System Prompt for Client that generates Stories
#'
#' @param genre Genre of the story
#' @param struc Structure of the story
#' @param num_paras Number of paragraphs in the story
#'
#' @returns System prompt as a string
#' @export
#'
#' @examples
#' generate_story_system_prompt("romance", "Story Circle", 5)
generate_story_system_prompt <- function(
    genre = c(
      "romance", "horror", "scifi", "mystery", "thriller",
      "fantasy", "comedy", "drama", "detective", "satire",
      "supernatural", "adventure", "western"
    ),
    struc = c(
      "Hero's Journey", "Three Act Structure", "Seven-Point Story Structure",
      "Freytag's Pyramid", "Story Circle", "Save The Cat", "Fichtean Curve"
    ),
    num_paras = 5) {

  genre <- match.arg(genre)
  struc <- match.arg(struc)

  paste0(
    "You tell short stories",
    ". The genre of the story must be ",
    genre,
    ". Use the ", struc, " for the structure of the story. ",
    "Just tell the story. DO NOT explain the story structure. ",
    "There must be exactly ", num_paras, " paragraphs of the story."
  )
}
