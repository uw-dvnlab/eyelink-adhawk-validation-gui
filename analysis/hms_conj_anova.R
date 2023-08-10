library(tidyverse)
library(ggpubr)
library(rstatix)

# Read data
tbl_data = read.csv(file = "./saccades/hms/hms_anova_data.csv")
tbl_data$tracker = factor(tbl_data$tracker)

# Summary stats
summary <- tbl_data %>%
  group_by(tracker) %>%
  get_summary_stats(diff, type = "mean_sd")
summary

# Visualize summary
bxp <- ggboxplot(
  tbl_data, x = "tracker", y = "diff",
  palette = "jco"
)
bxp

stat.test <- tbl_data %>%
  filter(tracker=="Ideal") %>%
  t_test(diff ~ 1, mu = 0)
stat.test

# simple main effect (task)
# Effect of task at each probe location
one.way <- tbl_data %>%
  anova_test(dv = diff, wid = subject, within = tracker) %>%
  get_anova_table() %>%
  adjust_pvalue(method = "bonferroni")
one.way

# Pairwise comparisons between group levels
pwc <- tbl_data %>%
  pairwise_t_test(diff ~ tracker, p.adjust.method = "bonferroni")
pwc
