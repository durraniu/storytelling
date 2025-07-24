#' Generate a Fictional Story with LLM
#'
#' @param user_prompt Character. Prompt about story
#' @param num_paras Integer. Number of paragraphs in the generated story. Default is 5
# @param system_prompt Character. System prompt for the client that generates stories. Default value is `NULL` that will create a system prompt with the function `storytelling::generate_story_system_prompt` that instructs the LLM to create an adventure story in a Hero's Journey structure
#' @param genre Genre of the story. One of "adventure", "horror", "scifi", "mystery", "thriller",
#' "fantasy", "comedy", "drama", "detective", "satire", "supernatural", "romance" or "western"
#' @param struc Structure of the story. One of "Hero's Journey", "Three Act Structure", "Seven-Point Story Structure", "Freytag's Pyramid", "Story Circle", "Save The Cat" or "Fichtean Curve"
#' @param chat_fn Ellmer client function. Default is `ellmer::chat_google_gemini`
#' @param model LLM model. Default is `"gemini-2.0-flash"`
#' @param ... Additional named arguments that go in `chat_fn`. You may include the API key here using `api_key` argument, but it is recommended to provide the API key in your `.Renviron` file using `usethis::edit_r_environ()`. For Gemini, you may get an API key [here](https://ai.google.dev/gemini-api/docs/api-key). See [ellmer docs](https://ellmer.tidyverse.org/) for more provider options
#'
#' @returns Character vector containing story text of length equal to `num_paras`
#' @export
#'
#' @examples
#' \dontrun{
#' library(storytelling)
#' user_prompt <- "Tell me a story of a boy who learned to fly."
#' generate_story(user_prompt)
#' generate_story(user_prompt, genre = "thriller", struc = "Freytag's Pyramid")
#' }
generate_story <- function(user_prompt,
                           num_paras = 5,
                           # system_prompt = NULL,
                           genre = c(
                             "adventure", "horror", "scifi", "mystery", "thriller",
                             "fantasy", "comedy", "drama", "detective", "satire",
                             "supernatural", "romance", "western"
                           ),
                           struc = c(
                             "Hero's Journey", "Three Act Structure", "Seven-Point Story Structure",
                             "Freytag's Pyramid", "Story Circle", "Save The Cat", "Fichtean Curve"
                           ),
                           chat_fn = ellmer::chat_google_gemini,
                           model = "gemini-2.0-flash",
                           ...){
  if (is.null(user_prompt)){
    return(NULL)
  }

  if (check_profanity(user_prompt)){
    stop("Please avoid profanity in user_prompt. Try again.")
  }

  # if (is.null(system_prompt)) {
  #   system_prompt <- generate_story_system_prompt(
  #     genre = "adventure",
  #     struc = "Hero's Journey",
  #     num_paras = num_paras
  #   )
  # }

  genre <- match.arg(genre)
  struc <- match.arg(struc)

  system_prompt <- generate_story_system_prompt(
    genre = genre,
    struc = struc,
    num_paras = num_paras
  )

  client <- make_chat(
    chat_fn,
    system_prompt = system_prompt,
    model = model,
    ...
  )

  res <- client$chat_structured(
    user_prompt,
    type = ellmer::type_object(
        title = ellmer::type_string("Title of the story. One sentence max."),
        story = ellmer::type_array(
        paste0("Return exactly ",  num_paras,  " paragraphs, as an array. Each array element is a paragraph of the story. Do not return explanations or any text outside the array. Each paragraph must be self-contained, i.e., do not use blank lines or newlines to separate paragraphs inside elements."),
        items = ellmer::type_string()
      )
    )
  )

  res
  # as.character(res)
  # strsplit(res, "(\\n\\n+|↵+\\s*)")[[1]]

}
