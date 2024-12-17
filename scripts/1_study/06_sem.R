library(tidyverse)
library(lavaan)

equivalence_test_ml = function(sesoi, ml_effect, ml_se){
  p1 = 1 - pnorm( ml_effect, mean = -sesoi, sd = ml_se)
  p2 =     pnorm( ml_effect, mean =  sesoi, sd = ml_se)
  return(max(p1, p2))
}
# 1. Load data ------------------------------------------------------------

load("data/ddm_clean.RData")
iv_data <- read_csv('data/liss_data/full_data.csv') |>
  filter(nomem_encr %in% unique(ddm_clean$nomem_encr)) |>
  mutate(across(c(p_scar_m, vict_sum, neigh_thr02_m, threat_comp, age, edu, child_adv), ~scale(.) |> as.numeric()))

ddm_clean <- ddm_clean |>
  mutate(across(-nomem_encr, ~scale(.) |> as.numeric()))

full_data <- full_join(iv_data, ddm_clean)

# 2. Drift Rate sub-model -------------------------------------------------

## 2.1 Model 1 ----

# Drift rate model 1 (Attention shifting and inhibition separate)
mod_v1 <-
  ' # Latent factors
    ps =~ 1*pos_v_c + flanker_inc_v_c + flanker_con_v_c + simon_inc_v_c + simon_con_v_c + cs_sw_v_c + cs_rep_v_c + gl_sw_v_c + gl_rep_v_c + as_sw_v_c + as_rep_v_c
    inh =~ 1*flanker_inc_v_c + simon_inc_v_c
    as =~ 1*as_sw_v_c + cs_sw_v_c + gl_sw_v_c

    # Covariances
    inh ~~ as + 0*ps
    as ~~ 0*ps

    flanker_inc_v_c ~~ flanker_con_v_c
    simon_inc_v_c   ~~ simon_con_v_c
    cs_sw_v_c       ~~ cs_rep_v_c
    gl_sw_v_c       ~~ gl_rep_v_c
    as_sw_v_c       ~~ as_rep_v_c

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

