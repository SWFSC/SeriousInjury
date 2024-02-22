.libPaths(c("/usr/lib64/R/shiny_library",.libPaths()))

ui <- fluidPage(
    tags$head(
        tags$style(HTML("
        .btn-custom {
                            background-color: #4CAF50; /* Green */
                                border: none;
                            color: white;
                            padding: 15px 32px;
                            text-align: center;
                            text-decoration: none;
                            display: inline-block;
                            font-size: 12px;
                            margin: 4px 2px;
                            cursor: pointer;
                        }
                        .btn-custom:hover {
                            background-color: #45a049; /* Darker Green */
                                color: white;
                        }

      /* Increase font size for all text elements */
      body {
        font-size: 24px; /* Adjust the font size as needed */
      }

      /* Increase font size for specific element by class */
      .title {
        font-size: 18px; /* Adjust the font size as needed */
      }
    "))
    ),


    titlePanel("R-Package SeriousInjury. Assess severity of whale injuries from a narrative."),
    mainPanel(actionButton("Add", "Update Narrative"),
        textAreaInput(inputId = "Narrative",
                      label = "Narrative",
                      value = "Type/paste text. Press ʻUpdate Narrativeʻ button for injury assessment. Toggle to switch between entanglements or vessel strikes. Whale with multiple wraps of line around peduncle and heavy cyamid growth.", width='400px', height='400px')),

               selectInput("Injury.Type", "EN (entanglement) or VS (vessel strike)",
                list(`Injury.Type` = list("EN", "VS"))),

    mainPanel(tabsetPanel(
        tabPanel("Predicted Probability of Death|Health Decline or Recovery", tableOutput(outputId = "table")))))
