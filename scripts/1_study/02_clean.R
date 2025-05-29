library(tidyverse)
library(sjlabelled)

load("data/raw_data_long.RData")
source("scripts/0_functions/functions_exclusions.R")
source("scripts/0_functions/create_codebook.R")

# Fast: < 250 ms
# very_slow: > 15s
# slow: > 3SD of intraindividual mean
# nval_trials: number of participants with fewer than 20 valid trials
# n_raw: sample size prior to exclusions
# n_clean: sample size after exclusions
exclusions <- list()

exclusions$sample$started <- (length(all_complete_ids) + length(all_incomplete_ids))
exclusions$sample$not_finish <- length(all_incomplete_ids)
exclusions$sample$finish <- length(all_complete_ids)

# 1. Preregistered exclusions ---------------------------------------------

## 1.1 Flanker task ----

flanker_clean <- flanker_raw |>
  filter(rt > 0, rt < 10) |> # Remove excessively long RTs
  group_by(nomem_encr, condition) |>
  mutate(
    ex_fast_outlier = ifelse(rt < 0.250, TRUE, FALSE),
    ex_slow_outlier = ifelse(as.numeric(scale(log(rt))) > 3, TRUE, FALSE)
  ) |>
  group_by(nomem_encr) |>
  mutate(
    ex_chance_perf  = ifelse(sum(correct==1)/n()*100 < gbinom(64, 0.50), TRUE, FALSE)
  ) |>
  ungroup()

exclusions$flanker <-
  list(
    fast      = paste(round(sum(flanker_clean$ex_fast_outlier)/nrow(flanker_clean)*100, 1), "%"),
    very_slow = paste(round(sum(flanker_raw$rt > 10)/nrow(flanker_raw)*100, 2), "%"),
    slow      = paste(round(sum(flanker_clean$ex_slow_outlier, na.rm = T)/nrow(flanker_clean)*100, 1), "%"),
    chance    = flanker_clean |> group_by(nomem_encr) |> summarise(n = sum(ex_chance_perf)) |> filter(n > 1) |> nrow(),
    raw_n     = unique(flanker_clean$nomem_encr) |> length()
  )

flanker_clean <- flanker_clean |>
  filter(ex_slow_outlier == FALSE, ex_fast_outlier == FALSE, ex_chance_perf == FALSE) |>
  group_by(nomem_encr) |>
  mutate(valid_trials = n()) |>
  ungroup() |>
  select(-starts_with("ex"))

exclusions$flanker$n_val_trials <- flanker_clean |> filter(valid_trials < 20) |> pull(nomem_encr) |> unique() |> length()

flanker_clean <- flanker_clean |>
  filter(valid_trials > 19) |>
  sjlabelled::var_labels(
    nomem_encr   = "LISS unique participant identifier",
    rt           = "Response time in seconds",
    task         = "Task identifier",
    condition    = "Task condition",
    correct      = "Whether or not the response was correct",
    valid_trials = "Number of valid trials after exclusions"
  ) |>
  sjlabelled::val_labels(
    condition = c("congruent" = 1, "incongruent" = 2),
    correct   = c("correct" = 1, "incorrect" = 0)
  )

## 1.2 Simon task ----

simon_clean <- simon_raw |>
  filter(rt > 0, rt < 10) |> # Remove excessively long RTs
  group_by(nomem_encr, condition) |>
  mutate(
    ex_fast_outlier = ifelse(rt < 0.250, TRUE, FALSE),
    ex_slow_outlier = ifelse(as.numeric(scale(log(rt))) > 3, TRUE, FALSE)
  ) |>
  group_by(nomem_encr) |>
  mutate(
    ex_chance_perf  = ifelse(sum(correct==1)/n()*100 < gbinom(64, 0.50), TRUE, FALSE)
  ) |>
  ungroup()

