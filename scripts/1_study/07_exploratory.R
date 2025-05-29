library(tidyverse)
library(lavaan)


# 1. Load data ------------------------------------------------------------

load('analysis_objects/results_confirmatory.RData')

load("data/ddm_clean.RData")
load("data/clean_data_mean.RData")

iv_data <- read_csv('data/liss_data/full_data.csv') |>
  filter(nomem_encr %in% unique(ddm_clean$nomem_encr)) |>
  mutate(across(c(child_dep, child_thr, age, p_scar_m, threat_comp, edu, child_adv), ~scale(.) |> as.numeric()))

ddm_clean <- ddm_clean |>
  mutate(across(-nomem_encr, ~scale(.) |> as.numeric()))

full_data <- full_join(iv_data, ddm_clean) |>
  left_join(clean_data_mean |> mutate(across(-nomem_encr, ~scale(.) |> as.numeric())))

data_long <- load("data/clean_data_long.RData")



equivalence_test_ml = function(sesoi, ml_effect, ml_se){
  p1 = 1 - pnorm( ml_effect, mean = -sesoi, sd = ml_se)
  p2 =     pnorm( ml_effect, mean =  sesoi, sd = ml_se)
  return(max(p1, p2))
}


# 2. Associations with childhood threat --------------------------------

## 2.1 Model specification ----
mod_expl_ch_thr <-
  '
    #### LATENT FACTORS ####

    # General factors #
    gen_v =~ 1*pos_v_c + flanker_inc_v_c + flanker_con_v_c + simon_inc_v_c + simon_con_v_c + cs_sw_v_c + cs_rep_v_c + gl_sw_v_c + gl_rep_v_c + as_sw_v_c + as_rep_v_c
    gen_a =~ 1*pos_a_c + flanker_inc_a_c + flanker_con_a_c + simon_inc_a_c + simon_con_a_c + cs_sw_a_c + cs_rep_a_c + gl_sw_a_c + gl_rep_a_c + as_sw_a_c + as_rep_a_c
    gen_t =~ 1*pos_t_c + flanker_inc_t_c + flanker_con_t_c + simon_inc_t_c + simon_con_t_c + cs_sw_t_c + cs_rep_t_c + gl_sw_t_c + gl_rep_t_c + as_sw_t_c + as_rep_t_c

    # Specific factors #
    common_v =~ 1*flanker_inc_v_c + simon_inc_v_c + cs_sw_v_c  + gl_sw_v_c + as_sw_v_c

    #### COVARIANCES ####

    # Between general factors #
    gen_v ~~ gen_a + gen_t
    gen_a ~~ gen_t

    # Between task-level parameters of the same task #
    flanker_inc_v_c ~~ flanker_con_v_c + flanker_inc_a_c + flanker_con_a_c + flanker_inc_t_c + flanker_con_t_c
    flanker_con_v_c ~~ flanker_inc_a_c + flanker_con_a_c + flanker_inc_t_c + flanker_con_t_c
    flanker_inc_a_c ~~ flanker_con_a_c + flanker_inc_t_c + flanker_con_t_c
    flanker_con_a_c ~~ flanker_inc_t_c + flanker_con_t_c
    flanker_inc_t_c ~~ flanker_con_t_c

    simon_inc_v_c ~~ simon_con_v_c + simon_inc_a_c + simon_con_a_c + simon_inc_t_c + simon_con_t_c
    simon_con_v_c ~~ simon_inc_a_c + simon_con_a_c + simon_inc_t_c + simon_con_t_c
    simon_inc_a_c ~~ simon_con_a_c + simon_inc_t_c + simon_con_t_c
    simon_con_a_c ~~ simon_inc_t_c + simon_con_t_c
    simon_inc_t_c ~~ simon_con_t_c

    cs_sw_v_c  ~~ cs_rep_v_c + cs_sw_a_c  + cs_rep_a_c + cs_sw_t_c  + cs_rep_t_c
    cs_rep_v_c ~~ cs_sw_a_c  + cs_rep_a_c + cs_sw_t_c  + cs_rep_t_c
    cs_sw_a_c  ~~ cs_rep_a_c + cs_sw_t_c  + cs_rep_t_c
    cs_rep_a_c ~~ cs_sw_t_c  + cs_rep_t_c
    cs_sw_t_c  ~~ cs_rep_t_c

    gl_sw_v_c  ~~ gl_rep_v_c + gl_sw_a_c   + gl_rep_a_c + gl_sw_t_c  + gl_rep_t_c
    gl_rep_v_c ~~ gl_sw_a_c  + gl_rep_a_c + gl_sw_t_c  + gl_rep_t_c
    gl_sw_a_c  ~~ gl_rep_a_c + gl_sw_t_c  + gl_rep_t_c
    gl_rep_a_c ~~ gl_sw_t_c  + gl_rep_t_c
    gl_sw_t_c  ~~ gl_rep_t_c

    as_sw_v_c  ~~ as_rep_v_c + as_sw_a_c  + as_rep_a_c + as_sw_t_c  + as_rep_t_c
    as_rep_v_c ~~ as_sw_a_c  + as_rep_a_c + as_sw_t_c  + as_rep_t_c
    as_sw_a_c  ~~ as_rep_a_c + as_sw_t_c  + as_rep_t_c
    as_rep_a_c ~~ as_sw_t_c  + as_rep_t_c
    as_sw_t_c  ~~ as_rep_t_c


    child_dep  ~~ child_thr + sex
    child_thr  ~~ sex


    #### INTERCEPTS ####

    pos_v_c         ~ 0
    flanker_inc_v_c ~ 0
    flanker_con_v_c ~ 0
    simon_inc_v_c   ~ 0
    simon_con_v_c   ~ 0
    cs_sw_v_c       ~ 0
    cs_rep_v_c      ~ 0
    gl_sw_v_c       ~ 0
    gl_rep_v_c      ~ 0
    as_sw_v_c       ~ 0
    as_rep_v_c      ~ 0

    pos_a_c         ~ 0
    flanker_inc_a_c ~ 0
    flanker_con_a_c ~ 0
    simon_inc_a_c   ~ 0
    simon_con_a_c   ~ 0
    cs_sw_a_c       ~ 0
    cs_rep_a_c      ~ 0
    gl_sw_a_c       ~ 0
    gl_rep_a_c      ~ 0
    as_sw_a_c       ~ 0
    as_rep_a_c      ~ 0

    pos_t_c         ~ 0
    flanker_inc_t_c ~ 0
    flanker_con_t_c ~ 0
    simon_inc_t_c   ~ 0
    simon_con_t_c   ~ 0
    cs_sw_t_c       ~ 0
    cs_rep_t_c      ~ 0
    gl_sw_t_c       ~ 0
    gl_rep_t_c      ~ 0
    as_sw_t_c       ~ 0
    as_rep_t_c      ~ 0

    child_dep       ~ 0
    child_thr       ~ 0

    ## REGRESSION PATHS ##

    gen_v ~ child_dep + child_thr + sex
    gen_a ~ child_dep + child_thr + sex
    gen_t ~ child_dep + child_thr + sex
'

## 2.2 Model fit ----

