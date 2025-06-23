#' Get all images corresponding to prompts
#'
#' @details `generate_images` uses the internal function `storytelling:::req_single_image` to request an image from Stable Diffusion XL Base 1.0 model via Cloudflare API. Therefore, you need to create an account on Cloudflare and get an API key, and then set `CLOUDFLARE_ACCOUNT_ID` and `CLOUDFLARE_API_KEY` in your `.Renviron` file.
#' [Follow these instructions](https://developers.cloudflare.com/workers-ai/get-started/rest-api/) to get the account ID and API key.
#' @param image_prompts A vector of prompts that describe what to draw
#' @param style A character vector specifying the desired style. Choices are:
#'   "anime", "comics", "lego_movie", "play_doh", "ethereal_fantasy", "isometric",
#'   "line_art", "origami", "pixel_art", "abstract", "impressionist",
#'   "renaissance", "watercolor", "biomechanical", "retro_futuristic",
#'   "fighting_game", "mario", "pokemon", "street_fighter", "horror",
#'   "manga", "space", "paper_mache", "tilt_shift".
#' @param ... Additional named arguments provided to Stable Diffusion model API. See [stable-diffusion-xl-base-1.0 docs](https://developers.cloudflare.com/workers-ai/models/stable-diffusion-xl-base-1.0/) for more details
#'
#' @returns List of raw images.
#' @export
#'
#' @examples
#' library(storytelling)
#' user_prompt <- "Tell me a story of a boy who learned to fly."
#' story <- generate_story(user_prompt)
#' image_prompts <- generate_image_prompts(story)
#' all_images <- generate_images(image_prompts, style = "ethereal_fantasy")
#' magick::image_read(all_images[[1]])
generate_images <- function(image_prompts,
                            style = c(
  "anime", "comics", "lego_movie", "play_doh", "ethereal_fantasy", "isometric",
  "line_art", "origami", "pixel_art", "abstract", "impressionist",
  "renaissance", "watercolor", "biomechanical", "retro_futuristic",
  "fighting_game", "mario", "pokemon", "street_fighter", "horror",
  "manga", "space", "paper_mache", "tilt_shift"
),
...){

  style <- match.arg(style)

  image_prompts <- format_image_prompts(image_prompts, style)

  if (is.null(image_prompts$prompt)){
    new_all_imgs <- NULL
  } else {
    reqs <- lapply(
      image_prompts$prompt,
      function(x){
        req_single_image(x, image_prompts$negative_prompt, ...)
      }
    )
    resps <- httr2::req_perform_parallel(reqs, on_error = "continue")
    # resps <- lapply(reqs, httr2::req_perform)

    # All images
    new_all_imgs <- lapply(resps, get_raw_image)
  }
  new_all_imgs
}
