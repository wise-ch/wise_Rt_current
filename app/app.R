library(shiny)
library(dplyr)
library(ggplot2)

available_approaches <- c("estimateR", "EpiSewer")
approach_colors <- c(estimateR = "#E64B35FF", EpiSewer = "#4DBBD5FF")

R_reports <- readRDS("../data/R_estimates.rds") |> 
  mutate(approach = factor(approach, levels = available_approaches, ordered = TRUE))

available_wwtps <- c(unique(R_reports$wastewater_treatment_plant.name))
available_targets <- unique(R_reports$target)

ui <- fluidPage(
  inputPanel(
    selectInput(
      "target", label = "Target", choices = available_targets
      ),
    selectizeInput(
      "approaches", label = "Approaches", multiple = TRUE,
      selected = available_approaches,
      choices = available_approaches
      ),
    selectInput(
      "wwtp", label = "Wastewater treatment plant", multiple = TRUE,
      selected = c("ARA Werdhoelzli", "ARA Region Bern", "STEP Aire"),
      choices = available_wwtps
      )
    ),
  textOutput("data_timestamp"),
  plotOutput("Rplot"),
  tags$head(tags$style("#data_timestamp{
                                 font-size: 10px;
                                 font-style: italic;
                                 }"
  )
  )
)
server <- function(input, output, session) {
  output$data_timestamp <- renderText(
    paste("Last data query:", max(R_reports$data_timestamp, na.rm = TRUE),
          " | ", "Data until:", max(R_reports$date, na.rm = TRUE))
  )
  
  output$Rplot <- renderPlot({
    data_to_plot <- R_reports |> 
      filter(wastewater_treatment_plant.name %in% input$wwtp) |> 
      filter(target %in% input$target) |> 
      filter(approach %in% input$approaches)
    
    ymin <- min(0.8, max(quantile(data_to_plot$lower_outer, probs = 0.01), 0.1))
    ymax <- max(1.4, min(quantile(data_to_plot$upper_outer, probs = 0.99), 3))
    
    ggplot(data_to_plot, aes(x=date)) +
      theme_bw() +
      scale_x_date(
        expand = c(0, 0),
        date_breaks = "1 month",
        date_labels = "%b\n%Y"
      ) +
      xlab("Date") +
      ylab(expression(R[t])) +
      theme(legend.title = element_blank(), legend.position = "top") +
      facet_wrap(~wastewater_treatment_plant.name, ncol = 1) +
      coord_cartesian(ylim = c(ymin, ymax)) +
      geom_hline(yintercept = 1, linetype = "dashed") +
      geom_ribbon(
        aes(ymin = lower_outer, ymax = upper_outer, fill = approach),
        alpha = 0.3, color = NA
      ) + 
      geom_ribbon(
        aes(ymin = lower_inner, ymax = upper_inner, fill = approach),
        alpha = 0.5, color = NA
      ) + 
      geom_line(aes(y = mean, color = approach)) +
      scale_fill_manual(values = approach_colors[input$approaches]) + 
      scale_color_manual(values = approach_colors[input$approaches])
  }, height = function() {
    n_wwtps <- R_reports |> 
      filter(wastewater_treatment_plant.name %in% input$wwtp) |> 
      filter(target %in% input$target) |> 
      filter(approach %in% input$approaches) |> 
      distinct(wastewater_treatment_plant.name) |> 
      nrow()
    if(n_wwtps > 3) {
      90 + n_wwtps * 100
    } else {
        "auto"
      }
    })
}
shinyApp(ui, server)