exclusions$simon <-
  list(
    fast   = paste(round(sum(simon_clean$ex_fast_outlier)/nrow(simon_clean)*100, 1), "%"),
    very_slow = paste(round(sum(simon_raw$rt > 10)/nrow(simon_raw)*100, 2), "%"),
    slow   = paste(round(sum(simon_clean$ex_slow_outlier, na.rm = T)/nrow(simon_clean)*100, 1), "%"),
    chance = simon_clean |> group_by(nomem_encr) |> summarise(n = sum(ex_chance_perf)) |> filter(n > 1) |> nrow(),
    raw_n   = unique(simon_clean$nomem_encr) |> length()
  )

simon_clean <- simon_clean |>
  filter(ex_slow_outlier == FALSE, ex_fast_outlier == FALSE, ex_chance_perf == FALSE) |>
  group_by(nomem_encr) |>
  mutate(valid_trials = n()) |>
  ungroup() |>
  select(-starts_with("ex"))

exclusions$simon$n_val_trials <- simon_clean |> filter(valid_trials < 20) |> pull(nomem_encr) |> unique() |> length()

simon_clean <- simon_clean |>
  filter(valid_trials > 19) |>
  sjlabelled::var_labels(
    nomem_encr   = "LISS unique participant identifier",
    rt           = "Response time in seconds",
    task         = "Task identifier",
    condition    = "Task condition",
    correct      = "Whether or not the response was correct",
    valid_trials = "Number of valid trials after exclusions"
  ) |>
  sjlabelled::val_labels(
    condition = c("congruent" = 1, "incongruent" = 2),
    correct   = c("correct" = 1, "incorrect" = 0)
  )

## 1.3 Color-shape task ----

colorshape_clean <- colorshape_raw |>
  filter(rt < 10, rt > 0) |> # Remove excessively long RTs
  group_by(nomem_encr, condition) |>
  mutate(
    ex_fast_outlier = ifelse(rt < 0.250, TRUE, FALSE),
    ex_slow_outlier = ifelse(as.numeric(scale(log(rt))) > 3, TRUE, FALSE)
  ) |>
  group_by(nomem_encr) |>
  mutate(
    ex_chance_perf  = ifelse(sum(correct==1)/n()*100 < gbinom(64, 0.50), TRUE, FALSE)
  ) |>
  ungroup()

exclusions$colorshape <-
  list(
    fast   = paste(round(sum(colorshape_clean$ex_fast_outlier)/nrow(colorshape_clean)*100, 1), "%"),
    very_slow = paste(round(sum(colorshape_raw$rt > 10)/nrow(colorshape_raw)*100, 2), "%"),
    slow   = paste(round(sum(colorshape_clean$ex_slow_outlier, na.rm = T)/nrow(colorshape_clean)*100, 1), "%"),
    chance = colorshape_clean |> group_by(nomem_encr) |> summarise(n = sum(ex_chance_perf)) |> filter(n > 1) |> nrow(),
    raw_n   = unique(colorshape_clean$nomem_encr) |> length()
  )

colorshape_clean <- colorshape_clean |>
  filter(ex_slow_outlier == FALSE, ex_fast_outlier == FALSE, ex_chance_perf == FALSE) |>
  group_by(nomem_encr) |>
  mutate(valid_trials = n()) |>
  ungroup() |>
  select(-starts_with("ex"))

exclusions$colorshape$n_val_trials <- colorshape_clean |> filter(valid_trials < 20) |> pull(nomem_encr) |> unique() |> length()

colorshape_clean <- colorshape_clean |>
  filter(valid_trials > 19) |>
  sjlabelled::var_labels(
    nomem_encr   = "LISS unique participant identifier",
    rt           = "Response time in seconds",
    task         = "Task identifier",
    condition    = "Task condition",
    rule         = "Category that has to be used for classification",
    correct      = "Whether or not the response was correct",
    valid_trials = "Number of valid trials after exclusions"
  ) |>
  sjlabelled::val_labels(
    condition = c("repeat" = 1, "switch" = 2),
    correct   = c("correct" = 1, "incorrect" = 0)
  )

## 1.4. Animacy-size task ----

