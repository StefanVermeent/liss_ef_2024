library(tidyverse)

load('data/pilot_data.RData')


flanker_clean <- flanker_data |>
  filter(variable != "end") |>
  group_by(id, condition) |>
  mutate(
    ex_fast = ifelse(rt < 250, TRUE, FALSE),
    ex_slow = ifelse(scale(rt) |> as.numeric() > 3.2, TRUE, FALSE)
  ) |>
  group_by(id) |>
  mutate(
    ex_chance = ifelse(sum(correct)/n()< .50, TRUE, FALSE)
  ) |>
  filter(ex_fast == FALSE & ex_slow == FALSE & ex_chance == FALSE) |>
  group_by(id, condition) |>
  summarise(
    flanker_RT  = mean(rt, na.rm = T)
  ) |>
  ungroup() |>
  pivot_wider(names_from = 'condition', values_from = 'flanker_RT') |>
  mutate(
    flanker_diff = incongruent - congruent
  ) |>
  select(id, flanker_diff)

colorshape_clean <- colorshape_data |>
  filter(variable != "colorshape_finish", type != "first") |>
  group_by(id, type) |>
  mutate(
    ex_fast = ifelse(rt < 250, TRUE, FALSE),
    ex_slow = ifelse(scale(rt) |> as.numeric() > 3.2, TRUE, FALSE),
    ex_error = ifelse(!correct, TRUE, FALSE),
    ex_preverror = ifelse(lag(correct,1) == FALSE, TRUE, FALSE),
  ) |>
  group_by(id) |>
  mutate(
    ex_chance = ifelse(sum(correct)/n() < .50, TRUE, FALSE)
  ) |>
  filter(ex_fast == FALSE & ex_slow == FALSE, ex_error == FALSE, ex_preverror == FALSE, ex_chance == FALSE) |>
  group_by(id, type) |>
  summarise(
    colorshape_RT  = mean(rt, na.rm = T),
    colorshape_acc = sum(correct) / n() * 100
  ) |>
  pivot_wider(names_from = 'type', values_from = 'colorshape_RT') |>
  mutate(
    colorshape_switchcost = switch - `repeat`
  ) |>
  select(id, colorshape_switchcost) |>
  ungroup()



animacysize_clean <- animacysize_data |>
  filter(variable != "end", condition != "first") |>
  group_by(id, condition) |>
  mutate(
    ex_fast = ifelse(rt < 250, TRUE, FALSE),
    ex_slow = ifelse(scale(rt) |> as.numeric() > 3.2, TRUE, FALSE),
    ex_error = ifelse(!correct, TRUE, FALSE),
    ex_preverror = ifelse(lag(correct,1) == FALSE, TRUE, FALSE),
  ) |>
  group_by(id) |>
  mutate(
    ex_chance = ifelse(sum(correct)/n() < .50, TRUE, FALSE)
  ) |>
  filter(ex_fast == FALSE & ex_slow == FALSE, ex_error == FALSE, ex_preverror == FALSE, ex_chance == FALSE) |>
  group_by(id, condition) |>
  summarise(
    animacysize_RT  = mean(rt, na.rm = T)
  ) |>
  ungroup() |>
  pivot_wider(names_from = 'condition', values_from = 'animacysize_RT') |>
  mutate(
    animacysize_switchcost = switch - `repeat`
  ) |>
  select(id, animacysize_switchcost)




globallocal_clean <- globallocal_data |>
  filter(variable != "end", type != "first") |>
  group_by(id, type) |>
  mutate(
    ex_fast = ifelse(rt < 250, TRUE, FALSE),
    ex_slow = ifelse(scale(rt) |> as.numeric() > 3.2, TRUE, FALSE),
    ex_error = ifelse(!correct, TRUE, FALSE),
    ex_preverror = ifelse(lag(correct,1) == FALSE, TRUE, FALSE),
  ) |>
  group_by(id) |>
  mutate(
    ex_chance = ifelse(sum(correct)/n() < .50, TRUE, FALSE)
  ) |>
  filter(ex_fast == FALSE & ex_slow == FALSE, ex_error == FALSE, ex_preverror == FALSE, ex_chance == FALSE) |>
  group_by(id, type) |>
  summarise(
    globallocal_RT  = mean(rt, na.rm = T),
    globallocal_acc = sum(correct) / n() * 100
  ) |>
  ungroup() |>
  pivot_wider(names_from = 'type', values_from = 'globallocal_RT') |>
  mutate(
    globallocal_switchcost = switch - `repeat`
  ) |>
  select(id, globallocal_switchcost)


