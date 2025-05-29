library(tidyverse)
library(furrr)
library(ggsci)
library(patchwork)
library(splithalf)

load("data/clean_data_long.RData")

load('analysis_objects/ddm_flanker_mod1_parsed.RData')
load('analysis_objects/ddm_simon_mod1_parsed.RData')
load('analysis_objects/ddm_colorshape_mod1_parsed.RData')
load('analysis_objects/ddm_animacysize_mod1_parsed.RData')
load('analysis_objects/ddm_globallocal_mod1_parsed.RData')
load('analysis_objects/ddm_posner_mod1_parsed.RData')

load('analysis_objects/rhat_flanker_mod1.RData')
load('analysis_objects/rhat_simon_mod1.RData')
load('analysis_objects/rhat_colorshape_mod1.RData')
load('analysis_objects/rhat_animacysize_mod1.RData')
load('analysis_objects/rhat_globallocal_mod1.RData')
load('analysis_objects/rhat_posner_mod1.RData')

load('analysis_objects/results_confirmatory.RData')


load("data/ddm_clean.RData")
ddm_raw <-  read_csv("data/ddm_raw.csv")
stai_noise <- haven::read_sav('data/L_CognitiveAdversity_1.0p.sav')
iv_data <- read_csv('data/liss_data/full_data.csv')


theme_set(
  theme_classic() +
  theme(
  axis.text = element_text(size = 10),
  axis.title = element_text(size = 10),
  legend.title = element_blank(),
  legend_text = element_text(size = 10),

  )
)


# 1. IV histograms --------------------------------------------------------


hist_data <- iv_data |>
  select(live_off_income_m, finan_trouble_m, curr_situation_m, p_scar_m,
         neigh_thr_m, neigh_thr02_m, vict_sum, threat_comp,
         child_dep, child_thr, child_adv)

## 1.1 Material deprivation ----

live_off_income_m_hist <- hist_data |>
  select(live_off_income_m) |>
  ggplot(aes(live_off_income_m)) +
  geom_histogram() +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 11, 1)) +
  labs(
    x = "How hard or how easy it is for you to\nlive off the income of your household?",
    y = "Frequency"
  )


finan_trouble_m_hist <- hist_data |>
  select(finan_trouble_m) |>
  ggplot(aes(finan_trouble_m)) +
  geom_histogram() +
  theme_classic() +
  # scale_x_continuous(breaks = seq(0, 6, 1)) +
  xlim(c(0,6)) +
  labs(
    x = "With which of the following issues are you\nor are you not confronted at present?",
    y = "Frequency"
  )

curr_situation_m_hist <- hist_data |>
  select(curr_situation_m) |>
  ggplot(aes(curr_situation_m)) +
  geom_histogram() +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 11, 1)) +
  labs(
    x = "How would you describe the financial situation\nof your household at this moment?",
    y = "Frequency"
  )


p_scar_m_hist <- hist_data |>
  select(p_scar_m) |>
  ggplot(aes(p_scar_m)) +
  geom_histogram() +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 11, 1)) +
  labs(
    x = "Material deprivation compositite",
    y = "Frequency"
  )


p_scar_m_combn_hist <- (live_off_income_m_hist + finan_trouble_m_hist) /
  (curr_situation_m_hist + p_scar_m_hist)

## 1.2 Threat ----

nvs_hist <- hist_data |>
  select(neigh_thr02_m) |>
  ggplot(aes(neigh_thr02_m)) +
  geom_histogram() +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 11, 1)) +
  labs(
    x = "Neighborhood Violence Scale",
    y = "Frequency"
  )


neigh_hist <- hist_data |>
  select(neigh_thr_m) |>
  ggplot(aes(neigh_thr_m)) +
  geom_histogram() +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 11, 1)) +
  labs(
    x = "Neighborhood Safety",
    y = "Frequency"
  )

vict_hist <- hist_data |>
  select(vict_sum) |>
  ggplot(aes(vict_sum)) +
  geom_histogram() +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 11, 1)) +
  labs(
    x = "Crime victimization",
    y = "Frequency"
  )


threat_comp_hist <- hist_data |>
  select(threat_comp) |>
  ggplot(aes(threat_comp)) +
  geom_histogram() +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 11, 1)) +
  labs(
    x = "Threat composite",
    y = "Frequency"
  )

threat_combn_hist <-
  (nvs_hist + neigh_hist) /
  (vict_hist + threat_comp_hist)

## 1.3 Childhood adversity ----

ch_dep_hist <- hist_data |>
  select(child_dep) |>
  ggplot(aes(child_dep)) +
  geom_histogram(bins = 100) +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 11, 1)) +
  labs(
    x = "Childhood deprivation",
    y = "Frequency"
  )


ch_thr_hist <- hist_data |>
  select(child_thr) |>
  ggplot(aes(child_thr)) +
  geom_histogram() +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 11, 1)) +
  labs(
    x = "Childhood threat",
    y = "Frequency"
  )

ch_adv_hist <- hist_data |>
  select(child_adv) |>
  ggplot(aes(child_adv)) +
  geom_histogram() +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 11, 1)) +
  labs(
    x = "Childhood adversity\n(threat and deprivation combined)",
    y = "Frequency"
  )

child_adv_combn_hist <-
  (ch_dep_hist + ch_thr_hist) /
  (ch_adv_hist)

save(p_scar_m_combn_hist, threat_combn_hist, child_adv_combn_hist, file = "analysis_objects/iv_histograms.RData")

# 1. RT Histograms --------------------------------------------------------

flanker_rt_hist <- flanker_clean |>
  group_by(nomem_encr, condition) |>
  summarise(rt = mean(rt)) |>
  mutate(condition = ifelse(condition == "1", "Congruent", "Incongruent")) |>
  mutate(condition = factor(condition)) |>
  ggplot(aes(rt, color = condition, fill = condition)) +
  geom_density(alpha = 0.5) +
  scale_x_continuous(breaks = seq(0, 5, 0.5)) +
  scale_color_uchicago() +
  scale_fill_uchicago() +
  theme_classic() +
  labs(
    title = "Flanker task",
    x = "Response time"
  )