fit_expl_ch_thr <- lavaan::sem(
  model = mod_expl_ch_thr,
  data = full_data,
  estimator = "MLR", # Robust SEs in case of non-normal data
  missing = "ML",    # FIML for missing data
  cluster = 'nohouse_encr', # Clustering within
  se = "robust",
  orthogonal = TRUE,
  auto.cov.lv.x = FALSE,
  auto.cov.y = TRUE,
  std.lv = FALSE,
  fixed.x = FALSE
)

fit_expl_ch_thr_sum <- summary(fit_expl_ch_thr, standardized = TRUE, fit.measures = T)
fit_expl_ch_thr_fitstats <- fit_expl_ch_thr_sum$fit[c('chisq', 'df', 'pvalue', 'cfi.robust', 'rmsea.robust', 'rmsea.ci.lower.robust', 'rmsea.ci.upper.robust')]


## 2.3 Extract model results ----

expl_ch_thr_factor_loadings <- parameterEstimates(fit_expl_ch_thr, standardized = T) |>
  filter(op == "=~", str_detect(lhs, "gen"))

expl_ch_thr_reg_coef <- standardizedsolution(fit_expl_ch_thr) |>
  as_tibble() |>
  filter(op == "~", rhs %in% c("child_thr")) |>
  mutate(
    ddm_parameter = case_when(
      lhs == "gen_v" | str_detect(lhs, "_v") ~ "Drift rate",
      lhs == "gen_a" | str_detect(lhs, "_a") ~ "Boundary separation",
      lhs == "gen_t" | str_detect(lhs, "_t") ~ "Non-decision time",
    )
  ) |>
  group_by(ddm_parameter) |>
  mutate(pvalue_adj = p.adjust(pvalue, method = "fdr")) |>
  ungroup()


## 2.4 Equivalence tests ----

expl_ch_thr_eqtests <- standardizedSolution(fit_expl_ch_thr) |>
  as_tibble() |>
  filter(op == "~", rhs %in% c("child_thr")) |>
  select(lhs, rhs, est.std, se) |>
  mutate(
    eq_pvalue = pmap(list(lhs, rhs, est.std, se), function(lhs, rhs, est.std, se) {
      equivalence_test_ml(0.1, est.std, se)
    })
  ) |>
  unnest(eq_pvalue)



# 3. Associations with childhood deprivation ------------------------------

## 3.1 Model specification ----
mod_expl_ch_dep <-
  '
    #### LATENT FACTORS ####

    # General factors #
    gen_v =~ 1*pos_v_c + flanker_inc_v_c + flanker_con_v_c + simon_inc_v_c + simon_con_v_c + cs_sw_v_c + cs_rep_v_c + gl_sw_v_c + gl_rep_v_c + as_sw_v_c + as_rep_v_c
    gen_a =~ 1*pos_a_c + flanker_inc_a_c + flanker_con_a_c + simon_inc_a_c + simon_con_a_c + cs_sw_a_c + cs_rep_a_c + gl_sw_a_c + gl_rep_a_c + as_sw_a_c + as_rep_a_c
    gen_t =~ 1*pos_t_c + flanker_inc_t_c + flanker_con_t_c + simon_inc_t_c + simon_con_t_c + cs_sw_t_c + cs_rep_t_c + gl_sw_t_c + gl_rep_t_c + as_sw_t_c + as_rep_t_c

    # Specific factors #
    common_v =~ 1*flanker_inc_v_c + simon_inc_v_c + cs_sw_v_c  + gl_sw_v_c + as_sw_v_c

    #### COVARIANCES ####

    # Between general factors #
    gen_v ~~ gen_a + gen_t
    gen_a ~~ gen_t

    # Between task-level parameters of the same task #
    flanker_inc_v_c ~~ flanker_con_v_c + flanker_inc_a_c + flanker_con_a_c + flanker_inc_t_c + flanker_con_t_c
    flanker_con_v_c ~~ flanker_inc_a_c + flanker_con_a_c + flanker_inc_t_c + flanker_con_t_c
    flanker_inc_a_c ~~ flanker_con_a_c + flanker_inc_t_c + flanker_con_t_c
    flanker_con_a_c ~~ flanker_inc_t_c + flanker_con_t_c
    flanker_inc_t_c ~~ flanker_con_t_c

    simon_inc_v_c ~~ simon_con_v_c + simon_inc_a_c + simon_con_a_c + simon_inc_t_c + simon_con_t_c
    simon_con_v_c ~~ simon_inc_a_c + simon_con_a_c + simon_inc_t_c + simon_con_t_c
    simon_inc_a_c ~~ simon_con_a_c + simon_inc_t_c + simon_con_t_c
    simon_con_a_c ~~ simon_inc_t_c + simon_con_t_c
    simon_inc_t_c ~~ simon_con_t_c

    cs_sw_v_c  ~~ cs_rep_v_c + cs_sw_a_c  + cs_rep_a_c + cs_sw_t_c  + cs_rep_t_c
    cs_rep_v_c ~~ cs_sw_a_c  + cs_rep_a_c + cs_sw_t_c  + cs_rep_t_c
    cs_sw_a_c  ~~ cs_rep_a_c + cs_sw_t_c  + cs_rep_t_c
    cs_rep_a_c ~~ cs_sw_t_c  + cs_rep_t_c
    cs_sw_t_c  ~~ cs_rep_t_c

    gl_sw_v_c  ~~ gl_rep_v_c + gl_sw_a_c   + gl_rep_a_c + gl_sw_t_c  + gl_rep_t_c
    gl_rep_v_c ~~ gl_sw_a_c  + gl_rep_a_c + gl_sw_t_c  + gl_rep_t_c
    gl_sw_a_c  ~~ gl_rep_a_c + gl_sw_t_c  + gl_rep_t_c
    gl_rep_a_c ~~ gl_sw_t_c  + gl_rep_t_c
    gl_sw_t_c  ~~ gl_rep_t_c

    as_sw_v_c  ~~ as_rep_v_c + as_sw_a_c  + as_rep_a_c + as_sw_t_c  + as_rep_t_c
    as_rep_v_c ~~ as_sw_a_c  + as_rep_a_c + as_sw_t_c  + as_rep_t_c
    as_sw_a_c  ~~ as_rep_a_c + as_sw_t_c  + as_rep_t_c
    as_rep_a_c ~~ as_sw_t_c  + as_rep_t_c
    as_sw_t_c  ~~ as_rep_t_c


    child_dep  ~~ sex

    #### INTERCEPTS ####

    pos_v_c         ~ 0
    flanker_inc_v_c ~ 0
    flanker_con_v_c ~ 0
    simon_inc_v_c   ~ 0
    simon_con_v_c   ~ 0
    cs_sw_v_c       ~ 0
    cs_rep_v_c      ~ 0
    gl_sw_v_c       ~ 0
    gl_rep_v_c      ~ 0
    as_sw_v_c       ~ 0
    as_rep_v_c      ~ 0

    pos_a_c         ~ 0
    flanker_inc_a_c ~ 0
    flanker_con_a_c ~ 0
    simon_inc_a_c   ~ 0
    simon_con_a_c   ~ 0
    cs_sw_a_c       ~ 0
    cs_rep_a_c      ~ 0
    gl_sw_a_c       ~ 0
    gl_rep_a_c      ~ 0
    as_sw_a_c       ~ 0
    as_rep_a_c      ~ 0

    pos_t_c         ~ 0
    flanker_inc_t_c ~ 0
    flanker_con_t_c ~ 0
    simon_inc_t_c   ~ 0
    simon_con_t_c   ~ 0
    cs_sw_t_c       ~ 0
    cs_rep_t_c      ~ 0
    gl_sw_t_c       ~ 0
    gl_rep_t_c      ~ 0
    as_sw_t_c       ~ 0
    as_rep_t_c      ~ 0

    child_dep       ~ 0
    child_thr       ~ 0

    ## REGRESSION PATHS ##

    gen_v ~ child_dep + sex
    gen_a ~ child_dep + sex
    gen_t ~ child_dep + sex
