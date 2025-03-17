# app.R

# Cargar librerías globales
library(shiny)
library(tidyverse)
library(plotly)
library(readxl)
library(RColorBrewer)

# Importar el script de limpieza de datos
source("Limpieza-data.r")

# Crear columna Region_Code que sera usada posteriormente
ventas <- ventas %>% 
  mutate(Region_Code = case_when(
    Region %in% c("Amazonia", "Andina") ~ "51164 Amazonía y Andina",
    Region == "Caribe" ~ "56635 Caribe",
    Region == "Orinoquia" ~ "56636 Orinoquia",
    Region == "Pacifica" ~ "51160 Pacífica",
    TRUE ~ Region
  ))

# Importar los módulos 
source("Resumen-Región.R")
source("Top-10-Vendedores-Opc-Region.R")
source("Tendencia-Diaria-Ventas-Region.R")
source("Análisis-Productos.R")


# Resumen por región basado en la columna Region_Code
region_summary <- ventas %>%
  group_by(Region_Code) %>%
  summarise(total_ventas = sum(Ventas, na.rm = TRUE)) %>%
  arrange(desc(total_ventas))

# Paleta de colores para las regiones
region_colors <- c("51164 Amazonía y Andina" = "#1b9e77", 
                   "56635 Caribe" = "#d95f02", 
                   "56636 Orinoquia" = "#7570b3", 
                   "51160 Pacífica" = "#e7298a", 
                   "Sin Región" = "#66a61e")

# Paleta de colores para vendedores
vendedores_colors <- setNames(
  colorRampPalette(brewer.pal(12, "Set3"))(length(unique(ventas$Vendedor))),
  sort(unique(ventas$Vendedor))
)

# Paleta de colores para productos
productos_unicos <- unique(ventas$Producto)
productos_colors <- setNames(
  colorRampPalette(brewer.pal(8, "Set2"))(length(productos_unicos)),
  sort(productos_unicos)
)

# Definir la UI con pestañas para cada módulo
ui <- fluidPage(
  titlePanel("Dashboard Integral de Ventas - Enero 2024 - CUN - Ingenieria de Sistemas - Alvaro Hernan"),
  tabsetPanel(
    tabPanel("Resumen por Región", 
             resumen_region_ui("resumen_region")),
    tabPanel("Top 10 Vendedores", 
             top_vendedores_ui("top_vendedores")),
    tabPanel("Tendencia Diaria", 
             tendencia_diaria_ui("tendencia_diaria")),
    tabPanel("Análisis de Productos", 
             analisis_productos_ui("analisis_productos"))
  )
)

# 6. Definir el server y llamar a cada módulo
server <- function(input, output, session) {
  resumen_region_server("resumen_region", 
                        region_summary = region_summary, 
                        region_colors = region_colors)
  top_vendedores_server("top_vendedores", 
                        ventas = ventas, 
                        vendedores_colors = vendedores_colors)
  tendencia_diaria_server("tendencia_diaria", 
                          ventas = ventas, 
                          region_colors = region_colors)
  analisis_productos_server("analisis_productos", 
                            ventas = ventas, 
                            productos_colors = productos_colors)
}

# 7. Ejecutar la aplicación
shinyApp(ui = ui, server = server)
