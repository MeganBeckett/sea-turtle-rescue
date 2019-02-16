# ==================================================================================================
#                                  Exploratory data analysis                                       #
#                                       Megan Beckett                                              #
# ==================================================================================================

# LIBRARIES ----------------------------------------------------------------------------------------
library(dplyr)
library(readr)
library(ggplot2)
library(tidyr)
library(DT)
# library(summarytools)
library(here)

# READ DATA ----------------------------------------------------------------------------------------
dirty <- read_csv("raw_data/dirty_data.csv")
clean <- read_csv("raw_data/cleaned_data.csv")
# var_def <- read_csv("raw_data/variable_definitions.csv")