'

## 2.2 Model fit ----

fit_expl_ch_dep <- lavaan::sem(
  model = mod_expl_ch_dep,
  data = full_data,
  estimator = "MLR", # Robust SEs in case of non-normal data
  missing = "ML",    # FIML for missing data
  cluster = 'nohouse_encr', # Clustering within
  se = "robust",
  orthogonal = TRUE,
  auto.cov.lv.x = FALSE,
  auto.cov.y = TRUE,
  std.lv = FALSE,
  fixed.x = FALSE
)

fit_expl_ch_dep_sum <- summary(fit_expl_ch_dep, standardized = TRUE, fit.measures = T)
fit_expl_ch_dep_fitstats <- fit_expl_ch_dep_sum$fit[c('chisq', 'df', 'pvalue', 'cfi.robust', 'rmsea.robust', 'rmsea.ci.lower.robust', 'rmsea.ci.upper.robust')]


## 2.3 Extract model results ----

expl_ch_dep_factor_loadings <- parameterEstimates(fit_expl_ch_dep, standardized = T) |>
  filter(op == "=~", str_detect(lhs, "gen"))

expl_ch_dep_reg_coef <- standardizedsolution(fit_expl_ch_dep) |>
  as_tibble() |>
  filter(op == "~", rhs %in% c("child_dep")) |>
  mutate(
    ddm_parameter = case_when(
      lhs == "gen_v" | str_detect(lhs, "_v") ~ "Drift rate",
      lhs == "gen_a" | str_detect(lhs, "_a") ~ "Boundary separation",
      lhs == "gen_t" | str_detect(lhs, "_t") ~ "Non-decision time",
    )
  ) |>
  mutate(pvalue_adj = p.adjust(pvalue, method = "fdr")) |>
  ungroup()


## 2.4 Equivalence tests ----

expl_ch_dep_eqtests <- standardizedSolution(fit_expl_ch_dep) |>
  as_tibble() |>
  filter(op == "~", rhs %in% c("child_dep")) |>
  select(lhs, rhs, est.std, se) |>
  mutate(
    eq_pvalue = pmap(list(lhs, rhs, est.std, se), function(lhs, rhs, est.std, se) {
      equivalence_test_ml(0.1, est.std, se)
    })
  ) |>
  unnest(eq_pvalue)

# 3. Associations with task-specific residual variances ----------------------

## 3.1 Model optimization 1: all drift rates correlate (does not converge) ----

mod1_expl_ts <-
  '
    #### LATENT FACTORS ####

    # General factors #
    gen_v =~ 1*pos_v_c + flanker_inc_v_c + flanker_con_v_c + simon_inc_v_c + simon_con_v_c + cs_sw_v_c + cs_rep_v_c + gl_sw_v_c + gl_rep_v_c + as_sw_v_c + as_rep_v_c


    # Specific factors #
    sp_pos_v    =~ 1*pos_v_c
    sp_fl_inc_v =~ 1*flanker_inc_v_c
    sp_fl_con_v =~ 1*flanker_con_v_c
    sp_si_inc_v =~ 1*simon_inc_v_c
    sp_si_con_v =~ 1*simon_con_v_c
    sp_cs_rep_v =~ 1*cs_rep_v_c
    sp_cs_sw_v  =~ 1*cs_sw_v_c
    sp_as_rep_v =~ 1*as_rep_v_c
    sp_as_sw_v  =~ 1*as_sw_v_c
    sp_gl_rep_v =~ 1*gl_rep_v_c
    sp_gl_sw_v  =~ 1*gl_sw_v_c

    #### COVARIANCES ####

    # Between general factors #

    # Between task-level parameters of the same task #

    sp_pos_v        ~~ sp_fl_inc_v + sp_fl_con_v + sp_si_inc_v + sp_si_con_v + sp_cs_rep_v + sp_cs_sw_v + sp_as_rep_v + sp_as_sw_v + sp_gl_rep_v + sp_gl_sw_v
    sp_fl_inc_v     ~~ sp_fl_con_v + sp_si_inc_v + sp_si_con_v + sp_cs_rep_v + sp_cs_sw_v + sp_as_rep_v + sp_as_sw_v + sp_gl_rep_v + sp_gl_sw_v
    sp_fl_con_v     ~~ sp_si_inc_v + sp_si_con_v + sp_cs_rep_v + sp_cs_sw_v + sp_as_rep_v + sp_as_sw_v + sp_gl_rep_v + sp_gl_sw_v
    sp_si_inc_v     ~~ sp_si_con_v + sp_cs_rep_v + sp_cs_sw_v + sp_as_rep_v + sp_as_sw_v + sp_gl_rep_v + sp_gl_sw_v
    sp_si_con_v     ~~ sp_cs_rep_v + sp_cs_sw_v + sp_as_rep_v + sp_as_sw_v + sp_gl_rep_v + sp_gl_sw_v
    sp_cs_rep_v     ~~ sp_cs_sw_v + sp_as_rep_v + sp_as_sw_v + sp_gl_rep_v + sp_gl_sw_v
    sp_cs_sw_v      ~~ sp_as_rep_v + sp_as_sw_v + sp_gl_rep_v + sp_gl_sw_v
    sp_as_rep_v     ~~ sp_as_sw_v + sp_gl_rep_v + sp_gl_sw_v
    sp_as_sw_v      ~~ sp_gl_rep_v + sp_gl_sw_v
    sp_gl_rep_v     ~~ sp_gl_sw_v

    pos_v_c         ~~ 0*pos_v_c
    flanker_inc_v_c ~~ 0*flanker_inc_v_c
    flanker_con_v_c ~~ 0*flanker_con_v_c
    simon_inc_v_c   ~~ 0*simon_inc_v_c
    simon_con_v_c   ~~ 0*simon_con_v_c
    cs_sw_v_c       ~~ 0*cs_sw_v_c
    cs_rep_v_c      ~~ 0*cs_rep_v_c
    gl_sw_v_c       ~~ 0*gl_sw_v_c
    gl_rep_v_c      ~~ 0*gl_rep_v_c
    as_sw_v_c       ~~ 0*as_sw_v_c
    as_rep_v_c      ~~ 0*as_rep_v_c

    #### INTERCEPTS ####

    pos_v_c         ~ 0
    flanker_inc_v_c ~ 0
    flanker_con_v_c ~ 0
    simon_inc_v_c   ~ 0
    simon_con_v_c   ~ 0
    cs_sw_v_c       ~ 0
    cs_rep_v_c      ~ 0
    gl_sw_v_c       ~ 0
    gl_rep_v_c      ~ 0
    as_sw_v_c       ~ 0
    as_rep_v_c      ~ 0
'
# Does not converge
fit_expl_ts_mod1 <- lavaan::sem(
  model = mod1_expl_ts,
  data = full_data,
  estimator = "MLR", # Robust SEs in case of non-normal data
  missing = "ML",    # FIML for missing data
  cluster = 'nohouse_encr', # Clustering within
  se = "robust",
  orthogonal = T,
  auto.cov.lv.x = TRUE,
  auto.cov.y = TRUE,
  std.lv = FALSE,
  fixed.x = FALSE
)

