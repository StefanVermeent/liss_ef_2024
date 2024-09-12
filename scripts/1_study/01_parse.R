# 1. Packages -------------------------------------------------------------
library(psych)
library(tidyverse)
library(qualtRics)
library(jsonlite)
library(here)
library(sjlabelled)


# 2. Data -----------------------------------------------------------------
raw_data <- read_delim("data/L_CognitiveAdversity_TASKDATA.csv", delim = ";")


raw_data <- raw_data |>
  mutate(
    data_simon = case_when(
      volgorde__1 == '1' ~ JSON1.4,
      volgorde__2 == '1' ~ JSON2.4,
      volgorde__3 == '1' ~ JSON3.4,
      volgorde__4 == '1' ~ JSON4.4,
      volgorde__5 == '1' ~ JSON5.4,
      volgorde__6 == '1' ~ JSON6.4
    ),
    data_flanker = case_when(
      volgorde__1 == '2' ~ JSON1.4,
      volgorde__2 == '2' ~ JSON2.4,
      volgorde__3 == '2' ~ JSON3.4,
      volgorde__4 == '2' ~ JSON4.4,
      volgorde__5 == '2' ~ JSON5.4,
      volgorde__6 == '2' ~ JSON6.4
    ),
    data_globallocal2 = case_when(
      volgorde__1 == '3' ~ JSON1.4,
      volgorde__2 == '3' ~ JSON2.4,
      volgorde__3 == '3' ~ JSON3.4,
      volgorde__4 == '3' ~ JSON4.4,
      volgorde__5 == '3' ~ JSON5.4,
      volgorde__6 == '3' ~ JSON6.4
    ),
    data_colorshape = case_when(
      volgorde__1 == '4' ~ JSON1.4,
      volgorde__2 == '4' ~ JSON2.4,
      volgorde__3 == '4' ~ JSON3.4,
      volgorde__4 == '4' ~ JSON4.4,
      volgorde__5 == '4' ~ JSON5.4,
      volgorde__6 == '4' ~ JSON6.4
    ),
    data_animacysize = case_when(
      volgorde__1 == '5' ~ JSON1.4,
      volgorde__2 == '5' ~ JSON2.4,
      volgorde__3 == '5' ~ JSON3.4,
      volgorde__4 == '5' ~ JSON4.4,
      volgorde__5 == '5' ~ JSON5.4,
      volgorde__6 == '5' ~ JSON6.4
    ),
    data_posner = case_when(
      volgorde__1 == '6' ~ JSON1.4,
      volgorde__2 == '6' ~ JSON2.4,
      volgorde__3 == '6' ~ JSON3.4,
      volgorde__4 == '6' ~ JSON4.4,
      volgorde__5 == '6' ~ JSON5.4,
      volgorde__6 == '6' ~ JSON6.4
    )
  ) |>
  select(nomem_encr, starts_with('data'))

# 3. Flanker Task ---------------------------------------------------------

