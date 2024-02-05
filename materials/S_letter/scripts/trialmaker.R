library(tidyverse)
library(glue)

set.seed(4785)


# Ecological Stimuli ------------------------------------------------------

# stimulus set 1
trials <- tibble(
  type     = c('first', sample(c(rep('repeat',32), rep('switch',32)), size = 64, replace = F)),
  rule     = c('oddeven', rep(NA, 64)),
  variable = "letter_shifting",
  task     = "letter_shifting1",
  stimulus = sample(c('1', '2', '3', '4', '6', '7', '8', '9'), 65, replace = T),
  key_answer = NA
)

trials <- trials |>
  mutate(
    valid1 = ifelse(type == lag(type,1) & type == lag(type,2) & type == lag(type,3), FALSE, TRUE),
    valid2 = ifelse(stimulus == lag(stimulus,1) & stimulus == lag(stimulus,2), FALSE, TRUE)
  )
n = 1
while(any(c(trials$valid1, trials$valid2) == FALSE, na.rm = T)) {
  trials <- trials |>
    mutate(
      type = c('first', sample(c(rep('repeat',32), rep('switch',32)), size = 64, replace = F)),
      stimulus = sample(c('1', '2', '3', '4', '6', '7', '8', '9'), 65, replace = T),
      valid1 = ifelse(type == lag(type,1) & type == lag(type,2) & type == lag(type,3), FALSE, TRUE),
      valid2 = ifelse(stimulus == lag(stimulus,1) & stimulus == lag(stimulus,2), FALSE, TRUE)
      )
}


n = 1
while(n<=64){
  trials <- trials |>
    mutate(
      rule = case_when(
        is.na(rule) & type == "repeat" & lag(rule, n=1) == 'oddeven' ~ 'oddeven',
        is.na(rule) & type == "repeat" & lag(rule, n=1) == 'largesmall' ~ 'largesmall',
        is.na(rule) & type == "switch" & lag(rule, n=1) == 'oddeven' ~ 'largesmall',
        is.na(rule) & type == "switch" & lag(rule, n=1) == 'largesmall' ~ 'oddeven',
        TRUE ~ rule
      )
    )
  n = n+1
}

trials <- trials |>
  mutate(
    key_answer = case_when(
      rule == 'oddeven'    & stimulus %in% c(2,4,6,8) ~ 'A',
      rule == 'oddeven'    & stimulus %in% c(1,3,7,9) ~ 'L',
      rule == 'largesmall' & stimulus < 5 ~ 'A',
      rule == 'largesmall' & stimulus > 5 ~ 'L',
    )
  )



glue_data(
  trials,
  "{{stim: {stimulus}, key_answer: '{key_answer}', data: {{rule: '{rule}', type: '{type}', variable: '{variable}', task: '{task}'}}}},"
)

