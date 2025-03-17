# ---------------------------------------
# Top-10-Vendedores-Opc-Region.R
# ---------------------------------------
# Módulo que muestra el top 10 de vendedores,
# con la opción de filtrar (o ignorar) la región.

top_vendedores_ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    sidebarLayout(
      sidebarPanel(
        selectInput(ns("region_select_vend"), "Filtrar por Región:",
                    choices = c("Todas"),  # Se actualizará en el server
                    selected = "Todas"),
        checkboxInput(ns("ignore_region"), "Ignorar Región", value = FALSE)
      ),
      mainPanel(
        plotlyOutput(ns("vendedores_plot")),
        br(),
        tableOutput(ns("vendedores_table"))
      )
    )
  )
}

top_vendedores_server <- function(id, ventas, vendedores_colors) {
  moduleServer(id, function(input, output, session) {
    
    # Actualizar las opciones de región en el selectInput según los datos de ventas
    observe({
      updateSelectInput(session, "region_select_vend",
                        choices = c("Todas", unique(ventas$Region_Code)),
                        selected = "Todas")
    })
    
    # Filtrar datos según el checkbox y la región seleccionada
    ventas_filtradas_vend <- reactive({
      if (input$ignore_region) {
        ventas
      } else if (input$region_select_vend == "Todas") {
        ventas
      } else {
        ventas %>% filter(Region_Code == input$region_select_vend)
      }
    })
    
    # Calcular el top 10 de vendedores basado en los datos filtrados
    top_vendedores <- reactive({
      ventas_filtradas_vend() %>% 
        group_by(Vendedor) %>% 
        summarise(total_ventas = sum(Ventas, na.rm = TRUE)) %>% 
        arrange(desc(total_ventas)) %>% 
        slice_head(n = 10)
    })
    
    output$vendedores_plot <- renderPlotly({
      p <- ggplot(top_vendedores(), aes(x = reorder(Vendedor, total_ventas), y = total_ventas, fill = Vendedor)) +
        geom_bar(stat = "identity") +
        coord_flip() +
        labs(
          title = if (input$ignore_region || input$region_select_vend == "Todas") {
            "Top 10 Vendedores Global"
          } else {
            paste("Top 10 Vendedores en", input$region_select_vend)
          },
          x = "Vendedor", y = "Total Ventas"
        ) +
        theme_minimal() +
        scale_fill_manual(values = vendedores_colors)
      
      ggplotly(p)
    })
    
    output$vendedores_table <- renderTable({
      top_vendedores()
    })
  })
}
