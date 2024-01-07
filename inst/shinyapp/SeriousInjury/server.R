#.libPaths(c("/usr/lib64/R/shiny_library",.libPaths()))
library(SeriousInjury)

server <- function(input, output){

    rv <- reactiveValues(
        df = data.frame(Narrative = "Type/paste text and ʻEnterʻ to update probabilities. Use toggle to switch between entanglements or vessel strikes. ʻWhale with multiple wraps of line around peduncle and heavy cyamid growth.ʻ", Injury.Type = "EN"),
            Narrative = character(),
            Injury.Type = character()
        )




    observeEvent(input$Add, {
        rv$df <- data.frame(Narrative = input$Narrative,
                            Injury.Type = input$Injury.Type
        )
    })

    output$table<-renderTable({
        if(input$Injury.Type=="EN") {cbind.data.frame(rv$df, predict(ModelEntangle, InjuryCovariates(rv$df), type="prob"))}
        else {cbind.data.frame(rv$df, predict(ModelVessel, InjuryCovariates(rv$df), type="prob"))}
    })

}
