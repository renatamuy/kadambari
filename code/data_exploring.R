# Exploring Kadambari data
# Renata Muylaert - 2024

# Packages

if (!require(tidyverse)) install.packages('tidyverse')
if (!require(ggplot2)) install.packages('ggplot2')
if (!require(xlsx)) install.packages('xlsx')
if (!require(DataExplorer)) install.packages('DataExplorer')

# Data

crop <- read.xlsx2('data/Deshpande_et_al_2021_OIK-08359_Data_Dryad.xlsx', sheetIndex = 3)

crop

sdistrict <- read.xlsx2('data/Deshpande_et_al_2021_OIK-08359_Data_Dryad.xlsx', sheetIndex = 4)

sdistrict

benefits <- read.xlsx2('data/Deshpande_et_al_2021_OIK-08359_Data_Dryad.xlsx', sheetIndex = 5)

benefits

# create reports

setwd('figures')

create_report(crop, output_file= 'crop.html')

create_report(sdistrict, output_file= 'sdistrict.html')

create_report(benefits, output_file= 'benefits.html')

#---------------------------------------------------------------------------