simon_rt_hist <- simon_clean |>
  group_by(nomem_encr, condition) |>
  summarise(rt = mean(rt)) |>
  mutate(condition = ifelse(condition == "1", "Congruent", "Incongruent")) |>
  mutate(condition = factor(condition)) |>
  ggplot(aes(rt, color = condition, fill = condition)) +
  geom_density(alpha = 0.5) +
  scale_x_continuous(breaks = seq(0, 5, 0.5)) +
  scale_color_uchicago() +
  scale_fill_uchicago() +
  theme_classic() +
  labs(
    title = "Simon task",
    x = "Response time"
  )

colorshape_rt_hist <- colorshape_clean |>
  group_by(nomem_encr, condition) |>
  summarise(rt = mean(rt)) |>
  mutate(condition = ifelse(condition == "1", "Repeat", "Switch")) |>
  mutate(condition = factor(condition)) |>
  ggplot(aes(rt, color = condition, fill = condition)) +
  geom_density(alpha = 0.5) +
  scale_x_continuous(breaks = seq(0, 5, 1)) +
  scale_color_uchicago() +
  scale_fill_uchicago() +
  theme_classic() +
  labs(
    title = "Color-shape task",
    x = "Response time"
  )

animacysize_rt_hist <- animacysize_clean |>
  group_by(nomem_encr, condition) |>
  summarise(rt = mean(rt)) |>
  mutate(condition = ifelse(condition == "1", "Repeat", "Switch")) |>
  mutate(condition = factor(condition)) |>
  ggplot(aes(rt, color = condition, fill = condition)) +
  geom_density(alpha = 0.5) +
  scale_x_continuous(breaks = seq(0, 5, 1)) +
  scale_color_uchicago() +
  scale_fill_uchicago() +
  theme_classic() +
  labs(
    title = "Animacy-size task",
    x = "Response time"
  )

globallocal_rt_hist <- globallocal_clean |>
  group_by(nomem_encr, condition) |>
  summarise(rt = mean(rt)) |>
  mutate(condition = ifelse(condition == "1", "Repeat", "Switch")) |>
  mutate(condition = factor(condition)) |>
  ggplot(aes(rt, color = condition, fill = condition)) +
  geom_density(alpha = 0.5) +
  scale_x_continuous(breaks = seq(0, 5, 0.5)) +
  scale_color_uchicago() +
  scale_fill_uchicago() +
  theme_classic() +
  labs(
    title = "Global-local task",
    x = "Response time"
  )

posner_rt_hist <- posner_clean |>
  group_by(nomem_encr, task) |>
  summarise(rt = mean(rt)) |>
  ggplot(aes(rt, color = task, fill = task)) +
  geom_density(alpha = 0.5) +
  scale_x_continuous(breaks = seq(0, 5, 0.5)) +
  scale_color_uchicago() +
  scale_fill_uchicago() +
  guides(color = 'none',
        fill = 'none') +
  theme_classic() +
  labs(
    title = "Posner task",
    x = "Response time"
  )

supp_fig_rt_hist <- (flanker_rt_hist + simon_rt_hist) /
(colorshape_rt_hist + animacysize_rt_hist) /
(globallocal_rt_hist + posner_rt_hist)


# 2. Accuracy Histograms --------------------------------------------------

flanker_acc_hist <- flanker_clean |>
  group_by(nomem_encr, condition) |>
  summarise(acc = sum(correct==1)/n()*100) |>
  mutate(condition = ifelse(condition == "1", "Congruent", "Incongruent")) |>
  mutate(condition = factor(condition)) |>
  ggplot(aes(acc, color = condition, fill = condition)) +
  geom_density(alpha = 0.5) +
  scale_color_uchicago() +
  scale_fill_uchicago() +
  theme_classic() +
  labs(
    title = "Flanker task",
    x = "Accuracy"
  )

simon_acc_hist <- simon_clean |>
  group_by(nomem_encr, condition) |>
  summarise(acc = sum(correct==1)/n()*100) |>
  mutate(condition = ifelse(condition == "1", "Congruent", "Incongruent")) |>
  mutate(condition = factor(condition)) |>
  ggplot(aes(acc, color = condition, fill = condition)) +
  geom_density(alpha = 0.5) +
  scale_color_uchicago() +
  scale_fill_uchicago() +
  theme_classic() +
  labs(
    title = "Simon task",
    x = "Accuracy"
  )

colorshape_acc_hist <- colorshape_clean |>
  group_by(nomem_encr, condition) |>
  summarise(acc = sum(correct==1)/n()*100) |>
  mutate(condition = ifelse(condition == "1", "Congruent", "Incongruent")) |>
  mutate(condition = factor(condition)) |>
  ggplot(aes(acc, color = condition, fill = condition)) +
  geom_density(alpha = 0.5) +
  scale_color_uchicago() +
  scale_fill_uchicago() +
  theme_classic() +
  labs(
    title = "Color-shape task",
    x = "Accuracy"
  )

animacysize_acc_hist <- animacysize_clean |>
  group_by(nomem_encr, condition) |>
  summarise(acc = sum(correct==1)/n()*100) |>
  mutate(condition = ifelse(condition == "1", "Congruent", "Incongruent")) |>
  mutate(condition = factor(condition)) |>
  ggplot(aes(acc, color = condition, fill = condition)) +
  geom_density(alpha = 0.5) +
  scale_color_uchicago() +
  scale_fill_uchicago() +
  theme_classic() +
  labs(
    title = "Animacy-size task",
    x = "Accuracy"
  )