## 3.2 Model optimization 2: only drift rates of the same task type (inhibition, shifting) correlate ----


mod2_expl_ts <-
  '
    #### LATENT FACTORS ####

    # General factors #
    gen_v =~ 1*pos_v_c + flanker_inc_v_c + flanker_con_v_c + simon_inc_v_c + simon_con_v_c + cs_sw_v_c + cs_rep_v_c + gl_sw_v_c + gl_rep_v_c + as_sw_v_c + as_rep_v_c


    # Specific factors #
    sp_pos_v    =~ 1*pos_v_c
    sp_fl_inc_v =~ 1*flanker_inc_v_c
    sp_fl_con_v =~ 1*flanker_con_v_c
    sp_si_inc_v =~ 1*simon_inc_v_c
    sp_si_con_v =~ 1*simon_con_v_c
    sp_cs_rep_v =~ 1*cs_rep_v_c
    sp_cs_sw_v  =~ 1*cs_sw_v_c
    sp_as_rep_v =~ 1*as_rep_v_c
    sp_as_sw_v  =~ 1*as_sw_v_c
    sp_gl_rep_v =~ 1*gl_rep_v_c
    sp_gl_sw_v  =~ 1*gl_sw_v_c

    #### COVARIANCES ####

    # Between general factors #

    # Between task-level parameters of the same ability #

    sp_fl_inc_v     ~~ sp_fl_con_v + sp_si_inc_v + sp_si_con_v
    sp_fl_con_v     ~~ sp_si_inc_v + sp_si_con_v
    sp_si_inc_v     ~~ sp_si_con_v
    sp_cs_rep_v     ~~ sp_cs_sw_v + sp_as_rep_v + sp_as_sw_v + sp_gl_rep_v + sp_gl_sw_v
    sp_cs_sw_v      ~~ sp_as_rep_v + sp_as_sw_v + sp_gl_rep_v + sp_gl_sw_v
    sp_as_rep_v     ~~ sp_as_sw_v + sp_gl_rep_v + sp_gl_sw_v
    sp_as_sw_v      ~~ sp_gl_rep_v + sp_gl_sw_v
    sp_gl_rep_v     ~~ sp_gl_sw_v


    pos_v_c         ~~ 0*pos_v_c
    flanker_inc_v_c ~~ 0*flanker_inc_v_c
    flanker_con_v_c ~~ 0*flanker_con_v_c
    simon_inc_v_c   ~~ 0*simon_inc_v_c
    simon_con_v_c   ~~ 0*simon_con_v_c
    cs_sw_v_c       ~~ 0*cs_sw_v_c
    cs_rep_v_c      ~~ 0*cs_rep_v_c
    gl_sw_v_c       ~~ 0*gl_sw_v_c
    gl_rep_v_c      ~~ 0*gl_rep_v_c
    as_sw_v_c       ~~ 0*as_sw_v_c
    as_rep_v_c      ~~ 0*as_rep_v_c

    #### INTERCEPTS ####

    pos_v_c         ~ 0
    flanker_inc_v_c ~ 0
    flanker_con_v_c ~ 0
    simon_inc_v_c   ~ 0
    simon_con_v_c   ~ 0
    cs_sw_v_c       ~ 0
    cs_rep_v_c      ~ 0
    gl_sw_v_c       ~ 0
    gl_rep_v_c      ~ 0
    as_sw_v_c       ~ 0
    as_rep_v_c      ~ 0
'

fit_expl_ts_mod2 <- lavaan::sem(
  model = mod2_expl_ts,
  data = full_data,
  estimator = "MLR", # Robust SEs in case of non-normal data
  missing = "ML",    # FIML for missing data
  cluster = 'nohouse_encr', # Clustering within
  se = "robust",
  orthogonal = T,
  auto.cov.lv.x = TRUE,
  auto.cov.y = TRUE,
  std.lv = FALSE,
  fixed.x = FALSE
)

fit_expl_ts_mod2_sum <- summary(fit_expl_ts_mod2, standardized = TRUE, fit.measures = T)
fit_expl_ts_mod2_fitstats <- fit_expl_ts_mod2_sum$fit[c('chisq', 'df', 'pvalue', 'cfi.robust', 'rmsea.robust', 'rmsea.ci.lower.robust', 'rmsea.ci.upper.robust')]


expl_ts_cor_inh <- standardizedSolution(fit_expl_ts_mod2) |>
  as_tibble() |>
  filter(op == "~~", str_detect(lhs, "^sp_"), str_detect(lhs, "_(fl|si)_"), str_detect(rhs, "^sp_"), str_detect(rhs, "_(fl|si)_")) |>
  bind_rows(
    standardizedSolution(fit_expl_ts_mod2) |>
      as_tibble() |>
      rename(rhs = lhs, lhs = rhs) |>
      filter(op == "~~", str_detect(lhs, "^sp_"), str_detect(rhs, "^sp_"), lhs != rhs,  str_detect(lhs, "_(fl|si)_"), str_detect(rhs, "_(fl|si)_"))
  ) |>
  select(lhs, rhs, est.std) |>
  arrange(lhs, rhs) |>
  mutate(across(c(lhs, rhs),
                ~case_when(
                  . == 'sp_fl_con_v' ~ "Flanker\ncongruent",
                  . == 'sp_fl_inc_v' ~ "Flanker\nincongruent",
                  . == 'sp_si_con_v' ~ "Simon\ncongruent",
                  . == 'sp_si_inc_v' ~ "Simon\nincongruent"
                ))) |>
  rowwise() %>%
  mutate(pair = sort(c(lhs, rhs)) %>% paste(collapse = ",")) %>%
  arrange() |>
  filter(rhs != lhs) |>
  group_by(pair) %>%
  distinct(pair, .keep_all = T)

expl_ts_cor_sh <- standardizedSolution(fit_expl_ts_mod2) |>
  as_tibble() |>
  filter(op == "~~", str_detect(lhs, "^sp_"), str_detect(lhs, "_(cs|as|gl)_"), str_detect(rhs, "^sp_"), str_detect(rhs, "_(cs|as|gl)_")) |>
  bind_rows(
    standardizedSolution(fit_expl_ts_mod2) |>
      as_tibble() |>
      filter(op == "~~", str_detect(lhs, "^sp_"), lhs != rhs, str_detect(lhs, "_(cs|as|gl)_"), str_detect(rhs, "^sp_"), str_detect(rhs, "_(cs|as|gl)_")) |>
      rename(rhs = lhs, lhs = rhs)
  ) |>
  select(lhs, rhs, est.std) |>
  arrange(lhs, rhs) |>
  mutate(across(c(lhs, rhs),
                ~case_when(
                  . == 'sp_cs_rep_v' ~ "Color-shape\nrepetition",
                  . == 'sp_cs_sw_v' ~ "Color-shape\nswitch",
                  . == 'sp_as_rep_v' ~ "Animacy-size\nrepetition",
                  . == 'sp_as_sw_v' ~ "Animacy-size\nswitch",
                  . == 'sp_gl_rep_v' ~ "Global-local\nrepetition",
                  . == 'sp_gl_sw_v' ~ "Global-local\nswitch",
                ))) |>
  rowwise() %>%
  mutate(pair = sort(c(lhs, rhs)) %>% paste(collapse = ",")) %>%
  arrange() |>
  filter(rhs != lhs) |>
  group_by(pair) %>%
  distinct(pair, .keep_all = T)

