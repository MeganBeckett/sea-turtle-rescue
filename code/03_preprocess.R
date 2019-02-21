# ==================================================================================================
#                                  Exploratory data analysis                                       #
#                                       Megan Beckett                                              #
# ==================================================================================================

# LIBRARIES ----------------------------------------------------------------------------------------
library(dplyr)
library(tidyr)
library(here)

# READ DATA ----------------------------------------------------------------------------------------
source(here::here("code/00_data.R"))

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
# Not sure yet if this is the right approach
target_matrix <- target %>%
  select(-value.x, -value.y) %>%
  spread(key = variable, value = error)

# Why are so many of text inputs different?
# Often seems to be if there's a double space
print(target[80029,3])
print(target[80029,4])


print(target[80018,3])
print(target[80018,4])