globallocal_acc_hist <- globallocal_clean |>
  group_by(nomem_encr, condition) |>
  summarise(acc = sum(correct==1)/n()*100) |>
  mutate(condition = ifelse(condition == "1", "Congruent", "Incongruent")) |>
  mutate(condition = factor(condition)) |>
  ggplot(aes(acc, color = condition, fill = condition)) +
  geom_density(alpha = 0.5) +
  scale_color_uchicago() +
  scale_fill_uchicago() +
  theme_classic() +
  labs(
    title = "Global-Local task",
    x = "Accuracy"
  )

posner_acc_hist <- posner_clean |>
  group_by(nomem_encr, task) |>
  summarise(acc = sum(correct==1)/n()*100) |>
  ggplot(aes(acc, color =task, fill = task)) +
  geom_density(alpha = 0.5) +
  scale_color_uchicago() +
  scale_fill_uchicago() +
  theme_classic() +
  labs(
    title = "Posner task",
    x = "Accuracy"
  )

supp_fig_acc_hist <- (flanker_acc_hist + simon_acc_hist) /
  (colorshape_acc_hist + animacysize_acc_hist) /
  (globallocal_acc_hist + posner_acc_hist)



# 3. Condition manipulation checks ----------------------------------------

man_checks <- list(flanker_clean, simon_clean, colorshape_clean,
     globallocal_clean, animacysize_clean) |>
  map(function(x){
    task <- x |> pull(task) |> unique()
      x |>
        group_by(nomem_encr, condition) |>
        summarise(mean_rt = mean(rt)) |>
        mutate(mean_rt = log(mean_rt)) |>
        ungroup() |>
        pivot_wider(names_from = 'condition', values_from = 'mean_rt') %>%
        summarise(ttest = list(t.test(.$`1`, .$`2`, paired = TRUE) |> broom::tidy())) |>
        mutate(task = task)
  }) |>
  bind_rows() |>
  unnest(ttest) |>
  select(task, estimate, statistic, p.value) |>
  mutate(
    statistic = abs(statistic) %>% formatC(., digits = 2, width = 2, format = 'f'),
    estimate  = abs(estimate) %>% formatC(., digits = 2, width = 2, format = 'f'),
    p.value   = ifelse(p.value < .001, "< .001", p.value)
    ) |>
  mutate(

    task = case_when(
      task == "flanker" ~ "Flanker task",
      task == "simon" ~ "Simon task",
      task == "colorshape" ~ "Color-shape task",
      task == "animacysize" ~ "Animacy-size task",
      task == "globallocal2" ~ "Global-local task",
      task == "posner" ~ "Posner task"
    )
  ) |>
  rename(
    Task     = task,
    Estimate = estimate,
    t        = statistic,
    p        = p.value
  )



# 3. Split-half reliabilities of cognitive measures -----------------------

cores <- parallel::detectCores()

plan(multisession, workers = cores - 2)

sh_rel_rt <- list(flanker_clean, simon_clean, colorshape_clean, animacysize_clean, globallocal_clean, posner_clean |> select(-condition)) |>
  furrr::future_map(function(x){

    if("condition" %in% names(x)) {
    result <- x |>
       filter(correct == 1) |>
       select(nomem_encr, rt, task, condition) |>
       splithalf(
         outcome = "RT",
         score = "average",
         halftype = "random",
         conditionlist = c("1", "2"),
         var.RT = "rt",
         var.condition = "condition",
         var.participant = "nomem_encr"
        )
    } else {
      result <- x |>
        filter(correct == 1) |>
        select(nomem_encr, rt, task) |>
        splithalf(
          outcome = "RT",
          score = "average",
          halftype = "random",
          var.RT = "rt",
          var.participant = "nomem_encr"
        )
    }

    task <- result$data |> pull(task) |> unique()
    result <- result$final_estimates |>
      mutate(task = task)

    return(result)

  }, .options = furrr_options(seed = TRUE)) |>
  bind_rows()

sh_rel_rt_table <- sh_rel_rt %>%
  mutate(
    across(c(`95_low`, `95_high`, SB_low, SB_high, splithalf, spearmanbrown), ~formatC(x = ., digits = 2, width = 2, format = 'f')),
    sh_ci = paste0(splithalf, " ", "[", `95_low`, ", ", `95_high`, "]"),
    sb_ci = paste0(spearmanbrown, " ", "[", `SB_low`, ", ", `SB_high`, "]"),
    condition = ifelse(condition %in% c("1", "all"), "congruent/repeat", "incongruent/switch")
  ) |>
  select(task, condition, sh_ci, sb_ci) |>
  pivot_wider(names_from = "condition", values_from = c(sh_ci, sb_ci)) |>
  mutate(
    task = case_when(
      task == "flanker" ~ "Flanker task",
      task == "simon" ~ "Simon task",
      task == "colorshape" ~ "Color-shape task",
      task == "animacysize" ~ "Animacy-size task",
      task == "globallocal2" ~ "Global-local task",
      task == "posner" ~ "Posner task"
    )
  )


sh_rel_acc <- list(flanker_clean, simon_clean, colorshape_clean, animacysize_clean, globallocal_clean, posner_clean |> select(-condition)) |>
  furrr::future_map(function(x){

    if("condition" %in% names(x)) {
      result <- x |>
        select(nomem_encr, correct, task, condition) |>
        splithalf(
          outcome = "accuracy",
          score = "average",
          halftype = "random",
          conditionlist = c("1", "2"),
          var.ACC = "correct",
          var.condition = "condition",
          var.participant = "nomem_encr"
        )
    } else {
      result <- x |>
        select(nomem_encr, correct, task) |>
        splithalf(
          outcome = "accuracy",
          score = "average",
          halftype = "random",
          var.ACC = "correct",
          var.participant = "nomem_encr"
        )
    }
    task <- result$data |> pull(task) |> unique()
    result <- result$final_estimates |>
      mutate(task = task)

    return(result)
  }, .options = furrr_options(seed = TRUE)) |>
  bind_rows()

