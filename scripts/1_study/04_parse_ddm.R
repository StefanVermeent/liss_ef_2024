
# 1. Load objects ------------------------------------------------------------

source("scripts/0_functions/ddm_functions.R")

load("data/clean_data_long.RData")

# Load DDM model objects
load("analysis_objects/ddm_flanker_mod1.RData")
load("analysis_objects/ddm_simon_mod1.RData")
load("analysis_objects/ddm_colorshape_mod1.RData")
load("analysis_objects/ddm_animacysize_mod1.RData")
load("analysis_objects/ddm_globallocal_mod1.RData")
load("analysis_objects/ddm_posner_mod1.RData")

# Load ID matches to link DDM IDs to LISS IDs

flanker_id_matches <- flanker_clean |>
  distinct(nomem_encr) |>
  mutate(nomem_encr_num = 1:n())

simon_id_matches <- simon_clean |>
  distinct(nomem_encr) |>
  mutate(nomem_encr_num = 1:n())

colorshape_id_matches <- colorshape_clean |>
  distinct(nomem_encr) |>
  mutate(nomem_encr_num = 1:n())

animacysize_id_matches <- animacysize_clean |>
  distinct(nomem_encr) |>
  mutate(nomem_encr_num = 1:n())

globallocal_id_matches <- globallocal_clean |>
  distinct(nomem_encr) |>
  mutate(nomem_encr_num = 1:n())

posner_id_matches <- posner_clean |>
  distinct(nomem_encr) |>
  mutate(nomem_encr_num = 1:n())

# 1. Extract traces -------------------------------------------------------


flanker_mod1_traces <- extract_traces_2con(mcmc_flanker_mod1, chains = 3, iterations = 1000)
simon_mod1_traces <- extract_traces_2con(mcmc_simon_mod1, chains = 3, iterations = 1000)
colorshape_mod1_traces <- extract_traces_2con(mcmc_colorshape_mod1, chains = 3, iterations = 1000)
animacysize_mod1_traces <- extract_traces_2con(mcmc_animacysize_mod1, chains = 3, iterations = 1000)
globallocal_mod1_traces <- extract_traces_2con(mcmc_globallocal_mod1, chains = 3, iterations = 1000)
posner_mod1_traces <- extract_traces(mcmc_posner_mod1, chains = 3, iterations = 1000)



# 2. Extract parameter estimates ------------------------------------------

flanker_mod1_param_est <- extract_ddm_estimates_2con(mcmc = mcmc_flanker_mod1, task_prefix = "flanker_", id_matches = flanker_id_matches)
simon_mod1_param_est <- extract_ddm_estimates_2con(mcmc = mcmc_simon_mod1, task_prefix = "simon_", id_matches = simon_id_matches)
colorshape_mod1_param_est <- extract_ddm_estimates_2con(mcmc = mcmc_colorshape_mod1, task_prefix = "colorshape_", id_matches = colorshape_id_matches)
animacysize_mod1_param_est <- extract_ddm_estimates_2con(mcmc = mcmc_animacysize_mod1, task_prefix = "animacysize_", id_matches = animacysize_id_matches)
globallocal_mod1_param_est <- extract_ddm_estimates_2con(mcmc = mcmc_globallocal_mod1, task_prefix = "globallocal_", id_matches = globallocal_id_matches)
posner_mod1_param_est <- extract_ddm_estimates(mcmc = mcmc_posner_mod1, task_prefix = "posner_", id_matches = posner_id_matches)


# 3. Generate simulated datasets for model fit assessment -----------------

## 3.1 Flanker ----

set.seed(284)

