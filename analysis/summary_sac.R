library(tidyverse)
library(ggpubr)
library(rstatix)

# Read data
tbl_data = read.csv(file = "./saccades/vms/vms_data.csv")

# Summary stats
tbl_sub <- tbl_data %>%
  group_by(tracker, subject) %>%
  get_summary_stats(c(amp, vel), type = "mean")
tbl_sub

tbl_sub <- spread(tbl_sub, variable, mean)

# Summary stats
summary <- tbl_sub %>%
  group_by(tracker) %>%
  get_summary_stats(c(amp, vel), type = "mean_sd")
summary
