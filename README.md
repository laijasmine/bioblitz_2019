# Reconciling Bioblitz spreadsheet data
The code takes care of the post-processing work after completing the bioblitz activity for UBC biology students at the Herbarium

### Workflow
Student emails -> Excel files -> Consolidated Excel files -> Import into Filemaker Database

## Dependencies
* Python
* R and `install.packages("here", "tidyverse", "readxl")`

## How to use
### Pre Bioblitz - Setup
1. Create a template spreadsheet based on Herbarium database where we last left off and including the following columns:
> Accession Number,	(X) Verified,	Genus,	Species,	Country,	Date,	Collector,	UUID
2. Distribute to students (ie through Canvas)
3. Bioblitz!
4. Save & Name file with first and last name
5. Get students to email files

### After Bioblitz - Post Processing
1. Extract Excel files from email attachments
- add .eml files to the email folder
- requires **python**
- run `save_eml_attachments.py`

2. Combine data from student Excel files
- add Excel files the data folder
- run `consolidating_data.R`
- the resulting file will be saved in the results folder

3. Adding the data to the UBC herbarium database
- open Filemaker
- file > import
- select your file
- select Arrange:`matching names`
- select `Update matching records in found set`
- select `Don't import first record (contains field names`
- press `import`
<img src="https://github.com/laijasmine/bioblitz_2019/blob/master/import_ubcalgae_instructions/import_window.PNG" alt="import" width="600"/>

