library(flextable)
library(tidyverse)
library(haven)
library(patchwork)
library(glue)
library(parameters)

source("scripts/0_functions/corr_plot.R")


load('analysis_objects/results_confirmatory.RData')
load('analysis_objects/results_exploratory.RData')
load('analysis_objects/results_raw_rts.RData')
load('analysis_objects/n_sessions.RData')
load('data/exclusions.RData')
load('data/ddm_clean.RData')
load("data/clean_data_mean.RData")


full_data <- read_csv('data/liss_data/full_data.csv')
descr <- read_sav(file = "data/L_CognitiveAdversity_1.0p.sav") |> as_tibble()


# 1. Figures -----------------------------------------------------------------

fig4_df <-
  bind_rows(
    fit_dep1_reg_coef |>
    mutate(model = "Primary causal model") |>
    left_join(fit_dep1_eqtests |> select(lhs, rhs, eq_pvalue)),
    fit_dep2_reg_coef |>
      mutate(model = "Secondary causal model") |>
      left_join(fit_dep2_eqtests |> select(lhs, rhs, eq_pvalue))
  ) |>
  bind_rows(
    fit_thr1_reg_coef |>
      mutate(model = "Primary causal model") |>
      left_join(fit_thr1_eqtests |> select(lhs, rhs, eq_pvalue)),
    fit_thr2_reg_coef |>
      mutate(model = "Secondary causal model") |>
      left_join(fit_thr2_eqtests |> select(lhs, rhs, eq_pvalue))
  ) |>
  mutate(
    ddm_parameter = case_when(
      ddm_parameter == "Drift rate" ~ "Task-general\nprocessing speed",
      ddm_parameter == "Boundary separation" ~ "Task-general\nresponse caution",
      ddm_parameter == "Non-decision time" ~ "Task-general\nnon-decision time"
    )
  ) |>
  filter(str_detect(lhs, "gen")) |>
  ungroup() |>
  add_row(
    ddm_parameter = "Filler1",
    rhs = "p_scar_m",
    model = c("Primary causal model", "Secondary causal model")
  ) |>
  add_row(ddm_parameter = "Filler2",
          rhs = "p_scar_m",
          model = c("Primary causal model", "Secondary causal model")
  ) |>
  mutate(
    eq_pvalue_discr = ifelse(round(eq_pvalue,3) < .050, "eq", "non-eq"),
    rhs = ifelse(rhs == "p_scar_m", "Material deprivation", "Threat"),
    ddm_parameter = factor(ddm_parameter, levels = c("Filler1", "Task-general\nprocessing speed", "Task-general\nresponse caution", "Task-general\nnon-decision time", "Filler2")),
    dot_size = 8,
    xmin = "Filler1",
    xmax = "Filler2",
    linetype = ifelse(model == "Primary causal model", "dashed", "solid"),
    alpha    = ifelse(model == "Primary causal model", 1, 2),
    sig_star = case_when(
      pvalue_adj >= 0.05 ~ "",
      pvalue_adj < 0.05 & pvalue_adj >= 0.01 ~ "*",
      pvalue_adj < 0.01 & pvalue_adj >= 0.001 ~  "**",
      pvalue_adj < 0.001 ~ "***"
    ),
    sig_pos = ifelse(est.std < 0, ci.lower - 0.03, ci.upper + 0.01),
    x = case_when(
      ddm_parameter == "Task-general\nprocessing speed"  ~ 1.85,
      ddm_parameter == "Task-general\nresponse caution"  ~ 2.85,
      ddm_parameter == "Task-general\nnon-decision time" ~ 3.85
    ),
    xend = case_when(
      ddm_parameter == "Task-general\nprocessing speed"  ~ 2.15,
      ddm_parameter == "Task-general\nresponse caution"  ~ 3.15,
      ddm_parameter == "Task-general\nnon-decision time" ~ 4.15
    )
  )