sh_rel_acc_table <- sh_rel_acc %>%
  mutate(
    across(c(`95_low`, `95_high`, SB_low, SB_high, splithalf, spearmanbrown), ~formatC(x = ., digits = 2, width = 2, format = 'f')),
    sh_ci = paste0(splithalf, " ", "[", `95_low`, ", ", `95_high`, "]"),
    sb_ci = paste0(spearmanbrown, " ", "[", `SB_low`, ", ", `SB_high`, "]"),
    condition = ifelse(condition %in% c("1", "all"), "congruent/repeat", "incongruent/switch")
  ) |>
  select(task, condition, sh_ci, sb_ci) |>
  pivot_wider(names_from = "condition", values_from = c(sh_ci, sb_ci)) |>
  mutate(
    task = case_when(
      task == "flanker" ~ "Flanker task",
      task == "simon" ~ "Simon task",
      task == "colorshape" ~ "Color-shape task",
      task == "animacysize" ~ "Animacy-size task",
      task == "globallocal2" ~ "Global-local task",
      task == "posner" ~ "Posner task"
    )
  )


save(supp_fig_acc_hist, supp_fig_rt_hist, man_checks, sh_rel_rt_table, sh_rel_acc_table, file = "analysis_objects/task_reliability.RData")


# 4. Distributions of DDM parameters --------------------------------------

hist_v <- ddm_clean |>
  select(ends_with('v')) |>
  pivot_longer(everything(), names_to = "parameter", values_to = "value") |>
  separate(parameter, into = c("task", "condition", "parameter"), sep = "_") |>
  mutate(
    task = case_when(
      task == "as" ~ "Animacy-size",
      task == "cs" ~ "Color-shape",
      task == "gl" ~ "Global-local",
      task == "pos" ~ "Posner",
      TRUE ~ task
    ),
    task = str_to_sentence(task)
  ) %>%
  unite(col = "task", c("task", "condition"), sep = " - ") |>
  mutate(
    task = ifelse(task == "Posner - v", "Posner", task),
    task = factor(task, levels = c(
      "Flanker - con",
      "Flanker - inc",
      "Simon - con",
      "Simon - inc",
      "Color-shape - rep",
      "Color-shape - sw",
      "Global-local - rep",
      "Global-local - sw",
      "Animacy-size - rep",
      "Animacy-size - sw",
      "Posner"))
  ) |>
  ggplot(aes(value)) +
  geom_histogram(bins = 100) +
  facet_wrap(~task, ncol = 2, axes = "all") +
  theme_classic() +
  labs(
    x = "Drift rate",
    y = "Frequency"
  )


hist_a <- ddm_clean |>
  select(ends_with('a')) |>
  pivot_longer(everything(), names_to = "parameter", values_to = "value") |>
  separate(parameter, into = c("task", "condition", "parameter"), sep = "_") |>
  mutate(
    task = case_when(
      task == "as" ~ "Animacy-size",
      task == "cs" ~ "Color-shape",
      task == "gl" ~ "Global-local",
      task == "pos" ~ "Posner",
      TRUE ~ task
    ),
    task = str_to_sentence(task)
  ) %>%
  unite(col = "task", c("task", "condition"), sep = " - ") |>
  mutate(
    task = ifelse(task == "Posner - a", "Posner", task),
    task = factor(task, levels = c(
      "Flanker - con",
      "Flanker - inc",
      "Simon - con",
      "Simon - inc",
      "Color-shape - rep",
      "Color-shape - sw",
      "Global-local - rep",
      "Global-local - sw",
      "Animacy-size - rep",
      "Animacy-size - sw",
      "Posner"))
  ) |>
  ggplot(aes(value)) +
  geom_histogram(bins = 100) +
  facet_wrap(~task, ncol = 2, axes = "all") +
  theme_classic() +
  labs(
    x = "Boundary separation",
    y = "Frequency"
  )


hist_t <- ddm_clean |>
  select(ends_with('t')) |>
  pivot_longer(everything(), names_to = "parameter", values_to = "value") |>
  separate(parameter, into = c("task", "condition", "parameter"), sep = "_") |>
  mutate(
    task = case_when(
      task == "as" ~ "Animacy-size",
      task == "cs" ~ "Color-shape",
      task == "gl" ~ "Global-local",
      task == "pos" ~ "Posner",
      TRUE ~ task
    ),
    task = str_to_sentence(task)
  ) %>%
  unite(col = "task", c("task", "condition"), sep = " - ") |>
  mutate(
    task = ifelse(task == "Posner - t", "Posner", task),
    task = factor(task, levels = c(
      "Flanker - con",
      "Flanker - inc",
      "Simon - con",
      "Simon - inc",
      "Color-shape - rep",
      "Color-shape - sw",
      "Global-local - rep",
      "Global-local - sw",
      "Animacy-size - rep",
      "Animacy-size - sw",
      "Posner"))
  ) |>
  ggplot(aes(value)) +
  geom_histogram(bins = 100) +
  facet_wrap(~task, ncol = 2, axes = "all") +
  theme_classic() +
  labs(
    x = "Non-decision time",
    y = "Frequency"
  )

save(hist_v, hist_a, hist_t, file = "analysis_objects/ddm_histograms.RData")

# 5. HDDM model fit -------------------------------------------------------

## 5.1 Traces ----

flanker_fit_trace <- flanker_mod1_traces |>
  mutate(parameter = case_when(
    parameter == "a1" ~ "Bound. sep. - Con",
    parameter == "a2" ~ "Bound. sep. - Inc",
    parameter == "t1" ~ "Non-dec. time - Con",
    parameter == "t2" ~ "Non-dec. time - Inc",
    parameter == "v1" ~ "Drift rate - Con",
    parameter == "v2" ~ "Drift rate - Inc",
  )) |>
  ggplot(aes(n, value, color = factor(chains))) +
  geom_line() +
  facet_wrap(~parameter, scales = 'free') +
  theme_classic() +
  scale_color_uchicago() +
  guides(color = 'none') +
  labs(
    x = "",
    y = "",
    color = "Chain"
  )