## 3.3 Threat in adulthood model ----

mod2_expl_ts_adult_threat <-
  '
    #### LATENT FACTORS ####

    # General factors #
    gen_v =~ 1*pos_v_c + flanker_inc_v_c + flanker_con_v_c + simon_inc_v_c + simon_con_v_c + cs_sw_v_c + cs_rep_v_c + gl_sw_v_c + gl_rep_v_c + as_sw_v_c + as_rep_v_c


    # Specific factors #
    sp_pos_v    =~ 1*pos_v_c
    sp_fl_inc_v =~ 1*flanker_inc_v_c
    sp_fl_con_v =~ 1*flanker_con_v_c
    sp_si_inc_v =~ 1*simon_inc_v_c
    sp_si_con_v =~ 1*simon_con_v_c
    sp_cs_rep_v =~ 1*cs_rep_v_c
    sp_cs_sw_v  =~ 1*cs_sw_v_c
    sp_as_rep_v =~ 1*as_rep_v_c
    sp_as_sw_v  =~ 1*as_sw_v_c
    sp_gl_rep_v =~ 1*gl_rep_v_c
    sp_gl_sw_v  =~ 1*gl_sw_v_c

    #### COVARIANCES ####

    # Between general factors #

    # Between task-level parameters of the same ability #

    sp_fl_inc_v     ~~ sp_fl_con_v + sp_si_inc_v + sp_si_con_v
    sp_fl_con_v     ~~ sp_si_inc_v + sp_si_con_v
    sp_si_inc_v     ~~ sp_si_con_v
    sp_cs_rep_v     ~~ sp_cs_sw_v + sp_as_rep_v + sp_as_sw_v + sp_gl_rep_v + sp_gl_sw_v
    sp_cs_sw_v      ~~ sp_as_rep_v + sp_as_sw_v + sp_gl_rep_v + sp_gl_sw_v
    sp_as_rep_v     ~~ sp_as_sw_v + sp_gl_rep_v + sp_gl_sw_v
    sp_as_sw_v      ~~ sp_gl_rep_v + sp_gl_sw_v
    sp_gl_rep_v     ~~ sp_gl_sw_v


    pos_v_c         ~~ 0*pos_v_c
    flanker_inc_v_c ~~ 0*flanker_inc_v_c
    flanker_con_v_c ~~ 0*flanker_con_v_c
    simon_inc_v_c   ~~ 0*simon_inc_v_c
    simon_con_v_c   ~~ 0*simon_con_v_c
    cs_sw_v_c       ~~ 0*cs_sw_v_c
    cs_rep_v_c      ~~ 0*cs_rep_v_c
    gl_sw_v_c       ~~ 0*gl_sw_v_c
    gl_rep_v_c      ~~ 0*gl_rep_v_c
    as_sw_v_c       ~~ 0*as_sw_v_c
    as_rep_v_c      ~~ 0*as_rep_v_c

    age             ~~ p_scar_m + threat_comp + sex + child_adv
    p_scar_m        ~~ threat_comp + sex + child_adv
    threat_comp     ~~ sex + child_adv
    sex             ~~ child_adv


    #### INTERCEPTS ####

    pos_v_c         ~ 0
    flanker_inc_v_c ~ 0
    flanker_con_v_c ~ 0
    simon_inc_v_c   ~ 0
    simon_con_v_c   ~ 0
    cs_sw_v_c       ~ 0
    cs_rep_v_c      ~ 0
    gl_sw_v_c       ~ 0
    gl_rep_v_c      ~ 0
    as_sw_v_c       ~ 0
    as_rep_v_c      ~ 0

    age             ~ 0
    child_adv       ~ 0
    threat_comp     ~ 0
    p_scar_m        ~ 0

    ## REGRESSION PATHS ##
    sp_pos_v    ~ threat_comp + p_scar_m + age + sex + child_adv
    sp_fl_inc_v ~ threat_comp + p_scar_m + age + sex + child_adv
    sp_fl_con_v ~ threat_comp + p_scar_m + age + sex + child_adv
    sp_si_inc_v ~ threat_comp + p_scar_m + age + sex + child_adv
    sp_si_con_v ~ threat_comp + p_scar_m + age + sex + child_adv
    sp_cs_rep_v ~ threat_comp + p_scar_m + age + sex + child_adv
    sp_cs_sw_v  ~ threat_comp + p_scar_m + age + sex + child_adv
    sp_as_rep_v ~ threat_comp + p_scar_m + age + sex + child_adv
    sp_as_sw_v  ~ threat_comp + p_scar_m + age + sex + child_adv
    sp_gl_rep_v ~ threat_comp + p_scar_m + age + sex + child_adv
    sp_gl_sw_v  ~ threat_comp + p_scar_m + age + sex + child_adv

'

fit_expl_ts_adult_threat <- lavaan::sem(
  model = mod2_expl_ts_adult_threat,
  data = full_data,
  estimator = "MLR", # Robust SEs in case of non-normal data
  missing = "ML",    # FIML for missing data
  cluster = 'nohouse_encr', # Clustering within
  se = "robust",
  orthogonal = T,
  auto.cov.lv.x = TRUE,
  auto.cov.y = TRUE,
  std.lv = FALSE,
  fixed.x = FALSE
)

fit_expl_ts_adult_threat_sum <- summary(fit_expl_ts_adult_threat, standardized = TRUE, fit.measures = T)
fit_expl_ts_adult_threat_fitstats <- fit_expl_ts_adult_threat_sum$fit[c('chisq', 'df', 'pvalue', 'cfi.robust', 'rmsea.robust', 'rmsea.ci.lower.robust', 'rmsea.ci.upper.robust')]


### Extract model results ----

expl_ts_adult_threat_factor_loadings <- parameterEstimates(fit_expl_ts_adult_threat, standardized = T) |>
  filter(op == "=~", str_detect(lhs, "gen"))

expl_ts_adult_threat_reg_coef <- standardizedsolution(fit_expl_ts_adult_threat) |>
  as_tibble() |>
  filter(op == "~", rhs == "threat_comp", !str_detect(lhs, "^gen_")) |>
  mutate(
    task = case_when(
      str_detect(lhs, "_pos_") ~ "Posner",
      str_detect(lhs, "_fl_") ~ "Flanker",
      str_detect(lhs, "_si_") ~ "Simon",
      str_detect(lhs, "_cs_") ~ "Color-shape",
      str_detect(lhs, "_as_") ~ "Animacy-size",
      str_detect(lhs, "_gl_") ~ "Global-local",
    )
  ) |>
  mutate(
    pvalue_adj = p.adjust(pvalue, method = "fdr"),
    adversity  = "Threat",
    timing     = "Adulthood" ) |>
  ungroup()

expl_ts_adult_threat_eqtests <- standardizedSolution(fit_expl_ts_adult_threat) |>
  as_tibble() |>
  filter(op == "~", rhs %in% c("threat_comp"), !str_detect(lhs, "^gen_")) |>
  select(lhs, rhs, est.std, se) |>
  mutate(
    eq_pvalue = pmap(list(lhs, rhs, est.std, se), function(lhs, rhs, est.std, se) {
      equivalence_test_ml(0.1, est.std, se)
    }),
    adversity  = "Threat",
    timing     = "Adulthood"
  ) |>
  unnest(eq_pvalue)

