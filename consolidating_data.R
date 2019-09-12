library(here)
library(tidyverse)
library(readxl)

# get all the excel files
files <- list.files(here("data"),full.names = T)

# reading a csv file
# df_csv <- read_csv("2019Sep_Algae SCIE 001.csv", skip = 11)

# read in all the files and 
# skip the first 10 rows
df_all <- files %>% 
  map_dfr(~read_xlsx(.,skip = 10))

# take only the ones inventoried
df_inventory <- df_all %>% 
  filter(!is.na(`X = Inventoried`))

# checking the contents
df_inventory %>% 
  group_by(`X = Inventoried`) %>% 
  summarise()

# removing duplicates
df_dup <- distinct(df_inventory)
