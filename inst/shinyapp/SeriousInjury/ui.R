.libPaths(c("/usr/lib64/R/shiny_library",.libPaths()))

ui <- fluidPage(
    titlePanel("R-Package *SeriousInjury*: Assess severity of whale injuries from a narrative."),
    mainPanel(
        textAreaInput(inputId = "Narrative",
                      label = "Narrative",
                      value = "Type/paste text and press ʻEnterʻ button for injury assessment. Use toggle to switch between entanglements or vessel strikes. Whale with multiple wraps of line around peduncle and heavy cyamid growth.", width='400px', height='400px')),
    selectInput("Injury.Type", "EN (entanglement) or VS (vessel strike)",
                list(`Injury.Type` = list("EN", "VS"))),
    actionButton("Add", "Enter"),

    mainPanel(tabsetPanel(
        tabPanel("Predicted Probability of Death|Health Decline or Recovery", tableOutput(outputId = "table")))))
