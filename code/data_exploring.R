# Kadambari
# This repo is a supplement to the manuscript:
# Muylaert et al., in prep. Connections in the Dark: Network Science and 
# Social-Ecological Networks as Tools for Bat Conservation and Public Health.
# Global Union of Bat Diversity Networks (GBatNet).
# See README for further info: https://github.com/renatamuy/kadambari

# Packages

if(!require(DataExplorer)){
  install.packages("DataExplorer")
  library(DataExplorer)
}

if(!require(ggplot2)){
  install.packages("ggplot2")
  library(ggplot2)
}

if(!require(tidyverse)){
  install.packages("tidyverse")
  library(tidyverse)
}

if(!require(xlsx)){         #Esse pacote está provocando um erro fatal no meu
  install.packages("xlsx"). #R Studio. Não tem como trocar por outro equivalente?
  library(xlsx)
}

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