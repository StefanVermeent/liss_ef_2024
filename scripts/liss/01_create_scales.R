# Packages ----------------------------------------------------------------
library(psych)
library(tidyverse)
library(qualtRics)
library(jsonlite)
library(here)
library(sjlabelled)


# Data --------------------------------------------------------------------
test_data <- read_delim("data/L_CognitiveAdversity_4.csv", delim = ";") |>
  filter(respondent == '-999')


test_data <- test_data |>
  mutate(
    data_simon = case_when(
      `volgorde[1]` == '1' ~ JSON1.4,
      `volgorde[2]` == '1' ~ JSON2.4,
      `volgorde[3]` == '1' ~ JSON3.4,
      `volgorde[4]` == '1' ~ JSON4.4,
      `volgorde[5]` == '1' ~ JSON5.4,
      `volgorde[6]` == '1' ~ JSON6.4
    ),
    data_flanker = case_when(
      `volgorde[1]` == '2' ~ JSON1.4,
      `volgorde[2]` == '2' ~ JSON2.4,
      `volgorde[3]` == '2' ~ JSON3.4,
      `volgorde[4]` == '2' ~ JSON4.4,
      `volgorde[5]` == '2' ~ JSON5.4,
      `volgorde[6]` == '2' ~ JSON6.4
    ),
    data_globallocal2 = case_when(
      `volgorde[1]` == '3' ~ JSON1.4,
      `volgorde[2]` == '3' ~ JSON2.4,
      `volgorde[3]` == '3' ~ JSON3.4,
      `volgorde[4]` == '3' ~ JSON4.4,
      `volgorde[5]` == '3' ~ JSON5.4,
      `volgorde[6]` == '3' ~ JSON6.4
    ),
    data_colorshape = case_when(
      `volgorde[1]` == '4' ~ JSON1.4,
      `volgorde[2]` == '4' ~ JSON2.4,
      `volgorde[3]` == '4' ~ JSON3.4,
      `volgorde[4]` == '4' ~ JSON4.4,
      `volgorde[5]` == '4' ~ JSON5.4,
      `volgorde[6]` == '4' ~ JSON6.4
    ),
    data_animacysize = case_when(
      `volgorde[1]` == '5' ~ JSON1.4,
      `volgorde[2]` == '5' ~ JSON2.4,
      `volgorde[3]` == '5' ~ JSON3.4,
      `volgorde[4]` == '5' ~ JSON4.4,
      `volgorde[5]` == '5' ~ JSON5.4,
      `volgorde[6]` == '5' ~ JSON6.4
    ),
    data_posner = case_when(
       `volgorde[1]` == '6' ~ JSON1.4,
       `volgorde[2]` == '6' ~ JSON2.4,
       `volgorde[3]` == '6' ~ JSON3.4,
       `volgorde[4]` == '6' ~ JSON4.4,
       `volgorde[5]` == '6' ~ JSON5.4,
       `volgorde[6]` == '6' ~ JSON6.4
    )
  ) |>
  select(respondent, starts_with('data'))

# Flanker Task ------------------------------------------------------------