fig4 <-
  ggplot(data = fig4_df, aes(x = ddm_parameter, y = est.std)) +
  geom_rect(
    aes(
      xmin = xmin, xmax = xmax, ymin = -0.1, ymax = 0.1
    ),
    fill = "#F2F3F5",
    inherit.aes = T
  ) +
  geom_hline(aes(yintercept = 0), size = 0.7) +
  geom_errorbar(aes(ymin = ci.lower, ymax = ci.upper, color = ddm_parameter, linetype = .data[['linetype']]), width = 0, size = 1) +

  geom_segment(aes(x = x, xend = xend, y = ci.upper, color = ddm_parameter), size = 0.5, linetype = "solid") +
  geom_segment(aes(x = x, xend = xend, y = ci.lower, color = ddm_parameter), size = 0.5, linetype = "solid") +

  geom_point(aes(color = ddm_parameter, shape = eq_pvalue_discr), fill = "white", size = 3, stroke = 1.5) +
  geom_text(
    aes(y = sig_pos, label = sig_star),
    color = "black"
  ) +
  facet_grid(model~rhs) +
  scale_shape_manual(values = c(16,21)) +
  coord_cartesian(xlim = c(2,5)) +
  scale_x_discrete(labels = c("", "Task-general\nprocessing speed", "Task-general\nresponse caution", "Task-general\nnon-decision time", "")) +
  ggsci::scale_color_uchicago(breaks = c("Task-general\nprocessing speed", "Task-general\nresponse caution", "Task-general\nnon-decision time")) +
  theme_classic() +
  theme(
    legend.position = "bottom",
    legend.text = element_text(size = 10),
    panel.spacing.x = unit(2, "lines"),
    panel.spacing.y = unit(2, "lines"),
    axis.line.x = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.text.y = element_text(size = 12),
    strip.background = element_rect(color = 'white'),
    strip.text.y = element_text(face = "bold", size = 11),
    strip.text.x = element_text(face = "bold", size = 13)
  ) +
  guides(shape = 'none', size = 'none', linetype = 'none') +
  labs(
    color = "",
    x = "",
    y = "Standardized regression coefficient"
  )


fig5 <- expl_ch_thr_reg_coef |>
  left_join(expl_ch_thr_eqtests |> select(lhs, rhs, eq_pvalue)) |>
  bind_rows(
    expl_ch_dep_reg_coef |>
      left_join(expl_ch_dep_eqtests |> select(lhs, rhs, eq_pvalue))
  ) |>
  mutate(
    ddm_parameter = case_when(
      ddm_parameter == "Drift rate" ~ "Task-general\nprocessing speed",
      ddm_parameter == "Boundary separation" ~ "Task-general\nresponse caution",
      ddm_parameter == "Non-decision time" ~ "Task-general\nnon-decision time"
    )
  ) |>
  filter(str_detect(lhs, "gen")) |>
  ungroup() |>
  add_row(
    ddm_parameter = "Filler1",
    rhs = c("child_dep","child_dep", "child_thr", "child_thr"),
  ) |>
  add_row(ddm_parameter = "Filler2",
          rhs = c("child_dep","child_dep", "child_thr", "child_thr"),
  ) |>
  mutate(
    eq_pvalue_discr = ifelse(eq_pvalue < .05, "eq", "non-eq"),
    rhs = ifelse(rhs == "child_dep", "Childhood material deprivation", "Childhood threat"),
    ddm_parameter = factor(ddm_parameter, levels = c("Filler1", "Task-general\nprocessing speed", "Task-general\nresponse caution", "Task-general\nnon-decision time", "Filler2")),
    dot_size = 8,
    xmin = "Filler1",
    xmax = "Filler2",
    sig_star = case_when(
      pvalue_adj >= 0.05 ~ "",
      pvalue_adj < 0.05 & pvalue_adj >= 0.01 ~ "*",
      pvalue_adj < 0.01 & pvalue_adj >= 0.001 ~  "**",
      pvalue_adj < 0.001 ~ "***"
    ),
    sig_pos = ifelse(est.std < 0, ci.lower - 0.03, ci.upper + 0.01)
  ) |>
  ggplot(aes(x = ddm_parameter, y = est.std)) +
  geom_rect(
    aes(
      xmin = xmin, xmax = xmax, ymin = -0.1, ymax = 0.1
    ),
    fill = "#F2F3F5",
    inherit.aes = T
  ) +
  geom_hline(aes(yintercept = 0), size = 0.7) +
  geom_errorbar(aes(ymin = ci.lower, ymax = ci.upper, color = ddm_parameter), width = 0.2, size = 1) +
  geom_point(aes(color = ddm_parameter, shape = eq_pvalue_discr), fill = "white", size = 3, stroke = 1.5) +
  geom_text(
    aes(y = sig_pos, label = sig_star),
    color = "black"
  ) +
  facet_wrap(~rhs) +
  scale_shape_manual(values = c(16,21)) +
  coord_cartesian(xlim = c(2,5)) +
  scale_x_discrete(labels = c("", "Task-general\nprocessing speed", "Task-general\nresponse caution", "Task-general\nnon-decision time", "")) +
  # scale_color_discrete(breaks = c('Task-general', 'Flanker', 'Attention Shifting', "Mental Rotation")) +
  ggsci::scale_color_uchicago(breaks = c("Task-general\nprocessing speed", "Task-general\nresponse caution", "Task-general\nnon-decision time")) +
  theme_classic() +
  theme(
    legend.position = "bottom",
    legend.text = element_text(size = 10),
    panel.spacing.x = unit(2, "lines"),
    panel.spacing.y = unit(2, "lines"),
    axis.line.x = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.text.y = element_text(size = 12),
    strip.background = element_rect(color = 'white'),
    strip.text.y = element_text(face = "bold", size = 11),
    strip.text.x = element_text(face = "bold", size = 13)
  ) +
  guides(shape = 'none', size = 'none') +
  labs(
    color = "",
    x = "",
    y = "Standardized regression coefficient"
  )



