library(shiny)
library(tidyverse)
library(glue)
library(DT)
library(plotly)
library(leaflet)
library(treemapify)
library(sf)
library(suntools)

meteorite_landings <- read_csv('./data/Meteorite_Landings_20250126.csv')

fireball_bolides <- read_csv('./data/Fireball_And_Bolide_Reports_20250126.csv')

fireball_bolides <- fireball_bolides |> 
  rename(c(Total_Radiated_Energy_J = `Total Radiated Energy (J)`, Altitude_km = `Altitude (km)`, Total_Impact_Energy_kt = `Calculated Total Impact Energy (kt)`))

fireball_bolides <- fireball_bolides |> 
  mutate(Latitude = str_remove(`Latitude (Deg)`, "(N|S)$") |> as.numeric(),
         Longitude = str_remove(`Longitude (Deg)`, "(E|W)$") |> as.numeric()) |> 
  mutate(Date = str_extract(`Date/Time - Peak Brightness (UT)`, "^\\d{2}/\\d{2}/\\d{4}")) |> 
  mutate(Time = str_extract(`Date/Time - Peak Brightness (UT)`, "\\d{2}:\\d{2}:\\d{2}\\s\\w+"))

fireball_bolides_sf <- st_as_sf(
  fireball_bolides |> select(-`Latitude (Deg)`, -`Longitude (Deg)`), 
  coords = c("Longitude", "Latitude"), 
  crs = st_crs(4326)
)

sunrise_tibble <- sunriset(
  fireball_bolides_sf,
  as.POSIXct(fireball_bolides_sf$`Date`, tryFormats = '%m/%d/%Y', tz = 'UTC'),
  direction = 'sunrise',
  POSIXct.out = TRUE
) |> 
  select(sunrise_time = time)

fireball_bolides_sf <- fireball_bolides_sf |> 
  bind_cols(sunrise_tibble)

sunset_tibble <- sunriset(
  fireball_bolides_sf,
  as.POSIXct(fireball_bolides_sf$`Date`, tryFormats = '%m/%d/%Y', tz = 'UTC'),
  direction = 'sunset',
  POSIXct.out = TRUE
) |> 
  select(sunset_time = time)

fireball_bolides_sf <- fireball_bolides_sf |> 
  bind_cols(sunset_tibble)

fireball_bolides_sf <- fireball_bolides_sf |> 
  mutate(`Date/Time - Peak Brightness (UT)` = as.POSIXct(`Date/Time - Peak Brightness (UT)`, tryFormats = '%m/%d/%Y %I:%M:%S %p'))

fireball_bolides_sf <- fireball_bolides_sf |> 
  mutate(If_Daytime = between(`Date/Time - Peak Brightness (UT)`, sunrise_time, sunset_time))
If_Daytime_mean <- fireball_bolides_sf |> 
  summarise(mean(If_Daytime, na.rm = TRUE)) |> 
  st_drop_geometry() |> 
  pull(`mean(If_Daytime, na.rm = TRUE)`)

Day_Night_Tibble <- tibble(
  Time_of_Day = c("Day", "Night"),
  Proportion = c(If_Daytime_mean, 1-If_Daytime_mean)
)

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