# Not converge
fit_v1 <- lavaan::sem(
  model = mod_v1,
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



## 2.2 Model 2 (attention shifting and inhibition collapsed ----

mod_v2 <-
  ' # Latent factors
    ps =~ 1*pos_v_c + flanker_inc_v_c + flanker_con_v_c + simon_inc_v_c + simon_con_v_c + cs_sw_v_c + cs_rep_v_c + gl_sw_v_c + gl_rep_v_c + as_sw_v_c + as_rep_v_c
    ef =~ 1*flanker_inc_v_c + simon_inc_v_c + cs_sw_v_c + gl_sw_v_c + as_sw_v_c

    # Covariances

    flanker_inc_v_c ~~ flanker_con_v_c
    simon_inc_v_c   ~~ simon_con_v_c
    cs_sw_v_c       ~~ cs_rep_v_c
    gl_sw_v_c       ~~ gl_rep_v_c
    as_sw_v_c       ~~ as_rep_v_c

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

fit_v2 <- lavaan::sem(
  model = mod_v2,
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

fit_v2_sum <- summary(fit_v2, standardized = TRUE, fit.measures = T)
fit_v2_fitstats <- fit_v2_sum$fit[c('chisq', 'df', 'pvalue', 'cfi.robust', 'rmsea.robust', 'rmsea.ci.lower.robust', 'rmsea.ci.upper.robust')]


# 3. Boundary Separation sub-model ----------------------------------------

## 3.1 Model 1 ----

# Boundary separation model 1 (Attention shifting and inhibition separate)
mod_a1 <-
  ' # Latent factors
    ps =~ 1*pos_a_c + flanker_inc_a_c + flanker_con_a_c + simon_inc_a_c + simon_con_a_c + cs_sw_a_c + cs_rep_a_c + gl_sw_a_c + gl_rep_a_c + as_sw_a_c + as_rep_a_c
    inh =~ 1*flanker_inc_a_c + simon_inc_a_c
    as =~ 1*cs_sw_a_c + gl_sw_a_c + as_sw_a_c

    # Covariances
    inh ~~ 0*as + 0*ps
    as ~~ 0*ps

    flanker_inc_a_c ~~ flanker_con_a_c
    simon_inc_a_c   ~~ simon_con_a_c
    cs_sw_a_c       ~~ cs_rep_a_c
    gl_sw_a_c       ~~ gl_rep_a_c
    as_sw_a_c       ~~ as_rep_a_c

    #### INTERCEPTS ####

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
  '

# Not converge
fit_a1 <- lavaan::sem(
  model = mod_a1,
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



## 3.2 Model 2 (attention shifting and inhibition collapsed) ----

mod_a2 <-
  ' # Latent factors
    gen_a =~ 1*pos_a_c + flanker_inc_a_c + flanker_con_a_c + simon_inc_a_c + simon_con_a_c + cs_sw_a_c + cs_rep_a_c + gl_sw_a_c + gl_rep_a_c + as_sw_a_c + as_rep_a_c
    sp_a  =~ 1*flanker_inc_a_c + simon_inc_a_c + cs_sw_a_c + gl_sw_a_c + as_sw_a_c

    # Covariances

    flanker_inc_a_c ~~ flanker_con_a_c
    simon_inc_a_c   ~~ simon_con_a_c
    cs_sw_a_c       ~~ cs_rep_a_c
    gl_sw_a_c       ~~ gl_rep_a_c
    as_sw_a_c       ~~ as_rep_a_c



    #### INTERCEPTS ####

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
  '

# Not converge
fit_a2 <- lavaan::sem(
  model = mod_a2,
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


## 3.3 Model 3

mod_a3 <-
  ' # Latent factors
    gen_a =~ 1*pos_a_c + flanker_inc_a_c + flanker_con_a_c + simon_inc_a_c + simon_con_a_c + cs_sw_a_c + cs_rep_a_c + gl_sw_a_c + gl_rep_a_c + as_sw_a_c + as_rep_a_c

    # Covariances

    flanker_inc_a_c ~~ flanker_con_a_c
    simon_inc_a_c   ~~ simon_con_a_c
    cs_sw_a_c       ~~ cs_rep_a_c
    gl_sw_a_c       ~~ gl_rep_a_c
    as_sw_a_c       ~~ as_rep_a_c



    #### INTERCEPTS ####

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
  '

fit_a3 <- lavaan::sem(
  model = mod_a3,
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

fit_a3_sum <- summary(fit_a3, standardized = TRUE, fit.measures = T)
fit_a3_fitstats <- fit_a3_sum$fit[c('chisq', 'df', 'pvalue', 'cfi.robust', 'rmsea.robust', 'rmsea.ci.lower.robust', 'rmsea.ci.upper.robust')]


# 4. Non-Decision Time sub-model ----------------------------------------

## 4.1 Model 1 ----

#  model 1 (Attention shifting and inhibition separate)
mod_t1 <-
  ' # Latent factors
    gen_t =~ 1*pos_t_c + flanker_inc_t_c + flanker_con_t_c + simon_inc_t_c + simon_con_t_c + cs_sw_t_c + cs_rep_t_c + gl_sw_t_c + gl_rep_t_c + as_sw_t_c + as_rep_t_c
    inh_t =~ 1*flanker_inc_t_c + simon_inc_t_c
    as_t =~ 1*cs_sw_t_c + gl_sw_t_c + as_sw_t_c

    # Covariances
    inh_t ~~ as_t + 0*gen_t
    as_t ~~ 0*gen_t

    flanker_inc_t_c ~~ flanker_con_t_c
    simon_inc_t_c   ~~ simon_con_t_c
    cs_sw_t_c       ~~ cs_rep_t_c
    gl_sw_t_c       ~~ gl_rep_t_c
    as_sw_t_c       ~~ as_rep_t_c

    #### INTERCEPTS ####

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
  '

# Not converge
fit_t1 <- lavaan::sem(
  model = mod_t1,
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



## 3.2 Model 2 (attention shifting and inhibition collapsed ----

mod_t2 <-
  ' # Latent factors
    gen_t =~ 1*pos_t_c + flanker_inc_t_c + flanker_con_t_c + simon_inc_t_c + simon_con_t_c + cs_sw_t_c + cs_rep_t_c + gl_sw_t_c + gl_rep_t_c + as_sw_t_c + as_rep_t_c
    sp_t  =~ 1*flanker_inc_t_c + simon_inc_t_c + cs_sw_t_c + gl_sw_t_c + as_sw_t_c

    # Covariances

    flanker_inc_t_c ~~ flanker_con_t_c
    simon_inc_t_c   ~~ simon_con_t_c
    cs_sw_t_c       ~~ cs_rep_t_c
    gl_sw_t_c       ~~ gl_rep_t_c
    as_sw_t_c       ~~ as_rep_t_c

    #### INTERCEPTS ####

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
  '

fit_t2 <- lavaan::sem(
  model = mod_t2,
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

fit_t2_sum <- summary(fit_t2, standardized = TRUE, fit.measures = T)
fit_t2_fitstats <- fit_t2_sum$fit[c('chisq', 'df', 'pvalue', 'cfi.robust', 'rmsea.robust', 'rmsea.ci.lower.robust', 'rmsea.ci.upper.robust')]



## 3.3 Model 3 (Only general)

mod_t3 <-
  ' # Latent factors
    gen_t =~ 1*pos_t_c + flanker_inc_t_c + flanker_con_t_c + simon_inc_t_c + simon_con_t_c + cs_sw_t_c + cs_rep_t_c + gl_sw_t_c + gl_rep_t_c + as_sw_t_c + as_rep_t_c

    # Covariances

    flanker_inc_t_c ~~ flanker_con_t_c
    simon_inc_t_c   ~~ simon_con_t_c
    cs_sw_t_c       ~~ cs_rep_t_c
    gl_sw_t_c       ~~ gl_rep_t_c
    as_sw_t_c       ~~ as_rep_t_c

    #### INTERCEPTS ####

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
  '

fit_t3 <- lavaan::sem(
  model = mod_t3,
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

fit_t3_sum <- summary(fit_t3, standardized = TRUE, fit.measures = T)
fit_t3_fitstats <- fit_t3_sum$fit[c('chisq', 'df', 'pvalue', 'cfi.robust', 'rmsea.robust', 'rmsea.ci.lower.robust', 'rmsea.ci.upper.robust')]



# 4. Full measurement model -----------------------------------------------


mod_meas <-
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
'

fit_meas <- lavaan::sem(
  model = mod_meas,
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

fit_meas_sum <- summary(fit_meas, standardized = TRUE, fit.measures = T)
fit_meas_fitstats <- fit_meas_sum$fit[c('chisq', 'df', 'pvalue', 'cfi.robust', 'rmsea.robust', 'rmsea.ci.lower.robust', 'rmsea.ci.upper.robust')]




# 5. Deprivation model ----------------------------------------------------

## 5.1 Primary model (without threat exposure as confounder) ----

mod_dep1 <-
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


    age        ~~ p_scar_m + sex + edu + child_adv
    p_scar_m   ~~ sex + edu + child_adv
    sex        ~~ edu + child_adv
    edu        ~~ child_adv

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

    p_scar_m        ~ 0
    age             ~ 0
    edu             ~ 0
    child_adv       ~ 0

    ## REGRESSION PATHS ##

    gen_v ~ p_scar_m + age + sex + edu + child_adv
    gen_a ~ p_scar_m + age + sex + edu + child_adv
    gen_t ~ p_scar_m + age + sex + edu + child_adv

'

fit_dep1 <- lavaan::sem(
  model = mod_dep1,
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

fit_dep1_sum <- summary(fit_dep1, standardized = TRUE, fit.measures = T)
fit_dep1_fitstats <- fit_dep1_sum$fit[c('chisq', 'df', 'pvalue', 'cfi.robust', 'rmsea.robust', 'rmsea.ci.lower.robust', 'rmsea.ci.upper.robust')]



# Extract model results ---------------------------------------------------

fit_dep1_factor_loadings <- parameterEstimates(fit_dep1, standardized = T) |>
  filter(op == "=~", str_detect(lhs, "gen"))

fit_dep1_reg_coef <- standardizedsolution(fit_dep1) |>
  as_tibble() |>
  filter(op == "~", rhs %in% c("p_scar_m")) |>
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

# Equivalence tests -------------------------------------------------------

fit_dep1_eqtests <- standardizedSolution(fit_dep1) |>
  as_tibble() |>
  filter(op == "~", rhs %in% c("p_scar_m")) |>
  select(lhs, rhs, est.std, se) |>
  mutate(
    eq_pvalue = pmap(list(lhs, rhs, est.std, se), function(lhs, rhs, est.std, se) {
      equivalence_test_ml(0.1, est.std, se)
    })
  ) |>
  unnest(eq_pvalue)



## 5.2 Primary model (with threat exposure as confounder) ----

mod_dep2 <-
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


    age           ~~ p_scar_m + neigh_thr02_m + vict_sum + sex + edu + child_adv
    p_scar_m      ~~ neigh_thr02_m + vict_sum + sex + edu + child_adv
    neigh_thr02_m ~~ vict_sum + sex + edu + child_adv
    vict_sum      ~~ sex + edu + child_adv
    sex           ~~ edu + child_adv
    edu           ~~ child_adv

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

    p_scar_m        ~ 0
    neigh_thr02_m   ~ 0
    vict_sum        ~ 0
    age             ~ 0
    edu             ~ 0
    child_adv       ~ 0

    ## REGRESSION PATHS ##

    gen_v ~ p_scar_m + neigh_thr02_m + vict_sum + age + sex + edu + child_adv
    gen_a ~ p_scar_m + neigh_thr02_m + vict_sum + age + sex + edu + child_adv
    gen_t ~ p_scar_m + neigh_thr02_m + vict_sum + age + sex + edu + child_adv

  #  common_v ~ p_scar_m + neigh_thr02_m + vict_sum + age + sex + edu + child_adv
  #  common_a ~ p_scar_m + neigh_thr02_m + vict_sum + age + sex + edu + child_adv
'

fit_dep2 <- lavaan::sem(
  model = mod_dep2,
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

fit_dep2_sum <- summary(fit_dep2, standardized = TRUE, fit.measures = T)
fit_dep2_fitstats <- fit_dep2_sum$fit[c('chisq', 'df', 'pvalue', 'cfi.robust', 'rmsea.robust', 'rmsea.ci.lower.robust', 'rmsea.ci.upper.robust')]

# Extract model results ---------------------------------------------------

fit_dep2_factor_loadings <- parameterEstimates(fit_dep2, standardized = T) |>
  filter(op == "=~", str_detect(lhs, "gen"))

fit_dep2_reg_coef <- standardizedsolution(fit_dep2) |>
  as_tibble() |>
  filter(op == "~", rhs %in% c("p_scar_m")) |>
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

# Equivalence tests -------------------------------------------------------

fit_dep2_eqtests <- standardizedSolution(fit_dep2) |>
  as_tibble() |>
  filter(op == "~", rhs %in% c("p_scar_m")) |>
  select(lhs, rhs, est.std, se) |>
  mutate(
    eq_pvalue = pmap(list(lhs, rhs, est.std, se), function(lhs, rhs, est.std, se) {
      equivalence_test_ml(0.1, est.std, se)
    })
  ) |>
  unnest(eq_pvalue)



# 6. Threat model ----------------------------------------------------

## 6.1 Primary model (with deprivation as confounder) ----

mod_thr1 <-
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


    age           ~~ p_scar_m + threat_comp + sex + child_adv
    p_scar_m      ~~ threat_comp + sex + child_adv
    threat_comp   ~~ sex + child_adv
    sex           ~~ child_adv

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

    p_scar_m        ~ 0
    age             ~ 0
    child_adv       ~ 0
    threat_comp     ~ 0

    ## REGRESSION PATHS ##

    gen_v ~ threat_comp + p_scar_m + age + sex + child_adv
    gen_a ~ threat_comp + p_scar_m + age + sex + child_adv
    gen_t ~ threat_comp + p_scar_m + age + sex + child_adv

   # common_v ~  threat_comp + p_scar_m + age + sex + child_adv
  #  common_a ~  threat_comp + p_scar_m + age + sex + child_adv
'

fit_thr1 <- lavaan::sem(
  model = mod_thr1,
  data = full_data |> filter(prev_participated == 1 | (prev_participated == 0 & !is.na(neigh_thr_m))),
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

fit_thr1_sum <- summary(fit_thr1, standardized = TRUE, fit.measures = T)
fit_thr1_fitstats <- fit_thr1_sum$fit[c('chisq', 'df', 'pvalue', 'cfi.robust', 'rmsea.robust', 'rmsea.ci.lower.robust', 'rmsea.ci.upper.robust')]

# Extract model results ---------------------------------------------------

fit_thr1_factor_loadings <- parameterEstimates(fit_thr1, standardized = T) |>
  filter(op == "=~", str_detect(lhs, "gen"))

fit_thr1_reg_coef <- standardizedsolution(fit_thr1) |>
  as_tibble() |>
  filter(op == "~", rhs %in% c("threat_comp")) |>
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

# Equivalence tests -------------------------------------------------------

fit_thr1_eqtests <- standardizedSolution(fit_thr1) |>
  as_tibble() |>
  filter(op == "~", rhs %in% c("threat_comp")) |>
  select(lhs, rhs, est.std, se) |>
  mutate(
    eq_pvalue = pmap(list(lhs, rhs, est.std, se), function(lhs, rhs, est.std, se) {
      equivalence_test_ml(0.1, est.std, se)
    })
  ) |>
  unnest(eq_pvalue)



## 6.2 Primary model (without deprivation as confounder) ----

mod_thr2 <-
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


    age           ~~ threat_comp + sex + child_adv
    threat_comp   ~~ sex + child_adv
    sex           ~~ child_adv

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

    age             ~ 0
    child_adv       ~ 0
    threat_comp     ~ 0

    ## REGRESSION PATHS ##

    gen_v ~ threat_comp + age + sex + edu + child_adv
    gen_a ~ threat_comp + age + sex + edu + child_adv
    gen_t ~ threat_comp + age + sex + edu + child_adv
'

fit_thr2 <- lavaan::sem(
  model = mod_thr2,
  data = full_data |> filter(prev_participated == 1 | (prev_participated == 0 & !is.na(neigh_thr_m))),
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

fit_thr2_sum <- summary(fit_thr2, standardized = TRUE, fit.measures = T)
fit_thr2_fitstats <- fit_thr2_sum$fit[c('chisq', 'df', 'pvalue', 'cfi.robust', 'rmsea.robust', 'rmsea.ci.lower.robust', 'rmsea.ci.upper.robust')]


# Extract model results ---------------------------------------------------

fit_thr2_factor_loadings <- parameterEstimates(fit_thr2, standardized = T) |>
  filter(op == "=~", str_detect(lhs, "gen"))

fit_thr2_reg_coef <- standardizedsolution(fit_thr2) |>
  as_tibble() |>
  filter(op == "~", rhs %in% c("threat_comp")) |>
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

# Equivalence tests -------------------------------------------------------

fit_thr2_eqtests <- standardizedSolution(fit_thr2) |>
  as_tibble() |>
  filter(op == "~", rhs %in% c("threat_comp")) |>
  select(lhs, rhs, est.std, se) |>
  mutate(
    eq_pvalue = pmap(list(lhs, rhs, est.std, se), function(lhs, rhs, est.std, se) {
      equivalence_test_ml(0.1, est.std, se)
    })
  ) |>
  unnest(eq_pvalue)


# 7. Save results ---------------------------------------------------------

save(fit_v2_sum, fit_v2_fitstats,
     fit_a3_sum, fit_a3_fitstats,
     fit_t3_sum, fit_t3_fitstats,
     fit_meas_sum, fit_meas_fitstats,
     fit_dep1, fit_dep1_sum, fit_dep1_fitstats, fit_dep1_factor_loadings, fit_dep1_reg_coef, fit_dep1_eqtests,
     fit_dep2_sum, fit_dep2_fitstats, fit_dep2_factor_loadings, fit_dep2_reg_coef, fit_dep2_eqtests,
     fit_thr1, fit_thr1_sum, fit_thr1_fitstats, fit_thr1_factor_loadings, fit_thr1_reg_coef, fit_thr1_eqtests,
     fit_thr2_sum, fit_thr2_fitstats, fit_thr2_factor_loadings, fit_thr2_reg_coef, fit_thr2_eqtests,
     file = "analysis_objects/results_confirmatory.RData"
)
