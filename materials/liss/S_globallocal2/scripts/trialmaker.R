set.seed(478)

# Abstract Stimuli ------------------------------------------------------

# stimulus set 1
trials01 <- tibble(
  type     = c('first', sample(c(rep('repeat',16), rep('switch',16)), size = 32, replace = F)),
  rule     = c('global', rep(NA, 32)),
  congruency = c('congruent', sample(c(rep('congruent', 16), rep("incongruent", 16)), size = 32, replace = F)),
  variable = "globallocal2_01",
  task     = "globallocal",
  stimulus = c('SQsq', rep(NA, 32)),
  key_answer = NA
)

trials01 <- trials01 |>
  mutate(
    valid1 = ifelse(type == lag(type,1) & type == lag(type,2) & type == lag(type,3), FALSE, TRUE),
    valid2 = ifelse(type == "repeat" & type == lag(type,1) & type == lag(type,2) & lag(type,3) == "switch", FALSE, TRUE),
    valid3 = ifelse(congruency == lag(congruency,1) & congruency == lag(congruency,2) & congruency == lag(congruency,3), FALSE, TRUE)
  )

n = 1
while(any(c(trials01$valid1, trials01$valid2, trials01$valid3) == FALSE, na.rm = T)) {
  trials01 <- trials01 |>
    mutate(
      type = c('first', sample(c(rep('repeat',16), rep('switch',16)), size = 32, replace = F)),
      congruency = c('congruent', sample(c(rep('congruent', 16), rep("incongruent", 16)), size = 32, replace = F)),
      valid1 = ifelse(type == lag(type,1) & type == lag(type,2) & type == lag(type,3), FALSE, TRUE),
      valid2 = ifelse(type == "repeat" & type == lag(type,1) & type == lag(type,2) & lag(type,3) == "switch", FALSE, TRUE),
      valid3 = ifelse(congruency == lag(congruency,1) & congruency == lag(congruency,2) & congruency == lag(congruency,3), FALSE, TRUE)
    )
  n = n+1
  print(n)
}

n = 1
while(n<=32){
  trials01 <- trials01 |>
    mutate(
      rule = case_when(
        is.na(rule) & type == "repeat" & lag(rule, n=1) == 'global' ~ 'global',
        is.na(rule) & type == "repeat" & lag(rule, n=1) == 'local' ~ 'local',
        is.na(rule) & type == "switch" & lag(rule, n=1) == 'global' ~ 'local',
        is.na(rule) & type == "switch" & lag(rule, n=1) == 'local' ~ 'global',
        TRUE ~ rule
      )
    )
  n = n+1
}

# Add stimuli

trials01 <- trials01 |>
  select(-starts_with('valid')) |>
  mutate(
    stimulus = ifelse(congruency == 'congruent', sample(c(rep("SQsq", 17), rep("RECrec", 16)), size = 33, replace = F), sample(c(rep("SQrec", 16), rep("RECsq", 16)), size = 32, replace = F)),
    valid1 = ifelse(stimulus == lag(stimulus,1) & stimulus == lag(stimulus,2), FALSE, TRUE)
  )

n = 1
while(any(c(trials01$valid1) == FALSE, na.rm = T)) {
  trials01 <- trials01 |>
    mutate(
      stimulus = ifelse(congruency == 'congruent', sample(c(rep("SQsq", 17), rep("RECrec", 16)), size = 33, replace = F), sample(c(rep("SQrec", 16), rep("RECsq", 16)), size = 32, replace = F)),
      valid1 = ifelse(stimulus == lag(stimulus,1) & stimulus == lag(stimulus,2), FALSE, TRUE)
    )
  n = n+1
  print(n)
}

trials01 <- trials01 |>
  mutate(
    key_answer = case_when(
      rule == 'global' & str_detect(stimulus, "^SQ")  ~ 'A',
      rule == 'global' & str_detect(stimulus, "^REC") ~ 'L',

      rule == 'local' & str_detect(stimulus, "sq$")   ~ 'A',
      rule == 'local' & str_detect(stimulus, "rec$")  ~ 'L'
    )
  )



# stimulus set 2
set.seed(4785)

# Abstract Stimuli ------------------------------------------------------