simon_clean <- simon_data |>
  filter(variable != "end") |>
  group_by(id, condition) |>
  mutate(
    ex_fast = ifelse(rt < 250, TRUE, FALSE),
    ex_slow = ifelse(scale(rt) |> as.numeric() > 3.2, TRUE, FALSE)
  ) |>
  group_by(id) |>
  mutate(
    ex_chance = ifelse(sum(correct)/n() < .50, TRUE, FALSE)
  ) |>
  filter(ex_fast == FALSE & ex_slow == FALSE & ex_chance == FALSE) |>
  group_by(id, condition) |>
  summarise(
    simon_RT  = mean(rt, na.rm = T)
  ) |>
  pivot_wider(names_from = 'condition', values_from = 'simon_RT') |>
  mutate(
    simon_diff = incongruent - congruent
  ) |>
  select(id, simon_diff)


posner_clean <- posner_data |>
  filter(variable != "end") |>
  group_by(id) |>
  mutate(
    ex_fast = ifelse(rt < 250, TRUE, FALSE),
    ex_slow = ifelse(scale(rt) |> as.numeric() > 3.2, TRUE, FALSE),
    ex_chance = ifelse(sum(correct)/n() < .50, TRUE, FALSE)
  ) |>
  filter(ex_fast == FALSE & ex_slow == FALSE & ex_chance == FALSE) |>
  summarise(
    posner_RT  = mean(rt, na.rm = T)
  ) |>
  group_by(id) |>
  ungroup()



# Bivariate correlations --------------------------------------------------

reduce(
  list(
    animacysize_clean,
    colorshape_clean,
    globallocal_clean,
    flanker_clean,
    simon_clean,
    posner_clean
  ),
  left_join, by = "id"
) |>
  select(-id) |>
  cor(use = "pairwise.complete.obs") |>
  corrplot::corrplot(method = "number")


globallocal_clean <- globallocal_data |>
  filter(variable != "end", type != "first") |>
  group_by(id, type) |>
  mutate(
    ex_fast = ifelse(rt < 250, TRUE, FALSE),
    ex_slow = ifelse(scale(rt) |> as.numeric() > 3.2, TRUE, FALSE),
    ex_error = ifelse(!correct, TRUE, FALSE),
    ex_preverror = ifelse(lag(correct,1) == FALSE, TRUE, FALSE),
  ) |>
  group_by(id) |>
  mutate(
    ex_chance = ifelse(sum(correct)/n() < .50, TRUE, FALSE)
  ) |>
  filter(ex_fast == FALSE & ex_slow == FALSE, ex_error == FALSE, ex_preverror == FALSE, ex_chance == FALSE) |>
  group_by(id, rule) |>
  summarise(
    globallocal_RT  = mean(rt, na.rm = T),
    globallocal_acc = sum(correct) / n() * 100
  ) |>
  ungroup() |>
  pivot_wider(names_from = 'rule', values_from = 'globallocal_RT') |>
  mutate(
    globallocal_switchcost = global - local
  ) |>
  select(id, globallocal_switchcost)


# Condition effects -------------------------------------------------------

t.test(globallocal_clean$globallocal_switchcost, mu = 0)
t.test(data = colorshape_clean, colorshape_RT~type)
t.test(data = animacysize_clean, animacysize_RT~condition)
t.test(data = flanker_clean, flanker_RT~condition)
t.test(data = simon_clean, simon_RT~condition)