animacysize_clean <- animacysize_raw |>
  filter(rt > 0, rt < 10) |> # Remove excessively long RTs
  group_by(nomem_encr, condition) |>
  mutate(
    ex_fast_outlier = ifelse(rt < 0.250, TRUE, FALSE),
    ex_slow_outlier = ifelse(as.numeric(scale(log(rt))) > 3, TRUE, FALSE)
  ) |>
  group_by(nomem_encr) |>
  mutate(
    ex_chance_perf  = ifelse(sum(correct==1)/n()*100 < gbinom(64, 0.50), TRUE, FALSE)
  ) |>
  ungroup()

exclusions$animacysize <-
  list(
    fast   = paste(round(sum(animacysize_clean$ex_fast_outlier)/nrow(animacysize_clean)*100, 1), "%"),
    very_slow = paste(round(sum(animacysize_raw$rt > 10)/nrow(animacysize_raw)*100, 2), "%"),
    slow   = paste(round(sum(animacysize_clean$ex_slow_outlier, na.rm = T)/nrow(animacysize_clean)*100, 1), "%"),
    chance = animacysize_clean |> group_by(nomem_encr) |> summarise(n = sum(ex_chance_perf)) |> filter(n > 1) |> nrow(),
    raw_n   = unique(animacysize_clean$nomem_encr) |> length()
  )

animacysize_clean <- animacysize_clean |>
  filter(ex_slow_outlier == FALSE, ex_fast_outlier == FALSE, ex_chance_perf == FALSE) |>
  group_by(nomem_encr) |>
  mutate(valid_trials = n()) |>
  ungroup() |>
  select(-starts_with("ex"))

exclusions$animacysize$n_val_trials <- animacysize_clean |> filter(valid_trials < 20) |> pull(nomem_encr) |> unique() |> length()

animacysize_clean <- animacysize_clean |>
  filter(valid_trials > 19) |>
  sjlabelled::var_labels(
    nomem_encr   = "LISS unique participant identifier",
    rt           = "Response time in seconds",
    task         = "Task identifier",
    condition    = "Task condition",
    rule         = "Category that has to be used for classification",
    correct      = "Whether or not the response was correct",
    valid_trials = "Number of valid trials after exclusions"
  ) |>
  sjlabelled::val_labels(
    condition = c("repeat" = 1, "switch" = 2),
    correct   = c("correct" = 1, "incorrect" = 0)
  )


## 1.5. Global-local task ----

globallocal_clean <- globallocal2_raw |>
  filter(rt > 0, rt < 10) |> # Remove excessively long RTs
  group_by(nomem_encr, condition) |>
  mutate(
    ex_fast_outlier = ifelse(rt < 0.250, TRUE, FALSE),
    ex_slow_outlier = ifelse(as.numeric(scale(log(rt))) > 3, TRUE, FALSE)
  ) |>
  group_by(nomem_encr) |>
  mutate(
    ex_chance_perf  = ifelse(sum(correct==1)/n()*100 < gbinom(64, 0.50), TRUE, FALSE)
  ) |>
  ungroup()

exclusions$globallocal <-
  list(
    fast   = paste(round(sum(globallocal_clean$ex_fast_outlier)/nrow(globallocal_clean)*100, 1), "%"),
    very_slow = paste(round(sum(globallocal2_raw$rt > 10)/nrow(globallocal2_raw)*100, 2), "%"),
    slow   = paste(round(sum(globallocal_clean$ex_slow_outlier, na.rm = T)/nrow(globallocal_clean)*100, 1), "%"),
    chance = globallocal_clean |> group_by(nomem_encr) |> summarise(n = sum(ex_chance_perf)) |> filter(n > 1) |> nrow(),
    raw_n   = unique(globallocal_clean$nomem_encr) |> length()
  )

globallocal_clean <- globallocal_clean |>
  filter(ex_slow_outlier == FALSE, ex_fast_outlier == FALSE, ex_chance_perf == FALSE) |>
  group_by(nomem_encr) |>
  mutate(valid_trials = n()) |>
  ungroup() |>
  select(-starts_with("ex"))

exclusions$globallocal$n_val_trials <- globallocal_clean |> filter(valid_trials < 20) |> pull(nomem_encr) |> unique() |> length()