expl_ts_cor_inh_fig <- expl_ts_cor_inh |>
  ggplot() +
  geom_tile(aes(lhs, rhs, fill = est.std), color = 'white', lwd = 1) +
  geom_text(aes(lhs, rhs, label = round(est.std, 2)), color = "white", size = 4) +
  coord_fixed() +
  theme_void() +
  guides(fill = 'none') +
  scale_fill_continuous(limits=c(0, 1), breaks = seq(0, 1, 0.5)) +
  theme(
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    axis.text.x = element_text(angle = 90, vjust = 0.5),
    axis.text.y = element_text()
  )

expl_ts_cor_sh_fig <- expl_ts_cor_sh |>
  ggplot() +
  geom_tile(aes(lhs, rhs, fill = est.std), color = 'white', lwd = 1) +
  geom_text(aes(lhs, rhs, label = round(est.std, 2)), color = "white", size = 4) +
  coord_fixed() +
  theme_void() +
  scale_fill_continuous(limits=c(0, 1), breaks = seq(0, 1, 0.5)) +
  theme(
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    axis.text.x = element_text(angle = 90, vjust = 0.5),
    axis.text.y = element_text(),
    legend.title.position = "top",
    legend.text = element_text(size = 12)
  ) +
  labs(fill = "")

fig6 <- (expl_ts_cor_inh_fig + theme(plot.margin = unit(c(0,10,0,0), "pt"))) +
        (expl_ts_cor_sh_fig + theme(plot.margin = unit(c(0,0,0,0), "pt"))) +
        plot_layout(guides = "collect", ncol = 2, nrow = 1) & theme(legend.position='bottom')


