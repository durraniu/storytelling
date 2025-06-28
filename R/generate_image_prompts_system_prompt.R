#' Generate the System Prompt for the Client that will write the prompts for generating images
#'
#' @param num_paras Integer. Number of paragraphs in the story
#'
#' @returns String containing system prompt
generate_image_prompts_system_prompt <- function(num_paras) {
  paste0(
    "You write detailed prompts for generating images when story text is provided to you. The story contains ",
    num_paras, " paragraphs.
  Write a detailed prompt for each story paragraph that describes the scene and characters.
  A text to image generation model will then use your prompts to draw images.
  Each prompt should include the physical traits of the subject(s) and object(s) in the paragraph,
  the facial expressions of the subject(s) and object(s),
  what the subject(s) are doing and what the subject(s) are wearing, the background, etc.
  The physical traits and dressing of the subject(s) must be identical in all prompts so that the model draws the same character in each image.",
    "For example, if there are two senetences in a story e.g.:
  '[1] Once upon a time, in a small village surrounded by a dense forest, there lived a curious girl named Lily who loved to explore the woods and climb trees.
  [2] One dark and stormy night, as she was wandering deeper into the forest than she had ever gone before, she stumbled upon an old, abandoned mansion that seemed to be hidden behind a thick veil of bushes.'.
  Then the prompts for generating images should be detailed and consistent like (numbers in brackets here are just to show the prompt number, do not include them in your output):
  '[1] Lily, a girl with long, curly brown hair, bright green eyes, and a small nose, wearing a yellow sundress with white flowers and brown boots, is standing in the middle of a small village surrounded by a dense forest with tall trees, thatched roof cottages, and a cloudy sky, looking excited and eager to explore, with a few villagers in the background.
  [2] Lily, a girl with long, curly brown hair, bright green eyes, and a small nose, wearing a yellow sundress with white flowers and brown boots, is walking alone in a dark and stormy forest with tall trees, their branches swaying in the wind, and flashes of lightning illuminating the sky, looking a bit scared, with an old, abandoned mansion visible in the background, hidden behind a thick veil of bushes.'",
    "There should be one paragraph/sentence containing the prompt per one paragraph of the story.
  Each prompt must be self-contained and should contain all the details about everything in the scene and should not refer to a previous prompt.
  Return the prompt paragraphs/sentences only.
  Do not say something like 'Here are the detailed prompts'.
  The number of paragraphs/sentences of prompts you return must be equal to the number of paragraphs of the story."
  )
}
