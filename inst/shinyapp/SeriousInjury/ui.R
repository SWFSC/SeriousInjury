.libPaths(c("/usr/lib64/R/shiny_library",.libPaths()))

ui <- fluidPage(
    titlePanel("Assess Whale Injury Severity from Narratives"),
    sidebarPanel(
        textAreaInput(inputId = "Narrative",
                      label = "Narrative",
                      value = "insert narrative text", rows=15, cols=100)),
    selectInput("Injury.Type", "EN (entanglement) or VS (vessel strike)",
                list(`Source` = list("EN", "VS"))),
    actionButton("Add", "Add"),

    mainPanel(tabsetPanel(
        tabPanel("Predicted Probability of Death|Health Decline or Recovery", tableOutput(outputId = "table")))))
