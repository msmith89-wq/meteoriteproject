library(shiny)
library(tidyverse)
library(glue)
library(DT)
library(plotly)
library(leaflet)

meteorite_landings <- read_csv('./data/Meteorite_Landings_20250126.csv')

fireball_bolides <- read_csv('./data/Fireball_And_Bolide_Reports_20250126.csv')

fireball_bolides <- fireball_bolides |> 
  rename(c(Total_Radiated_Energy_J = `Total Radiated Energy (J)`, Altitude_km = `Altitude (km)`, Total_Impact_Energy_kt = `Calculated Total Impact Energy (kt)`))

plot_heights <- "300px"

meteorite_class <- function(recclass_filter){meteorite_landings |> 
  filter(recclass == recclass_filter)}