library(shiny)
library(tidyverse)
library(glue)
library(DT)
library(plotly)
library(leaflet)
library(treemapify)

meteorite_landings <- read_csv('./data/Meteorite_Landings_20250126.csv')

fireball_bolides <- read_csv('./data/Fireball_And_Bolide_Reports_20250126.csv')

fireball_bolides <- fireball_bolides |> 
  rename(c(Total_Radiated_Energy_J = `Total Radiated Energy (J)`, Altitude_km = `Altitude (km)`, Total_Impact_Energy_kt = `Calculated Total Impact Energy (kt)`))

fireball_bolides <- fireball_bolides |> 
  mutate(Latitude = str_remove(`Latitude (Deg)`, "(N|S)$") |> as.numeric(),
         Longitude = str_remove(`Longitude (Deg)`, "(E|W)$") |> as.numeric())

meteorite_landings <- meteorite_landings |> 
  mutate(Mass_Log = log1p(`mass (g)`))

meteorite_type_count <- meteorite_landings |> 
  count(recclass) |> 
  rename(count = `n`) |> 
  arrange(desc(count))

fireball_bolides <- fireball_bolides |> 
  mutate(Impact_Log = log(Total_Impact_Energy_kt))
  

plot_heights <- "300px"

meteorite_class <- function(recclass_filter){meteorite_landings |> 
  filter(recclass == recclass_filter)}