# 1. Packages -------------------------------------------------------------
library(psych)
library(tidyverse)
library(jsonlite)
library(here)
library(sjlabelled)


# 2. Data -----------------------------------------------------------------
raw_data <- read_delim("data/L_CognitiveAdversity_TASKDATA.csv", delim = ";")

# JSON strings of task data are shuffled within variables due to randomized order. This function matches the json strings the the correct cognitive tasks.
parse_json_data <- function(data, x) {
  data <- data |>
    mutate(
      var = case_when(
        volgorde__1 == x ~ JSON1.4,
        volgorde__2 == x ~ JSON2.4,
        volgorde__3 == x ~ JSON3.4,
        volgorde__4 == x ~ JSON4.4,
        volgorde__5 == x ~ JSON5.4,
        volgorde__6 == x ~ JSON6.4
      )
    )
  return(data$var)
}

parse_json_timestamp <- function(data, x) {
  data <- data |>
    mutate(
      var = case_when(
        volgorde__1 == x ~ JSON1.1,
        volgorde__2 == x ~ JSON2.1,
        volgorde__3 == x ~ JSON3.1,
        volgorde__4 == x ~ JSON4.1,
        volgorde__5 == x ~ JSON5.1,
        volgorde__6 == x ~ JSON6.1
      )
    )
  return(data$var)
}

raw_data <- raw_data %>%
  mutate(
    data_simon        = parse_json_data(data = ., x = "1"),
    data_flanker      = parse_json_data(data = ., x = "2"),
    data_globallocal2 = parse_json_data(data = ., x = "3"),
    data_colorshape   = parse_json_data(data = ., x = "4"),
    data_animacysize  = parse_json_data(data = ., x = "5"),
    data_posner       = parse_json_data(data = ., x = "6"),

    timestamp_simon        = parse_json_timestamp(data = ., x = "1"),
    timestamp_flanker      = parse_json_timestamp(data = ., x = "2"),
    timestamp_globallocal2 = parse_json_timestamp(data = ., x = "3"),
    timestamp_colorshape   = parse_json_timestamp(data = ., x = "4"),
    timestamp_animacysize  = parse_json_timestamp(data = ., x = "5"),
    timestamp_posner       = parse_json_timestamp(data = ., x = "6"),
    ) |>
  select(nomem_encr, starts_with('data'), starts_with("timestamp")) %>%
  mutate(across(starts_with("timestamp"), ~lubridate::as_date(x = .))) |>
  rowwise() |>
  mutate(
    n_sessions = unique(na.omit(c(timestamp_simon, timestamp_flanker, timestamp_colorshape, timestamp_animacysize, timestamp_globallocal2, timestamp_posner))) |> length()
  )

n_sessions <- raw_data |>
  select(nomem_encr, starts_with('timestamp'), n_sessions) %>%
  mutate(across(starts_with('timestamp'), ~as.numeric(.))) |>
  rowwise() |>
  mutate(
    first_date      = min(c(timestamp_simon, timestamp_flanker, timestamp_globallocal2, timestamp_colorshape, timestamp_animacysize, timestamp_posner), na.rm = T),
    session_flanker = ifelse(timestamp_flanker == first_date, "session1", "session2"),
    session_simon   = ifelse(timestamp_simon == first_date, "session1", "session2"),
    session_cs = ifelse(timestamp_colorshape == first_date, "session1", "session2"),
    session_gl = ifelse(timestamp_globallocal2 == first_date, "session1", "session2"),
    session_as = ifelse(timestamp_animacysize == first_date, "session1", "session2"),
    session_pos = ifelse(timestamp_posner == first_date, "session1", "session2"),
  ) |>
  ungroup()


# 3. Flanker Task ---------------------------------------------------------

flanker_raw <-
  raw_data |>
  select(nomem_encr, data_flanker, n_sessions) |>
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
  select(nomem_encr, rt, task, condition, correct, n_sessions)


# 4. Simon Task -----------------------------------------------------------

simon_raw <-
  raw_data |>
  select(nomem_encr, data_simon, n_sessions) |>
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
  select(nomem_encr, rt, task, condition, correct, n_sessions)

# 5. Color Shape Task -----------------------------------------------------

colorshape_raw <-
  raw_data |>
  select(nomem_encr, data_colorshape, n_sessions) |>
  filter(!is.na(data_colorshape)) |>
  filter(data_colorshape != "[]", data_colorshape != "\"I\"") |>
  mutate(across(c(matches("data_colorshape")), ~str_replace_all(., "^\\\"", ""))) |>
  mutate(across(c(matches("data_colorshape")), ~str_replace_all(., "\\\\", ""))) |>
  mutate(across(c(matches("data_colorshape")), ~map_if(., .p =  ~!is.na(.x), .f = jsonlite::fromJSON))) |>
  unnest(data_colorshape) |>
  filter(!variable %in% c("test_start", "colorshape_finish"), condition != "first") |>
  # Due to a coding error, the 'correct' variable logged by JsPsych contains errors. Here, I manually fix those errors
  mutate(
    correct = case_when(
      response == "a" & str_detect(stimulus, "yellow")   & rule == "color" ~ TRUE,
      response == "a" & str_detect(stimulus, "triangle") & rule == "shape" ~ TRUE,
      response == "l" & str_detect(stimulus, "blue")     & rule == "color" ~ TRUE,
      response == "l" & str_detect(stimulus, "circle")   & rule == "shape" ~ TRUE,

      TRUE ~ FALSE
    )
  ) |>
  mutate(
    rt        = rt / 1000,
    correct   = ifelse(correct == TRUE, 1, 0),
    condition = ifelse(condition == "repeat", 1, 2)) |>
  select(nomem_encr, rt, task, condition, rule, correct, n_sessions)


# 6. Animacy Size Task ----------------------------------------------------

animacysize_raw <-
  raw_data |>
  select(nomem_encr, data_animacysize, n_sessions) |>
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
  select(nomem_encr, rt, task, condition, rule, correct, n_sessions)

# 7. Posner Task ----------------------------------------------------------

posner_raw <-
  raw_data |>
  select(nomem_encr, data_posner, n_sessions) |>
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
  select(nomem_encr, rt, task, condition, correct, n_sessions)

# 8. Global Local2 Task ----------------------------------------------------

globallocal2_raw <-
  raw_data |>
  select(nomem_encr, data_globallocal2, n_sessions) |>
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
  select(nomem_encr, rt, task, condition, rule, correct, n_sessions)



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
save(n_sessions, file = "analysis_objects/n_sessions.RData")
