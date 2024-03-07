# Hour 1: Getting started with 2020 Decennial Census
library(tidycensus)
library(tidyverse)
options(tigris_use_cache = TRUE)


## Pop 2020
pop20 <- get_decennial(
  geography = "state",
  variables = "P1_001N",
  year = 2020
)

pop20


## Get all variables from a table
table_p2 <- get_decennial(
  geography = "state",
  table = "P2",
  year = 2020
)

table_p2


## Get a single State
tx_population <- get_decennial(
  geography = "county",
  variables = "P1_001N",
  state = "TX",
  sumfile = "dhc",
  year = 2020
)

tx_population

## Get a single county
matagorda_blocks <- get_decennial(
  geography = "block",
  variables = "P1_001N",
  state = "TX",
  county = "Matagorda",
  sumfile = "dhc",
  year = 2020
)

matagorda_blocks


# View variables
vars <- load_variables(2020, "dhc")
View(vars)


# DHC closest to past sumfiles
# dp pretabulated Demographic Profiles


# Part 1 Exercises
## Exercise 1
la_aspop <- get_decennial(
  geography = "county subdivision",
  variables = "P10_006N",
  state = "CA",
  county = "Los Angeles",
  sumfile = "dhc",
  summary_var = "P1_001N",
  year = 2020
) %>% mutate(pct = 100 * (value / summary_value))

la_aspop %>% arrange(desc(pct))

# CA same sex, long and wide
ca_samesex_long <- get_decennial(
  geography = "county",
  state = "CA",
  variables = c(married = "DP1_0116P",
                partnered = "DP1_0118P"),
  year = 2020,
  sumfile = "dp"
)

ca_samesex_wide <- get_decennial(
  geography = "county",
  state = "CA",
  variables = c(married = "DP1_0116P",
                partnered = "DP1_0118P"),
  year = 2020,
  sumfile = "dp",
  output = "wide"
)

# Hour2: Analysis workflows with 2020 Census Data
## Finding the largest values
tx_population <- get_decennial(
  geography = "county",
  variables = "P1_001N",
  year = 2020,
  state = "TX",
  sumfile = "dhc"
)

tx_population %>% arrange(desc(value))

## filtering
below1000 <- tx_population %>% filter(value < 1000)
below1000

## Using summary variables
race_vars <- c(
  Hispanic = "P5_010N",
  White = "P5_003N",
  Black = "P5_004N",
  Native = "P5_005N",
  Asian = "P5_006N",
  HIPI = "P5_007N"
)

cd_race <- get_decennial(
  geography = "congressional district",
  variables = race_vars,
  summary_var = "P5_001N",
  year = 2020,
  sumfile = "cd118"
)

cd_race

## Normalizing columns with mutate()

cd_race_percent <- cd_race %>% 
  mutate(percent = 100 * (value / summary_value)) %>% 
  select(NAME, variable, percent)

cd_race_percent

## Group-wise Census data analysis
largest_group <- cd_race_percent %>% 
  group_by(NAME) %>% 
  filter(percent == max(percent))

largest_group

## using .by argument in filter call automatically ungroups data after process
## group_by results inherit group(s)
# Hour 3: The detailed DHC-A data and time-series analysis