## 3.3 Deprivation in adulthood model ----

mod2_expl_ts_adult_dep <-
  '
    #### LATENT FACTORS ####

    # General factors #
    gen_v =~ 1*pos_v_c + flanker_inc_v_c + flanker_con_v_c + simon_inc_v_c + simon_con_v_c + cs_sw_v_c + cs_rep_v_c + gl_sw_v_c + gl_rep_v_c + as_sw_v_c + as_rep_v_c


    # Specific factors #
    sp_pos_v    =~ 1*pos_v_c
    sp_fl_inc_v =~ 1*flanker_inc_v_c
    sp_fl_con_v =~ 1*flanker_con_v_c
    sp_si_inc_v =~ 1*simon_inc_v_c
    sp_si_con_v =~ 1*simon_con_v_c
    sp_cs_rep_v =~ 1*cs_rep_v_c
    sp_cs_sw_v  =~ 1*cs_sw_v_c
    sp_as_rep_v =~ 1*as_rep_v_c
    sp_as_sw_v  =~ 1*as_sw_v_c
    sp_gl_rep_v =~ 1*gl_rep_v_c
    sp_gl_sw_v  =~ 1*gl_sw_v_c

    #### COVARIANCES ####

    # Between general factors #

    # Between task-level parameters of the same ability #

    sp_fl_inc_v     ~~ sp_fl_con_v + sp_si_inc_v + sp_si_con_v
    sp_fl_con_v     ~~ sp_si_inc_v + sp_si_con_v
    sp_si_inc_v     ~~ sp_si_con_v
    sp_cs_rep_v     ~~ sp_cs_sw_v + sp_as_rep_v + sp_as_sw_v + sp_gl_rep_v + sp_gl_sw_v
    sp_cs_sw_v      ~~ sp_as_rep_v + sp_as_sw_v + sp_gl_rep_v + sp_gl_sw_v
    sp_as_rep_v     ~~ sp_as_sw_v + sp_gl_rep_v + sp_gl_sw_v
    sp_as_sw_v      ~~ sp_gl_rep_v + sp_gl_sw_v
    sp_gl_rep_v     ~~ sp_gl_sw_v


    pos_v_c         ~~ 0*pos_v_c
    flanker_inc_v_c ~~ 0*flanker_inc_v_c
    flanker_con_v_c ~~ 0*flanker_con_v_c
    simon_inc_v_c   ~~ 0*simon_inc_v_c
    simon_con_v_c   ~~ 0*simon_con_v_c
    cs_sw_v_c       ~~ 0*cs_sw_v_c
    cs_rep_v_c      ~~ 0*cs_rep_v_c
    gl_sw_v_c       ~~ 0*gl_sw_v_c
    gl_rep_v_c      ~~ 0*gl_rep_v_c
    as_sw_v_c       ~~ 0*as_sw_v_c
    as_rep_v_c      ~~ 0*as_rep_v_c

    age             ~~ p_scar_m + sex + edu + child_adv
    p_scar_m        ~~ sex + edu + child_adv
    sex             ~~ edu + child_adv
    edu             ~~ child_adv

    #### INTERCEPTS ####

    pos_v_c         ~ 0
    flanker_inc_v_c ~ 0
    flanker_con_v_c ~ 0
    simon_inc_v_c   ~ 0
    simon_con_v_c   ~ 0
    cs_sw_v_c       ~ 0
    cs_rep_v_c      ~ 0
    gl_sw_v_c       ~ 0
    gl_rep_v_c      ~ 0
    as_sw_v_c       ~ 0
    as_rep_v_c      ~ 0

    age             ~ 0
    child_adv       ~ 0
    p_scar_m        ~ 0
    edu             ~ 0

    ## REGRESSION PATHS ##
    sp_pos_v    ~ p_scar_m + age + sex + edu + child_adv
    sp_fl_inc_v ~ p_scar_m + age + sex + edu + child_adv
    sp_fl_con_v ~ p_scar_m + age + sex + edu + child_adv
    sp_si_inc_v ~ p_scar_m + age + sex + edu + child_adv
    sp_si_con_v ~ p_scar_m + age + sex + edu + child_adv
    sp_cs_rep_v ~ p_scar_m + age + sex + edu + child_adv
    sp_cs_sw_v  ~ p_scar_m + age + sex + edu + child_adv
    sp_as_rep_v ~ p_scar_m + age + sex + edu + child_adv
    sp_as_sw_v  ~ p_scar_m + age + sex + edu + child_adv
    sp_gl_rep_v ~ p_scar_m + age + sex + edu + child_adv
    sp_gl_sw_v  ~ p_scar_m + age + sex + edu + child_adv

'

fit_expl_ts_adult_dep <- lavaan::sem(
  model = mod2_expl_ts_adult_dep,
  data = full_data,
  estimator = "MLR", # Robust SEs in case of non-normal data
  missing = "ML",    # FIML for missing data
  cluster = 'nohouse_encr', # Clustering within
  se = "robust",
  orthogonal = T,
  auto.cov.lv.x = TRUE,
  auto.cov.y = TRUE,
  std.lv = FALSE,
  fixed.x = FALSE
)

fit_expl_ts_adult_dep_sum <- summary(fit_expl_ts_adult_dep, standardized = TRUE, fit.measures = T)
fit_expl_ts_adult_dep_fitstats <- fit_expl_ts_adult_dep_sum$fit[c('chisq', 'df', 'pvalue', 'cfi.robust', 'rmsea.robust', 'rmsea.ci.lower.robust', 'rmsea.ci.upper.robust')]

### Extract model results

expl_ts_adult_dep_factor_loadings <- parameterEstimates(fit_expl_ts_adult_dep, standardized = T) |>
  filter(op == "=~", str_detect(lhs, "gen"))

expl_ts_adult_dep_reg_coef <- standardizedsolution(fit_expl_ts_adult_dep) |>
  as_tibble() |>
  filter(op == "~", rhs == "p_scar_m", !str_detect(lhs, "^gen_")) |>
  mutate(
    task = case_when(
      str_detect(lhs, "_pos_") ~ "Posner",
      str_detect(lhs, "_fl_") ~ "Flanker",
      str_detect(lhs, "_si_") ~ "Simon",
      str_detect(lhs, "_cs_") ~ "Color-shape",
      str_detect(lhs, "_as_") ~ "Animacy-size",
      str_detect(lhs, "_gl_") ~ "Global-local",
    )
  ) |>
  mutate(
    pvalue_adj = p.adjust(pvalue, method = "fdr"),
    adversity  = "Deprivation",
    timing     = "Adulthood"
  ) |>
  ungroup()


### Equivalence tests ----

expl_ts_adult_dep_eqtests <- standardizedSolution(fit_expl_ts_adult_dep) |>
  as_tibble() |>
  filter(op == "~", rhs %in% c("p_scar_m"), !str_detect(lhs, "^gen_")) |>
  select(lhs, rhs, est.std, se) |>
  mutate(
    eq_pvalue = pmap(list(lhs, rhs, est.std, se), function(lhs, rhs, est.std, se) {
      equivalence_test_ml(0.1, est.std, se)
    }),
    adversity  = "Deprivation",
    timing     = "Childhood"
  ) |>
  unnest(eq_pvalue)


