#' Copy QMD Revealjs template file to a directory for use with `create_slides`
#'
#' @param dest_dir Path to directory where you want to copy the template file
#' @param audio `TRUE` will copy a template QMD that takes in audio inputs, while `FALSE` (default) will copy a template QMD that does not take audio inputs (only text and images)
#'
#' @returns Copies a QMD file and provide the path to the destination directory
#' @export
copy_template <- function(dest_dir, audio = FALSE) {
  if (audio){
    src <- system.file("templates/input_with_audio.qmd", package = "storytelling")
    dest <- file.path(dest_dir, "story_with_audio.qmd")
    file.copy(src, dest, overwrite = TRUE)
    return(dest)
  }
  src <- system.file("templates/input.qmd", package = "storytelling")
  dest <- file.path(dest_dir, "story.qmd")
  file.copy(src, dest, overwrite = TRUE)
  dest
}



#' Create revealjs slides using quarto
#'
#' @param input_qmd Path to qmd file
#' @param theme Revealjs theme
#' @param title Story title
#' @param story Story text
#' @param images List of binary images
#' @param audios List of binary audios
#'
#' @returns Quarto revealjs slides
#' @export
create_slides <- function(input_qmd,
                          theme = c("dark", "beige", "blood", "league", "moon", "night",
                                    "serif", "simple", "sky", "solarized", "default"),
                          title,
                          story,
                          images,
                          audios) {

  if (length(audios) == 1){
    return(
      quarto::quarto_render(
        input = input_qmd,
        output_format = "all",
        metadata = list(
          theme = theme,
          "title-slide-attributes" = list(
            "data-background-image" = paste0("data:image/png;base64,", base64enc::base64encode(utils::tail(images, 1)[[1]])),
            "data-background-size" = "cover",
            "data-background-opacity" = 0.3
          )
        ),
        quarto_args = c(
          "--metadata",
          paste0("title=", title)
        ),
        execute_params = list(
          story = story,
          imgs = lapply(images, base64enc::base64encode)
        ),
        quiet = TRUE
      )
    )
  }


  quarto::quarto_render(
    input = input_qmd,
    output_format = "all",
    metadata = list(
      theme = theme,
      "title-slide-attributes" = list(
        "data-background-image" = paste0("data:image/png;base64,", base64enc::base64encode(utils::tail(images, 1)[[1]])),
        "data-background-size" = "cover",
        "data-background-opacity" = 0.3
      )
    ),
    quarto_args = c(
      "--metadata",
      paste0("title=", title)
    ),
    execute_params = list(
      story = story,
      imgs = lapply(images, base64enc::base64encode),
      audios = lapply(audios, base64enc::base64encode)
    ),
    quiet = TRUE
  )
}