fig7 <- bind_rows(
  expl_ts_adult_dep_reg_coef,
  expl_ts_adult_threat_reg_coef,
  expl_ts_ch_thr_reg_coef,
  expl_ts_ch_dep_reg_coef
) |>
  left_join(
    bind_rows(
      expl_ts_adult_dep_eqtests |> select(lhs, rhs, eq_pvalue),
      expl_ts_adult_threat_eqtests |> select(lhs, rhs, eq_pvalue),
      expl_ts_ch_thr_eqtests |> select(lhs, rhs, eq_pvalue),
      expl_ts_ch_dep_eqtests |> select(lhs, rhs, eq_pvalue),
    )
  ) |>
  filter(str_detect(lhs, "sp")) |>
  ungroup() |>
  add_row(
    lhs = "Filler1",

    adversity = c("Deprivation", "Deprivation", "Threat", "Threat"),
    timing    = c("Adulthood", "Childhood", "Adulthood", "Childhood"),
    .before = 1
  ) |>
  add_row(lhs = "Filler2",
          adversity = c("Deprivation", "Deprivation", "Threat", "Threat"),
          timing    = c("Adulthood", "Childhood", "Adulthood", "Childhood"),
          .after = 48
  ) |>
  mutate(
    lhs = str_replace(lhs, "_v$", ""),
    adversity = factor(adversity, levels = c("Deprivation", "Threat")),
    timing    = factor(timing, levels = c("Adulthood", "Childhood")),
    dot_size = 8,
    xmin = "Filler1",
    xmax = "Filler2",
    sig_star = case_when(
      pvalue_adj >= 0.05 ~ "",
      pvalue_adj < 0.05 & pvalue_adj >= 0.01 ~ "*",
      pvalue_adj < 0.01 & pvalue_adj >= 0.001 ~  "**",
      pvalue_adj < 0.001 ~ "***"
    ),
    sig_pos = ifelse(est.std < 0, ci.lower - 0.06, ci.upper + 0.03),
    condition = case_when(
      str_detect(lhs, "_(inc|sw)$") ~ "incongruent/switch",
      str_detect(lhs, "_(con|rep|pos)$") ~ "congruent/repeat",
      str_detect(lhs, "pos") ~ "all trials"
    ),
    eq_pvalue_discr = case_when(
      eq_pvalue < .05 & condition == "incongruent/switch" ~ "inc_eq",
      eq_pvalue < .05 & condition == "congruent/repeat"   ~ "con_eq",
      eq_pvalue > .05 & condition == "incongruent/switch" ~ "inc_noneq",
      eq_pvalue > .05 & condition == "congruent/repeat"   ~ "con_noneq",
      str_detect(lhs, "Filler1")                          ~ "con_eq",
      TRUE ~ "inc_eq"
    ),
    lhs = case_when(
      str_detect(lhs, "pos") ~ "Posner",
      str_detect(lhs, "fl") ~ "Flanker",
      str_detect(lhs, "si") ~ "Simon",
      str_detect(lhs, "cs") ~ "Color-shape",
      str_detect(lhs, "gl") ~ "Global-local",
      str_detect(lhs, "as") ~ "Animacy-size",
      TRUE ~ lhs
    ),
    lhs = factor(lhs, levels = c("Filler1", "Posner", "Flanker", "Simon", "Color-shape", "Animacy-size", "Global-local", "Filler2")),
    eq_pvalue_discr = factor(eq_pvalue_discr, levels = c("inc_eq", "con_eq", "inc_noneq", "con_noneq"))
  ) |>
  ggplot(aes(x = lhs, y = est.std, color = lhs)) +
  geom_rect(
    aes(
      xmin = xmin, xmax = xmax, ymin = -0.1, ymax = 0.1
    ),
    fill = "#F2F3F5",
    color = "#F2F3F5",
    inherit.aes = T
  ) +
  geom_hline(aes(yintercept = 0), size = 0.7) +
  geom_errorbar(aes(ymin = ci.lower, ymax = ci.upper, color = lhs, group = condition), position = position_dodge(width = 0.8), width = 0.2, size = 1) +
  geom_point(aes(color = lhs, shape = eq_pvalue_discr, group = condition), position = position_dodge(width = 0.8), fill = "white", size = 3, stroke = 1.5) +
  geom_text(
    aes(y = sig_pos, label = sig_star, group = condition),
    color = "black",
    position = position_dodge(width = 0.5)
  ) +
  facet_grid(timing~adversity) +
  scale_shape_manual(values = c(16,17,21,24), labels = c("Equivalent\nincongruent/switch", "Equivalent\ncongruent/repeat", "Non-equivalent\nincongruent/switch", "Non-equivalent\ncongruent/repeat")) +
  coord_cartesian(xlim = c(2,7)) +
  scale_x_discrete(labels = c("", "Posner", "Flanker", "Simon", "Color-shape", "Animacy-size", "Global-local", "")) +
  ggsci::scale_color_uchicago(breaks = c("Posner", "Flanker", "Simon", "Color-shape", "Animacy-size", "Global-local")) +
  theme_classic() +
  theme(
    legend.position = "bottom",
    legend.text = element_text(size = 10),
    legend.title = element_blank(),
    panel.spacing.x = unit(2, "lines"),
    panel.spacing.y = unit(2, "lines"),
    #  axis.line.x = element_blank(),
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.ticks.x = element_blank(),
    axis.text = element_text(size = 12),
    strip.background = element_rect(color = 'white'),
    strip.text.y = element_text(face = "bold", size = 11),
    strip.text.x = element_text(face = "bold", size = 13)
  ) +
  guides(color = 'none', size = 'none') +
  labs(
    color = "",
    x = "",
    y = "Standardized regression coefficient"
  )



# 2. Tables ---------------------------------------------------------------


