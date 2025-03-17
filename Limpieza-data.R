# Cargar librerías
library(readxl)
library(tidyverse)

# Leer el archivo Excel 
ventas <- read_excel("Ventas - Estudiantes - ACA.xlsx")

#names(ventas)
# Eliminar los espacios en blanco al inicio y al final de las columnas de tipo texto
ventas <- ventas %>% 
  mutate(across(where(is.character), str_trim))

# Transforma los nombres en la columna Vendedor para que tengan la primera letra de cada palabra en mayúscula y el resto en minúsculas
ventas <- ventas %>% 
  mutate(Vendedor = str_to_title(str_to_lower(Vendedor)))

# Revisar resumen de los datos para ver valores NA
#summary(ventas)

#eliminamos los caracteres especiales en las columnas de texto
ventas <- ventas %>% 
  mutate(across(where(is.character), ~ gsub("[^[:alnum:][:space:]]", "", .)))

## Estandariza los nombres de productos y los guarda en 'Producto_corregido'
ventas <- ventas %>% 
  mutate(Producto_corregido = case_when(
    Producto == "Lavado" ~ "Lavadora",
    Producto %in% c("Nebe", "Ne") ~ "Nevera",
    Producto %in% c("Televisor", "TeleviZOOR") ~ "Televisor",
    Producto == "Sofa" ~ "Sofa",
    Producto == "Aire Acondicion" ~ "Aire Acondicionado",
    Producto %in% c("EstUFa", "Estu") ~ "Estufa",
    Producto == "Ventilador" ~ "Ventilador",
    Producto == "Aire Acondicionado" ~ "Aire Acondicionado",
    Producto %in% c("Microondas", "Microonda") ~ "Microondas",
    Producto == "Sofa Cama" ~ "Sofa Cama",
    TRUE ~ Producto  # Para cualquier otro valor, se mantiene el original
  ))

# Reemplaza valores NA en la columna 'Region' con "Sin Región"
ventas <- ventas %>% 
  mutate(Region = ifelse(is.na(Region), "Sin Región", Region))

# Elimina la columna 'Producto' original y renombra 'Producto_corregido' como 'Producto'
ventas <- ventas %>% 
  select(-Producto) %>%  
  rename(Producto = Producto_corregido)  



















