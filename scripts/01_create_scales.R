# Packages ----------------------------------------------------------------
library(psych)
library(tidyverse)
library(qualtRics)
library(jsonlite)
library(here)
library(sjlabelled)


# Data --------------------------------------------------------------------
pilot1_data <-
  fetch_survey(
    surveyID = "SV_0Srsyx4Vh2UajhY",
    verbose  = T,
    force_request = T,
    label = F,
    convert = F,
    add_var_labels = F
  ) %>%
  rename_with(tolower) %>%
  filter(finished==1, status == 0, `duration (in seconds)` > 0) |>
  select(prolific_pid, starts_with("data"))

pilot2_data <-
  fetch_survey(
    surveyID = "SV_5tp0I8hsA2YGMyG",
    verbose  = T,
    force_request = T,
    label = F,
    convert = F,
    add_var_labels = F
  ) %>%
  rename_with(tolower) %>%
  filter(finished==1, status == 0, `duration (in seconds)` > 0) |>
  select(-session_id) |>
  select(prolific_pid, starts_with("data"))

pilot3_data <-
  fetch_survey(
    surveyID = "SV_3kot0l1n43R9DU2",
    verbose  = T,
    force_request = T,
    label = F,
    convert = F,
    add_var_labels = F
  ) %>%
  rename_with(tolower) %>%
  filter(finished==1, status == 0, `duration (in seconds)` > 0) |>
  select(-session_id) |>
  select(prolific_pid, starts_with("data"))

pilot_data <- left_join(pilot1_data, pilot2_data) |>
  bind_rows(pilot3_data |> select(starts_with('data'))) |>
  mutate(id = 1:n())



# Self-report -------------------------------------------------------------


## Demographics ----

vars01_dems <-
  pilot_data %>%
  select(prolific_pid, matches("^dems_"))



## Admin ----

vars02_admin <-
  pilot_data %>%
  select(ends_with("id"))



# Flanker Task ------------------------------------------------------------

