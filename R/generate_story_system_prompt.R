#' Generate System Prompt for Client that generates Stories
#'
#' @param genre Genre of the story
#' @param struc Structure of the story
#' @param num_paras Number of paragraphs in the story
#'
#' @returns System prompt as a string
# @export
generate_story_system_prompt <- function(
    genre,
    struc,
    num_paras = 5
) {

  # genre <- match.arg(genre)
  # struc <- match.arg(struc)

  # if (genre == "scifi"){
  #   genre <- "science fiction"
  # }

  paste0(
    "You are an AI short story and title generator.",
    " The genre of the story must be ", genre, ".",
    " Structure it according to ", struc, ".",
    " You must return exactly ", num_paras, " paragraphs of the story.",
    " Do not include introduction, explanation, or any commentary in the story.",
    " Each paragraph of the story should be its own array/list element in the response.",
    " Do not join story paragraphs with newlines.",
    " Do not add anything outside of the story array; only the array of paragraphs.",
    " Also return an appropriate title of the story. "
  )
}
