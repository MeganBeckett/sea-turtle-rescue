# ==================================================================================================
#                                  Exploratory data analysis                                       #
#                                       Megan Beckett                                              #
# ==================================================================================================

# LIBRARIES ----------------------------------------------------------------------------------------
library(dplyr)
library(ggplot2)
library(tidyr)
# library(DT)
library(here)
library(arsenal)
library(zoo)
library(tm)
library(SnowballC)
library(wordcloud)

# READ DATA ----------------------------------------------------------------------------------------
source(here::here("code/00_data.R"))

# INITIAL VIEW -------------------------------------------------------------------------------------
summary(dirty)
summary(clean)

glimpse(dirty)

# quick look at some differences
unique(dirty$Status)
unique(clean$Status)

unique(dirty$ForagingGround)
unique(clean$ForagingGround)

unique(dirty$ReleaseSite)
unique(clean$ReleaseSite)

# EDA ----------------------------------------------------------------------------------------------
# How many turtles caught per month?
catch_count <- clean %>%
  group_by(Date_Caught) %>%
  summarise(turtles_per_day = n()) %>%
  complete(Date_Caught = seq.Date(min(Date_Caught),max(Date_Caught), by = "day")) %>%
  mutate(year_mon = as.yearmon(Date_Caught, "%b-%Y")) %>%
  group_by(year_mon) %>%
  summarise(turtles_caught = sum(turtles_per_day, na.rm = TRUE))

ggplot(catch_count, aes(x= year_mon, y = turtles_caught)) +
  geom_line() +
  scale_x_yearmon() +
  labs(title = "Turtles caught per month", x = "", y = "Number")

# Split across different species?
species_count <- clean %>%
  group_by(Species) %>%
  summarise(species_count = n())

# Distribution of Central Carapace measurements - and dirty vs clean
# Potential for outliers in numerical values?
ggplot(clean, aes(CCL_cm)) +
  geom_histogram() +
  labs(title = "Distribution of Central Carapace Length - CLEAN data")

ggplot(dirty, aes(CCL_cm)) +
  geom_histogram() +
  labs(title = "Distribution of Central Carapace Length - DIRTY data")

ggplot(clean, aes(CCW_cm)) +
  geom_histogram() +
  labs(title = "Distribution of Central Carapace Width - CLEAN data")

ggplot(dirty, aes(CCW_cm)) +
  geom_histogram() +
  labs(title = "Distribution of Central Carapace Width - DIRTY data")

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
