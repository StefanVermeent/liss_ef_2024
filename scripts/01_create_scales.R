# Packages ----------------------------------------------------------------
library(psych)
library(tidyverse)
library(qualtRics)
library(jsonlite)
library(here)
library(sjlabelled)


# Data --------------------------------------------------------------------
pilot_data <-
  fetch_survey(
    surveyID = "SV_0Srsyx4Vh2UajhY",
    verbose  = T,
    force_request = T,
    label = F,
    convert = F,
    add_var_labels = F
  ) %>%
  rename_with(tolower) %>%
  mutate(id = 1:n()) %>%
  sjlabelled::var_labels(
    id = "Blinded participant ID"
  ) |>
  filter(finished==1, status == 0, `duration (in seconds)` > 0) |>
  select(-session_id)


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
  mutate(across(c(matches("data_flanker_prac")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_flanker_prac) |>
  select(id, prolific_pid, time_elapsed, rt, variable, task, response, stimtype, correct) |>
  mutate(condition = ifelse(str_detect(stimtype, "^incongruent"), "incongruent", "congruent"))

flanker_data <-
  pilot_data |>
  select(id, prolific_pid, data_flanker) |>
  filter(!is.na(data_flanker)) |>
  mutate(across(c(matches("data_flanker")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_flanker) |>
  select(id, prolific_pid, rt, response, variable, task, stimtype, correct, time_elapsed) |>
  mutate(condition = ifelse(str_detect(stimtype, "^incongruent"), "incongruent", "congruent")) |>
  filter(!variable %in% c("interblock", "test_start"))

flanker_fb <-
  pilot_data |>
  select(id, prolific_pid, data_flanker_fb) |>
  filter(!is.na(data_flanker_fb)) |>
  mutate(across(c(matches("data_flanker_fb")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_flanker_fb) |>
  unnest(response) |>
  select(id, prolific_pid, user_feedback)



# Simon Task --------------------------------------------------------------

simon_prac <-
  pilot_data |>
  select(id, prolific_pid, data_simon_prac) |>
  filter(!is.na(data_simon_prac)) |>
  mutate(across(c(matches("data_simon_prac")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_simon_prac) |>
  mutate(condition = ifelse(str_detect(stimtype, "^incongruent"), "incongruent", "congruent")) |>
  select(id, prolific_pid, time_elapsed, rt, variable, task, response, condition, correct)


simon_data <-
  pilot_data |>
  select(id, prolific_pid, data_simon) |>
  filter(!is.na(data_simon)) |>
  mutate(across(c(matches("data_simon")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_simon) |>
  mutate(condition = ifelse(str_detect(stimtype, "^incongruent"), "incongruent", "congruent")) |>
  select(id, prolific_pid, time_elapsed, rt, variable, task, response, condition, correct) |>
  filter(!variable %in% c("interblock", "test_start"))

simon_fb <-
  pilot_data |>
  select(id, prolific_pid, data_simon_fb) |>
  filter(!is.na(data_simon_fb)) |>
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
  select(id, prolific_pid, time_elapsed, rt, variable, task, response, condition, correct)


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
  mutate(across(c(matches("data_colorshape_prac")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_colorshape_prac) |>
  select(id, prolific_pid, variable, task, rt, correct, rule, type, response, time_elapsed)


colorshape_data <-
  pilot_data |>
  select(id, prolific_pid, data_colorshape) |>
  filter(!is.na(data_colorshape)) |>
  mutate(across(c(matches("data_colorshape")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_colorshape) |>
  select(id, prolific_pid, variable, task, rt, correct, rule, type, response, time_elapsed) |>
  filter(!variable %in% c("interblock", "test_start"))

colorshape_fb <-
  pilot_data |>
  select(id, prolific_pid, data_colorshape_fb) |>
  filter(!is.na(data_colorshape_fb)) |>
  mutate(across(c(matches("data_colorshape_fb")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_colorshape_fb) |>
  unnest(response) |>
  select(id, prolific_pid, user_feedback)


# Animacy Size Task -------------------------------------------------------

animacysize_prac <-
  pilot_data |>
  select(id, prolific_pid, data_animacysize_prac) |>
  filter(!is.na(data_animacysize_prac)) |>
  mutate(across(c(matches("data_animacysize_prac")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_animacysize_prac) |>
  select(id, prolific_pid, variable, task, rt, correct, rule, condition, response, time_elapsed)


animacysize_data <-
  pilot_data |>
  select(id, prolific_pid, data_animacysize) |>
  filter(!is.na(data_animacysize)) |>
  mutate(across(c(matches("data_animacysize")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_animacysize) |>
  select(id, prolific_pid, variable, task, rt, correct, rule, condition, response, time_elapsed)|>
  filter(!variable %in% c("interblock", "test_start"))


animacysize_fb <-
  pilot_data |>
  select(id, prolific_pid, data_animacysize_fb) |>
  filter(!is.na(data_animacysize_fb)) |>
  mutate(across(c(matches("data_animacysize_fb")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_animacysize_fb) |>
  unnest(response) |>
  select(id, prolific_pid, user_feedback)



# Posner Task -------------------------------------------------------------

posner_prac <-
  pilot_data |>
  select(id, prolific_pid, data_posner_prac) |>
  filter(!is.na(data_posner_prac)) |>
  mutate(across(c(matches("data_posner_prac")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_posner_prac) |>
  select(id, prolific_pid, variable, task, rt, correct, condition, response, time_elapsed)


posner_data <-
  pilot_data |>
  select(id, prolific_pid, data_posner) |>
  filter(!is.na(data_posner)) |>
  mutate(across(c(matches("data_posner")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_posner) |>
  select(id, prolific_pid, variable, task, rt, correct, condition, response, time_elapsed)|>
  filter(!variable %in% c("interblock", "test_start"))

posner_fb <-
  pilot_data |>
  select(id, prolific_pid, data_posner_fb) |>
  filter(!is.na(data_posner_fb)) |>
  mutate(across(c(matches("data_posner_fb")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_posner_fb) |>
  unnest(response) |>
  select(id, prolific_pid, user_feedback)


# Task durations ----------------------------------------------------------

posner_data |>
  group_by(id) |>
  mutate(rownum = row_number()) |>
  filter(variable == "end") |>
  ungroup() |>
  select(id, variable, time_elapsed) |>
  left_join(posner_prac |> filter(variable == "welcome") |> select(id, practice_start = time_elapsed)) |>
  summarise(posner_duration = (time_elapsed - practice_start)/60/60)

globallocal_data |>
  group_by(id) |>
  mutate(rownum = row_number()) |>
  filter(rownum == 64) |>
  ungroup() |>
  select(id, variable, time_elapsed) |>
  left_join(globallocal_prac |> filter(variable == "welcome") |> select(id, practice_start = time_elapsed)) |>
  summarise(globallocal_duration = (time_elapsed - practice_start)/60/60)




save(pilot_full_data, file = "data/pilot_full_data.RData")
