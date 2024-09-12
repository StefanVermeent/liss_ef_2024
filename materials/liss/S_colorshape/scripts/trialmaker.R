set.seed(4785)

# Abstract Stimuli ------------------------------------------------------

# stimulus set 1
trials01 <- tibble(
  type     = c('first', sample(c(rep('repeat',16), rep('switch',16)), size = 32, replace = F)),
  rule     = c('color', rep(NA, 32)),
  variable = "colorshape1",
  task     = "colorshape",
  stimulus = sample(c('yellow_circle', 'yellow_triangle', 'blue_circle', 'blue_triangle'), 33, replace = T),
  key_answer = NA
)

trials01 <- trials01 |>
  mutate(
    valid1 = ifelse(type == lag(type,1) & type == lag(type,2) & type == lag(type,3), FALSE, TRUE),
    valid2 = ifelse(stimulus == lag(stimulus,1) & stimulus == lag(stimulus,2), FALSE, TRUE)
  )

n = 1
while(any(c(trials01$valid1, trials01$valid2) == FALSE, na.rm = T)) {
  trials01 <- trials01 |>
    mutate(
      type = c('first', sample(c(rep('repeat',16), rep('switch',16)), size = 32, replace = F)),
      stimulus = sample(c('yellow_circle', 'yellow_triangle', 'blue_circle', 'blue_triangle'), 33, replace = T),
      valid1 = ifelse(type == lag(type,1) & type == lag(type,2) & type == lag(type,3), FALSE, TRUE),
      valid2 = ifelse(stimulus == lag(stimulus,1) & stimulus == lag(stimulus,2), FALSE, TRUE)
    )
}

n = 1
while(n<=32){
  trials01 <- trials01 |>
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

trials01 <- trials01 |>
  mutate(
    key_answer = case_when(
      rule == 'color' & str_detect(stimulus, "^blue") ~ 'L',
      rule == 'color' & str_detect(stimulus, "^yellow") ~ 'ArrowLeft',
      rule == 'shape' & str_detect(stimulus, "circle") ~ 'L',
      rule == 'shape' & str_detect(stimulus, "triangle") ~ 'ArrowLeft',
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
    ),
    stim_chr = case_when(
      str_detect(stimulus, "yellowtriangle") ~ "yellowtriangle",
      str_detect(stimulus, "yellowcircle") ~ "yellowcircle",
      str_detect(stimulus, "bluecircle") ~ "bluecircle",
      str_detect(stimulus, "bluetriangle") ~ "bluetriangle"
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
    ),
    stim_chr = case_when(
      str_detect(stimulus, "yellowtriangle") ~ "yellowtriangle",
      str_detect(stimulus, "yellowcircle") ~ "yellowcircle",
      str_detect(stimulus, "bluecircle") ~ "bluecircle",
      str_detect(stimulus, "bluetriangle") ~ "bluetriangle"
    )
  )

glue_data(
  trials01,
  "{{stimulus: {stimulus}, stim_chr: '{stim_chr}', key_answer: '{key_answer}', data: {{rule: '{rule}', type: '{type}', variable: '{variable}', task: '{task}'}}}},"
)

glue_data(
  trials02,
  "{{stimulus: {stimulus}, stim_chr: '{stim_chr}', key_answer: '{key_answer}', data: {{rule: '{rule}', type: '{type}', variable: '{variable}', task: '{task}'}}}},"
)


