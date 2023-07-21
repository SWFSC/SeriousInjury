.libPaths(c("/usr/lib64/R/shiny_library",.libPaths()))

ui <- fluidPage(
    titlePanel("Assess Severity of Whale Injuries from Narratives"),
    sidebarPanel(
        textAreaInput(inputId = "Narrative",
                      label = "Narrative",
                      value = "Enter / paste text and click 'Add' button to update. Include words and phrases related to whale injuries. Random text, such as 'the quick brown fox jumps over the lazy dog', will return a meaningless prediction of health status due to a lack of relevant variables.", width='400px', height='400px')),
    selectInput("Injury.Type", "EN (entanglement) or VS (vessel strike)",
                list(`Source` = list("EN", "VS"))),
    actionButton("Add", "Add"),

    mainPanel(tabsetPanel(
        tabPanel("Predicted Probability of Death|Health Decline or Recovery", tableOutput(outputId = "table")))))