flanker_mod1_fit <- flanker_mod1_param_est %>%
  mutate(
    responses = pmap(., function(nomem_encr, flanker_v1, flanker_v2, flanker_a1, flanker_a2, flanker_t1, flanker_t2) {

      bind_rows(
        # Condition 1
        RWiener::rwiener(n=500, alpha=flanker_a1, tau=flanker_t1, beta=0.5, delta=flanker_v1) |>
          as_tibble() |>
          mutate(
            condition = 1
          ),
        # Condition 2
        RWiener::rwiener(n=500, alpha=flanker_a2, tau=flanker_t2, beta=0.5, delta=flanker_v2) |>
          as_tibble() |>
          mutate(
            condition = 2
          )
      )
    })
  ) |>
  unnest(responses) |>
  select(nomem_encr, condition, choice_sim = resp, rt = q) |>
  mutate(choice_sim = ifelse(choice_sim == 'upper', 1, 0)) |>
  group_by(nomem_encr, condition) |>
  summarise(
    RT_25 = quantile(rt, 0.25),
    RT_50 = quantile(rt, 0.50),
    RT_75 = quantile(rt, 0.75),
    acc_sim   = sum(choice_sim) / n()
  ) |>
  pivot_longer(starts_with("RT"), names_to = "percentile", values_to = "RT_sim") |>
  left_join(
    flanker_clean |>
      drop_na(rt) |>
      group_by(nomem_encr, condition) |>
      summarise(
        RT_25 = quantile(rt, 0.25),
        RT_50 = quantile(rt, 0.50),
        RT_75 = quantile(rt, 0.75),
        acc   = sum(correct, na.rm = T) / n()
      ) |>
      pivot_longer(starts_with("RT"), names_to = "percentile", values_to = "RT")
  )

save(flanker_mod1_traces, flanker_mod1_param_est, flanker_mod1_fit, file = "analysis_objects/ddm_flanker_mod1_parsed.RData")


## 3.2 Simon ----

set.seed(56)

simon_mod1_fit <- simon_mod1_param_est %>%
  mutate(
    responses = pmap(., function(nomem_encr, simon_v1, simon_v2, simon_a1, simon_a2, simon_t1, simon_t2) {

      bind_rows(
        # Condition 1
        RWiener::rwiener(n=500, alpha=simon_a1, tau=simon_t1, beta=0.5, delta=simon_v1) |>
          as_tibble() |>
          mutate(
            condition = 1
          ),
        # Condition 2
        RWiener::rwiener(n=500, alpha=simon_a2, tau=simon_t2, beta=0.5, delta=simon_v2) |>
          as_tibble() |>
          mutate(
            condition = 2
          )
      )
    })
  ) |>
  unnest(responses) |>
  select(nomem_encr, condition, choice_sim = resp, rt = q) |>
  mutate(choice_sim = ifelse(choice_sim == 'upper', 1, 0)) |>
  group_by(nomem_encr, condition) |>
  summarise(
    RT_25 = quantile(rt, 0.25),
    RT_50 = quantile(rt, 0.50),
    RT_75 = quantile(rt, 0.75),
    acc_sim   = sum(choice_sim) / n()
  ) |>
  pivot_longer(starts_with("RT"), names_to = "percentile", values_to = "RT_sim") |>
  left_join(
    simon_clean |>
      drop_na(rt) |>
      group_by(nomem_encr, condition) |>
      summarise(
        RT_25 = quantile(rt, 0.25),
        RT_50 = quantile(rt, 0.50),
        RT_75 = quantile(rt, 0.75),
        acc   = sum(correct, na.rm = T) / n()
      ) |>
      pivot_longer(starts_with("RT"), names_to = "percentile", values_to = "RT")
  )

save(simon_mod1_traces, simon_mod1_param_est, simon_mod1_fit, file = "analysis_objects/ddm_simon_mod1_parsed.RData")


## 3.3 Color-shape ----

set.seed(284)

colorshape_mod1_fit <- colorshape_mod1_param_est %>%
  mutate(
    responses = pmap(., function(nomem_encr, colorshape_v1, colorshape_v2, colorshape_a1, colorshape_a2, colorshape_t1, colorshape_t2) {

      bind_rows(
        # Condition 1
        RWiener::rwiener(n=500, alpha=colorshape_a1, tau=colorshape_t1, beta=0.5, delta=colorshape_v1) |>
          as_tibble() |>
          mutate(
            condition = 1
          ),
        # Condition 2
        RWiener::rwiener(n=500, alpha=colorshape_a2, tau=colorshape_t2, beta=0.5, delta=colorshape_v2) |>
          as_tibble() |>
          mutate(
            condition = 2
          )
      )
    })
  ) |>
  unnest(responses) |>
  select(nomem_encr, condition, choice_sim = resp, rt = q) |>
  mutate(choice_sim = ifelse(choice_sim == 'upper', 1, 0)) |>
  group_by(nomem_encr, condition) |>
  summarise(
    RT_25 = quantile(rt, 0.25),
    RT_50 = quantile(rt, 0.50),
    RT_75 = quantile(rt, 0.75),
    acc_sim   = sum(choice_sim) / n()
  ) |>
  pivot_longer(starts_with("RT"), names_to = "percentile", values_to = "RT_sim") |>
  left_join(
    colorshape_clean |>
      drop_na(rt) |>
      group_by(nomem_encr, condition) |>
      summarise(
        RT_25 = quantile(rt, 0.25),
        RT_50 = quantile(rt, 0.50),
        RT_75 = quantile(rt, 0.75),
        acc   = sum(correct, na.rm = T) / n()
      ) |>
      pivot_longer(starts_with("RT"), names_to = "percentile", values_to = "RT")
  )

