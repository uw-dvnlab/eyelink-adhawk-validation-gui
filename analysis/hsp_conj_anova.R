# Load libraries
library(tidyverse)
library(ggpubr)
library(rstatix)

# Read data
tbl_data = read.csv(file = "./smooth_pursuit/gain_anova_hsp.csv")
tbl_data$source <- factor(tbl_data$source , levels=c("eyelink", "adhawk", "ideal"))
tbl_data$freq <- factor(tbl_data$freq , levels=c(0.01, 0.1, 0.2))

# Summary stats
summary <- tbl_data %>%
  group_by(source, freq) %>%
  get_summary_stats(gain, type = "mean_sd")
summary

# ANOVA
res.aov <- anova_test(
  data = tbl_data, dv = gain, wid = subject,
  within = c(freq, source)
)
tbl.aov <- get_anova_table(res.aov)
tbl.aov