flanker_prac <-
  pilot_data |>
  select(id, prolific_pid, data_flanker_prac) |>
  filter(!is.na(data_flanker_prac)) |>
  filter(data_flanker_prac != "[]") |>
  mutate(across(c(matches("data_flanker_prac")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_flanker_prac) |>
  select(id, prolific_pid, time_elapsed, rt, variable, task, response, stimtype, correct) |>
  mutate(condition = ifelse(str_detect(stimtype, "^incongruent"), "incongruent", "congruent"))

flanker_data <-
  pilot_data |>
  select(id, prolific_pid, data_flanker) |>
  filter(!is.na(data_flanker)) |>
  filter(data_flanker != "[]") |>
  mutate(across(c(matches("data_flanker")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_flanker) |>
  select(id, prolific_pid, rt, response, variable, task, stimtype, correct, time_elapsed) |>
  mutate(condition = ifelse(str_detect(stimtype, "^incongruent"), "incongruent", "congruent")) |>
  filter(!variable %in% c("interblock", "test_start"))

flanker_fb <-
  pilot_data |>
  select(id, prolific_pid, data_flanker_fb) |>
  filter(!is.na(data_flanker_fb)) |>
  filter(data_flanker_fb != "[]") |>
  mutate(across(c(matches("data_flanker_fb")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_flanker_fb) |>
  unnest(response) |>
  select(id, prolific_pid, user_feedback)



# Simon Task --------------------------------------------------------------

simon_prac <-
  pilot_data |>
  select(id, prolific_pid, data_simon_prac) |>
  filter(!is.na(data_simon_prac)) |>
  filter(data_simon_prac != "[]") |>
  mutate(across(c(matches("data_simon_prac")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_simon_prac) |>
  mutate(condition = ifelse(str_detect(stimtype, "^incongruent"), "incongruent", "congruent")) |>
  select(id, prolific_pid, time_elapsed, rt, variable, task, response, condition, correct)


simon_data <-
  pilot_data |>
  select(id, prolific_pid, data_simon) |>
  filter(!is.na(data_simon)) |>
  filter(data_simon != "[]") |>
  mutate(across(c(matches("data_simon")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_simon) |>
  mutate(condition = ifelse(str_detect(stimtype, "^incongruent"), "incongruent", "congruent")) |>
  select(id, prolific_pid, time_elapsed, rt, variable, task, response, condition, correct) |>
  filter(!variable %in% c("interblock", "test_start"))

simon_fb <-
  pilot_data |>
  select(id, prolific_pid, data_simon_fb) |>
  filter(!is.na(data_simon_fb)) |>
  filter(data_simon_fb != "[]") |>
  mutate(across(c(matches("data_simon_fb")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_simon_fb) |>
  unnest(response) |>
  select(id, prolific_pid, user_feedback)

# Global Local Task -------------------------------------------------------

globallocal_prac <-
  pilot_data |>
  select(id, prolific_pid, data_globallocal_prac) |>
  filter(!is.na(data_globallocal_prac)) |>
  mutate(across(c(matches("data_globallocal_prac")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_globallocal_prac) |>
  select(id, prolific_pid, time_elapsed, rt, variable, task, response, correct)


globallocal_data <-
  pilot_data |>
  select(id, prolific_pid, data_globallocal) |>
  filter(!is.na(data_globallocal)) |>
  mutate(across(c(matches("data_globallocal")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_globallocal) |>
  select(id, prolific_pid, time_elapsed, rt, variable, task, rule, type, response, correct) |>
  filter(!variable %in% c("interblock", "test_interblock", "test_start"))

globallocal_fb <-
  pilot_data |>
  select(id, prolific_pid, data_globallocal_fb) |>
  filter(!is.na(data_globallocal_fb)) |>
  mutate(across(c(matches("data_globallocal_fb")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_globallocal_fb) |>
  unnest(response) |>
  select(id, prolific_pid, user_feedback)


# Color Shape Task --------------------------------------------------------

colorshape_prac <-
  pilot_data |>
  select(id, prolific_pid, data_colorshape_prac) |>
  filter(!is.na(data_colorshape_prac)) |>
  filter(data_colorshape_prac != "[]") |>
  mutate(across(c(matches("data_colorshape_prac")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_colorshape_prac) |>
  select(id, prolific_pid, variable, task, rt, correct, rule, type, response, time_elapsed)


colorshape_data <-
  pilot_data |>
  select(id, prolific_pid, data_colorshape) |>
  filter(!is.na(data_colorshape)) |>
  filter(data_colorshape != "[]") |>
  mutate(across(c(matches("data_colorshape")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_colorshape) |>
  select(id, prolific_pid, variable, task, rt, correct, rule, type, response, time_elapsed) |>
  filter(!variable %in% c("interblock", "test_start"))

colorshape_fb <-
  pilot_data |>
  select(id, prolific_pid, data_colorshape_fb) |>
  filter(!is.na(data_colorshape_fb)) |>
  filter(data_colorshape_fb != "[]") |>
  mutate(across(c(matches("data_colorshape_fb")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_colorshape_fb) |>
  unnest(response) |>
  select(id, prolific_pid, user_feedback)


# Animacy Size Task -------------------------------------------------------

animacysize_prac <-
  pilot_data |>
  select(id, prolific_pid, data_animacysize_prac) |>
  filter(!is.na(data_animacysize_prac)) |>
  filter(data_animacysize_prac != "[]") |>
  mutate(across(c(matches("data_animacysize_prac")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_animacysize_prac) |>
  select(id, prolific_pid, variable, task, rt, correct, rule, condition, response, time_elapsed)


animacysize_data <-
  pilot_data |>
  select(id, prolific_pid, data_animacysize) |>
  filter(!is.na(data_animacysize)) |>
  filter(data_animacysize != "[]") |>
  mutate(across(c(matches("data_animacysize")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_animacysize) |>
  select(id, prolific_pid, variable, task, rt, correct, rule, condition, response, time_elapsed)|>
  filter(!variable %in% c("interblock", "test_start"))


animacysize_fb <-
  pilot_data |>
  select(id, prolific_pid, data_animacysize_fb) |>
  filter(!is.na(data_animacysize_fb)) |>
  filter(data_animacysize_fb != "[]") |>
  mutate(across(c(matches("data_animacysize_fb")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_animacysize_fb) |>
  unnest(response) |>
  select(id, prolific_pid, user_feedback)



# Posner Task -------------------------------------------------------------

posner_prac <-
  pilot_data |>
  select(id, prolific_pid, data_posner_prac) |>
  filter(!is.na(data_posner_prac)) |>
  filter(data_posner_prac != "[]") |>
  mutate(across(c(matches("data_posner_prac")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_posner_prac) |>
  select(id, prolific_pid, variable, task, rt, correct, condition, response, time_elapsed)


posner_data <-
  pilot_data |>
  select(id, prolific_pid, data_posner) |>
  filter(!is.na(data_posner)) |>
  filter(data_posner != "[]") |>
  mutate(across(c(matches("data_posner")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_posner) |>
  select(id, prolific_pid, variable, task, rt, correct, condition, response, time_elapsed)|>
  filter(!variable %in% c("interblock", "test_start"))

posner_fb <-
  pilot_data |>
  select(id, prolific_pid, data_posner_fb) |>
  filter(!is.na(data_posner_fb)) |>
  filter(data_posner_fb != "[]") |>
  mutate(across(c(matches("data_posner_fb")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_posner_fb) |>
  unnest(response) |>
  select(id, prolific_pid, user_feedback)


# Global Local2 Task --------------------------------------------------------

globallocal2_prac <-
  pilot_data |>
  select(id, prolific_pid, data_globallocal2_prac) |>
  filter(!is.na(data_globallocal2_prac)) |>
  filter(data_globallocal2_prac != "[]") |>
  mutate(across(c(matches("data_globallocal2_prac")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_globallocal2_prac) |>
  select(id, prolific_pid, variable, task, rt, correct, rule, type, response, time_elapsed)


globallocal2_data <-
  pilot_data |>
  select(id, prolific_pid, data_globallocal2) |>
  filter(!is.na(data_globallocal2)) |>
  filter(data_globallocal2 != "[]") |>
  mutate(across(c(matches("data_globallocal2")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_globallocal2) |>
  select(id, prolific_pid, variable, task, rt, stimulus, correct, rule, condition, congruency, response, time_elapsed) |>
  filter(!variable %in% c("interblock", "test_start", 'fixation'))

globallocal2_fb <-
  pilot_data |>
  select(id, prolific_pid, data_globallocal2_fb) |>
  filter(!is.na(data_globallocal2_fb)) |>
  filter(data_globallocal2_fb != "[]") |>
  mutate(across(c(matches("data_globallocal2_fb")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_globallocal2_fb) |>
  unnest(response) |>
  select(id, prolific_pid, user_feedback)



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