save(colorshape_mod1_traces, colorshape_mod1_param_est, colorshape_mod1_fit, file = "analysis_objects/ddm_colorshape_mod1_parsed.RData")


## 3.4 Animacy-size ----

set.seed(865)

animacysize_mod1_fit <- animacysize_mod1_param_est %>%
  mutate(
    responses = pmap(., function(nomem_encr, animacysize_v1, animacysize_v2, animacysize_a1, animacysize_a2, animacysize_t1, animacysize_t2) {

      bind_rows(
        # Condition 1
        RWiener::rwiener(n=500, alpha=animacysize_a1, tau=animacysize_t1, beta=0.5, delta=animacysize_v1) |>
          as_tibble() |>
          mutate(
            condition = 1
          ),
        # Condition 2
        RWiener::rwiener(n=500, alpha=animacysize_a2, tau=animacysize_t2, beta=0.5, delta=animacysize_v2) |>
          as_tibble() |>
          mutate(
            condition = 2
          )
      )
    })
  ) |>
  unnest(responses) |>
  select(nomem_encr, condition, choice_sim = resp, rt = q) |>
  mutate(choice_sim = ifelse(choice_sim == 'upper', 1, 0)) |>
  group_by(nomem_encr, condition) |>
  summarise(
    RT_25 = quantile(rt, 0.25),
    RT_50 = quantile(rt, 0.50),
    RT_75 = quantile(rt, 0.75),
    acc_sim   = sum(choice_sim) / n()
  ) |>
  pivot_longer(starts_with("RT"), names_to = "percentile", values_to = "RT_sim") |>
  left_join(
    animacysize_clean |>
      drop_na(rt) |>
      group_by(nomem_encr, condition) |>
      summarise(
        RT_25 = quantile(rt, 0.25),
        RT_50 = quantile(rt, 0.50),
        RT_75 = quantile(rt, 0.75),
        acc   = sum(correct, na.rm = T) / n()
      ) |>
      pivot_longer(starts_with("RT"), names_to = "percentile", values_to = "RT")
  )

save(animacysize_mod1_traces, animacysize_mod1_param_est, animacysize_mod1_fit, file = "analysis_objects/ddm_animacysize_mod1_parsed.RData")



## 3.5 Global-local ----

set.seed(974)

globallocal_mod1_fit <- globallocal_mod1_param_est %>%
  mutate(
    responses = pmap(., function(nomem_encr, globallocal_v1, globallocal_v2, globallocal_a1, globallocal_a2, globallocal_t1, globallocal_t2) {

      bind_rows(
        # Condition 1
        RWiener::rwiener(n=500, alpha=globallocal_a1, tau=globallocal_t1, beta=0.5, delta=globallocal_v1) |>
          as_tibble() |>
          mutate(
            condition = 1
          ),
        # Condition 2
        RWiener::rwiener(n=500, alpha=globallocal_a2, tau=globallocal_t2, beta=0.5, delta=globallocal_v2) |>
          as_tibble() |>
          mutate(
            condition = 2
          )
      )
    })
  ) |>
  unnest(responses) |>
  select(nomem_encr, condition, choice_sim = resp, rt = q) |>
  mutate(choice_sim = ifelse(choice_sim == 'upper', 1, 0)) |>
  group_by(nomem_encr, condition) |>
  summarise(
    RT_25 = quantile(rt, 0.25),
    RT_50 = quantile(rt, 0.50),
    RT_75 = quantile(rt, 0.75),
    acc_sim   = sum(choice_sim) / n()
  ) |>
  pivot_longer(starts_with("RT"), names_to = "percentile", values_to = "RT_sim") |>
  left_join(
    globallocal_clean |>
      drop_na(rt) |>
      group_by(nomem_encr, condition) |>
      summarise(
        RT_25 = quantile(rt, 0.25),
        RT_50 = quantile(rt, 0.50),
        RT_75 = quantile(rt, 0.75),
        acc   = sum(correct, na.rm = T) / n()
      ) |>
      pivot_longer(starts_with("RT"), names_to = "percentile", values_to = "RT")
  )

