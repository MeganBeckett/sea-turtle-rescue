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
library(here)
library(arsenal)
library(lubridate)

# READ DATA ----------------------------------------------------------------------------------------
dirty <- read_csv("raw_data/dirty_data.csv")
clean <- read_csv("raw_data/cleaned_data.csv")
# var_def <- read_csv("raw_data/variable_definitions.csv")

# INITIAL VIEW -------------------------------------------------------------------------------------
summary(dirty)
summary(clean)

glimpse(dirty)

# quick look at some differences
unique(dirty$Status)
unique(clean$Status)

# MODIFY VARIABLE TYPES ----------------------------------------------------------------------------
# dirty <- dirty %>%
#   mutate(Date_Caught = mdy(Date_Caught),
#          Date_Release = mdy(Date_Release))
#
# clean <- clean %>%
#   mutate(Date_Caught = mdy(Date_Caught),
#          Date_Release = mdy(Date_Release))

# COMPARE CLEAN AND DIRTY --------------------------------------------------------------------------
# Use compare() to create compare object
cmp <- compare(dirty, clean)
cmp

# How many differences are there bbetween dirty and clean?
n.diffs(cmp)

# Quick look at differences
head(diffs(cmp))

# which variables have the most differences
diffs <- diffs(cmp, by.var = TRUE) %>%
  arrange(desc(n))
diffs

# CREATE TARGET VARIABLE ---------------------------------------------------------------------------
# First make data long
dirty_long <- dirty %>%
  gather(key = "variable", value = "value", -Rescue_ID)
clean_long <- clean %>%
  gather(key = "variable", value = "value", -Rescue_ID)

# Combine into one df to compare
target <- dirty_long %>%
  left_join(clean_long, by = c("Rescue_ID", "variable"))

# Create TRUE (1) if don't match (ie. there's an error) or FALSE (0) to say no error
target <- target %>%
  mutate(error = ifelse(is.na(value.x) & is.na(value.y), 0,
                        ifelse(value.x == value.y, 0, 1))) %>%
  # Mutate again to transform NAs to 1 as means there has been a change
  mutate(error = ifelse(is.na(error), 1, error))

# Create "error matrix"
target_matrix <- target %>%
  select(-value.x, -value.y) %>%
  spread(key = variable, value = error)


print(target[80029,3])
print(target[80029,4])


print(target[80018,3])
print(target[80018,4])
