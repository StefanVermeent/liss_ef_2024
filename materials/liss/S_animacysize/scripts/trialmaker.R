set.seed(4785)


# Stimulus sets -----------------------------------------------------------

lsm_test_words <- c("egel", "goudvis", "kever", "kikker", "mier",
                    "mug", "muis", "mus", "rat", "rups", "slak", "spin",
                    "vlinder", "wesp", "worm", "kuiken")

lbi_test_words <- c( "beer", "dolfijn", "ezel", "geit", "hert", "ijsbeer",
                     "kameel", "leeuw", "olifant", "ooievaar", "orka",
                     "schaap", "stier", "tijger", "walvis", "wolf")


nlsm_test_words <- c("blik", "bril", "kam", "lepel", "mok", "naald", "pen",
                     "pil", "ring", "schaar", "sok", "speld", "spijker",
                     "stift", "vork", "zeep")


nlbi_test_words <- c("bus", "caravan", "fiets", "iglo",  "kano", "kanon",
                     "matras",  "lantaarn", "piano", "raket", "saxofoon",
                     "tent", "toren", "tractor", "vulkaan", "windmolen")

lsm_test_words <- sample(lsm_test_words, size = 16, replace = F)
lbi_test_words <- sample(lbi_test_words, size = 16, replace = F)
nlsm_test_words <- sample(nlsm_test_words, size = 16, replace = F)
nlbi_test_words <- sample(nlbi_test_words, size = 16, replace = F)

# stimulus set 1
trials01 <- tibble(
  type     = c(rep('repeat',16), rep('switch',16)),
  rule     = c(rep(NA, 32)),
  stimulus = c(lsm_test_words[1:8], lbi_test_words[1:8], nlsm_test_words[1:8], nlbi_test_words[1:8]),
  correct  = c(rep('living_smaller', 8), rep("living_larger",8), rep("nonliving_smaller",8), rep("nonliving_larger",8)),
  variable = "animacysize1",
  task     = "animacysize",
  key_answer = NA
)

trials01 <- trials01 |>
  mutate(
    valid1 = ifelse(type == lag(type,1) & type == lag(type,2) & type == lag(type,3), FALSE, TRUE),
    valid2 = ifelse(type == 'repeat' & lag(type,1) == 'repeat' & lag(type,2) == 'repeat' & lag(type,3) == 'switch', FALSE, TRUE)
  )

n = 1
while(any(c(trials01$valid1, trials01$valid2) == FALSE, na.rm = T)) {
  trials01 <- trials01 |>
    mutate(
      n = sample(1:n(), n(), replace = F)
    ) |>
    arrange(n) |>
    mutate(
      valid1 = ifelse(type == lag(type,1) & type == lag(type,2) & type == lag(type,3), FALSE, TRUE),
      valid2 = ifelse(type == 'repeat' & lag(type,1) == 'repeat' & lag(type,2) == 'repeat' & lag(type,3) == 'switch', FALSE, TRUE)
    )
}

trials01 <- trials01 |>
  add_row(.before = 1, type = "first", rule = "size", stimulus = "gorilla", variable = "animacysize1", task = "animacysize", correct = "living_larger")

n = 1
while(n<=32){
  trials01 <- trials01 |>
    mutate(
      rule = case_when(
        is.na(rule) & type == "repeat" & lag(rule, n=1) == 'animacy' ~ 'animacy',
        is.na(rule) & type == "repeat" & lag(rule, n=1) == 'size' ~ 'size',
        is.na(rule) & type == "switch" & lag(rule, n=1) == 'animacy' ~ 'size',
        is.na(rule) & type == "switch" & lag(rule, n=1) == 'size' ~ 'animacy',
        TRUE ~ rule
      )
    )
  n = n+1
}

trials01 <- trials01 |>
  mutate(
    key_answer = case_when(
      rule == 'size' & str_detect(correct, "larger") ~ 'L',
      rule == 'size' & str_detect(correct, "smaller") ~ 'A',
      rule == 'animacy' & str_detect(correct, "^living") ~ 'A',
      rule == 'animacy' & str_detect(correct, "^nonliving") ~ 'L'
    )
  )



# stimulus set 2
trials02 <- tibble(
  type     = c(rep('repeat',16), rep('switch',16)),
  rule     = c(rep(NA, 32)),
  stimulus = c(lsm_test_words[9:16], lbi_test_words[9:16], nlsm_test_words[9:16], nlbi_test_words[9:16]),
  correct  = c(rep('living_smaller', 8), rep("living_larger",8), rep("nonliving_smaller",8), rep("nonliving_larger",8)),
  variable = "animacysize2",
  task     = "animacysize",
  key_answer = NA
)

trials02 <- trials02 |>
  mutate(
    valid1 = ifelse(type == lag(type,1) & type == lag(type,2) & type == lag(type,3), FALSE, TRUE),
    valid2 = ifelse(type == 'repeat' & lag(type,1) == 'repeat' & lag(type,2) == 'repeat' & lag(type,3) == 'switch', FALSE, TRUE)
  )

n = 1
while(any(c(trials02$valid1, trials02$valid2) == FALSE, na.rm = T)) {
  trials02 <- trials02 |>
    mutate(
      n = sample(1:n(), n(), replace = F)
    ) |>
    arrange(n) |>
    mutate(
      valid1 = ifelse(type == lag(type,1) & type == lag(type,2) & type == lag(type,3), FALSE, TRUE),
      valid2 = ifelse(type == 'repeat' & lag(type,1) == 'repeat' & lag(type,2) == 'repeat' & lag(type,3) == 'switch', FALSE, TRUE)
    )
}

trials02 <- trials02 |>
  add_row(.before = 1, type = "first", rule = "size", stimulus = "knikker", variable = "animacysize2", task = "animacysize", correct = "nonliving_smaller")

n = 1
while(n<=32){
  trials02 <- trials02 |>
    mutate(
      rule = case_when(
        is.na(rule) & type == "repeat" & lag(rule, n=1) == 'animacy' ~ 'animacy',
        is.na(rule) & type == "repeat" & lag(rule, n=1) == 'size' ~ 'size',
        is.na(rule) & type == "switch" & lag(rule, n=1) == 'animacy' ~ 'size',
        is.na(rule) & type == "switch" & lag(rule, n=1) == 'size' ~ 'animacy',
        TRUE ~ rule
      )
    )
  n = n+1
}

trials02 <- trials02 |>
  mutate(
    key_answer = case_when(
      rule == 'size' & str_detect(correct, "larger") ~ 'L',
      rule == 'size' & str_detect(correct, "smaller") ~ 'A',
      rule == 'animacy' & str_detect(correct, "^living") ~ 'A',
      rule == 'animacy' & str_detect(correct, "^nonliving") ~ 'L'
    )
  )

glue_data(
  trials01,
  "{{stimulus: '{stimulus}', key_answer: '{key_answer}', data: {{rule: '{rule}', type: '{type}', variable: '{variable}', task: '{task}'}}}},"
)

glue_data(
  trials02,
  "{{stimulus: '{stimulus}', key_answer: '{key_answer}', data: {{rule: '{rule}', type: '{type}', variable: '{variable}', task: '{task}'}}}},"
)
