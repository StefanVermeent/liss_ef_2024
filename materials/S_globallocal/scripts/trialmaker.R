library(tidyverse)
library(glue)

check_if_same_stim <- function(data) {
  1:nrow(data) |>
    map_chr(function(x) {

      if(x ==1) {
        return(data$stimulus[x])
      }

      current = data$stimulus[x]
      previous = data$stimulus[x-1]
      subsequent = data$stimulus[x+1]

      global_stims <- c('Ge_Lf', 'Ge_Lp', 'Ge_Lt', 'Gh_Lf', 'Gh_Lp', 'Gh_Lt')
      local_stims <-  c('Gf_Le', 'Gf_Lh', 'Gp_Le', 'Gp_Lh', 'Gt_Le', 'Gt_Lh')

      if(current == previous) {
        if(data$rule[x] == "global") {
          current <- sample(global_stims[!global_stims %in% c(subsequent, current)], size = 1)
        }
        if(data$rule[x] == "local") {
          current <- sample(local_stims[!local_stims %in% c(subsequent, current)], size = 1)
        }
      }
      return(current)
    })
}

set.seed(486)

n_block_trials <-  32

stim_vector <- c('Ge_Lf', 'Ge_Lp', 'Ge_Lt', 'Gf_Le', 'Gf_Lh',
'Gh_Lf', 'Gh_Lp', 'Gh_Lt', 'Gp_Le', 'Gp_Lh', 'Gt_Le',
'Gt_Lh')

# stimulus set 1
trials01 <- tibble(
  type     = c('first', sample(c(rep('repeat',n_block_trials/2), rep('switch',n_block_trials/2)), size = n_block_trials, replace = F)),
  rule     = c('global', rep(NA, n_block_trials)),
  variable = "globloc01",
  task     = "globloc01",
  key_answer = NA
)

n = 1
while(n<=32){
  trials01 <- trials01 |>
    mutate(
      rule = case_when(
        is.na(rule) & type == "repeat" & lag(rule,1) == "global" ~ "global",
        is.na(rule) & type == "repeat" & lag(rule,1) == "local" ~ "local",
        is.na(rule) & type == "switch" & lag(rule,1) == "global" ~ "local",
        is.na(rule) & type == "switch" & lag(rule,1) == "local" ~ "global",
        TRUE ~ rule
      )
    )
  n = n+1
}

trials01 <- trials01 |>
  mutate(
    valid1 = ifelse(type == lag(type,1) & type == lag(type,2) & type == lag(type,3), FALSE, TRUE),
    valid2 = ifelse(rule == lag(rule,1) & rule == lag(rule,2) & rule == lag(rule,3), FALSE, TRUE),
  ) |>
  mutate(
    n=1:n(),
    type = ifelse(n==11, "switch", type),
    type = ifelse(n==33, "switch", type),
    type = ifelse(n==2,  "repeat", type),
    type = ifelse(n==8,  "repeat", type)
  )

n = 1
while(n<=32){
  trials01 <- trials01 |>
    mutate(
      rule = case_when(
        type == "repeat" & lag(rule,1) == "global" ~ "global",
        type == "repeat" & lag(rule,1) == "local" ~ "local",
        type == "switch" & lag(rule,1) == "global" ~ "local",
        type == "switch" & lag(rule,1) == "local" ~ "global",
        TRUE ~ rule
      )
    )
  n = n+1
}

trials01 <- trials01 |>
  mutate(
    stimulus = case_when(
      rule == 'global' ~ sample(str_subset(stim_vector, "(Ge|Gh)"), size = 33, replace = T),
      rule == 'local' ~ sample(str_subset(stim_vector, "(Le|Lh)"), size = 33, replace = T)),
    key_answer = case_when(
      rule == 'global' ~ 'A',
      rule == 'local'  ~ 'L'
    )
  ) %>%
  mutate(stimulus = check_if_same_stim(data = .))


# stimulus set 2
trials02 <- tibble(
  type     = c('first', sample(c(rep('repeat',n_block_trials/2), rep('switch',n_block_trials/2)), size = n_block_trials, replace = F)),
  rule     = c('global', rep(NA, n_block_trials)),
  variable = "globloc02",
  task     = "globloc",
  key_answer = NA
)

n = 1
while(n<=32){
  trials02 <- trials02 |>
    mutate(
      rule = case_when(
        is.na(rule) & type == "repeat" & lag(rule,1) == "global" ~ "global",
        is.na(rule) & type == "repeat" & lag(rule,1) == "local" ~ "local",
        is.na(rule) & type == "switch" & lag(rule,1) == "global" ~ "local",
        is.na(rule) & type == "switch" & lag(rule,1) == "local" ~ "global",
        TRUE ~ rule
      )
    )
  n = n+1
}

trials02 <- trials02 |>
  mutate(
    valid1 = ifelse(type == lag(type,1) & type == lag(type,2) & type == lag(type,3), FALSE, TRUE),
    valid2 = ifelse(rule == lag(rule,1) & rule == lag(rule,2) & rule == lag(rule,3), FALSE, TRUE),
  ) |>
  mutate(
    n=1:n(),
    type = ifelse(n==21, "switch", type),
    type = ifelse(n==24, "switch", type),
    type = ifelse(n==31,  "repeat", type),
    type = ifelse(n==34,  "repeat", type)
  )

n = 1
while(n<=32){
  trials02 <- trials02 |>
    mutate(
      rule = case_when(
        type == "repeat" & lag(rule,1) == "global" ~ "global",
        type == "repeat" & lag(rule,1) == "local" ~ "local",
        type == "switch" & lag(rule,1) == "global" ~ "local",
        type == "switch" & lag(rule,1) == "local" ~ "global",
        TRUE ~ rule
      )
    )
  n = n+1
}

trials02 <- trials02 |>
  mutate(
    stimulus = case_when(
      rule == 'global' ~ sample(str_subset(stim_vector, "(Ge|Gh)"), size = 33, replace = T),
      rule == 'local' ~ sample(str_subset(stim_vector, "(Le|Lh)"), size = 33, replace = T)),
    key_answer = case_when(
      rule == 'global' ~ 'A',
      rule == 'local'  ~ 'L'
    )
  ) %>%
  mutate(stimulus = check_if_same_stim(data = .))



glue_data(
  trials01,
  "{{stimulus: {stimulus}, key_answer: '{key_answer}', data: {{rule: '{rule}', type: '{type}', variable: '{variable}', task: '{task}'}}}},"
)

glue_data(
  trials02,
  "{{stimulus: {stimulus}, key_answer: '{key_answer}', data: {{rule: '{rule}', type: '{type}', variable: '{variable}', task: '{task}'}}}},"
)

