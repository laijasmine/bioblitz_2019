library(tidyverse)
library(readxl)

# if you need to extract data from emails see save_eml_attachments.py
#change some variables
verified_date <- "03/17/2020"
file <- "./02_data/2020Mar10_DE_algaeinventory.xlsx"
blank_template <- "./00_templates/2020Mar01_UBCAlgae ENVR200 BioBlitz_template.xlsx"
name_of_results_file <- "04_results/2019_bioblitz_verified_volunteers.csv"
  
data <- read_xlsx(file)

# reads in all the data, gets the unique number of rows, standardizes the x
result <- data %>% 
  filter(!is.na(`Inventory (x = verified)`))

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