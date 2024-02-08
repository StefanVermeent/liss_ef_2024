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




# Binding-Updating Color --------------------------------------------------



bind_upd_color_practice <-
  pilot_data |>
  select(id, prolific_pid, data_bind_upd_color_practice) |>
  filter(!is.na(data_bind_upd_color_practice)) |>
  mutate(across(c(matches("data_bind_upd_color_practice")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  mutate(data_bind_upd_color_practice = pmap(list(data_bind_upd_color_practice), function(data_bind_upd_color_practice) {
    data_bind_upd_color_practice |> mutate(recall = as.character(recall))})) |>
  unnest(data_bind_upd_color_practice) |>
  select(id, prolific_pid, rt, stimulus, step_type, variable, nBind, nUpd, task, counterbalance, position, recall, stimuli, accuracy, time_elapsed) |>
  filter(variable == "recall") |>
  mutate(version = ifelse(nUpd == 0, "binding", "updating"))

bind_upd_color_data <-
  pilot_data |>
  select(id, prolific_pid, data_bind_upd_color01, data_bind_upd_color02, data_bind_upd_color03) |>
  filter(!is.na(data_bind_upd_color01), !is.na(data_bind_upd_color02), !is.na(data_bind_upd_color03)) |>
  mutate(across(c(matches("data_bind_upd_color(01|02|03)")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  mutate(data_bind_upd_color = pmap(list(data_bind_upd_color01, data_bind_upd_color02, data_bind_upd_color03), function(data_bind_upd_color01, data_bind_upd_color02, data_bind_upd_color03) {
    bind_rows(data_bind_upd_color01 |> mutate(recall = as.character(recall)), data_bind_upd_color02 |> mutate(recall = as.character(recall)), data_bind_upd_color03 |> mutate(recall = as.character(recall)))})) |>
  unnest(data_bind_upd_color) |>
  select(id, prolific_pid, rt, stimulus, step_type, variable, nBind, nUpd, task, counterbalance, position, recall, stimuli, accuracy, time_elapsed) |>
  mutate(version = ifelse(nUpd == 0, "binding", "updating"))

bind_upd_color_clean <- bind_upd_color_data |>
  filter(variable == "recall") |>
  mutate(task = str_replace_all(task, "_test\\d\\d", "")) |>
  group_by(prolific_pid, version, task) |>
  summarise(color_acc = sum(accuracy)/n()) |>
  ungroup()

# Binding-Updating Number -------------------------------------------------

bind_upd_number_practice <-
  pilot_data |>
  select(id, prolific_pid, data_bind_upd_number_practice) |>
  filter(!is.na(data_bind_upd_number_practice)) |>
  mutate(across(c(matches("data_bind_upd_number_practice")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  mutate(data_bind_upd_number_practice = pmap(list(data_bind_upd_number_practice), function(data_bind_upd_number_practice) {
    data_bind_upd_number_practice |> mutate(recall = as.character(recall))})) |>
  unnest(data_bind_upd_number_practice) |>
  select(id, prolific_pid, rt, stimulus, step_type, variable, nBind, nUpd, task, counterbalance, position, recall, stimuli, accuracy, time_elapsed) |>
  mutate(version = ifelse(nUpd == 0, "binding", "updating"))

bind_upd_number_data <-
  pilot_data |>
  select(id, prolific_pid, data_bind_upd_number01, data_bind_upd_number02, data_bind_upd_number03) |>
  filter(!is.na(data_bind_upd_number01), !is.na(data_bind_upd_number02), !is.na(data_bind_upd_number03)) |>
  mutate(across(c(matches("data_bind_upd_number(01|02|03)")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  mutate(data_bind_upd_number = pmap(list(data_bind_upd_number01, data_bind_upd_number02, data_bind_upd_number03), function(data_bind_upd_number01, data_bind_upd_number02, data_bind_upd_number03) {
    bind_rows(data_bind_upd_number01 |> mutate(recall = as.character(recall)), data_bind_upd_number02 |> mutate(recall = as.character(recall)), data_bind_upd_number03 |> mutate(recall = as.character(recall)))})) |>
  unnest(data_bind_upd_number) |>
  select(id, prolific_pid, rt, stimulus, step_type, variable, nBind, nUpd, task, counterbalance, position, recall, stimuli, accuracy, time_elapsed) |>
  mutate(version = ifelse(nUpd == 0, "binding", "updating"))

bind_upd_number_clean <- bind_upd_number_data |>
  filter(variable == "recall") |>
  mutate(task = str_replace_all(task, "_test\\d\\d", "")) |>
  group_by(prolific_pid, version, task) |>
  summarise(number_acc = sum(accuracy)/n()) |>
  ungroup()

## Ospan ----

ospan_practice <-
  pilot_data %>%
  select(id, prolific_pid, data_ospan_practice) %>%
  filter(!is.na(data_ospan_practice)) |>
  mutate(across(c(starts_with("data_ospan_practice")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) %>%
  unnest(data_ospan_practice) |>
  select(id, prolific_pid, rt, response, task, set_size, variable, block, counterbalance, correct, step_number, recall, stimuli, accuracy, time_elapsed)

ospan_data <-
  pilot_data %>%
  select(id, prolific_pid, data_ospan) %>%
  filter(!is.na(data_ospan)) |>
  mutate(across(c(starts_with("data_ospan")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) %>%
  unnest(data_ospan) |>
  select(id, prolific_pid, rt, response, task, set_size, variable, block, counterbalance, correct, step_number, recall, stimuli, accuracy, time_elapsed)

ospan_data_letter_clean <-
  ospan_data |>
  filter(variable == "recall") |>
  select(id, prolific_pid, block, counterbalance, stimuli, set_size, accuracy) |>
  mutate(acc_prop = accuracy / set_size) |>
  group_by(prolific_pid) |>
  summarise(ospan_cap = mean(acc_prop))


ospan_data_math_clean <-
  ospan_data |>
  filter(variable == "math") |>
  select(id, prolific_pid, rt, block, counterbalance, correct) |>
  group_by(prolific_pid) |>
  summarise(ospan_sec_acc = sum(correct) / n())

## Rspan ----

rspan_practice <-
  pilot2_data %>%
  select(id, prolific_pid, data_rspan_practice) %>%
  filter(!is.na(data_rspan_practice)) |>
  mutate(across(c(starts_with("data_rspan_practice")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) %>%
  unnest(data_rspan_practice) |>
  select(id, prolific_pid, rt, response, task, set_size, variable, block, correct, step_number, recall, stimuli, accuracy, time_elapsed)

rspan_data <-
  pilot2_data %>%
  select(id, prolific_pid, data_rspan) %>%
  filter(!is.na(data_rspan)) |>
  mutate(across(c(starts_with("data_rspan")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) %>%
  unnest(data_rspan) |>
  select(id, prolific_pid, rt, response, task, set_size, variable, block, correct, step_number, recall, stimuli, accuracy, time_elapsed)

rspan_data_arrow_clean <-
  rspan_data |>
  filter(variable == "recall") |>
  select(id, prolific_pid, block, stimuli, set_size, accuracy) |>
  mutate(acc_prop = accuracy / set_size) |>
  group_by(prolific_pid) |>
  summarise(rspan_cap = mean(acc_prop))


rspan_data_rotation_clean <-
  rspan_data |>
  filter(variable == "rotation") |>
  select(id, prolific_pid, rt, block, correct) |>
  group_by(prolific_pid) |>
  summarise(rspan_sec_acc = sum(correct) / n())


# Combine All Data --------------------------------------------------------

pilot_full_data <-
  left_join(ospan_data_letter_clean, rspan_data_arrow_clean) |>
  left_join(ospan_data_math_clean) |>
  left_join(rspan_data_rotation_clean) |>
  left_join(
    bind_upd_color_clean |>
      pivot_wider(names_from = "version", values_from = 'color_acc') |>
      select(-task) |>
      rename(
        binding_color = binding,
        updating_color = updating
      )
  ) |>
  left_join(
    bind_upd_number_clean |>
      pivot_wider(names_from = "version", values_from = 'number_acc') |>
      select(-task) |>
      rename(
        binding_number = binding,
        updating_number = updating
      )
  ) |>
  left_join(vars03_unp |> select(prolific_pid, pcunp_mean)) |>
  left_join(vars04_vio |> select(prolific_pid, vio_comp)) |>
  left_join(vars05_ses |> select(prolific_pid, ses_subj_comp)) |>
  left_join(vars10_dems |> select(prolific_pid, dems_age)) |>
  mutate(id = 1:n()) |>
  select(-prolific_pid)

save(pilot_full_data, file = "data/pilot_full_data.RData")
