# ==================================================================================================
#                                    Read in Turtle data                                           #
#                                       Megan Beckett                                              #
# ==================================================================================================

# LIBRARIES ----------------------------------------------------------------------------------------
library(dplyr)
library(here)
library(readr)
library(lubridate)

# READ DATA ----------------------------------------------------------------------------------------
dirty <- read_csv(here::here("raw_data/dirty_data.csv"))
clean <- read_csv(here::here("raw_data/cleaned_data.csv"))
# var_def <- read_csv("raw_data/variable_definitions.csv")

# MODIFY VARIABLE TYPES ----------------------------------------------------------------------------
dirty <- dirty %>%
  mutate(Date_Caught = mdy(Date_Caught),
         Date_Release = mdy(Date_Release))

clean <- clean %>%
  mutate(Date_Caught = mdy(Date_Caught),
         Date_Release = mdy(Date_Release))