table1 <- descr |>
  filter(nomem_encr %in% exclusions$sample$ids) |>
  select(leeftijd, geslacht) |>
  mutate(geslacht = case_when(
    geslacht == 1 ~ "Male",
    geslacht == 2 ~ "Female",
    geslacht == 3 ~ "Other")
    ) |>
  summarise(
    age_m = mean(leeftijd, na.rm = T),
    age_sd = sd(leeftijd, na.rm = T),
    sex_male = sum(geslacht == 'Male')/n()*100,
    sex_female = sum(geslacht == 'Female')/n()*100,
    sex_other  = sum(geslacht == "Other")/n()*100
  ) |>
  transmute(
    `Mean age (SD)` = paste0(round(age_m, 1), " (", round(age_sd, 1), ")"),
    `Female (%)` = round(sex_female, 1) |> as.character(),
    `Male (%)` = round(sex_male, 1) |> as.character(),
    `Other (%)` = round(sex_other, 1) |> as.character(),
    ) |>
  pivot_longer(everything(), names_to = "cat", values_to = "stat") |>
  bind_rows(
    descr |>
      filter(nomem_encr %in% exclusions$sample$ids) |>
      select(oplmet) |>
      mutate(
        oplmet = case_when(
          oplmet == 1 ~ "primary school",
          oplmet == 2 ~ "vmbo (intermediate secondary education)",
          oplmet == 3 ~ "havo/vwo (higher secondary education)",
          oplmet == 4 ~ "mbo (intermediate vocational education)",
          oplmet == 5 ~ "hbo (higher vocational education)",
          oplmet == 6 ~ "wo (university)",
          oplmet == 7 ~ "other",
          TRUE ~ "missing"
        ),
        oplmet = factor(oplmet, levels = c("primary school", "vmbo (intermediate secondary education)", "havo/vwo (higher secondary education)",
                                           "mbo (intermediate vocational education)", "hbo (higher vocational education)", "wo (university)",
                                           "other", "missing")
        )
      ) |>
      group_by(oplmet) |>
      summarise(stat = round(n()/759*100, 1) |> as.character()) |>
      rename(cat = oplmet)
  ) |>
  bind_rows(
    full_data |>
      select(n_waves_threat, n_waves_mat_dep) |>
      summarise(
        `Material deprivation` = paste0(round(mean(n_waves_mat_dep, na.rm = T),1), " (", round(sd(n_waves_mat_dep, na.rm = T), 1), ")"),
        Threat = paste0(round(mean(n_waves_threat, na.rm = T),1), " (", round(sd(n_waves_threat, na.rm = T), 1), ")"),
      ) |>
      pivot_longer(everything(), names_to = "cat", values_to = "stat")
  ) |>
  add_row(.before = 2, cat = "Sex") |>
  add_row(.before = 6, cat = "Highest completed education (%)") |>
  add_row(.before = 15, cat = "Mean number of waves (SD)")


table2 <- full_data |>
  select(live_off_income_m, finan_trouble_m, curr_situation_m, p_scar_m,
         neigh_thr_m, neigh_thr02_m, vict_sum, threat_comp,
         child_dep, child_thr, child_adv, sex, age, edu,
         ) |>
  corr_table(
    use = "pairwise.complete.obs",
    sample_size = F,
    method = "spearman",
    stats = list("mean", "sd", "min", "max", "skew", "kurtosis"),
    c.names = c(
      "Living off income",
      "Financial troubles",
      "Current situation",
      "Material deprivation in adulthood (composite)",
      "Neighborhood safety",
      "Neighborhood Violence Scale",
      "Crime victimization",
      "Threat in adulthood (composite)",
      "Childhood deprivation",
      "Childhood threat",
      "Childhood adversity (composite)",
      "Sex assigned at birth",
      "Age",
      "Highest education"
    ),
    numbered = T,
    flagged = F
  )

table3 <- clean_data_mean |>
  pivot_longer(-nomem_encr, names_sep = "_", names_to = c("task", "stat", "condition")) |>
  pivot_wider(names_from = 'stat', values_from = 'value') |>
  group_by(task, condition) |>
  summarise(
    rt_m   = mean(rt, na.rm = T),
    rt_sd  = sd(rt, na.rm = T),
    rt_min = min(rt, na.rm = T),
    rt_max = max(rt, na.rm = T),
    ac_m   = mean(ac, na.rm = T),
    ac_sd  = sd(ac, na.rm = T),
    ac_min = min(ac, na.rm = T),
    ac_max = max(ac, na.rm = T)
  ) |>
  ungroup() |>
  mutate(
    across(-c(task, condition), ~formatC(., digits = 2, width = 2, format = 'f')),
    rt_m     = glue("{rt_m} ({rt_sd})"),
    rt_range = glue("[{rt_min}, {rt_max}]"),
    ac_m     = glue("{ac_m} ({ac_sd})"),
    ac_range = glue("[{ac_min}, {ac_max}]")
  ) |>
  select(task, condition, rt_m, rt_range, ac_m, ac_range) |>
  mutate(
    condition = case_when(
      condition == "rep" ~ "Repetition",
      condition == "sw" ~ "Switch",
      condition == "con" ~ "Congruent",
      condition == "inc" ~ "Incongruent"
    ),
    task = case_when(
      task == "animacysize" ~ "Animacy-size",
      task == "colorshape" ~ "Color-shape",
      task == "flanker" ~ "Flanker",
      task == "simon" ~ "Simon",
      task == "globallocal" ~ "Global-local",
      task == "pos" ~ "Posner"
    )
  ) %>%
  arrange(factor(.$task, levels = c("Flanker", "Simon", "Color-shape", "Global-local", "Animacy-size", "Posner")))


