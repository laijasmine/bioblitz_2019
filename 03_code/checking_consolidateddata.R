name_of_results_file <- "04_results/2019_bioblitz_verified_volunteers.csv"
imported_file <- "data/imported_20191015.xlsx"

# Import data
# matching by UUID
# import only Verified Column

# Checking your work if everything is imported properly
import <- read_xlsx(imported_file)

df_result <- read_csv(name_of_results_file)

filter(import,!(import$`Accession Number` %in% df_result$`Accession Number`))

filter(df_result,!(df_result$`Accession Number` %in% import$`Accession Number`))