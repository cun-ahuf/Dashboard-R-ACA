# ---------------------------------------
# Tendencia-Diaria-Ventas-Region.R
# ---------------------------------------
# Módulo que muestra la tendencia diaria de ventas por región en un gráfico de líneas.

tendencia_diaria_ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    sidebarLayout(
      sidebarPanel(
        selectInput(ns("region_select"), "Selecciona Región:",
                    choices = c("Todas"),  # Se actualizará en el server
                    selected = "Todas")
      ),
      mainPanel(
        plotlyOutput(ns("line_plot"))
      )
    )
  )
}

tendencia_diaria_server <- function(id, ventas, region_colors) {
  moduleServer(id, function(input, output, session) {
    
    # Asegurarnos de que la columna Fecha sea tipo Date
    ventas <- ventas %>% 
      mutate(Fecha = as.Date(Fecha))
    
    # Agrupar ventas diarias por Fecha y Region_Code
    daily_sales <- ventas %>% 
      group_by(Fecha, Region_Code) %>% 
      summarise(total_ventas = sum(Ventas, na.rm = TRUE)) %>% 
      ungroup()
    
    # Actualizar las opciones de región en el selectInput
    observe({
      updateSelectInput(session, "region_select",
                        choices = c("Todas", unique(daily_sales$Region_Code)),
                        selected = "Todas")
    })
    
    filtered_daily <- reactive({
      if (input$region_select == "Todas") {
        daily_sales
      } else {
        daily_sales %>% filter(Region_Code == input$region_select)
      }
    })
    
    output$line_plot <- renderPlotly({
      p <- ggplot(filtered_daily(), aes(x = Fecha, y = total_ventas, color = Region_Code)) +
        geom_line(size = 1) +
        labs(
          title = ifelse(input$region_select == "Todas",
                         "Tendencia Diaria de Ventas por Todas las Regiones",
                         paste("Tendencia Diaria de Ventas en", input$region_select)),
          x = "Fecha",
          y = "Total de Ventas"
        ) +
        theme_minimal() +
        scale_color_manual(values = region_colors)
      
      ggplotly(p)
    })
  })
}
