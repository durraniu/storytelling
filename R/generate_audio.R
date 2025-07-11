#' Convert text to speech
#'
#' @param text Text to be converted to speech
#' @param voice Google text-to-speech voice name. Not compatible with `model = "cloudflare"`. One of 36 voices can be specified.
#' @param model Text to speech model. Options are "google" and "cloudflare"
#' @param CF_ACCOUNT_ID Cloudflare Workers AI Model API account ID
#' @param CF_API_KEY Cloudflare Workers AI Model API key
#' @param G_API_KEY Google API key
#'
#' @returns httr2 request.
get_audio_req <- function(text,
                          voice = NULL,
                          model = c("cloudflare", "google"),
                          CF_ACCOUNT_ID = Sys.getenv("CLOUDFLARE_ACCOUNT_ID"),
                          CF_API_KEY = Sys.getenv("CLOUDFLARE_API_KEY"),
                          G_API_KEY = Sys.getenv("GOOGLE_API_KEY")){

  if (is.null(text)){
    return(NULL)
  }

  model <- match.arg(model)

  if (model == "cloudflare") {

    if (!is.null(voice)){
      stop("`voice` is compatible with `model = 'google'` only", call. = TRUE)
    }

    if (CF_ACCOUNT_ID == "" | CF_API_KEY == ""){
      stop("To use the cloudflare text-to-speech, please provide the cloudflare API key and account ID", call. = TRUE)
    }

    url_audio <- paste0("https://api.cloudflare.com/client/v4/accounts/", CF_ACCOUNT_ID, "/ai/run/@cf/myshell-ai/melotts")

    req <- httr2::request(url_audio) |>
      httr2::req_headers(
        "Authorization" = paste("Bearer", CF_API_KEY)
      ) |>
      httr2::req_body_json(list(
        prompt = text
      )) |>
      httr2::req_method("POST")
  } else {
      if (G_API_KEY == ""){
        stop("To use the google text-to-speech, please provide the google API key", call. = TRUE)
      }
      if (is.null(voice)){
        # message("`voice` was not provided; choosing `voice = 'Zephyr'`")
        voice <- "Zephyr"
      }
    req <- httr2::request("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-tts:generateContent") |>
      httr2::req_headers(
        `x-goog-api-key` = G_API_KEY,
        `Content-Type` = "application/json"
      ) |>
      httr2::req_body_json(list(
        contents = list(
          list(
            parts = list(
              list(
                text = paste0("Read out loud like you are narrating a story: ", text)
              )
            )
          )
        ),
        generationConfig = list(
          responseModalities = list("AUDIO"),
          speechConfig = list(
            voiceConfig = list(
              prebuiltVoiceConfig = list(voiceName = voice)
            )
          )
        ),
        model = "gemini-2.5-pro-preview-tts" #"gemini-2.5-flash-preview-tts"
      ))
  }

  req
}



#' Extract Raw Audio
#'
#' @param res API response
#' @param model Text to speech model. Options are "google" and "cloudflare"
#'
#' @returns Audio in binary.
get_raw_audio <- function(res, model = c("cloudflare", "google")){
  if (res$status_code == 200){

    resp <- httr2::resp_body_json(res)

    if (model == "cloudflare"){
      aud <- base64enc::base64decode(
        resp$result$audio
         )
    } else {
      aud <- base64enc::base64decode(
        resp$candidates[[1]]$content$parts[[1]]$inlineData$data
        )
    }
  } else {
    aud <- NULL
  }
  aud
}




#' Convert PCM audio to MP3 audio
#'
#' @param aud Base64 decoded audio (pcm)
#'
#' @returns Base64 encoded audio (mp3)
convert_pcm_to_mp3 <- function(aud){
  pcm_file <- tempfile(fileext = ".pcm")
  writeBin(aud, pcm_file)
  mp3_file <- tempfile(fileext = ".mp3")
  system2("ffmpeg", args = c(
    "-f", "s16le", "-ar", "24000", "-ac", "1", "-i", pcm_file,
    "-acodec", "libmp3lame", "-b:a", "128k", mp3_file
  ))
  base64enc::base64encode(mp3_file)
}


#' Get audio from story
#'
#' @param story Vector of story text
#' @param voice Google text-to-speech voice name. Not compatible with `model = "cloudflare"`. One of 36 voices can be specified. See Details.
#' @param model Text to speech model. Options are "google" and "cloudflare"
#'
#' @returns List of audio in binary.
#' @export
#' @details
#' Visit [speech generation voice options](https://ai.google.dev/gemini-api/docs/speech-generation#voices)
#' for details about the 36 voice options.
#'
#' @examples
#' \dontrun{
#' library(storytelling)
#' user_prompt <- "Tell me a story about a dragon who turned into a human."
#' story <- generate_story(user_prompt)
#' audios <- generate_audio(story)
#' }
generate_audio <- function(story, voice = NULL, model = c("cloudflare", "google")){
  if (is.null(story) || length(story) == 0) {
    return(NULL)
  }
  reqs <- lapply(story, function(x) {get_audio_req(x, model = model, voice = voice)})
  resps <- lapply(reqs, httr2::req_perform)
  # resps <- httr2::req_perform_parallel(reqs, on_error = "continue")
  # All audio
  auds <- tryCatch({
    lapply(resps, function(x) {get_raw_audio(x, model = model)})
  }, error = function(e) {
    NULL
  })

  if (model == "google"){
    auds <- lapply(auds, convert_pcm_to_mp3)
  } else {
    auds <- lapply(auds, base64enc::base64encode)
  }

  auds
}