save(globallocal_mod1_traces, globallocal_mod1_param_est, globallocal_mod1_fit, file = "analysis_objects/ddm_globallocal_mod1_parsed.RData")


## 3.6 Posner ----

set.seed(743)

posner_mod1_fit <- posner_mod1_param_est %>%
  mutate(
    responses = pmap(., function(nomem_encr, posner_v, posner_a, posner_t) {

        RWiener::rwiener(n=500, alpha=posner_a, tau=posner_t, beta=0.5, delta=posner_v) |>
          as_tibble()
    })
  ) |>
  unnest(responses) |>
  select(nomem_encr, choice_sim = resp, rt = q) |>
  mutate(choice_sim = ifelse(choice_sim == 'upper', 1, 0)) |>
  group_by(nomem_encr) |>
  summarise(
    RT_25 = quantile(rt, 0.25),
    RT_50 = quantile(rt, 0.50),
    RT_75 = quantile(rt, 0.75),
    acc_sim   = sum(choice_sim) / n()
  ) |>
  pivot_longer(starts_with("RT"), names_to = "percentile", values_to = "RT_sim") |>
  left_join(
    posner_clean |>
      drop_na(rt) |>
      group_by(nomem_encr) |>
      summarise(
        RT_25 = quantile(rt, 0.25),
        RT_50 = quantile(rt, 0.50),
        RT_75 = quantile(rt, 0.75),
        acc   = sum(correct, na.rm = T) / n()
      ) |>
      pivot_longer(starts_with("RT"), names_to = "percentile", values_to = "RT")
  )

save(posner_mod1_traces, posner_mod1_param_est, posner_mod1_fit, file = "analysis_objects/ddm_posner_mod1_parsed.RData")


# 4. Combine DDM data --------------------------------------------------------