simon_fit_trace <- simon_mod1_traces |>
  mutate(parameter = case_when(
    parameter == "a1" ~ "Bound. sep. - Con",
    parameter == "a2" ~ "Bound. sep. - Inc",
    parameter == "t1" ~ "Non-dec. time - Con",
    parameter == "t2" ~ "Non-dec. time - Inc",
    parameter == "v1" ~ "Drift rate - Con",
    parameter == "v2" ~ "Drift rate - Inc",
  )) |>
  ggplot(aes(n, value, color = factor(chains))) +
  geom_line() +
  facet_wrap(~parameter, scales = 'free') +
  theme_classic() +
  scale_color_uchicago() +
  guides(color = 'none') +
  labs(
    x = "",
    y = "",
    color = "Chain"
  )

colorshape_fit_trace <- colorshape_mod1_traces |>
  mutate(parameter = case_when(
    parameter == "a1" ~ "Bound. sep. - Con",
    parameter == "a2" ~ "Bound. sep. - Inc",
    parameter == "t1" ~ "Non-dec. time - Con",
    parameter == "t2" ~ "Non-dec. time - Inc",
    parameter == "v1" ~ "Drift rate - Con",
    parameter == "v2" ~ "Drift rate - Inc",
  )) |>
  ggplot(aes(n, value, color = factor(chains))) +
  geom_line() +
  facet_wrap(~parameter, scales = 'free') +
  theme_classic() +
  scale_color_uchicago() +
  guides(color = 'none') +
  labs(
    x = "",
    y = "",
    color = "Chain"
  )

animacysize_fit_trace <- animacysize_mod1_traces |>
  mutate(parameter = case_when(
    parameter == "a1" ~ "Bound. sep. - Con",
    parameter == "a2" ~ "Bound. sep. - Inc",
    parameter == "t1" ~ "Non-dec. time - Con",
    parameter == "t2" ~ "Non-dec. time - Inc",
    parameter == "v1" ~ "Drift rate - Con",
    parameter == "v2" ~ "Drift rate - Inc",
  )) |>
  ggplot(aes(n, value, color = factor(chains))) +
  geom_line() +
  facet_wrap(~parameter, scales = 'free') +
  theme_classic() +
  scale_color_uchicago() +
  guides(color = 'none') +
  labs(
    x = "",
    y = "",
    color = "Chain",
  )

globallocal_fit_trace <- globallocal_mod1_traces |>
  mutate(parameter = case_when(
    parameter == "a1" ~ "Bound. sep. - Con",
    parameter == "a2" ~ "Bound. sep. - Inc",
    parameter == "t1" ~ "Non-dec. time - Con",
    parameter == "t2" ~ "Non-dec. time - Inc",
    parameter == "v1" ~ "Drift rate - Con",
    parameter == "v2" ~ "Drift rate - Inc",
  )) |>
  ggplot(aes(n, value, color = factor(chains))) +
  geom_line() +
  facet_wrap(~parameter, scales = 'free') +
  theme_classic() +
  scale_color_uchicago() +
  guides(color = 'none') +
  labs(
    x = "",
    y = "",
    color = "Chain",
  )

posner_fit_trace <- posner_mod1_traces |>
  mutate(parameter = case_when(
    parameter == "a" ~ "Bound. sep.",
    parameter == "t0" ~ "Non-dec. time",
    parameter == "v" ~ "Drift rate",
  )) |>
  ggplot(aes(n, value, color = factor(chains))) +
  geom_line() +
  facet_wrap(~parameter, scales = 'free') +
  theme_classic() +
  scale_color_uchicago() +
  guides(color = 'none') +
  labs(
    x = "",
    y = "",
    color = "Chain",
  )

## 5.2 R^ values ----

rhat <-
  tribble(
    ~task,               ~rhat,
    "Flanker task",      max(rhat_flanker_mod1$`Point est.`, na.rm = T),
    "Simon task",        max(rhat_simon_mod1$`Point est.`, na.rm = T),
    "Color-shape task",  max(rhat_colorshape_mod1$`Point est.`, na.rm = T),
    "Animacy-size task", max(rhat_animacysize_mod1$`Point est.`, na.rm = T),
    "Global-local task", max(rhat_globallocal_mod1$`Point est.`, na.rm = T),
    "Posner task",       max(rhat_posner_mod1$`Point est.`, na.rm = T),
  ) |>
  mutate(rhat = formatC(x = rhat, digits = 3, width = 3, flag = "0", format = 'f'))

## 5.3 Model fit statistics ----

