library(tidyverse)
library(readxl)

# if you need to extract data from emails see save_eml_attachments.py
#change some variables
verified_date <- "03/17/2020"
xlsx_files_folder <- "./02_data/20200309_data/"
blank_template <- "./00_templates/2020Mar01_UBCAlgae ENVR200 BioBlitz_template.xlsx"
name_of_results_file <- "04_results/2019_bioblitz_verified_envr200.csv"
  
#function to take the data and give what was inventoried
inventory_files <- function(files){
  
  # read in all the files and 
  # skip the first 10 rows (instructions and student names)
  df_all <- files %>% 
    map_dfr(~read_xlsx(.,skip = 3))
  
  # take only the rows where it was inventoried (x)
  df_inventory <- df_all %>% 
    filter(!is.na(`(X) Verified`))
  
  # checking the contents
  df_inventory %>% 
    group_by(`(X) Verified`) %>% 
    summarise()
  
  # removing duplicates
  df_dup <- distinct(df_inventory)
  
  return(df_dup)
}

#how to do this for multiple sets of data (in seperate folders - one folder for each "lab group")
data <- list.files(xlsx_files_folder, full.names = T)

# reads in all the data, gets the unique number of rows, standardizes the x
result <- data %>% 
  map_dfr(~inventory_files(.)) %>% 
  distinct(UUID,.keep_all = T)

# and making new column of the date verified
df_result <- result %>% 
  mutate(Verified = verified_date)

# get a blank spreadsheet to compare with
temp <- read_xlsx(blank_template, skip = 3, 
                  col_types = c("text","text","text","text","text","text","text","text","text","text"))

#checking the data
# get all the missing records
missing <- anti_join(temp, result, by = "UUID")

#summarized results
summary_of_missing <- missing %>% 
  group_by(Genus,Species) %>% 
  summarise(n())

summary_of_results <- df_result %>% 
  group_by(Genus,Species) %>% 
  summarise(n())

write_csv(df_result, name_of_results_file)

# Import data
# matching by UUID
# import only Verified Column

# Checking your work if everything is imported properly
# import <- read_xlsx("data/imported_20191015.xlsx")
# 
# filter(import,!(import$`Accession Number` %in% df_result$`Accession Number`))
# 
# filter(df_result,!(df_result$`Accession Number` %in% import$`Accession Number`))