globallocal_clean <- globallocal_clean |>
  filter(valid_trials > 19) |>
  sjlabelled::var_labels(
    nomem_encr   = "LISS unique participant identifier",
    rt           = "Response time in seconds",
    task         = "Task identifier",
    condition    = "Task condition",
    rule         = "Category that has to be used for classification",
    correct      = "Whether or not the response was correct",
    valid_trials = "Number of valid trials after exclusions"
  ) |>
  sjlabelled::val_labels(
    condition = c("repeat" = 1, "switch" = 2),
    correct   = c("correct" = 1, "incorrect" = 0)
  )

## 1.6. Posner Task ----

posner_clean <- posner_raw |>
  filter(rt < 10) |> # Remove excessively long RTs
  group_by(nomem_encr) |>
  mutate(
    ex_fast_outlier = ifelse(rt < 0.250, TRUE, FALSE),
    ex_slow_outlier = ifelse(as.numeric(scale(log(rt))) > 3, TRUE, FALSE)
  ) |>
  group_by(nomem_encr) |>
  mutate(
    ex_chance_perf  = ifelse(sum(correct==1)/n()*100 < gbinom(64, 0.50), TRUE, FALSE)
  ) |>
  ungroup()

exclusions$posner <-
  list(
    fast   = paste(round(sum(posner_clean$ex_fast_outlier)/nrow(posner_clean)*100, 1), "%"),
    very_slow = paste(round(sum(posner_raw$rt > 10)/nrow(posner_raw)*100, 2), "%"),
    slow   = paste(round(sum(posner_clean$ex_slow_outlier, na.rm = T)/nrow(posner_clean)*100, 1), "%"),
    chance = posner_clean |> group_by(nomem_encr) |> summarise(n = sum(ex_chance_perf)) |> filter(n > 1) |> nrow(),
    raw_n   = unique(posner_clean$nomem_encr) |> length()
  )

posner_clean <- posner_clean |>
  filter(ex_slow_outlier == FALSE, ex_fast_outlier == FALSE, ex_chance_perf == FALSE) |>
  group_by(nomem_encr) |>
  mutate(valid_trials = n()) |>
  ungroup() |>
  select(-starts_with("ex"))

exclusions$posner$n_val_trials <- posner_clean |> filter(valid_trials < 20) |> pull(nomem_encr) |> unique() |> length()

posner_clean <- posner_clean |>
  filter(valid_trials > 19) |>
  sjlabelled::var_labels(
    nomem_encr   = "LISS unique participant identifier",
    rt           = "Response time in seconds",
    task         = "Task identifier",
    correct      = "Whether or not the response was correct",
    valid_trials = "Number of valid trials after exclusions"
  ) |>
  sjlabelled::val_labels(
    correct   = c("correct" = 1, "incorrect" = 0)
  )


# 2. Store cleaned sample sizes -------------------------------------------

exclusions$flanker$clean_n = unique(flanker_clean$nomem_encr) |> length()
exclusions$simon$clean_n = unique(simon_clean$nomem_encr) |> length()
exclusions$colorshape$clean_n = unique(colorshape_clean$nomem_encr) |> length()
exclusions$animacysize$clean_n = unique(animacysize_clean$nomem_encr) |> length()
exclusions$globallocal$clean_n = unique(globallocal_clean$nomem_encr) |> length()
exclusions$posner$clean_n = unique(posner_clean$nomem_encr) |> length()

all_included_ids <- reduce(
  list(
    animacysize_clean |>
      select(nomem_encr, task) |> distinct(),
    globallocal_clean |>
      select(nomem_encr, task) |> distinct(),
    colorshape_clean |>
      select(nomem_encr, task) |> distinct(),
    flanker_clean |>
      select(nomem_encr, task) |> distinct(),
    simon_clean |>
      select(nomem_encr, task) |> distinct(),
    posner_clean |>
      select(nomem_encr, task) |> distinct()
  ),
  full_join, by = "nomem_encr"
) |>
  pull(nomem_encr) |>
  as.numeric()

all_included_ids_n <- all_included_ids |>
  length()

