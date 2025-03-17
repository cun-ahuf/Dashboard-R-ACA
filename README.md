# 📊 Dashboard de Ventas en R con Shiny

Este proyecto es un **dashboard interactivo en R** desarrollado con **Shiny**, que permite analizar las ventas de enero 2024 de manera visual e intuitiva. Proporciona reportes sobre ventas por región, top vendedores y análisis de productos.

## 📌 Requisitos

Antes de ejecutar el proyecto, asegúrate de tener instaladas las siguientes librerías en R:

```r
install.packages(c("shiny", "tidyverse", "plotly", "readxl", "RColorBrewer"))

🚀 Cómo Ejecutar el Proyecto
git clone https://github.com/tu-usuario/Proyecto-Dashboard-Ventas.git
cd Proyecto-Dashboard-Ventas

📌 **Ejecutar el Dashboard**

Ejecuta el siguiente comando en RStudio para cargar la aplicación:
Asegúrate de que la carpeta Dashboard-R-ACA-main/ esté dentro del directorio predeterminado de RStudio.
source("Dashboard-R-ACA-main/DashboardApp.R", echo = TRUE)

📂 Estructura del Proyecto
/Proyecto-Dashboard-Ventas
│── DashboardApp.R                 # Archivo principal que ejecuta la aplicación
│── Limpieza-data.R                 # Script para limpiar y estandarizar los datos
│── Análisis-Productos.R            # Módulo de análisis de productos
│── Resumen-Región.R                 # Módulo de resumen por región
│── Tendencia-Diaria-Ventas-Region.R # Módulo de tendencia de ventas diarias
│── Top-10-Vendedores-Opc-Region.R   # Módulo del ranking de vendedores
│── README.md                        # Documentación del proyecto

📈 Características
Interactividad: Posibilidad de filtrar y explorar datos dinámicamente.
Visualización Avanzada: Uso de Plotly para gráficos interactivos.
Limpieza de Datos: Proceso de estandarización y corrección de errores en los datos.
Arquitectura Modular: Cada análisis es un módulo independiente.
Filtros Personalizados: Permite segmentar datos por región, vendedor y producto.

Este dashboard permite un análisis detallado de las ventas mediante herramientas de inteligencia de negocios. Su diseño modular facilita futuras ampliaciones y adaptaciones. ¡Disfruta explorando los datos! 🚀