ddm_raw <-
  reduce(
    list(
      flanker_mod1_param_est,
      simon_mod1_param_est,
      animacysize_mod1_param_est,
      colorshape_mod1_param_est,
      globallocal_mod1_param_est,
      posner_mod1_param_est
    ),
    full_join, by = "nomem_encr"
  ) |>
  drop_na(nomem_encr) |>
  select(nomem_encr, everything()) |>
  rename(
    flanker_con_v = flanker_v1,
    flanker_inc_v = flanker_v2,
    flanker_con_a = flanker_a1,
    flanker_inc_a = flanker_a2,
    flanker_con_t = flanker_t1,
    flanker_inc_t = flanker_t2,

    simon_con_v   = simon_v1,
    simon_inc_v   = simon_v2,
    simon_con_a   = simon_a1,
    simon_inc_a   = simon_a2,
    simon_con_t   = simon_t1,
    simon_inc_t   = simon_t2,

    cs_rep_v      = colorshape_v1,
    cs_sw_v       = colorshape_v2,
    cs_rep_a      = colorshape_a1,
    cs_sw_a       = colorshape_a2,
    cs_rep_t      = colorshape_t1,
    cs_sw_t       = colorshape_t2,

    as_rep_v      = animacysize_v1,
    as_sw_v       = animacysize_v2,
    as_rep_a      = animacysize_a1,
    as_sw_a       = animacysize_a2,
    as_rep_t      = animacysize_t1,
    as_sw_t       = animacysize_t2,

    gl_rep_v      = globallocal_v1,
    gl_sw_v       = globallocal_v2,
    gl_rep_a      = globallocal_a1,
    gl_sw_a       = globallocal_a2,
    gl_rep_t      = globallocal_t1,
    gl_sw_t       = globallocal_t2,

    pos_v         = posner_v,
    pos_a         = posner_a,
    pos_t         = posner_t,
  ) |>
  sjlabelled::var_labels(
    flanker_con_v = "Flanker task - drift rate of congruent trials",
    flanker_inc_v = "Flanker task - drift rate of incongruent trials",
    flanker_con_a = "Flanker task - Boundary separation of congruent trials",
    flanker_inc_a = "Flanker task - Boundary separation of incongruent trials",
    flanker_con_t = "Flanker task - Non-decision time of congruent trials",
    flanker_inc_t = "Flanker task - Non-decision time of incongruent trials",
    simon_con_v   = "Simon task - drift rate of congruent trials",
    simon_inc_v   = "Simon task - drift rate of incongruent trials",
    simon_con_a   = "Simon task - Boundary separation of congruent trials",
    simon_inc_a   = "Simon task - Boundary separation of incongruent trials",
    simon_con_t   = "Simon task - Non-decision time of congruent trials",
    simon_inc_t   = "Simon task - Non-decision time of incongruent trials",
    cs_rep_v      = "Color-shape task - Drift rate of repeat trials",
    cs_sw_v       = "Color-shape task - Drift rate of switch trials",
    cs_rep_a      = "Color-shape task - Boundary separation of repeat trials",
    cs_sw_a       = "Color-shape task - Boundary separation of switch trials",
    cs_rep_t      = "Color-shape task - Non-decision time of repeat trials",
    cs_sw_t       = "Color-shape task - Non-decision time of switch trials",
    as_rep_v      = "Animacy-size task - Drift rate of repeat trials",
    as_sw_v       = "Animacy-size task - Drift rate of switch trials",
    as_rep_a      = "Animacy-size task - Boundary separation of repeat trials",
    as_sw_a       = "Animacy-size task - Boundary separation of switch trials",
    as_rep_t      = "Animacy-size task - Non-decision time of repeat trials",
    as_sw_t       = "Animacy-size task - Non-decision time of switch trials",
    gl_rep_v      = "Global-local task - Drift rate of repeat trials",
    gl_sw_v       = "Global-local task - Drift rate of switch trials",
    gl_rep_a      = "Global-local task - Boundary separation of repeat trials",
    gl_sw_a       = "Global-local task - Boundary separation of switch trials",
    gl_rep_t      = "Global-local task - Non-decision time of repeat trials",
    gl_sw_t       = "Global-local task - Non-decision time of switch trials",
    pos_v         = "Posner task - Drift rate",
    pos_a         = "Posner task - Boundary separation",
    pos_t         = "Posner task - Non-decision time",
  )

write_csv(ddm_raw, "data/ddm_raw.csv")


# 5. Control DDM parameters for environmental noise and state anxiety ---------

stai_noise <- haven::read_sav('data/L_CognitiveAdversity_1.0p.sav')


stai_noise <- stai_noise |>
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
    stai_posner_diff      = stai_posner - stai_mean,

    one_session           = ifelse(DatumB == DatumE, 0, 1)
  ) |>
  rename(
    noise_simon       = Q1_1,
    noise_flanker     = Q1_2,
    noise_globallocal = Q1_3,
    noise_colorshape  = Q1_4,
    noise_animacysize = Q1_5,
    noise_posner      = Q1_6,
  ) |>
  select(nomem_encr, starts_with("noise"), matches("stai.*diff"))

