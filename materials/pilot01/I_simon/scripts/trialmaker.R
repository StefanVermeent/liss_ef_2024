set.seed(4785)


trials01 <- expand_grid(
  location = c("left", "right"),
  stim     = c("LINKS", "RECHTS"),
  n        = 1:16
) |>
  select(-n) |>
  mutate(condition = case_when(
    location == "left" & stim == "LINKS" ~ "congruent",
    location == "left" & stim == "RECHTS" ~ "incongruent",
    location == "right" & stim == "LINKS" ~ "incongruent",
    location == "right" & stim == "RECHTS" ~ "congruent",
  )) |>
  mutate(n = sample(1:n(), size = n(), replace=F)) |>
  arrange(n) |>
  mutate(correct_response = ifelse(stim == "LINKS", "A", "L"))


trials01 <- trials01 |>
  mutate(
    valid1 = ifelse(stim == lag(stim,1) & stim == lag(stim,2) & stim == lag(stim,3), FALSE, TRUE),
    valid2 = ifelse(condition == lag(condition,1) & condition == lag(condition,2) & condition == lag(condition,3), FALSE, TRUE)
  )

n = 1
while(any(c(trials01$valid1, trials01$valid2) == FALSE, na.rm = T)) {
  trials01 <- trials01 |>
    mutate(n = sample(1:n(), size = n(), replace=F)) |>
    arrange(n) |>
    mutate(
      valid1 = ifelse(stim == lag(stim,1) & stim == lag(stim,2) & stim == lag(stim,3), FALSE, TRUE),
      valid2 = ifelse(condition == lag(condition,1) & condition == lag(condition,2) & condition == lag(condition,3), FALSE, TRUE),
    )
  print(n)
  n = n+1
}

glue_data(
  trials01,
  "{{location: '{location}', correct_response: '{correct_response}', condition: '{condition}', stim: '{stim}'}},"
)