# stimulus set 1
trials02 <- tibble(
  type     = c('first', sample(c(rep('repeat',16), rep('switch',16)), size = 32, replace = F)),
  rule     = c('color', rep(NA, 32)),
  variable = "colorshape1",
  task     = "colorshape",
  stimulus = sample(c('yellow_circle', 'yellow_triangle', 'blue_circle', 'blue_triangle'), 33, replace = T),
  key_answer = NA
)

trials02 <- trials02 |>
  mutate(
    valid1 = ifelse(type == lag(type,1) & type == lag(type,2) & type == lag(type,3), FALSE, TRUE),
    valid2 = ifelse(stimulus == lag(stimulus,1) & stimulus == lag(stimulus,2), FALSE, TRUE)
  )

n = 1
while(any(c(trials02$valid1, trials02$valid2) == FALSE, na.rm = T)) {
  trials02 <- trials02 |>
    mutate(
      type = c('first', sample(c(rep('repeat',16), rep('switch',16)), size = 32, replace = F)),
      stimulus = sample(c('yellow_circle', 'yellow_triangle', 'blue_circle', 'blue_triangle'), 33, replace = T),
      valid1 = ifelse(type == lag(type,1) & type == lag(type,2) & type == lag(type,3), FALSE, TRUE),
      valid2 = ifelse(stimulus == lag(stimulus,1) & stimulus == lag(stimulus,2), FALSE, TRUE)
    )
}

n = 1
while(n<=32){
  trials02 <- trials02 |>
    mutate(
      rule = case_when(
        is.na(rule) & type == "repeat" & lag(rule, n=1) == 'color' ~ 'color',
        is.na(rule) & type == "repeat" & lag(rule, n=1) == 'shape' ~ 'shape',
        is.na(rule) & type == "switch" & lag(rule, n=1) == 'color' ~ 'shape',
        is.na(rule) & type == "switch" & lag(rule, n=1) == 'shape' ~ 'color',
        TRUE ~ rule
      )
    )
  n = n+1
}

trials02 <- trials02 |>
  mutate(
    key_answer = case_when(
      rule == 'color' & str_detect(stimulus, "^blue") ~ 'L',
      rule == 'color' & str_detect(stimulus, "^yellow") ~ 'A',
      rule == 'shape' & str_detect(stimulus, "circle") ~ 'L',
      rule == 'shape' & str_detect(stimulus, "triangle") ~ 'A',
    ),
    stimulus = case_when(
      rule == 'color' & str_detect(stimulus, "^blue_circle") ~ 'bluecircle_color',
      rule == 'color' & str_detect(stimulus, "^blue_triangle") ~ 'bluetriangle_color',
      rule == 'shape' & str_detect(stimulus, "^blue_circle") ~ 'bluecircle_shape',
      rule == 'shape' & str_detect(stimulus, "^blue_triangle") ~ 'bluetriangle_shape',

      rule == 'color' & str_detect(stimulus, "^yellow_circle") ~ 'yellowcircle_color',
      rule == 'color' & str_detect(stimulus, "^yellow_triangle") ~ 'yellowtriangle_color',
      rule == 'shape' & str_detect(stimulus, "^yellow_circle") ~ 'yellowcircle_shape',
      rule == 'shape' & str_detect(stimulus, "^yellow_triangle") ~ 'yellowtriangle_shape',
    )
  )

glue_data(
  trials01,
  "{{stimulus: {stimulus}, key_answer: '{key_answer}', data: {{rule: '{rule}', type: '{type}', variable: '{variable}', task: '{task}'}}}},"
)

glue_data(
  trials02,
  "{{stimulus: {stimulus}, key_answer: '{key_answer}', data: {{rule: '{rule}', type: '{type}', variable: '{variable}', task: '{task}'}}}},"
)





# stimulus set 2
set.seed(763)

# Abstract Stimuli ------------------------------------------------------

# stimulus set 1
trials02 <- tibble(
  type     = c('first', sample(c(rep('repeat',16), rep('switch',16)), size = 32, replace = F)),
  rule     = c('global', rep(NA, 32)),
  congruency = c('congruent', sample(c(rep('congruent', 16), rep("incongruent", 16)), size = 32, replace = F)),
  variable = "globallocal2_01",
  task     = "globallocal",
  stimulus = c('SQsq', rep(NA, 32)),
  key_answer = NA
)