flanker_raw <-
  raw_data |>
  select(nomem_encr, data_flanker) |>
  filter(!is.na(data_flanker)) |>
  filter(data_flanker != "[]", data_flanker != "\"I\"") |>
  mutate(across(c(matches("data_flanker")), ~str_replace_all(., "^\\\"", ""))) |>
  mutate(across(c(matches("data_flanker")), ~str_replace_all(., "\\\\", ""))) |>
  mutate(across(c(matches("data_flanker")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_flanker) |>
  mutate(
    rt        = rt / 1000,
    correct   = ifelse(correct == TRUE, 1, 0),
    condition = ifelse(str_detect(stimtype, "^congruent"), 1, 2)) |>
  filter(!variable %in% c("interblock", "test_start", "end")) |>
  select(nomem_encr, rt, task, condition, correct)


# 4. Simon Task -----------------------------------------------------------

simon_raw <-
  raw_data |>
  select(nomem_encr, data_simon) |>
  filter(!is.na(data_simon)) |>
  filter(data_simon != "[]", data_simon != "\"I\"") |>
  mutate(across(c(matches("data_simon")), ~str_replace_all(., "^\\\"", ""))) |>
  mutate(across(c(matches("data_simon")), ~str_replace_all(., "\\\\", ""))) |>
  mutate(across(c(matches("data_simon")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_simon) |>
  mutate(
    rt        = rt / 1000,
    correct   = ifelse(correct == TRUE, 1, 0),
    condition = ifelse(str_detect(stimtype, "^congruent"), 1, 2)) |>
  filter(!variable %in% c("interblock", "test_start", "end")) |>
  select(nomem_encr, rt, task, condition, correct)

# 5. Color Shape Task -----------------------------------------------------

colorshape_raw <-
  raw_data |>
  select(nomem_encr, data_colorshape) |>
  filter(!is.na(data_colorshape)) |>
  filter(data_colorshape != "[]", data_colorshape != "\"I\"") |>
  mutate(across(c(matches("data_colorshape")), ~str_replace_all(., "^\\\"", ""))) |>
  mutate(across(c(matches("data_colorshape")), ~str_replace_all(., "\\\\", ""))) |>
  mutate(across(c(matches("data_colorshape")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_colorshape) |>
  filter(!variable %in% c("test_start", "colorshape_finish"), condition != "first") |>
  mutate(
    rt        = rt / 1000,
    correct   = ifelse(correct == TRUE, 1, 0),
    condition = ifelse(condition == "repeat", 1, 2)) |>
  select(nomem_encr, rt, task, condition, rule, correct)


# 6. Animacy Size Task ----------------------------------------------------

animacysize_raw <-
  raw_data |>
  select(nomem_encr, data_animacysize) |>
  filter(!is.na(data_animacysize)) |>
  filter(data_animacysize != "[]", data_animacysize != "\"I\"") |>
  mutate(across(c(matches("data_animacysize")), ~str_replace_all(., "^\\\"", ""))) |>
  mutate(across(c(matches("data_animacysize")), ~str_replace_all(., "\\\\", ""))) |>
  mutate(across(c(matches("data_animacysize")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_animacysize) |>
  filter(!variable %in% c("test_start", "interblock", "end"), condition != "first") |>
  mutate(
    rt        = rt / 1000,
    correct   = ifelse(correct == TRUE, 1, 0),
    condition = ifelse(condition == "repeat", 1, 2)) |>
  select(nomem_encr, rt, task, condition, rule, correct)

# 7. Posner Task ----------------------------------------------------------

posner_raw <-
  raw_data |>
  select(nomem_encr, data_posner) |>
  filter(!is.na(data_posner)) |>
  filter(data_posner != "[]", data_posner != "\"I\"") |>
  mutate(across(c(matches("data_posner")), ~str_replace_all(., "^\\\"", ""))) |>
  mutate(across(c(matches("data_posner")), ~str_replace_all(., "\\\\", ""))) |>
  mutate(across(c(matches("data_posner")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_posner) |>
  filter(!variable %in% c("interblock", "test_start", "end")) |>
  mutate(
    rt        = rt / 1000,
    correct   = ifelse(correct == TRUE, 1, 0),
    condition = ifelse(condition == "same", 1, 2)
  ) |>
  select(nomem_encr, rt, task, condition, correct)

# 8. Global Local2 Task ----------------------------------------------------

globallocal2_raw <-
  raw_data |>
  select(nomem_encr, data_globallocal2) |>
  filter(!is.na(data_globallocal2)) |>
  filter(data_globallocal2 != "[]", data_globallocal2 != "\"I\"") |>
  mutate(across(c(matches("data_globallocal2")), ~str_replace_all(., "^\\\"", ""))) |>
  mutate(across(c(matches("data_globallocal2")), ~str_replace_all(., "\\\\", ""))) |>
  mutate(across(c(matches("data_globallocal2")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_globallocal2) |>
  filter(!variable %in% c("test_start", "fixation", "test_interblock", "end"), condition != "first") |>
  mutate(
    rt        = (rt / 1000) - 1, # -1 to account for the stimulus offset delay of 1s
    rt        = ifelse(rt < 0, 0, rt), # Set negative RTs to zero to prevent later issues with log-transformations
    correct   = ifelse(correct == TRUE, 1, 0),
    condition = ifelse(condition == "repeat", 1, 2)) |>
  select(nomem_encr, rt, task, condition, rule, correct)



# 9. Remove participants who did not complete the full experiment ---------

all_unique_ids <- reduce(
  list(
  animacysize_raw |>
    select(nomem_encr, task) |> distinct(),
  globallocal2_raw |>
    select(nomem_encr, task) |> distinct(),
  colorshape_raw |>
    select(nomem_encr, task) |> distinct(),
  flanker_raw |>
    select(nomem_encr, task) |> distinct(),
  simon_raw |>
    select(nomem_encr, task) |> distinct(),
  posner_raw |>
    select(nomem_encr, task) |> distinct()
),
full_join, by = "nomem_encr"
  )

all_incomplete_ids <- all_unique_ids |>
  filter(if_any(-nomem_encr, is.na)) |>
  pull(nomem_encr)

all_complete_ids <- all_unique_ids |>
  drop_na() |>
  pull(nomem_encr)

length(all_incomplete_ids) + length(all_complete_ids) == nrow(all_unique_ids)

# Remove participants who did not complete the full experiment

flanker_raw     <- flanker_raw |> filter(nomem_encr %in% all_complete_ids)
simon_raw       <- simon_raw |> filter(nomem_encr %in% all_complete_ids)
colorshape_raw  <- colorshape_raw |> filter(nomem_encr %in% all_complete_ids)
animacysize_raw <- animacysize_raw |> filter(nomem_encr %in% all_complete_ids)
globallocal2_raw <- globallocal2_raw |> filter(nomem_encr %in% all_complete_ids)
posner_raw      <- posner_raw |> filter(nomem_encr %in% all_complete_ids)


# 10. Write data ------------------------------------------------------------

save(animacysize_raw, colorshape_raw, flanker_raw, posner_raw, simon_raw, globallocal2_raw, all_incomplete_ids, all_complete_ids, file = "data/raw_data_long.RData")
