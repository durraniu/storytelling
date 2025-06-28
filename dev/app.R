library(shiny)
library(bslib)
library(gsapy)
library(storytelling)
library(base64enc)

ui <- page_fillable(
  # placeholder for GSAP-enhanced content
  input_task_button("create_story", "Create Story"),
  uiOutput("story_content")
)

server <- function(input, output, session) {

  story <- reactiveVal()
  images <- reactiveVal()

  observeEvent(input$create_story, {

    new_story <- storytelling::generate_story(
      user_prompt = "Tell me a story about a man who travelled to Mars",
      num_paras = 2
    )
    story(new_story)

    image_prompts <- storytelling::generate_image_prompts(new_story)

    new_images <- storytelling::generate_images(
      image_prompts
    )
    images(new_images)
  })


  output$story_content <- renderUI({
    req(story(), images())
    withGsapy(
      id = "story_container",
      animation = "fadeIn",
      lapply(seq_along(story()), function(i) {
        div(
          bslib::layout_column_wrap(width = 1/2,
            p(story()[i]),
            img(src = paste0("data:image/png;base64,",
                             base64encode(images()[[i]])))
          ),
          br()
        )
      })
    )
  })


}


shinyApp(ui, server)
