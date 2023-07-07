library(tidyverse)
library(ggpubr)
library(rstatix)

# Read data
tbl_data = read.csv(file = "./fixation_stability/fixation_stability_stats.csv")

# Summary stats
summary <- tbl_data %>%
  group_by(tracker) %>%
  get_summary_stats(c(sd_x, sd_y, bcea), type = "mean_sd")
summary