## 3.4 Threat in childhood model ----

mod2_expl_ts_ch_thr <-
  '
    #### LATENT FACTORS ####

    # General factors #
    gen_v =~ 1*pos_v_c + flanker_inc_v_c + flanker_con_v_c + simon_inc_v_c + simon_con_v_c + cs_sw_v_c + cs_rep_v_c + gl_sw_v_c + gl_rep_v_c + as_sw_v_c + as_rep_v_c


    # Specific factors #
    sp_pos_v    =~ 1*pos_v_c
    sp_fl_inc_v =~ 1*flanker_inc_v_c
    sp_fl_con_v =~ 1*flanker_con_v_c
    sp_si_inc_v =~ 1*simon_inc_v_c
    sp_si_con_v =~ 1*simon_con_v_c
    sp_cs_rep_v =~ 1*cs_rep_v_c
    sp_cs_sw_v  =~ 1*cs_sw_v_c
    sp_as_rep_v =~ 1*as_rep_v_c
    sp_as_sw_v  =~ 1*as_sw_v_c
    sp_gl_rep_v =~ 1*gl_rep_v_c
    sp_gl_sw_v  =~ 1*gl_sw_v_c

    #### COVARIANCES ####

    # Between general factors #

    # Between task-level parameters of the same ability #

    sp_fl_inc_v     ~~ sp_fl_con_v + sp_si_inc_v + sp_si_con_v
    sp_fl_con_v     ~~ sp_si_inc_v + sp_si_con_v
    sp_si_inc_v     ~~ sp_si_con_v
    sp_cs_rep_v     ~~ sp_cs_sw_v + sp_as_rep_v + sp_as_sw_v + sp_gl_rep_v + sp_gl_sw_v
    sp_cs_sw_v      ~~ sp_as_rep_v + sp_as_sw_v + sp_gl_rep_v + sp_gl_sw_v
    sp_as_rep_v     ~~ sp_as_sw_v + sp_gl_rep_v + sp_gl_sw_v
    sp_as_sw_v      ~~ sp_gl_rep_v + sp_gl_sw_v
    sp_gl_rep_v     ~~ sp_gl_sw_v


    pos_v_c         ~~ 0*pos_v_c
    flanker_inc_v_c ~~ 0*flanker_inc_v_c
    flanker_con_v_c ~~ 0*flanker_con_v_c
    simon_inc_v_c   ~~ 0*simon_inc_v_c
    simon_con_v_c   ~~ 0*simon_con_v_c
    cs_sw_v_c       ~~ 0*cs_sw_v_c
    cs_rep_v_c      ~~ 0*cs_rep_v_c
    gl_sw_v_c       ~~ 0*gl_sw_v_c
    gl_rep_v_c      ~~ 0*gl_rep_v_c
    as_sw_v_c       ~~ 0*as_sw_v_c
    as_rep_v_c      ~~ 0*as_rep_v_c

    child_dep ~~ child_thr + sex
    child_thr ~~ sex

    #### INTERCEPTS ####

    pos_v_c         ~ 0
    flanker_inc_v_c ~ 0
    flanker_con_v_c ~ 0
    simon_inc_v_c   ~ 0
    simon_con_v_c   ~ 0
    cs_sw_v_c       ~ 0
    cs_rep_v_c      ~ 0
    gl_sw_v_c       ~ 0
    gl_rep_v_c      ~ 0
    as_sw_v_c       ~ 0
    as_rep_v_c      ~ 0

    child_thr       ~ 0
    child_dep       ~ 0

    ## REGRESSION PATHS ##
    sp_pos_v    ~ child_thr + child_dep + sex
    sp_fl_inc_v ~ child_thr + child_dep + sex
    sp_fl_con_v ~ child_thr + child_dep + sex
    sp_si_inc_v ~ child_thr + child_dep + sex
    sp_si_con_v ~ child_thr + child_dep + sex
    sp_cs_rep_v ~ child_thr + child_dep + sex
    sp_cs_sw_v  ~ child_thr + child_dep + sex
    sp_as_rep_v ~ child_thr + child_dep + sex
    sp_as_sw_v  ~ child_thr + child_dep + sex
    sp_gl_rep_v ~ child_thr + child_dep + sex
    sp_gl_sw_v  ~ child_thr + child_dep + sex

'

fit_expl_ts_ch_thr <- lavaan::sem(
  model = mod2_expl_ts_ch_thr,
  data = full_data,
  estimator = "MLR", # Robust SEs in case of non-normal data
  missing = "ML",    # FIML for missing data
  cluster = 'nohouse_encr', # Clustering within
  se = "robust",
  orthogonal = T,
  auto.cov.lv.x = TRUE,
  auto.cov.y = TRUE,
  std.lv = FALSE,
  fixed.x = FALSE
)

fit_expl_ts_ch_thr_sum <- summary(fit_expl_ts_ch_thr, standardized = TRUE, fit.measures = T)
fit_expl_ts_ch_thr_fitstats <- fit_expl_ts_ch_thr_sum$fit[c('chisq', 'df', 'pvalue', 'cfi.robust', 'rmsea.robust', 'rmsea.ci.lower.robust', 'rmsea.ci.upper.robust')]


### Extract model results ----

expl_ts_ch_thr_factor_loadings <- parameterEstimates(fit_expl_ts_ch_thr, standardized = T) |>
  filter(op == "=~", str_detect(lhs, "gen"))

expl_ts_ch_thr_reg_coef <- standardizedsolution(fit_expl_ts_ch_thr) |>
  as_tibble() |>
  filter(op == "~", rhs %in% c("child_thr"), !str_detect(lhs, "^gen_")) |>
  mutate(
    task = case_when(
      str_detect(lhs, "_pos_") ~ "Posner",
      str_detect(lhs, "_fl_") ~ "Flanker",
      str_detect(lhs, "_si_") ~ "Simon",
      str_detect(lhs, "_cs_") ~ "Color-shape",
      str_detect(lhs, "_as_") ~ "Animacy-size",
      str_detect(lhs, "_gl_") ~ "Global-local",
    )
  ) |>
  mutate(
    pvalue_adj = p.adjust(pvalue, method = "fdr"),
    adversity  = "Threat",
    timing     = "Childhood"
  ) |>
  ungroup()


### Equivalence tests ----

expl_ts_ch_thr_eqtests <- standardizedSolution(fit_expl_ts_ch_thr) |>
  as_tibble() |>
  filter(op == "~", rhs %in% c("child_thr"), !str_detect(lhs, "^gen_")) |>
  select(lhs, rhs, est.std, se) |>
  mutate(
    eq_pvalue = pmap(list(lhs, rhs, est.std, se), function(lhs, rhs, est.std, se) {
      equivalence_test_ml(0.1, est.std, se)
    })
  ) |>
  unnest(eq_pvalue)


## 3.5 Deprivation in childhood model ----