flanker_data <-
  test_data |>
  select(respondent, data_flanker) |>
  filter(!is.na(data_flanker)) |>
  filter(data_flanker != "[]") |>
  mutate(across(c(matches("data_flanker")), ~str_replace_all(., "^\\\"", ""))) |>
  mutate(across(c(matches("data_flanker")), ~str_replace_all(., "\\\\", ""))) |>
  mutate(across(c(matches("data_flanker")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_flanker) |>
  select(respondent, rt, response, variable, task, stimtype, correct, time_elapsed) |>
  mutate(condition = ifelse(str_detect(stimtype, "^incongruent"), "incongruent", "congruent")) |>
  filter(!variable %in% c("interblock", "test_start"))

# Simon Task --------------------------------------------------------------

simon_data <-
  test_data |>
  select(respondent, data_simon) |>
  filter(!is.na(data_simon)) |>
  filter(data_simon != "[]") |>
  mutate(across(c(matches("data_simon")), ~str_replace_all(., "^\\\"", ""))) |>
  mutate(across(c(matches("data_simon")), ~str_replace_all(., "\\\\", ""))) |>
  mutate(across(c(matches("data_simon")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_simon) |>
  mutate(condition = ifelse(str_detect(stimtype, "^incongruent"), "incongruent", "congruent")) |>
  select(respondent, time_elapsed, rt, variable, task, response, condition, correct) |>
  filter(!variable %in% c("interblock", "test_start"))


# Color Shape Task --------------------------------------------------------

colorshape_data <-
  test_data |>
  select(respondent, data_colorshape) |>
  filter(!is.na(data_colorshape)) |>
  filter(data_colorshape != "[]") |>
  mutate(across(c(matches("data_colorshape")), ~str_replace_all(., "^\\\"", ""))) |>
  mutate(across(c(matches("data_colorshape")), ~str_replace_all(., "\\\\", ""))) |>
  mutate(across(c(matches("data_colorshape")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_colorshape) |>
  select(respondent, variable, task, rt, correct, rule, condition, response, time_elapsed) |>
  filter(!variable %in% c("interblock", "test_start"))


# Animacy Size Task -------------------------------------------------------

animacysize_data <-
  test_data |>
  select(respondent, data_animacysize) |>
  filter(!is.na(data_animacysize)) |>
  filter(data_animacysize != "[]") |>
  mutate(across(c(matches("data_animacysize")), ~str_replace_all(., "^\\\"", ""))) |>
  mutate(across(c(matches("data_animacysize")), ~str_replace_all(., "\\\\", ""))) |>
  mutate(across(c(matches("data_animacysize")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_animacysize) |>
  select(respondent, stimulus, variable, task, rt, correct, rule, condition, response, time_elapsed)|>
  filter(!variable %in% c("interblock", "test_start"))

# Posner Task -------------------------------------------------------------

posner_data <-
  test_data |>
  select(respondent, data_posner) |>
  filter(!is.na(data_posner)) |>
  filter(data_posner != "[]") |>
  mutate(across(c(matches("data_posner")), ~str_replace_all(., "^\\\"", ""))) |>
  mutate(across(c(matches("data_posner")), ~str_replace_all(., "\\\\", ""))) |>
  mutate(across(c(matches("data_posner")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_posner) |>
  select(respondent, variable, task, rt, correct, condition, response, time_elapsed)|>
  filter(!variable %in% c("interblock", "test_start"))

# Global Local2 Task --------------------------------------------------------

globallocal2_data <-
  test_data |>
  select(respondent, data_globallocal2) |>
  filter(!is.na(data_globallocal2)) |>
  filter(data_globallocal2 != "[]") |>
  mutate(across(c(matches("data_globallocal2")), ~str_replace_all(., "^\\\"", ""))) |>
  mutate(across(c(matches("data_globallocal2")), ~str_replace_all(., "\\\\", ""))) |>
  mutate(across(c(matches("data_globallocal2")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_globallocal2) |>
  select(respondent, variable, task, rt, stimulus, correct, rule, condition, congruency, response, time_elapsed) |>
  filter(!variable %in% c("interblock", "test_start", 'fixation'))


# Task durations ----------------------------------------------------------
task_durations <-
  reduce(
    list(
      posner_data |>
        group_by(id) |>
        mutate(rownum = row_number()) |>
        filter(variable == "end") |>
        ungroup() |>
        select(id, variable, time_elapsed) |>
        left_join(posner_prac |> filter(variable == "welcome") |> select(id, practice_start = time_elapsed)) |>
        mutate(
          starttime = practice_start/1000,
          endtime   = time_elapsed / 1000,
          posner_total_time = (endtime - starttime) / 60
        ) |>
        select(id, posner_total_time),

      globallocal_data |>
        group_by(id) |>
        mutate(rownum = row_number()) |>
        filter(rownum == 64) |>
        ungroup() |>
        select(id, variable, time_elapsed) |>
        left_join(globallocal_prac |> filter(variable == "welcome") |> select(id, practice_start = time_elapsed)) |>
        mutate(
          starttime = practice_start/1000,
          endtime   = time_elapsed / 1000,
          globallocal_total_time = (endtime - starttime) / 60
        ) |>
        select(id, globallocal_total_time),

      globallocal2_data |>
        group_by(id) |>
        mutate(rownum = row_number()) |>
        filter(rownum == 64) |>
        ungroup() |>
        select(id, variable, time_elapsed) |>
        left_join(globallocal2_prac |> filter(variable == "welcome") |> select(id, practice_start = time_elapsed)) |>
        mutate(
          starttime = practice_start/1000,
          endtime   = time_elapsed / 1000,
          globallocal2_total_time = (endtime - starttime) / 60
        ) |>
        select(id, globallocal2_total_time),

      colorshape_data |>
        group_by(id) |>
        filter(variable == "colorshape_finish") |>
        ungroup() |>
        select(id, variable, time_elapsed) |>
        left_join(colorshape_prac |> filter(variable == "welcome") |> select(id, practice_start = time_elapsed)) |>
        mutate(
          starttime = practice_start/1000,
          endtime   = time_elapsed / 1000,
          colorshape_total_time = (endtime - starttime) / 60
        ) |>
        select(id, colorshape_total_time),

      animacysize_data |>
        group_by(id) |>
        filter(variable == "end") |>
        ungroup() |>
        select(id, variable, time_elapsed) |>
        left_join(animacysize_prac |> filter(variable == "welcome") |> select(id, practice_start = time_elapsed)) |>
        mutate(
          starttime = practice_start/1000,
          endtime   = time_elapsed / 1000,
          animacysize_total_time = (endtime - starttime) / 60
        ) |>
        select(id, animacysize_total_time),

      flanker_data |>
        group_by(id) |>
        filter(variable == "end") |>
        ungroup() |>
        select(id, variable, time_elapsed) |>
        left_join(flanker_prac |> filter(variable == "welcome") |> select(id, practice_start = time_elapsed)) |>
        mutate(
          starttime = practice_start/1000,
          endtime   = time_elapsed / 1000,
          flanker_total_time = (endtime - starttime) / 60
        )|>
        select(id, flanker_total_time),

      simon_data |>
        group_by(id) |>
        filter(variable == "end") |>
        ungroup() |>
        select(id, variable, time_elapsed) |>
        left_join(simon_prac |> filter(variable == "welcome") |> select(id, practice_start = time_elapsed)) |>
        mutate(
          starttime = practice_start/1000,
          endtime   = time_elapsed / 1000,
          simon_total_time = (endtime - starttime) / 60
        ) |>
        select(id, simon_total_time)
    ),
    full_join, by = "id"
  ) |>
  rowwise() |>
  drop_na() |>
  mutate(
    experiment_time1 = across(c(-id, -globallocal2_total_time)) |>  rowSums(na.rm = T),
    experiment_time2 = across(c(-id, -globallocal_total_time, -experiment_time1)) |> rowSums(na.rm = T)
  )

ggplot(task_durations, aes(experiment_time1)) +
  geom_histogram()

median(task_durations$experiment_time1)
median(task_durations$experiment_time2)

quantile(task_durations$experiment_time1, probs = c(0.25, 0.50, 0.75, 0.90, 0.95))
quantile(task_durations$experiment_time2, probs = c(0.25, 0.50, 0.75, 0.90, 0.95))

# Performance -------------------------------------------------------------

globallocal_data |>
  filter(!id %in% 1:5, variable != "end", type != "first") |>
  group_by(id, type) |>
  summarise(
    mean_rt = mean(rt, na.rm = T),
    acc     = sum(correct)/n()*100
  ) |>
  pivot_longer(c(mean_rt, acc), names_to = "name", values_to = "value") |>
  ggplot(aes(value)) +
  geom_histogram() +
  facet_grid(type~name, scales = "free") +
  geom_vline(xintercept = 50)

animacysize_data |>
  filter(!id %in% 1:5, variable != "end", condition != "first") |>
  group_by(id, condition) |>
  summarise(
    mean_rt = mean(rt, na.rm = T),
    acc     = sum(correct)/n()*100
  ) |>
  pivot_longer(c(mean_rt, acc), names_to = "name", values_to = "value") |>
  ggplot(aes(value)) +
  geom_histogram() +
  facet_grid(condition~name, scales = "free") +
  geom_vline(xintercept = 50)

colorshape_data |>
  filter(!id %in% 1:5, variable != "end", type != "first") |>
  group_by(id, type) |>
  summarise(
    mean_rt = mean(rt, na.rm = T),
    acc     = sum(correct)/n()*100
  ) |>
  pivot_longer(c(mean_rt, acc), names_to = "name", values_to = "value") |>
  ggplot(aes(value)) +
  geom_histogram() +
  facet_grid(type~name, scales = "free") +
  geom_vline(xintercept = 50)


flanker_data |>
  filter(!id %in% 1:5, variable != "end") |>
  group_by(id, condition) |>
  summarise(
    mean_rt = mean(rt, na.rm = T),
    acc     = sum(correct)/n()*100
  ) |>
  pivot_longer(c(mean_rt, acc), names_to = "name", values_to = "value") |>
  ggplot(aes(value)) +
  geom_histogram() +
  facet_grid(condition~name, scales = "free") +
  geom_vline(xintercept = 50)


simon_data |>
  filter(!id %in% 1:5, variable != "end") |>
  group_by(id, condition) |>
  summarise(
    mean_rt = mean(rt, na.rm = T),
    acc     = sum(correct)/n()*100
  ) |>
  pivot_longer(c(mean_rt, acc), names_to = "name", values_to = "value") |>
  ggplot(aes(value)) +
  geom_histogram() +
  facet_grid(condition~name, scales = "free") +
  geom_vline(xintercept = 50)


posner_data |>
  filter(!id %in% 1:5, variable != "end") |>
  group_by(id) |>
  summarise(
    mean_rt = mean(rt, na.rm = T),
    acc     = sum(correct)/n()*100
  ) |>
  pivot_longer(c(mean_rt, acc), names_to = "name", values_to = "value") |>
  ggplot(aes(value)) +
  geom_histogram() +
  facet_wrap(~name, scales = "free") +
  geom_vline(xintercept = 50)


globallocal2_data |>
  filter(id != 10) |>
  filter(rt >250 & rt < 5000) |>
  filter(condition != "first", !variable %in% c("test_interblock", "end")) |>
  mutate(prev_error = ifelse(lag(correct,1) == FALSE, TRUE, FALSE)) |>
  group_by(id,congruency, condition) |>
  summarise(
    mean_rt = mean(rt, na.rm = T),
    accuracy = sum(correct)/n()*100
  ) |>
  filter(accuracy > 61) |>
  group_by(congruency, condition) |>
  summarise(
    mean_rt = mean(mean_rt, na.rm = T),
    accuracy = mean(accuracy)
  )


# Combine data ------------------------------------------------------------

save(animacysize_data, colorshape_data, flanker_data, globallocal_data, posner_data, simon_data, globallocal2_data, file = "data/pilot_data.RData")
