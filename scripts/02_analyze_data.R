library(tidyverse)

load('data/pilot_data.RData')


flanker_clean <- flanker_data |>
  filter(variable != "end") |>
  group_by(id, condition) |>
  mutate(
    ex_fast = ifelse(rt < 250, TRUE, FALSE),
    ex_slow = ifelse(scale(rt) |> as.numeric() > 3.2 | rt > 3000, TRUE, FALSE)
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
  pivot_wider(names_from = 'condition', names_prefix = "flanker_", values_from = 'flanker_RT') |>
  mutate(flanker_diff = flanker_incongruent - flanker_congruent) |>
  select(id, flanker_incongruent, flanker_congruent, flanker_diff)


colorshape_clean <- colorshape_data |>
  filter(variable != "colorshape_finish", type != "first") |>
  group_by(id, type) |>
  mutate(
    ex_fast = ifelse(rt < 250, TRUE, FALSE),
    ex_slow = ifelse(scale(rt) |> as.numeric() > 3.2 | rt > 5000, TRUE, FALSE),
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
  pivot_wider(names_from = 'type', names_prefix = "colorshape_", values_from = 'colorshape_RT') |>
  mutate(colorshape_switchcost = colorshape_switch - colorshape_repeat) |>
  select(id, colorshape_switch, colorshape_repeat, colorshape_switchcost) |>
  ungroup()



animacysize_clean <- animacysize_data |>
  filter(variable != "end", condition != "first") |>
  group_by(id, condition) |>
  mutate(
    ex_fast = ifelse(rt < 250, TRUE, FALSE),
    ex_slow = ifelse(scale(rt) |> as.numeric() > 3.2 | rt > 5000, TRUE, FALSE),
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
  pivot_wider(names_from = 'condition', names_prefix = "animacysize_", values_from = 'animacysize_RT') |>
  mutate(animacysize_switchcost = animacysize_switch - animacysize_repeat) |>
  select(id, animacysize_switch, animacysize_repeat, animacysize_switchcost)




globallocal_clean <- globallocal_data |>
  filter(variable != "end", type != "first") |>
  group_by(id, type) |>
  mutate(
    ex_fast = ifelse(rt < 250, TRUE, FALSE),
    ex_slow = ifelse(scale(rt) |> as.numeric() > 3.2 | rt > 5000, TRUE, FALSE),
    ex_error = ifelse(!correct, TRUE, FALSE),
    ex_preverror = ifelse(lag(correct,1) == FALSE, TRUE, FALSE),
  ) |>
  group_by(id) |>
  mutate(
    ex_chance = ifelse(sum(correct)/n() < .50, TRUE, FALSE)
  ) |>
  filter(ex_fast == FALSE & ex_slow == FALSE, ex_error == FALSE, ex_preverror == FALSE, ex_chance == FALSE) |>
  filter(rt < 5000) |>
  group_by(id, type) |>
  summarise(
    globallocal_RT  = mean(rt, na.rm = T),
    globallocal_acc = sum(correct) / n() * 100
  ) |>
  ungroup() |>
  pivot_wider(names_from = c('type'), names_prefix = "globallocal_", values_from = 'globallocal_RT') |>
  mutate(globallocal_switchcost = globallocal_switch - globallocal_repeat) |>
  select(id, globallocal_switch, globallocal_repeat, globallocal_switchcost)


simon_clean <- simon_data |>
  filter(variable != "end") |>
  group_by(id, condition) |>
  mutate(
    ex_fast = ifelse(rt < 250, TRUE, FALSE),
    ex_slow = ifelse(scale(rt) |> as.numeric() > 3.2 | rt > 3000, TRUE, FALSE)
  ) |>
  group_by(id) |>
  mutate(
    ex_chance = ifelse(sum(correct)/n() < .60, TRUE, FALSE)
  ) |>
  filter(ex_fast == FALSE & ex_slow == FALSE & ex_chance == FALSE) |>
  group_by(id, condition) |>
  summarise(
    simon_RT  = mean(rt, na.rm = T)
  ) |>
  pivot_wider(names_from = 'condition', names_prefix = "simon_", values_from = 'simon_RT') |>
  mutate(simon_diff = simon_incongruent - simon_congruent) |>
  select(id, simon_congruent, simon_incongruent, simon_diff)|>
  ungroup()


posner_clean <- posner_data |>
  filter(variable != "end") |>
  group_by(id) |>
  mutate(
    ex_fast = ifelse(rt < 250, TRUE, FALSE),
    ex_slow = ifelse(scale(rt) |> as.numeric() > 3.2 | rt > 3000, TRUE, FALSE),
    ex_chance = ifelse(sum(correct)/n() < .50, TRUE, FALSE)
  ) |>
  filter(ex_fast == FALSE & ex_slow == FALSE & ex_chance == FALSE) |>
  summarise(
    posner_RT  = mean(rt, na.rm = T)
  ) |>
  ungroup()

globallocal2_clean <- globallocal2_data |>
  filter(variable != "end", condition != "first") |>
  group_by(id, condition) |>
  mutate(
    ex_fast = ifelse(rt < 1250, TRUE, FALSE),
    ex_slow = ifelse(scale(rt) |> as.numeric() > 3.2 | rt > 5000, TRUE, FALSE)
  ) |>
  group_by(id) |>
  mutate(
    ex_chance = ifelse(sum(correct)/n() < .60, TRUE, FALSE)
  ) |>
  filter(ex_fast == FALSE & ex_slow == FALSE, ex_chance == FALSE) |>
  mutate(n = n()) |>
  group_by(id, condition) |>
  summarise(
    globallocal_RT  = mean(rt, na.rm = T),
    globallocal_acc = sum(correct) / n() * 100
  ) |>
  ungroup() |>
  select(-globallocal_acc) |>
  pivot_wider(names_from = c('condition'), names_prefix = "globallocal2_", values_from = 'globallocal_RT') |>
  mutate(globallocal2_switchcost = globallocal2_switch - globallocal2_repeat) |>
  select(id, globallocal2_repeat, globallocal2_switch, globallocal2_switchcost)




# Bivariate correlations --------------------------------------------------

reduce(
  list(
    animacysize_clean,
    colorshape_clean,
    globallocal2_clean,
    flanker_clean,
    simon_clean,
    posner_clean
  ),
  left_join, by = "id"
) |>
  select(
         posner_RT,
         colorshape_switch, animacysize_switch, globallocal2_switch,
         colorshape_repeat, animacysize_repeat, globallocal2_repeat,
         colorshape_switchcost, animacysize_switchcost, globallocal2_switchcost, flanker_diff, simon_diff,
         simon_congruent, flanker_congruent,
         simon_incongruent, flanker_incongruent
         ) |>
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
  mutate(n = n()) |>
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