# 3. SEM fit statistics ---------------------------------------------------

table4 <- bind_rows(
  fit_v2_fitstats |> as_tibble_row() |> mutate(model = "Drift rate model 2"),
  fit_a3_fitstats |> as_tibble_row() |> mutate(model = "Boundary separation model 3"),
  fit_t3_fitstats |> as_tibble_row() |> mutate(model = "Non-decision time model 3"),
  fit_meas_fitstats |> as_tibble_row() |> mutate(model = "Full measurement model"),
  fit_dep1_fitstats |> as_tibble_row() |> mutate(model = "Primary deprivation model"),
  fit_dep2_fitstats |> as_tibble_row() |> mutate(model = "Secondary deprivation model"),
  fit_thr1_fitstats |> as_tibble_row() |> mutate(model = "Primary threat model"),
  fit_thr2_fitstats |> as_tibble_row() |> mutate(model = "Secondary threat model"),
) |>
  mutate(
    across(-c(pvalue, model, df), ~formatC(., digits = 2, width = 2, format = 'f')),
    pvalue = ifelse(pvalue < .001, "p < .001", paste0("p = ", ~formatC(pvalue, digits = 3, width = 3, format = 'f') %>% str_remove(., "^0"))),
    chisq = glue::glue("{chisq} ({df}), {pvalue}"),
    rmsea.robust = glue::glue("{rmsea.robust} [{rmsea.ci.lower.robust}, {rmsea.ci.upper.robust}]")
  ) |>
  # Add models that did not converge
  add_row(model = "Drift rate model 1", chisq = "Model did not converge", .before = 1) |>
  add_row(model = "Boundary separation model 1", chisq = "Model did not converge", .before = 3) |>
  add_row(model = "Boundary separation model 2", chisq = "Model did not converge", .before = 4) |>
  add_row(model = "Non-decision time model 1", chisq = "Model did not converge", .before = 6) |>
  add_row(model = "Non-decision time model 2", chisq = "Model did not converge",  .before = 7) |>
  select(model, chisq, cfi.robust, rmsea.robust) |>
  add_row(model = "Measurement models", .before = 1) |>
  add_row(model = "Structural models", .before = 11)



# 4. Investigate session effect -------------------------------------------

session_effects <- ddm_clean |>
  select(nomem_encr, ends_with("_v")) |>
  pivot_longer(-nomem_encr, names_to = 'parameter', values_to = "value") |>
  separate(parameter, into = c("task", "condition", "par"), sep = "_") |>
  left_join(
    n_sessions |>
      select(nomem_encr, n_sessions, starts_with('session')) |>
      pivot_longer(-c(nomem_encr, n_sessions), names_to = "task", values_to = "session") |>
      separate(task, into = c("ses", "task")) |>
      select(nomem_encr, task, session, n_sessions)
  ) |>
  filter(n_sessions > 1) |>
  group_by(task, condition) |>
  mutate(value = scale(value) |> as.numeric()) |>
  ungroup() |>
  group_by(nomem_encr, session) |>
  summarise(v_m = ifelse(n()>1, mean(value), value)) |>  # calculate average standardized drift rate for first and second session
  drop_na() |>
  ungroup()


session_effect <- t.test(v_m ~ session, data = session_effects) |>
  parameters() |>
  mutate(across(c(t, df_error), ~formatC(., digits = 2, width = 2, format = 'f')))


save(table1, table2, table3, table4, file = "analysis_objects/rendered_tables.RData")
save(fig4, fig5, fig6, fig7, session_effect, file = "analysis_objects/rendered_figures.RData")

