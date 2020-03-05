library(here)
library(tidyverse)
library(readxl)

# if you need to extract data from emails see save_eml_attachments.py

#function to take the data and give what was inventoried
inventory <- function(folder){
  # get all the excel files
  files <- list.files(here(folder), pattern = "*.xlsx",full.names = T)
  
  # read in all the files and 
  # skip the first 10 rows (instructions and student names)
  df_all <- files %>% 
    map_dfr(~read_xlsx(.,skip = 10))
  
  # take only the rows where it was inventoried (x)
  df_inventory <- df_all %>% 
    filter(!is.na(`X = Inventoried`))
  
  # checking the contents
  df_inventory %>% 
    group_by(`X = Inventoried`) %>% 
    summarise()
  
  # removing duplicates
  df_dup <- distinct(df_inventory)
  
  return(df_dup)
}

#how to do this for multiple sets of data (in seperate folders - one folder for each "lab group")
data <- list.files("./data")

# reads in all the data, gets the unique number of rows, standardizes the x
result <- data %>% 
  map(~paste0("./data/",.)) %>% 
  map_dfr(~inventory(.)) %>% 
  unique()

#fixing the columns so it will rbind
# and making new column of the date verified
df_result <- result[1:8] %>% 
  mutate(Verified = "11/10/2019")

# get a blank spreadsheet to compare with
temp <- read_xlsx("2019Sep_Algae SCIE 001_template.xlsx", skip = 10, col_types = c("text","text","text","text","text","text","text","text"))

#checking the data
# get all the missing records
missing <- anti_join(temp, result, by = "UUID")

mt <- missing %>% 
  group_by(Genus,Species) %>% 
  summarise(n())

dr <- df_result %>% 
  group_by(Genus,Species) %>% 
  summarise(n())

write_csv(df_result, "results/2019_bioblitz_verified.csv")

# Import data
# matching by UUID
# import only Verified Column

# Checking your work if everything is imported properly
import <- read_xlsx("data/imported_20191015.xlsx")

filter(import,!(import$`Accession Number` %in% df_result$`Accession Number`))

filter(df_result,!(df_result$`Accession Number` %in% import$`Accession Number`))