ddm_fit_table <- bind_rows(
  flanker_mod1_fit |>
    mutate(condition = ifelse(condition == "1", "Congruent", "Incongruent")) |>
    group_by(condition, percentile) |>
    summarise(
      r_RT = cor(RT_sim, RT),
      r_acc = cor(acc_sim, acc)) |>
    ungroup() |>
    mutate(task = 'Flanker task'),
  simon_mod1_fit |>
    mutate(condition = ifelse(condition == "1", "Congruent", "Incongruent")) |>
    group_by(condition, percentile) |>
    summarise(
      r_RT = cor(RT_sim, RT),
      r_acc = cor(acc_sim, acc)) |>
    ungroup() |>
    mutate(task = 'Simon task'),
  colorshape_mod1_fit |>
    mutate(condition = ifelse(condition == "1", "Repeat", "Switch")) |>
    group_by(condition, percentile) |>
    summarise(
      r_RT = cor(RT_sim, RT),
      r_acc = cor(acc_sim, acc)) |>
    ungroup() |>
    mutate(task = 'Color-shape task'),
  animacysize_mod1_fit |>
    mutate(condition = ifelse(condition == "1", "Repeat", "Switch")) |>
    group_by(condition, percentile) |>
    summarise(
      r_RT = cor(RT_sim, RT),
      r_acc = cor(acc_sim, acc)) |>
    ungroup() |>
    mutate(task = 'Animacy-size task'),
  globallocal_mod1_fit |>
    mutate(condition = ifelse(condition == "1", "Repeat", "Switch")) |>
    group_by(condition, percentile) |>
    summarise(
      r_RT = cor(RT_sim, RT),
      r_acc = cor(acc_sim, acc)) |>
    ungroup() |>
    mutate(task = 'Global-local task'),
  posner_mod1_fit |>
    group_by(percentile) |>
    summarise(
      r_RT = cor(RT_sim, RT),
      r_acc = cor(acc_sim, acc)) |>
    ungroup() |>
    mutate(task = 'Posner task')
) |>
  pivot_wider(names_from = 'percentile', values_from = c('r_RT', 'r_acc')) |>
  select(task, condition, contains("RT_RT"), r_acc_RT_25) %>%
  mutate(across(-c(task, condition), ~formatC(x = ., digits = 2, width = 3, flag = "0", format = 'f'))) |>
  left_join(rhat) |>
  flextable::flextable() |>
  flextable::autofit() |>
  flextable::set_header_labels(
    task = "Task",
    condition = 'Condition',
    r_RT_RT_25 = "RT - 25th Percentile",
    r_RT_RT_50 = "RT - 50th Percentile",
    r_RT_RT_75 = "RT - 75th Percentile",
    r_acc_RT_25 = "Accuracy",
    rhat        = "R^"
  )

save(posner_fit_trace, flanker_fit_trace, simon_fit_trace, colorshape_fit_trace, animacysize_fit_trace, globallocal_fit_trace, ddm_fit_table, file = "analysis_objects/hddm_model_fit")



# 6. Correlations between DDM parameters ----------------------------------

ddm_cor <- ddm_clean |>
  select(ends_with("_v"), ends_with("_a"), ends_with("_t")
  ) %>%
  rename_with(.cols = matches("_v"), ~str_replace_all(string = ., pattern = "con_v", replacement = "Congruent__driftrate")) %>%
  rename_with(.cols = matches("_v"), ~str_replace_all(string = ., pattern = "inc_v", replacement = "Incongruent__driftrate")) %>%
  rename_with(.cols = matches("_v"), ~str_replace_all(string = ., pattern = "rep_v", replacement = "Repeat__driftrate")) %>%
  rename_with(.cols = matches("_v"), ~str_replace_all(string = ., pattern = "sw_v", replacement = "Switch__driftrate")) %>%
  rename_with(.cols = matches("_v"), ~str_replace_all(string = ., pattern = "pos_v", replacement = "Posner_NA__driftrate")) %>%

  rename_with(.cols = matches("_a"), ~str_replace_all(string = ., pattern = "con_a", replacement = "Congruent__boundary")) %>%
  rename_with(.cols = matches("_a"), ~str_replace_all(string = ., pattern = "inc_a", replacement = "Incongruent__boundary")) %>%
  rename_with(.cols = matches("_a"), ~str_replace_all(string = ., pattern = "rep_a", replacement = "Repeat__boundary")) %>%
  rename_with(.cols = matches("_a"), ~str_replace_all(string = ., pattern = "sw_a", replacement = "Switch__boundary")) %>%
  rename_with(.cols = matches("_a"), ~str_replace_all(string = ., pattern = "pos_a", replacement = "Posner_NA__boundary")) %>%

  rename_with(.cols = matches("_t"), ~str_replace_all(string = ., pattern = "con_t", replacement = "Congruent__Nondec")) %>%
  rename_with(.cols = matches("_t"), ~str_replace_all(string = ., pattern = "inc_t", replacement = "Incongruent__Nondec")) %>%
  rename_with(.cols = matches("_t"), ~str_replace_all(string = ., pattern = "rep_t", replacement = "Repeat__Nondec")) %>%
  rename_with(.cols = matches("_t"), ~str_replace_all(string = ., pattern = "sw_t", replacement = "Switch__Nondec")) %>%
  rename_with(.cols = matches("_t"), ~str_replace_all(string = ., pattern = "pos_t", replacement = "Posner_NA__Nondec")) %>%

  rename_with(.cols = matches("^cs_"), ~str_replace_all(string = ., pattern = "^cs_", replacement = "Color-shape_")) %>%
  rename_with(.cols = matches("^as_"), ~str_replace_all(string = ., pattern = "^as_", replacement = "Animacy-size_")) %>%
  rename_with(.cols = matches("^gl_"), ~str_replace_all(string = ., pattern = "^gl_", replacement = "Global-local_")) %>%
  corr_table(
    use = "pairwise.complete.obs",
    sample_size = F,
    method = "spearman",
    stats = NA,
    numbered = T,
    flagged = F
  ) |>
  separate_wider_delim("Variable", "__", names = c("Variable", "Parameter")) |>
  add_row(Variable = "Drift rates", .before = 1) |>
  add_row(Variable = "Boundary separations", .before = 13) |>
  add_row(Variable = "Non-decision times", .before = 25) %>%
  mutate(
    Variable = Variable %>% str_replace_all("_", " ") %>% str_remove("NA") %>% str_to_title()
  ) |>
  select(-Parameter)

save(ddm_cor, file = "analysis_objects/ddm_correlations.RData")


# 7. Influence of environmental variables ---------------------------------

