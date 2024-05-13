.libPaths(c("/usr/lib64/R/shiny_library",.libPaths()))

# Define UI
ui <- fluidPage(
    tags$head(
        tags$style(HTML("
      #submit {
        background-color: #4CAF50; /* Green */
        color: white;
        padding: 14px 20px;
        margin: 8px 0;
        border: none;
        border-radius: 4px;
        cursor: pointer;
      }

      #submit:hover {
        background-color: #ff5733;
      }
    "))
    ),

    titlePanel(em("R-Package SeriousInjury: Choose Entanglement *or* Vessel Strike to run appropriate model.")),
    fluidRow(
        column(3, checkboxGroupInput("Injury.Type", "", choices = c("Entanglement", "Vessel Strike", "Calf or Juvenile", "Mobility.Limited (anchored, reduced mobility)", "Constricting Gear", "Non-Constricting or Loose Gear likely to be shed (lack of constricting gear must be confirmed)"))),
        column(3, checkboxGroupInput("checkGroup2", "", choices = c("Injury involves head, mouth, or blowhole?", "Fluke or Peduncle involvement", "Free-swimming and/or Diving (opposite of Mobility.Limited)","Health Decline (cyamids, emaciation, skin discoloration)", "Gear-free", "Pectoral Flipper involvement", "Trailing Gear"))),
        column(3, checkboxGroupInput("checkGroup3", "", choices = c("Wraps Present (one or multiple wraps of gear)", "Wraps Absent (must be confirmed)", "Evidence of Healing", "Laceration Deep", "Laceration Shallow", "Monofilament Hook & Line (exludes gillnets)", "Severe (extensive injuries)"))),
        column(3, checkboxGroupInput("checkGroup4", "", choices = c("Vessel Fast >10kt", "Vessel Slow <=10kt", "Vessel Speed Unknown", "Vessel Large >=65ft", "Vessel Small <65ft", "Vessel Size Unknown")),

               actionButton("submit", "Submit"))),
    tableOutput("table")
)
