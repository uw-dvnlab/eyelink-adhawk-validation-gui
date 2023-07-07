library(tidyverse)
library(ggpubr)
library(rstatix)

# Read data
tbl_data = read.csv(file = "./smooth_pursuit/gains_hsp_long.csv")
tbl_data <- subset(tbl_data, coeff>0.5)
tbl_data$slope <- abs(tbl_data$slope)

# Summary stats
tbl_sub <- tbl_data %>%
  group_by(source, subject, freq) %>%
  get_summary_stats(c(slope, gain), type = "mean")
tbl_sub

tbl_sub <- spread(tbl_sub, variable, mean)

# Summary stats
summary <- tbl_sub %>%
  group_by(source, freq) %>%
  get_summary_stats(c(slope, gain), type = "mean_sd")
summary