stai_noise <- haven::read_sav('data/L_CognitiveAdversity_1.0p.sav') |>
  mutate(
    # STAI variables (absolute)
    stai_simon        = (5-SE1_1) + SE2_1 + SE3_1 + (5-SE4_1) + (5-SE5_1) + SE6_1,
    stai_flanker      = (5-SE1_2) + SE2_2 + SE3_2 + (5-SE4_2) + (5-SE5_2) + SE6_2,
    stai_globallocal  = (5-SE1_3) + SE2_3 + SE3_3 + (5-SE4_3) + (5-SE5_3) + SE6_3,
    stai_colorshape   = (5-SE1_4) + SE2_4 + SE3_4 + (5-SE4_4) + (5-SE5_4) + SE6_4,
    stai_animacysize  = (5-SE1_5) + SE2_5 + SE3_5 + (5-SE4_5) + (5-SE5_5) + SE6_5,
    stai_posner       = (5-SE1_6) + SE2_6 + SE3_6 + (5-SE4_6) + (5-SE5_6) + SE6_6,

    # Average STAI score across tasks
    stai_mean         = across(starts_with('stai')) |> rowMeans(),
    # STAI variables (difference from the grand mean)
    stai_simon_diff       = stai_simon - stai_mean,
    stai_flanker_diff     = stai_flanker - stai_mean,
    stai_globallocal_diff = stai_globallocal - stai_mean,
    stai_colorshape_diff  = stai_colorshape - stai_mean,
    stai_animacysize_diff = stai_animacysize - stai_mean,
    stai_posner_diff      = stai_posner - stai_mean
  ) |>
  rename(
    noise_simon       = Q1_1,
    noise_flanker     = Q1_2,
    noise_globallocal = Q1_3,
    noise_colorshape  = Q1_4,
    noise_animacysize = Q1_5,
    noise_posner      = Q1_6,
  ) |>
  mutate(
    noise_mean  = across(starts_with("noise")) |> rowMeans()
  ) |>
  select(nomem_encr, starts_with("noise"), stai_mean, matches("stai.*diff"))

env_models <-
  ddm_raw |>
  select(-nomem_encr) |>
  pivot_longer(everything(), names_to = "parameter", values_to = "value") |>
  select(-value) |>
  mutate(task = str_extract(parameter, "^[a-z]*")) |>
  distinct() |>
  left_join(
    tibble(
      noise = str_c("noise_", c("simon", "flanker", "globallocal", "colorshape", "animacysize", "posner")),
      task = c("simon", "flanker", "gl", "cs", "as", "pos")
      )
  ) |>
  left_join(
    tibble(
      stai = str_c("stai_", c("simon", "flanker", "globallocal", "colorshape", "animacysize", "posner"), "_diff"),
      task = c("simon", "flanker", "gl", "cs", "as", "pos")
    )
  ) |>
  mutate(
    model = glue("{parameter} ~ {noise} + {stai}")
  )

env_fit <- env_models |>
  mutate(fit = purrr::map(model, ~lm(.x, data = ddm_raw |> left_join(stai_noise)))) |>
  mutate(fit = pmap(list(fit), function(fit){
    fit |>
      broom::tidy() |>
      mutate(
        estimate  = paste0(formatC(estimate, digits = 2, width = 2, format = 'f'), " (", formatC(std.error, digits = 2, width = 2, format = 'f'), ")"),
        p.value   = ifelse(p.value < .001, "< .001", formatC(p.value, digits = 3, width = 3, format = 'f')),
        p.value   = str_remove(p.value, "^0"),
        term      = case_when(
          str_detect(term, "Intercept") ~ "intercept",
          str_detect(term, "noise") ~ "noise",
          str_detect(term, "stai") ~ "anxiety"
            )
      ) |>
      select(-std.error, -statistic) |>
      pivot_wider(names_from = 'term', values_from = c('estimate', 'p.value')) |>
      select(estimate_intercept, p.value_intercept, estimate_noise, p.value_noise, estimate_anxiety, p.value_anxiety)
  })) |>
  select(parameter, task, fit) |>
  unnest(fit) |>
  mutate(
    condition = case_when(
      str_detect(parameter, "_con_") ~ "(Con.)",
      str_detect(parameter, "_inc_") ~ "(Inc.)",
      str_detect(parameter, "_sw_") ~ "(Sw.)",
      str_detect(parameter, "_rep_") ~ "(Rep.)",
      TRUE ~ ""
    ),
    parameter = case_when(
      str_detect(parameter, "_v$") ~ "Drift rate",
      str_detect(parameter, "_a$") ~ "Bound. sep.",
      str_detect(parameter, "_t$") ~ "Non-dec. time",
    ),
    task = case_when(
      task == "as" ~ "Animacy-size",
      task == "gl" ~ "Global-local",
      task == "cs" ~ "Color-shape",
      task == "pos" ~ "Posner",
      TRUE ~ task
    ),
    task = str_to_title(task)
  ) |>
  arrange(task, parameter, condition) |>
  mutate(task = glue("{task} {condition} - {parameter}")) |>
  select(-parameter, -condition)

env_fit_table <- env_fit |>
  mutate(empty1 = "", empty2 = "") |>
  select(task, estimate_intercept, p.value_intercept, empty1, estimate_noise, p.value_noise, empty2, estimate_anxiety, p.value_anxiety) |>
  flextable() |>
  flextable::compose(i = 1, j = c(1), as_paragraph("Task"), part = "header") |>
  flextable::compose(i = 1, j = c(4,7), as_paragraph(""), part = "header") |>
  flextable::compose(i = 1, j = c(2,5,8), as_paragraph("Estimate"), part = "header") |>
  flextable::compose(i = 1, j = c(3,6,9), as_paragraph(as_i("p")), part = "header") |>
  add_header_row(
    values = c("", "Intercept", "", "Noise", "", "Anxiety"),
                 colwidths = c(1,2,1,2,1,2), top = TRUE
  ) |>
  align(i = 1:2, align = "center", part = "header") |>
  align(j = 2:7, align = "center", part = "body")


