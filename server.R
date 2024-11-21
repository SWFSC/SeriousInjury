#.libPaths(c("/usr/lib64/R/shiny_library",.libPaths()))
library(SeriousInjury)
library(dplyr)
library(shiny)

# Define server logic
server <- function(input, output, session) {
    # Reactive value to store the dataframe
    checkbox_df <- reactiveVal(data.frame())

    observeEvent(input$submit, {
        # Convert checkbox input to a single text field in a dataframe
        combined_text <- paste(input$Injury.Type, input$checkGroup2, input$checkGroup3, input$checkGroup4, collapse = ", ")
        df <- data.frame(Narrative = combined_text, stringsAsFactors = FALSE)

        # append df with Injury.Type, depending on text

        if(grepl("Entanglement", df$Narrative)==TRUE) {df$Injury.Type = "EN"} else {df$Injury.Type = "VS"}

        if(df$Injury.Type=="EN") {df <- cbind.data.frame(df, predict(ModelEntangle, InjuryCovariates(df), type="prob"))}
        if(df$Injury.Type=="VS") {df <- cbind.data.frame(df, predict(ModelVessel, InjuryCovariates(df), type="prob")) }
        # use this if you just want to see the covariate states assigned: if(df$Injury.Type=="VS") {df <- InjuryCovariates(df) }

        # Update the reactive dataframe
        checkbox_df(df)
    })

    # Render the table
    output$table <- renderTable({
        checkbox_df()
    })

}
