library(here)
library(tidyverse)
library(readxl)

# if you need to extract data from emails see save_eml_attachments.py

inventory_all <- function(folder, s){
  # get all the excel files
  files <- list.files(here(folder), pattern = "*.xlsx",full.names = T)
  
  # read in all the files and 
  # skip the first 10 rows (instructions and student names)
  df_all <- files %>% 
    map_dfr(~read_xlsx(.,skip = s))
  
  # removing duplicates
  df_dup <- distinct(df_all)
  
  return(df_dup)
}

#how to do this for multiple sets of data (in seperate folders - one folder for each "lab group")
data <- list.files("./data/")

# reads in all the data, gets the unique number of rows, standardizes the x
result_1 <- data %>% 
  map(~paste0("./data/",.)) %>% 
  map_dfr(~inventory_all(., s = 10)) %>% 
  .[1:8] %>% 
  select(-"Collector",-"Country")

check <- paste0("./data/","EF") %>% 
map_dfr(~inventory_all(.,s = 8)) %>% 
  unique()

#update names
names(result_1) <- names(check)

df_all <- rbind(result_1,check)

df_inventory <- df_all %>% 
  filter(!is.na(`X = Inventoried`)) %>% 
  mutate(Verified = "03/16/2020")

# removing duplicates
df_dup <- distinct(df_inventory, UUID, .keep_all = T)

#comparing between previous upload
result_bio <- read_csv("results/2019_bioblitz_verified.csv")

diff <- anti_join(df_dup, result_bio, by = "UUID")

write_csv(diff, "results/2020Mar17_missinginventory.csv")