exclusions$sample$ids <- all_included_ids
exclusions$sample$final <- all_included_ids_n


# 3. Calculate raw performance measures -----------------------------------

flanker_clean_mean <- flanker_clean |>
  group_by(nomem_encr, condition) |>
  summarize(
    flanker_rt = mean(rt, na.rm = T),
    flanker_ac = sum(correct)/n() * 100
    ) |>
  mutate(condition = ifelse(condition == 1, "con", "inc")) |>
  pivot_wider(names_from = "condition", values_from = c("flanker_rt", "flanker_ac"))

simon_clean_mean <- simon_clean |>
  group_by(nomem_encr, condition) |>
  summarize(
    simon_rt = mean(rt, na.rm = T),
    simon_ac = sum(correct)/n() * 100
  ) |>
  mutate(condition = ifelse(condition == 1, "con", "inc")) |>
  pivot_wider(names_from = "condition", values_from = c("simon_rt", "simon_ac"))

colorshape_clean_mean <- colorshape_clean |>
  group_by(nomem_encr, condition) |>
  summarize(
    colorshape_rt = mean(rt, na.rm = T),
    colorshape_ac = sum(correct)/n() * 100
  ) |>
  mutate(condition = ifelse(condition == 1, "rep", "sw")) |>
  pivot_wider(names_from = "condition", values_from = c("colorshape_rt", "colorshape_ac"))

globallocal_clean_mean <- globallocal_clean |>
  group_by(nomem_encr, condition) |>
  summarize(
    globallocal_rt = mean(rt, na.rm = T),
    globallocal_ac = sum(correct)/n() * 100
  ) |>
  mutate(condition = ifelse(condition == 1, "rep", "sw")) |>
  pivot_wider(names_from = "condition", values_from = c("globallocal_rt", "globallocal_ac"))

animacysize_clean_mean <- animacysize_clean |>
  group_by(nomem_encr, condition) |>
  summarize(
    animacysize_rt = mean(rt, na.rm = T),
    animacysize_ac = sum(correct)/n() * 100
  ) |>
  mutate(condition = ifelse(condition == 1, "rep", "sw")) |>
  pivot_wider(names_from = "condition", values_from = c("animacysize_rt", "animacysize_ac"))

posner_clean_mean <- posner_clean |>
  group_by(nomem_encr) |>
  summarize(
    pos_rt = mean(rt, na.rm = T),
    pos_ac = sum(correct)/n() * 100)

clean_data_mean <- reduce(
  list(flanker_clean_mean, simon_clean_mean, colorshape_clean_mean, globallocal_clean_mean, animacysize_clean_mean, posner_clean_mean),
  full_join, by = "nomem_encr"
) |>
  ungroup()




# 4. Create codebooks -----------------------------------------------------

flanker_codebook <- create_codebook(flanker_clean)
simon_codebook <- create_codebook(simon_clean)
colorshape_codebook <- create_codebook(colorshape_clean)
animacysize_codebook <- create_codebook(animacysize_clean)
globallocal_codebook <- create_codebook(globallocal_clean)
posner_codebook <- create_codebook(posner_clean)

# 5. Save cleaned data ----------------------------------------------------

save(flanker_clean, simon_clean, colorshape_clean, globallocal_clean, animacysize_clean, posner_clean, file = "data/clean_data_long.RData")
save(clean_data_mean, file = "data/clean_data_mean.RData")
save(exclusions, file = "data/exclusions.RData")

openxlsx::write.xlsx(flanker_codebook, "codebooks/flanker_clean_codebook.xlsx")
openxlsx::write.xlsx(simon_codebook, "codebooks/simon_clean_codebook.xlsx")
openxlsx::write.xlsx(colorshape_codebook, "codebooks/colorshape_clean_codebook.xlsx")
openxlsx::write.xlsx(animacysize_codebook, "codebooks/animacysize_clean_codebook.xlsx")
openxlsx::write.xlsx(globallocal_codebook, "codebooks/globallocal_clean_codebook.xlsx")
openxlsx::write.xlsx(posner_codebook, "codebooks/posner_clean_codebook.xlsx")
