#.libPaths(c("/usr/lib64/R/shiny_library",.libPaths()))
library(SeriousInjury)

server <- function(input, output){

    rv <- reactiveValues(
        df = data.frame(
            Narrative = character(),
            Injury.Type = character()
        )
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
