# ---------------------------------------
# Resumen-Región.R
# ---------------------------------------
# Módulo que muestra un resumen de ventas por región

resumen_region_ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    sidebarLayout(
      sidebarPanel(
        selectInput(ns("region_select"), "Selecciona Región:",
                    choices = c("Todas"), 
                    selected = "Todas")
      ),
      mainPanel(
        plotlyOutput(ns("region_plot")),
        br(),
        tableOutput(ns("region_table"))
      )
    )
  )
}

resumen_region_server <- function(id, region_summary, region_colors) {
  moduleServer(id, function(input, output, session) {
    
    # Actualizar las opciones de región en el selectInput según los datos de region_summary
    observe({
      updateSelectInput(session, "region_select",
                        choices = c("Todas", unique(region_summary$Region_Code)),
                        selected = "Todas")
    })
    
    region_data <- reactive({
      if (input$region_select == "Todas") {
        region_summary
      } else {
        region_summary %>% filter(Region_Code == input$region_select)
      }
    })
    
    output$region_plot <- renderPlotly({
      p <- ggplot(region_data(), aes(x = Region_Code, y = total_ventas, fill = Region_Code)) +
        geom_bar(stat = "identity") +
        labs(title = ifelse(input$region_select == "Todas",
                            "Ventas por Todas las Regiones",
                            paste("Ventas en", input$region_select)),
             x = "Región", y = "Total Ventas") +
        theme_minimal() +
        scale_fill_manual(values = region_colors)
      
      ggplotly(p)
    })
    
    output$region_table <- renderTable({
      region_data()
    })
  })
}