ddm_clean <- ddm_raw |>
  left_join(stai_noise) %>%
  mutate(
    flanker_con_v_c = lm(flanker_con_v ~ noise_flanker + stai_flanker_diff, data = ., na.action=na.exclude) |> resid(),
    flanker_inc_v_c = lm(flanker_inc_v ~ noise_flanker + stai_flanker_diff, data = ., na.action=na.exclude) |> resid(),
    flanker_con_a_c = lm(flanker_con_a ~ noise_flanker + stai_flanker_diff, data = ., na.action=na.exclude) |> resid(),
    flanker_inc_a_c = lm(flanker_inc_a ~ noise_flanker + stai_flanker_diff, data = ., na.action=na.exclude) |> resid(),
    flanker_con_t_c = lm(flanker_con_t ~ noise_flanker + stai_flanker_diff, data = ., na.action=na.exclude) |> resid(),
    flanker_inc_t_c = lm(flanker_inc_t ~ noise_flanker + stai_flanker_diff, data = ., na.action=na.exclude) |> resid(),

    simon_con_v_c = lm(simon_con_v ~ noise_simon + stai_simon_diff, data = ., na.action=na.exclude) |> resid(),
    simon_inc_v_c = lm(simon_inc_v ~ noise_simon + stai_simon_diff, data = ., na.action=na.exclude) |> resid(),
    simon_con_a_c = lm(simon_con_a ~ noise_simon + stai_simon_diff, data = ., na.action=na.exclude) |> resid(),
    simon_inc_a_c = lm(simon_inc_a ~ noise_simon + stai_simon_diff, data = ., na.action=na.exclude) |> resid(),
    simon_con_t_c = lm(simon_con_t ~ noise_simon + stai_simon_diff, data = ., na.action=na.exclude) |> resid(),
    simon_inc_t_c = lm(simon_inc_t ~ noise_simon + stai_simon_diff, data = ., na.action=na.exclude) |> resid(),

    cs_rep_v_c = lm(cs_rep_v ~ noise_colorshape + stai_colorshape_diff, data = ., na.action=na.exclude) |> resid(),
    cs_sw_v_c  = lm(cs_sw_v ~ noise_colorshape + stai_colorshape_diff, data = ., na.action=na.exclude) |> resid(),
    cs_rep_a_c = lm(cs_rep_a ~ noise_colorshape + stai_colorshape_diff, data = ., na.action=na.exclude) |> resid(),
    cs_sw_a_c  = lm(cs_sw_a ~ noise_colorshape + stai_colorshape_diff, data = ., na.action=na.exclude) |> resid(),
    cs_rep_t_c = lm(cs_rep_t ~ noise_colorshape + stai_colorshape_diff, data = ., na.action=na.exclude) |> resid(),
    cs_sw_t_c  = lm(cs_sw_t ~ noise_colorshape + stai_colorshape_diff, data = ., na.action=na.exclude) |> resid(),

    gl_rep_v_c = lm(gl_rep_v ~ noise_globallocal + stai_globallocal_diff, data = ., na.action=na.exclude) |> resid(),
    gl_sw_v_c  = lm(gl_sw_v ~ noise_globallocal + stai_globallocal_diff, data = ., na.action=na.exclude) |> resid(),
    gl_rep_a_c = lm(gl_rep_a ~ noise_globallocal + stai_globallocal_diff, data = ., na.action=na.exclude) |> resid(),
    gl_sw_a_c  = lm(gl_sw_a ~ noise_globallocal + stai_globallocal_diff, data = ., na.action=na.exclude) |> resid(),
    gl_rep_t_c = lm(gl_rep_t ~ noise_globallocal + stai_globallocal_diff, data = ., na.action=na.exclude) |> resid(),
    gl_sw_t_c  = lm(gl_sw_t ~ noise_globallocal + stai_globallocal_diff, data = ., na.action=na.exclude) |> resid(),

    as_rep_v_c = lm(as_rep_v ~ noise_animacysize + stai_animacysize_diff, data = ., na.action=na.exclude) |> resid(),
    as_sw_v_c  = lm(as_sw_v ~ noise_animacysize + stai_animacysize_diff, data = ., na.action=na.exclude) |> resid(),
    as_rep_a_c = lm(as_rep_a ~ noise_animacysize + stai_animacysize_diff, data = ., na.action=na.exclude) |> resid(),
    as_sw_a_c  = lm(as_sw_a ~ noise_animacysize + stai_animacysize_diff, data = ., na.action=na.exclude) |> resid(),
    as_rep_t_c = lm(as_rep_t ~ noise_animacysize + stai_animacysize_diff, data = ., na.action=na.exclude) |> resid(),
    as_sw_t_c  = lm(as_sw_t ~ noise_animacysize + stai_animacysize_diff, data = ., na.action=na.exclude) |> resid(),

    pos_v_c = lm(pos_v ~ noise_posner + stai_posner_diff, data = ., na.action=na.exclude) |> resid(),
    pos_a_c = lm(pos_a ~ noise_posner + stai_posner_diff, data = ., na.action=na.exclude) |> resid(),
    pos_t_c = lm(pos_t ~ noise_posner + stai_posner_diff, data = ., na.action=na.exclude) |> resid(),
  )

# 5. Create codebook ------------------------------------------------------

ddm_clean_codebook <- create_codebook(ddm_clean)

openxlsx::write.xlsx(ddm_clean_codebook, file = "codebooks/ddm_clean_codebook.xlsx")



# 6. Write data -----------------------------------------------------------

save(ddm_clean, file = "data/ddm_clean.RData")


