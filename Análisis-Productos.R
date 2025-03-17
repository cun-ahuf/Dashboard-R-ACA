# ---------------------------------------
# Análisis-Productos.R
# ---------------------------------------
# Módulo que muestra el total y promedio de ventas por producto, con un selector.

analisis_productos_ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    sidebarLayout(
      sidebarPanel(
        selectInput(ns("producto_select"), "Selecciona Producto:",
                    choices = c("Todas"),  # Se actualizará en el server
                    selected = "Todas")
      ),
      mainPanel(
        tabsetPanel(
          tabPanel("Total de Ventas",
                   plotlyOutput(ns("total_ventas_plot"))),
          tabPanel("Promedio de Ventas",
                   plotlyOutput(ns("promedio_ventas_plot"))),
          tabPanel("Resumen",
                   tableOutput(ns("producto_table")))
        )
      )
    )
  )
}

analisis_productos_server <- function(id, ventas, productos_colors) {
  moduleServer(id, function(input, output, session) {
    
    # Calcular resumen de productos
    producto_summary <- ventas %>% 
      group_by(Producto) %>% 
      summarise(
        total_ventas = sum(Ventas, na.rm = TRUE),
        promedio_ventas = mean(Ventas, na.rm = TRUE)
      ) %>% 
      arrange(desc(total_ventas))
    
    # Actualizar selectInput con la lista de productos
    observe({
      updateSelectInput(session, "producto_select",
                        choices = c("Todas", unique(producto_summary$Producto)),
                        selected = "Todas")
    })
    
    producto_data <- reactive({
      if(input$producto_select == "Todas"){
        producto_summary
      } else {
        producto_summary %>% filter(Producto == input$producto_select)
      }
    })
    
    output$total_ventas_plot <- renderPlotly({
      p <- ggplot(producto_data(), aes(x = reorder(Producto, total_ventas), y = total_ventas, fill = Producto)) +
        geom_bar(stat = "identity") +
        coord_flip() +
        labs(title = ifelse(input$producto_select == "Todas",
                            "Total de Ventas por Producto",
                            paste("Total de Ventas para", input$producto_select)),
             x = "Producto", y = "Total de Ventas") +
        theme_minimal() +
        scale_fill_manual(values = productos_colors)
      
      ggplotly(p)
    })
    
    output$promedio_ventas_plot <- renderPlotly({
      p <- ggplot(producto_data(), aes(x = reorder(Producto, promedio_ventas), y = promedio_ventas, fill = Producto)) +
        geom_bar(stat = "identity") +
        coord_flip() +
        labs(title = ifelse(input$producto_select == "Todas",
                            "Promedio de Ventas por Producto",
                            paste("Promedio de Ventas para", input$producto_select)),
             x = "Producto", y = "Promedio de Ventas") +
        theme_minimal() +
        scale_fill_manual(values = productos_colors)
      
      ggplotly(p)
    })
    
    output$producto_table <- renderTable({
      producto_data()
    })
  })
}
