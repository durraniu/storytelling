#' Request a single image from Stable Diffusion XL Base 1.0 model via Cloudflare API
#'
#' @param prompt Description of image
#' @param negative_prompt Description of what to exclude
#' @param num_steps Number of diffusion steps. Max 20
#' @param ACCOUNT_ID Cloudflare Workers AI Model API account ID
#' @param API_KEY Cloudflare Workers AI Model API key
#' @param ... Additional named arguments provided to Stable Diffusion model API. See [stable-diffusion-xl-base-1.0 docs](https://developers.cloudflare.com/workers-ai/models/stable-diffusion-xl-base-1.0/) for more details
#'
#' @return Request.
req_single_image <- function(prompt,
                             negative_prompt,
                             num_steps = 20,
                             ACCOUNT_ID = Sys.getenv("CLOUDFLARE_ACCOUNT_ID"),
                             API_KEY = Sys.getenv("CLOUDFLARE_API_KEY"),
                             ...){

  url_img <- paste0("https://api.cloudflare.com/client/v4/accounts/", ACCOUNT_ID, "/ai/run/@cf/stabilityai/stable-diffusion-xl-base-1.0")

  # Create the request
  httr2::request(url_img) |>
    httr2::req_headers(
      "Authorization" = paste("Bearer", API_KEY)
    ) |>
    httr2::req_body_json(list(
      prompt = prompt,
      negative_prompt = negative_prompt,
      guidance = 10,
      num_steps = num_steps
    )) |>
    httr2::req_method("POST")
}

#' Get image if request is successful
#'
#' @param response Response from Workers AI Model API
#'
#' @return Image or NULL.
get_raw_image <- function(response){

  if(is.null(response$status_code)){
    return(NULL)
  }

  if (response$status_code == 200){
    png_img <- httr2::resp_body_raw(response)
  } else{
    png_img <- NULL
  }
  png_img
}