env_cor_table <- full_data |>
  left_join(stai_noise) |>
  select(p_scar_m, threat_comp, child_dep, child_thr, noise_mean, stai_mean) |>
  corr_table(
    use = "pairwise.complete.obs",
    sample_size = F,
    method = "spearman",
    stats = F,
    c.names = c(
      "Deprivation in adulthood",
      "Threat in aduldhood",
      "Childhood threat",
      "Childhood deprivation",
      "Environmental noise",
      "State anxiety"
    ),
    numbered = T,
    flagged = F
  )

save(env_fit_table, env_cor_table, file = "analysis_objects/env_effects.RData")



# 8. Indirect effects of confounders --------------------------------------

confound_coef_confirmatory <-
  bind_rows(
    lavaan::standardizedsolution(fit_thr1) |>
      filter(op == "~", rhs %in% c("age", "sex", "child_adv", "p_scar_m")) |>
      mutate(model = "thr"),
    lavaan::standardizedsolution(fit_dep1) |>
      filter(op == "~", rhs %in% c("age", "sex", "edu", "child_adv")) |>
      mutate(model = "dep")
  ) |>
  mutate(
    across(c(est.std, se, ci.lower, ci.upper), ~formatC(., digits = 2, width = 2, format = 'f')),
    pvalue = ifelse(pvalue < .001, "< .001", formatC(pvalue, digits = 3, width = 3, format = 'f') |> str_remove("^0")),
    ci     = glue::glue("[{ci.lower}, {ci.upper}]"),
    rhs = case_when(
      rhs == "p_scar_m" ~ "Material deprivation",
      rhs == "age" ~ "Age",
      rhs == "sex" ~ "Sex",
      rhs == "child_adv" ~ "Childhood adversity",
      rhs == "edu" ~ "Education"
    )
  ) |>
  select(-c(z, ci.lower, ci.upper, op)) |>
  pivot_wider(names_from = c("model"), values_from = c("est.std", "se", "ci", "pvalue")) |>
  mutate(empty = "") |>
  select(lhs, rhs, est.std_thr, se_thr, ci_thr, pvalue_thr, empty, est.std_dep, se_dep, ci_dep, pvalue_dep) |>
  arrange(desc(lhs)) |>
  add_row(rhs = "Task-general drift rate", .before = 1) |>
  add_row(rhs = "Task-general boundary separation", .before = 7) |>
  add_row(rhs = "Task-general non-decision time", .before = 13) |>
  select(-lhs)



confound_coef_ch <-
  bind_rows(
    lavaan::standardizedsolution(fit_expl_ch_thr) |>
      filter(op == "~", rhs %in% c("sex", "child_dep")) |>
      mutate(model = "thr"),
    lavaan::standardizedsolution(fit_expl_ch_dep) |>
      filter(op == "~", rhs %in% c("sex")) |>
      mutate(model = "dep")
  ) |>
  mutate(
    across(c(est.std, se, ci.lower, ci.upper), ~formatC(., digits = 2, width = 2, format = 'f')),
    pvalue = ifelse(pvalue < .001, "< .001", formatC(pvalue, digits = 3, width = 3, format = 'f') |> str_remove("^0")),
    ci     = glue::glue("[{ci.lower}, {ci.upper}]"),
    rhs = case_when(
      rhs == "child_dep" ~ "Childhood deprivation",
      rhs == "sex" ~ "Sex"
    )
  ) |>
  select(-c(z, ci.lower, ci.upper, op)) |>
  pivot_wider(names_from = c("model"), values_from = c("est.std", "se", "ci", "pvalue")) |>
  mutate(empty = "") |>
  select(lhs, rhs, est.std_thr, se_thr, ci_thr, pvalue_thr, empty, est.std_dep, se_dep, ci_dep, pvalue_dep) |>
  arrange(desc(lhs)) |>
  add_row(rhs = "Task-general drift rate", .before = 1) |>
  add_row(rhs = "Task-general boundary separation", .before = 4) |>
  add_row(rhs = "Task-general non-decision time", .before = 7) |>
  select(-lhs)



confound_coef_ts_adult <-
  bind_rows(
    lavaan::standardizedsolution(fit_expl_ts_adult_threat) |>
      filter(op == "~", rhs %in% c("age", "sex", "p_scar_m", "child_adv")) |>
      mutate(model = "thr"),
    lavaan::standardizedsolution(fit_expl_ts_adult_dep) |>
      filter(op == "~", rhs %in% c("age", "sex", "edu", "child_adv")) |>
      mutate(model = "dep")
  ) |>
  filter(pvalue < .01) |>
  mutate(
    across(c(est.std, se, ci.lower, ci.upper), ~formatC(., digits = 2, width = 2, format = 'f')),
    pvalue = ifelse(pvalue < .001, "< .001", formatC(pvalue, digits = 3, width = 3, format = 'f') |> str_remove("^0")),
    ci     = glue::glue("[{ci.lower}, {ci.upper}]"),
    rhs = case_when(
      rhs == "p_scar_m" ~ "Material deprivation",
      rhs == "age" ~ "Age",
      rhs == "sex" ~ "Sex",
      rhs == "child_adv" ~ "Childhood adversity",
      rhs == "edu" ~ "Education"
    )
  ) |>
  select(-c(z, ci.lower, ci.upper, op)) |>
  pivot_wider(names_from = c("model"), values_from = c("est.std", "se", "ci", "pvalue")) |>
  mutate(empty = "") |>
  select(lhs, rhs, est.std_thr, se_thr, ci_thr, pvalue_thr, empty, est.std_dep, se_dep, ci_dep, pvalue_dep) |>
  arrange(desc(lhs)) |>
  add_row(rhs = "Task-general drift rate", .before = 1) |>
  add_row(rhs = "Task-general boundary separation", .before = 7) |>
  add_row(rhs = "Task-general non-decision time", .before = 13) |>
  select(-lhs)


save(confound_coef_confirmatory, confound_coef_ch, file = "analysis_objects/confounder_coefficients.RData")
