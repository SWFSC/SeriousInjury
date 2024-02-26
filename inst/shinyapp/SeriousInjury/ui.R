.libPaths(c("/usr/lib64/R/shiny_library",.libPaths()))

ui <- fluidPage(
    tags$head(
        tags$style(HTML("

      /* Increase font size for all text elements */
      body {
        font-size: 18px; /* Adjust the font size as needed */
      }

      /* Increase font size for specific element by class */
      .title {
        font-size: 18px; /* Adjust the font size as needed */
      }

      /* Custom CSS for action button */
      .btn-custom {
        background-color: #4CAF50; /* Green */
        border-color: #ff5733; /* Match background color */
        color: white; /* Text color */
      }

    "))
    ),

    titlePanel("R-Package SeriousInjury. Assess severity of whale injuries from a narrative."),
    div(style = "width: 100px; display: inline-block;"), # Horizontal space
    mainPanel(actionButton("Add", "Update Narrative and Interaction Type", class = "btn-custom"),
        textAreaInput(inputId = "Narrative",
        label = "Narrative",
        value = "Free-swimming whale with loose rope draped over dorsal hump and minor scrapes on skin.",
                      width='1000px', height='200px')),

               selectInput("Injury.Type", "EN (entanglement) or VS (vessel strike)",
                list(`Injury.Type` = list("EN", "VS"))),

    mainPanel(tabsetPanel(
        tabPanel("Predicted Probability of Death|Health Decline or Recovery", tableOutput(outputId = "table")))))
