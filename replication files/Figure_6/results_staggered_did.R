# install.packages("pacman")
rm(list=ls())
library(pacman)
p_load(did, dplyr)
# Data cleaning ------------------------------------------------

data <- read.csv("/Figure_6/data_boardgendereige.csv")
treat_year <- data   |>  filter(treat == 1) |> group_by(unit) |> summarise(first.treat = min(time))
data <- data |> left_join(treat_year, by = c("unit")) |> mutate(first.treat = ifelse(is.na(first.treat), 0, first.treat)) |> arrange(unit, time)

# Event-study / dynamic effects ------------------------------------------------
out <- att_gt(
  yname = "fratio",
  gname = "first.treat",
  idname = "id",
  tname = "time",
  xformla = ~1,
  data = data,
  est_method = "reg"
)
summary(out)
es <- aggte(out, type = "dynamic")

# Export results ------------------------------------------------
# Dynamic effect estimates are in es$egt, es$att.egt, es$se.egt
es_df <- data.frame(
  event_time = es$egt,
  att = es$att.egt,
  se = es$se.egt
)

# Compute 95% confidence intervals
es_df$ci_lower <- es_df$att - 1.96 * es_df$se
es_df$ci_upper <- es_df$att + 1.96 * es_df$se

# View the data frame
print(es_df)


write.csv(es_df, "/Figure_6/results_staggered_did.csv")



# Event-study / dynamic effects ------------------------------------------------
est <- did_imputation(
        data, 
        yname = "fratio", 
        gname = "first.treat", 
        tname = "time", 
        idname = "id",
        horizon = TRUE,
        pretrends = -10:-2
      )

es_df <- data.frame(
  event_time = as.numeric(est$term),
  att = as.numeric(est$estimate),
  se = as.numeric(est$std.error)
)

es_df <- es_df %>% filter(event_time <= 5 & event_time >= -5)
es_df$ci_lower <- es_df$att - 1.96 * es_df$se
es_df$ci_upper <- es_df$att + 1.96 * es_df$se

print(es_df)

write.csv(es_df, "/Figure_6/results_borusyak.csv")
