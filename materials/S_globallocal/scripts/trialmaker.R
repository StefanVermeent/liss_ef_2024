library(tidyverse)
library(glue)
set.seed(486)

n_block_trials <-  32

check_if_same_rule <- function(data) {
  1:nrow(data) |> 
    map_chr(function(x) {
      
      if(x %in% c(1,2)) {
        return(data$type[x])
      }
      current <- data$type[x]
      previous <- c(data$type[x-1], data$type[x-2])
      
      if(all(previous == current)) {
        if(current == "repeat") {
          current <- "switch"
        }
      }
      return(current)
    })
}

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
) %>% 
  mutate(type = check_if_same_rule(data = .)) %>%
  mutate(type = check_if_same_rule(data = .)) %>%
  mutate(type = check_if_same_rule(data = .)) %>%
  mutate(type = check_if_same_rule(data = .))

# Generate repeat or switch trials
n = 1
while(n<=n_block_trials){
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


trials01 <- trials01 |> 
  mutate(
    stimulus = case_when(
      rule == 'global' ~ sample(str_subset(stim_vector, "(Ge|Gh)"), size = 33, replace = T), 
      rule == 'local' ~ sample(str_subset(stim_vector, "(Le|Lh)"), size = 33, replace = T)),
    key_answer = case_when(
      rule == 'global' ~ 'g',
      rule == 'local'  ~ 'l'
    )
  ) %>%
  mutate(stimulus = check_if_same_stim(data = .))


# stimulus set 2
trials02 <- tibble(
  type     = c('first', sample(c(rep('repeat',n_block_trials/2), rep('switch',n_block_trials/2)), size = n_block_trials, replace = F)),
  rule     = c('global', rep(NA, n_block_trials)),
  variable = "globloc02",
  task     = "globloc02",
  key_answer = NA
) %>%
  mutate(type = check_if_same_rule(data = .)) %>%
  mutate(type = check_if_same_rule(data = .)) %>%
  mutate(type = check_if_same_rule(data = .)) %>%
  mutate(type = check_if_same_rule(data = .))

# Generate repeat or switch trials
n = 1
while(n<=n_block_trials){
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


trials02 <- trials02 |> 
  mutate(
    stimulus = case_when(
      rule == 'global' ~ sample(str_subset(stim_vector, "(Ge|Gh)"), size = 33, replace = T), 
      rule == 'local' ~ sample(str_subset(stim_vector, "(Le|Lh)"), size = 33, replace = T)),
    key_answer = case_when(
      rule == 'global' ~ 'g',
      rule == 'local'  ~ 'l'
    )
  ) %>%
  mutate(stimulus = check_if_same_stim(data = .)) %>%
  mutate(stimulus = check_if_same_stim(data = .))



# Trial stimulus set
trialsprac <- tibble(
  type     = c('first', sample(c(rep('repeat',5), rep('switch',5)), size = 10, replace = F)),
  rule     = c('global', rep(NA,10)),
  variable = "globloc_prac",
  task     = "globloc_prac",
  key_answer = NA
) 

# Generate repeat or switch trials
n = 1
while(n<=10){
  trialsprac <- trialsprac |> 
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


trialsprac <- trialsprac |> 
  mutate(
    stimulus = case_when(
      rule == 'global' ~ sample(str_subset(stim_vector, "(Ge|Gh)"), size = 11, replace = T), 
      rule == 'local' ~ sample(str_subset(stim_vector, "(Le|Lh)"), size = 11, replace = T)),
    key_answer = case_when(
      rule == 'global' ~ 'g',
      rule == 'local'  ~ 'l'
      
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

glue_data(
  trialsprac,
  "{{stimulus: {stimulus}, key_answer: '{key_answer}', data: {{rule: '{rule}', type: '{type}', variable: '{variable}', task: '{task}'}}}},"
)