trials02 <- trials02 |>
  mutate(
    valid1 = ifelse(type == lag(type,1) & type == lag(type,2) & type == lag(type,3), FALSE, TRUE),
    valid2 = ifelse(type == "repeat" & type == lag(type,1) & type == lag(type,2) & lag(type,3) == "switch", FALSE, TRUE),
    valid3 = ifelse(congruency == lag(congruency,1) & congruency == lag(congruency,2) & congruency == lag(congruency,3), FALSE, TRUE)
  )

n = 1
while(any(c(trials02$valid1, trials02$valid2, trials02$valid3) == FALSE, na.rm = T)) {
  trials02 <- trials02 |>
    mutate(
      type = c('first', sample(c(rep('repeat',16), rep('switch',16)), size = 32, replace = F)),
      congruency = c('congruent', sample(c(rep('congruent', 16), rep("incongruent", 16)), size = 32, replace = F)),
      valid1 = ifelse(type == lag(type,1) & type == lag(type,2) & type == lag(type,3), FALSE, TRUE),
      valid2 = ifelse(type == "repeat" & type == lag(type,1) & type == lag(type,2) & lag(type,3) == "switch", FALSE, TRUE),
      valid3 = ifelse(congruency == lag(congruency,1) & congruency == lag(congruency,2) & congruency == lag(congruency,3), FALSE, TRUE)
    )
  n = n+1
  print(n)
}

n = 1
while(n<=32){
  trials02 <- trials02 |>
    mutate(
      rule = case_when(
        is.na(rule) & type == "repeat" & lag(rule, n=1) == 'global' ~ 'global',
        is.na(rule) & type == "repeat" & lag(rule, n=1) == 'local' ~ 'local',
        is.na(rule) & type == "switch" & lag(rule, n=1) == 'global' ~ 'local',
        is.na(rule) & type == "switch" & lag(rule, n=1) == 'local' ~ 'global',
        TRUE ~ rule
      )
    )
  n = n+1
}

# Add stimuli

trials02 <- trials02 |>
  select(-starts_with('valid')) |>
  mutate(
    stimulus = ifelse(congruency == 'congruent', sample(c(rep("SQsq", 17), rep("RECrec", 16)), size = 33, replace = F), sample(c(rep("SQrec", 16), rep("RECsq", 16)), size = 32, replace = F)),
    valid1 = ifelse(stimulus == lag(stimulus,1) & stimulus == lag(stimulus,2), FALSE, TRUE)
  )

n = 1
while(any(c(trials02$valid1) == FALSE, na.rm = T)) {
  trials02 <- trials02 |>
    mutate(
      stimulus = ifelse(congruency == 'congruent', sample(c(rep("SQsq", 17), rep("RECrec", 16)), size = 33, replace = F), sample(c(rep("SQrec", 16), rep("RECsq", 16)), size = 32, replace = F)),
      valid1 = ifelse(stimulus == lag(stimulus,1) & stimulus == lag(stimulus,2), FALSE, TRUE)
    )
  n = n+1
  print(n)
}

trials02 <- trials02 |>
  mutate(
    key_answer = case_when(
      rule == 'global' & str_detect(stimulus, "^SQ")  ~ 'A',
      rule == 'global' & str_detect(stimulus, "^REC") ~ 'L',

      rule == 'local' & str_detect(stimulus, "sq$")   ~ 'A',
      rule == 'local' & str_detect(stimulus, "rec$")  ~ 'L'
    )
  )



glue_data(
  trials01,
  "{{stimulus: {stimulus}, key_answer: '{key_answer}', data: {{stimulus: '{stimulus}', rule: '{rule}', type: '{type}', congruency: '{congruency}', variable: '{variable}', task: '{task}'}}}},"
)

glue_data(
  trials02,
  "{{stimulus: {stimulus}, key_answer: '{key_answer}', data: {{stimulus: '{stimulus}', rule: '{rule}', type: '{type}', congruency: '{congruency}', variable: '{variable}', task: '{task}'}}}},"
)