mod2_expl_ts_ch_dep <-
  '
    #### LATENT FACTORS ####

    # General factors #
    gen_v =~ 1*pos_v_c + flanker_inc_v_c + flanker_con_v_c + simon_inc_v_c + simon_con_v_c + cs_sw_v_c + cs_rep_v_c + gl_sw_v_c + gl_rep_v_c + as_sw_v_c + as_rep_v_c


    # Specific factors #
    sp_pos_v    =~ 1*pos_v_c
    sp_fl_inc_v =~ 1*flanker_inc_v_c
    sp_fl_con_v =~ 1*flanker_con_v_c
    sp_si_inc_v =~ 1*simon_inc_v_c
    sp_si_con_v =~ 1*simon_con_v_c
    sp_cs_rep_v =~ 1*cs_rep_v_c
    sp_cs_sw_v  =~ 1*cs_sw_v_c
    sp_as_rep_v =~ 1*as_rep_v_c
    sp_as_sw_v  =~ 1*as_sw_v_c
    sp_gl_rep_v =~ 1*gl_rep_v_c
    sp_gl_sw_v  =~ 1*gl_sw_v_c

    #### COVARIANCES ####

    # Between general factors #

    # Between task-level parameters of the same ability #

    sp_fl_inc_v     ~~ sp_fl_con_v + sp_si_inc_v + sp_si_con_v
    sp_fl_con_v     ~~ sp_si_inc_v + sp_si_con_v
    sp_si_inc_v     ~~ sp_si_con_v
    sp_cs_rep_v     ~~ sp_cs_sw_v + sp_as_rep_v + sp_as_sw_v + sp_gl_rep_v + sp_gl_sw_v
    sp_cs_sw_v      ~~ sp_as_rep_v + sp_as_sw_v + sp_gl_rep_v + sp_gl_sw_v
    sp_as_rep_v     ~~ sp_as_sw_v + sp_gl_rep_v + sp_gl_sw_v
    sp_as_sw_v      ~~ sp_gl_rep_v + sp_gl_sw_v
    sp_gl_rep_v     ~~ sp_gl_sw_v


    pos_v_c         ~~ 0*pos_v_c
    flanker_inc_v_c ~~ 0*flanker_inc_v_c
    flanker_con_v_c ~~ 0*flanker_con_v_c
    simon_inc_v_c   ~~ 0*simon_inc_v_c
    simon_con_v_c   ~~ 0*simon_con_v_c
    cs_sw_v_c       ~~ 0*cs_sw_v_c
    cs_rep_v_c      ~~ 0*cs_rep_v_c
    gl_sw_v_c       ~~ 0*gl_sw_v_c
    gl_rep_v_c      ~~ 0*gl_rep_v_c
    as_sw_v_c       ~~ 0*as_sw_v_c
    as_rep_v_c      ~~ 0*as_rep_v_c

    child_dep ~~  sex

    #### INTERCEPTS ####

    pos_v_c         ~ 0
    flanker_inc_v_c ~ 0
    flanker_con_v_c ~ 0
    simon_inc_v_c   ~ 0
    simon_con_v_c   ~ 0
    cs_sw_v_c       ~ 0
    cs_rep_v_c      ~ 0
    gl_sw_v_c       ~ 0
    gl_rep_v_c      ~ 0
    as_sw_v_c       ~ 0
    as_rep_v_c      ~ 0

    child_dep       ~ 0

    ## REGRESSION PATHS ##
    sp_pos_v    ~ child_dep + sex
    sp_fl_inc_v ~ child_dep + sex
    sp_fl_con_v ~ child_dep + sex
    sp_si_inc_v ~ child_dep + sex
    sp_si_con_v ~ child_dep + sex
    sp_cs_rep_v ~ child_dep + sex
    sp_cs_sw_v  ~ child_dep + sex
    sp_as_rep_v ~ child_dep + sex
    sp_as_sw_v  ~ child_dep + sex
    sp_gl_rep_v ~ child_dep + sex
    sp_gl_sw_v  ~ child_dep + sex

'

fit_expl_ts_ch_dep <- lavaan::sem(
  model = mod2_expl_ts_ch_dep,
  data = full_data,
  estimator = "MLR", # Robust SEs in case of non-normal data
  missing = "ML",    # FIML for missing data
  cluster = 'nohouse_encr', # Clustering within
  se = "robust",
  orthogonal = T,
  auto.cov.lv.x = TRUE,
  auto.cov.y = TRUE,
  std.lv = FALSE,
  fixed.x = FALSE
)

fit_expl_ts_ch_dep_sum <- summary(fit_expl_ts_ch_dep, standardized = TRUE, fit.measures = T)
fit_expl_ts_ch_dep_fitstats <- fit_expl_ts_ch_dep_sum$fit[c('chisq', 'df', 'pvalue', 'cfi.robust', 'rmsea.robust', 'rmsea.ci.lower.robust', 'rmsea.ci.upper.robust')]


### Extract model results ----

expl_ts_ch_dep_factor_loadings <- parameterEstimates(fit_expl_ts_ch_dep, standardized = T) |>
  filter(op == "=~", str_detect(lhs, "gen"))

expl_ts_ch_dep_reg_coef <- standardizedsolution(fit_expl_ts_ch_dep) |>
  as_tibble() |>
  filter(op == "~", rhs %in% c("child_dep"), !str_detect(lhs, "^gen_")) |>
  mutate(
    task = case_when(
      str_detect(lhs, "_pos_") ~ "Posner",
      str_detect(lhs, "_fl_") ~ "Flanker",
      str_detect(lhs, "_si_") ~ "Simon",
      str_detect(lhs, "_cs_") ~ "Color-shape",
      str_detect(lhs, "_as_") ~ "Animacy-size",
      str_detect(lhs, "_gl_") ~ "Global-local",
    )
  ) |>
  mutate(
    pvalue_adj = p.adjust(pvalue, method = "fdr"),
    adversity  = "Deprivation",
    timing     = "Childhood"
  ) |>
  ungroup()


### Equivalence tests ----

expl_ts_ch_dep_eqtests <- standardizedSolution(fit_expl_ts_ch_dep) |>
  as_tibble() |>
  filter(op == "~", rhs %in% c("child_dep"), !str_detect(lhs, "^gen_")) |>
  select(lhs, rhs, est.std, se) |>
  mutate(
    eq_pvalue = pmap(list(lhs, rhs, est.std, se), function(lhs, rhs, est.std, se) {
      equivalence_test_ml(0.1, est.std, se)
    })
  ) |>
  unnest(eq_pvalue)




save(fit_expl_ch_thr_sum, expl_ch_thr_factor_loadings, expl_ch_thr_reg_coef, expl_ch_thr_eqtests,
     fit_expl_ch_dep_sum, expl_ch_dep_factor_loadings, expl_ch_dep_reg_coef, expl_ch_dep_eqtests,
     fit_expl_ts_mod2_fitstats, expl_ts_cor_inh, expl_ts_cor_sh,
     fit_expl_ts_adult_threat_sum, expl_ts_adult_threat_factor_loadings, expl_ts_adult_threat_reg_coef, expl_ts_adult_threat_eqtests,
     fit_expl_ts_adult_dep_sum, expl_ts_adult_dep_factor_loadings, expl_ts_adult_dep_reg_coef, expl_ts_adult_dep_eqtests,
     fit_expl_ts_ch_thr_sum, expl_ts_ch_thr_factor_loadings, expl_ts_ch_thr_reg_coef, expl_ts_ch_thr_eqtests,
     fit_expl_ts_ch_dep_sum, expl_ts_ch_dep_factor_loadings, expl_ts_ch_dep_reg_coef, expl_ts_ch_dep_eqtests,
     file = "analysis_objects/results_exploratory.RData")

