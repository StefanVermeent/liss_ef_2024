

set.seed(4785)


# Ecological Stimuli ------------------------------------------------------

# stimulus set 1
trials01 <- tibble(
  type     = c('first', sample(c(rep('repeat',16), rep('switch',16)), size = 32, replace = F)),
  rule     = c('gender', rep(NA, 32)),
  variable = "face_shifting",
  task     = "shifting_eco1",
  stimulus = sample(c('female_happy1', 'female_angry1', 'male_happy1', 'male_angry1'), 33, replace = T),
  key_answer = NA
)

n = 1
while(n<=32){
  trials01 <- trials01 |> 
    mutate(
      rule = case_when(
        is.na(rule) & type == "repeat" & lag(rule, n=1) == 'gender' ~ 'gender',
        is.na(rule) & type == "repeat" & lag(rule, n=1) == 'emotion' ~ 'emotion',
        is.na(rule) & type == "switch" & lag(rule, n=1) == 'gender' ~ 'emotion',
        is.na(rule) & type == "switch" & lag(rule, n=1) == 'emotion' ~ 'gender',
        TRUE ~ rule
      )
    )
  n = n+1
}

trials01 <- trials01 |> 
  mutate(
    key_answer = case_when(
      rule == 'gender' & str_detect(stimulus, "^male") ~ 'ArrowRight',
      rule == 'gender' & str_detect(stimulus, "^female") ~ 'ArrowLeft',
      rule == 'emotion' & str_detect(stimulus, "happy") ~ 'ArrowRight',
      rule == 'emotion' & str_detect(stimulus, "angry") ~ 'ArrowLeft',
    ),
    stimulus = case_when(
      rule == 'gender' & str_detect(stimulus, "^male_happy") ~ 'male_happy_gender1',
      rule == 'gender' & str_detect(stimulus, "^male_angry") ~ 'male_angry_gender1',
      rule == 'emotion' & str_detect(stimulus, "^male_happy") ~ 'male_happy_emotion1',
      rule == 'emotion' & str_detect(stimulus, "^male_angry") ~ 'male_angry_emotion1',
      
      rule == 'gender' & str_detect(stimulus, "^female_happy") ~ 'female_happy_gender1',
      rule == 'gender' & str_detect(stimulus, "^female_angry") ~ 'female_angry_gender1',
      rule == 'emotion' & str_detect(stimulus, "^female_happy") ~ 'female_happy_emotion1',
      rule == 'emotion' & str_detect(stimulus, "^female_angry") ~ 'female_angry_emotion1',
    )
  )


# stimulus set 2
trials02 <- tibble(
  type     = c('first', sample(c(rep('repeat',16), rep('switch',16)), size = 32, replace = F)),
  rule     = c('gender', rep(NA, 32)),
  variable = "face_shifting",
  task     = "shifting_eco2",
  stimulus = sample(c('female_happy2', 'female_angry2', 'male_happy2', 'male_angry2'), 33, replace = T),
  key_answer = NA
)

n = 1
while(n<=32){
  trials02 <- trials02 |> 
    mutate(
      rule = case_when(
        is.na(rule) & type == "repeat" & lag(rule, n=1) == 'gender' ~ 'gender',
        is.na(rule) & type == "repeat" & lag(rule, n=1) == 'emotion' ~ 'emotion',
        is.na(rule) & type == "switch" & lag(rule, n=1) == 'gender' ~ 'emotion',
        is.na(rule) & type == "switch" & lag(rule, n=1) == 'emotion' ~ 'gender',
        TRUE ~ rule
      )
    )
  n = n+1
}

trials02 <- trials02 |> 
  mutate(
    key_answer = case_when(
      rule == 'gender' & str_detect(stimulus, "^male") ~ 'ArrowRight',
      rule == 'gender' & str_detect(stimulus, "^female") ~ 'ArrowLeft',
      rule == 'emotion' & str_detect(stimulus, "happy") ~ 'ArrowRight',
      rule == 'emotion' & str_detect(stimulus, "angry") ~ 'ArrowLeft',
    ),
    stimulus = case_when(
      rule == 'gender' & str_detect(stimulus, "^male_happy") ~ 'male_happy_gender2',
      rule == 'gender' & str_detect(stimulus, "^male_angry") ~ 'male_angry_gender2',
      rule == 'emotion' & str_detect(stimulus, "^male_happy") ~ 'male_happy_emotion2',
      rule == 'emotion' & str_detect(stimulus, "^male_angry") ~ 'male_angry_emotion2',
      
      rule == 'gender' & str_detect(stimulus, "^female_happy") ~ 'female_happy_gender2',
      rule == 'gender' & str_detect(stimulus, "^female_angry") ~ 'female_angry_gender2',
      rule == 'emotion' & str_detect(stimulus, "^female_happy") ~ 'female_happy_emotion2',
      rule == 'emotion' & str_detect(stimulus, "^female_angry") ~ 'female_angry_emotion2',
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


# Abstract Stimuli ------------------------------------------------------

# stimulus set 1
trialsabs01 <- tibble(
  type     = c('first', sample(c(rep('repeat',16), rep('switch',16)), size = 32, replace = F)),
  rule     = c('color', rep(NA, 32)),
  variable = "shape_shifting",
  task     = "shifting_abs1",
  stimulus = sample(c('yellow_circle1', 'yellow_triangle1', 'blue_circle1', 'blue_triangle1'), 33, replace = T),
  key_answer = NA
)

n = 1
while(n<=32){
  trialsabs01 <- trialsabs01 |> 
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

trialsabs01 <- trialsabs01 |> 
  mutate(
    key_answer = case_when(
      rule == 'color' & str_detect(stimulus, "^blue") ~ 'ArrowRight',
      rule == 'color' & str_detect(stimulus, "^yellow") ~ 'ArrowLeft',
      rule == 'shape' & str_detect(stimulus, "circle") ~ 'ArrowRight',
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
    )
  )



# stimulus set 2
trialsabs02 <- tibble(
  type     = c('first', sample(c(rep('repeat',16), rep('switch',16)), size = 32, replace = F)),
  rule     = c('color', rep(NA, 32)),
  variable = "shape_shifting",
  task     = "shifting_abs2",
  stimulus = sample(c('yellow_circle', 'yellow_triangle', 'blue_circle', 'blue_triangle'), 33, replace = T),
  key_answer = NA
)

n = 1
while(n<=32){
  trialsabs02 <- trialsabs02 |> 
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

trialsabs02 <- trialsabs02 |> 
  mutate(
    key_answer = case_when(
      rule == 'color' & str_detect(stimulus, "^blue") ~ 'ArrowRight',
      rule == 'color' & str_detect(stimulus, "^yellow") ~ 'ArrowLeft',
      rule == 'shape' & str_detect(stimulus, "circle") ~ 'ArrowRight',
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
    )
  )

glue_data(
  trialsabs01,
  "{{stimulus: {stimulus}, key_answer: '{key_answer}', data: {{rule: '{rule}', type: '{type}', variable: '{variable}', task: '{task}'}}}},"
)

glue_data(
  trialsabs02,
  "{{stimulus: {stimulus}, key_answer: '{key_answer}', data: {{rule: '{rule}', type: '{type}', variable: '{variable}', task: '{task}'}}}},"
)