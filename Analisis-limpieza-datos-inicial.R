# Cargar librerías
library(readxl)
library(tidyverse)

# Leer el archivo Excel (se asume que está en el directorio de trabajo)
ventas <- read_excel("Ventas - Estudiantes - ACA.xlsx")

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

#Debuggear
#View(ventas)
#unique(ventas$Producto)
#unique(ventas$Region)
ventas <- ventas %>% 
  mutate(Producto_corregido = case_when(
    Producto == "Lavado" ~ "Lavadora",
    Producto %in% c("Nebe", "Ne") ~ "Nevera",
    Producto %in% c("Televisor", "TeleviZOOR") ~ "Televisor",
    Producto == "Sofa" ~ "Sofa",
    Producto == "Aire Acondicion" ~ "Aire Acondicionado",
    Producto %in% c("EstUFa", "Estu") ~ "Estufa",
    Producto == "Ventilador" ~ "Ventilador",
    Producto == "Aire Acondicionado" ~ "Aire Acondicionado",*
    Producto %in% c("Microondas", "Microonda") ~ "Microondas",
    Producto == "Sofa Cama" ~ "Sofa Cama",
    TRUE ~ Producto  # Para cualquier otro valor, se mantiene el original
  ))

ventas <- ventas %>% 
  mutate(Region = ifelse(is.na(Region), "Sin Región", Region))

ventas <- ventas %>% 
  select(-Producto) %>%  # Elimina la columna original
  rename(Producto = Producto_corregido)  # Renombra la columna corregida

# Analisis por Region
region_ventas <- ventas %>% 
  group_by(Region) %>% 
  summarise(total_ventas = sum(Ventas, na.rm = TRUE)) %>% 
  arrange(desc(total_ventas))
print(region_ventas)

# Total y Promedio de Ventas por Producto
producto_ventas <- ventas %>% 
  group_by(Producto) %>% 
  summarise(
    total_ventas = sum(Ventas, na.rm = TRUE),
    promedio_ventas = mean(Ventas, na.rm = TRUE)
  ) %>% 
  arrange(desc(total_ventas))
print(producto_ventas)

#Producto Más Costoso y el Más Económico
producto_precio <- ventas %>% 
  group_by(Producto) %>% 
  summarise(precio_promedio = mean(Ventas, na.rm = TRUE)) %>% 
  arrange(desc(precio_promedio))
print(producto_precio)

#  Búsqueda de Ventas por Vendedor
ventas_vendedor <- ventas %>% 
  filter(Vendedor == "ALVARO HERNAN USECHE FUENTES")

print(ventas_vendedor)

# Ventas por grupo
ventas_grupo <- ventas %>% 
  filter(Grupo == "56636")  # Reemplaza "Nombre_del_Grupo" por el grupo correspondiente

#print(ventas_grupo)

print(region_ventas)

# Total y Promedio de Ventas por Producto
producto_ventas <- ventas %>% 
  group_by(Producto) %>% 
  summarise(
    total_ventas = sum(Ventas, na.rm = TRUE),
    promedio_ventas = mean(Ventas, na.rm = TRUE)
  ) %>% 
  arrange(desc(total_ventas))

print(producto_ventas)

#Producto Más Costoso y el Más Económico
producto_precio <- ventas %>% 
  group_by(Producto) %>% 
  summarise(precio_promedio = mean(Ventas, na.rm = TRUE)) %>% 
  arrange(desc(precio_promedio))

print(producto_precio)

#  Búsqueda de Ventas por Vendedor
ventas_vendedor <- ventas %>% 
  filter(Vendedor == "Alvaro Hernan Useche Fuentes")
print(ventas_vendedor)

# Ventas por grupo
ventas_grupo <- ventas %>% 
  filter(Grupo == "56636")  # Reemplaza "Nombre_del_Grupo" por el grupo correspondiente















