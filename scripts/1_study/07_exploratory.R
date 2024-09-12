
# 1. Load data ------------------------------------------------------------

load("data/ddm_clean.RData")
iv_data <- read_csv('data/liss_data/full_data.csv') |>
  filter(nomem_encr %in% unique(ddm_clean$nomem_encr)) |>
  mutate(across(c(child_dep, child_thr), ~scale(.) |> as.numeric()))

ddm_clean <- ddm_clean |>
  mutate(across(-nomem_encr, ~scale(.) |> as.numeric()))

full_data <- full_join(iv_data, ddm_clean)


# 5. Deprivation model ----------------------------------------------------

## 5.1 Primary model (without threat exposure as confounder)

mod_expl <-
  '
    #### LATENT FACTORS ####

    # General factors #
    gen_v =~ 1*pos_v_c + flanker_inc_v_c + flanker_con_v_c + simon_inc_v_c + simon_con_v_c + cs_sw_v_c + cs_rep_v_c + gl_sw_v_c + gl_rep_v_c + as_sw_v_c + as_rep_v_c
    gen_a =~ 1*pos_a_c + flanker_inc_a_c + flanker_con_a_c + simon_inc_a_c + simon_con_a_c + cs_sw_a_c + cs_rep_a_c + gl_sw_a_c + gl_rep_a_c + as_sw_a_c + as_rep_a_c
    gen_t =~ 1*pos_t_c + flanker_inc_t_c + flanker_con_t_c + simon_inc_t_c + simon_con_t_c + cs_sw_t_c + cs_rep_t_c + gl_sw_t_c + gl_rep_t_c + as_sw_t_c + as_rep_t_c

    # Specific factors #
    common_v =~ 1*flanker_inc_v_c + simon_inc_v_c + cs_sw_v_c  + gl_sw_v_c + as_sw_v_c
    common_a =~ 1*flanker_inc_a_c + simon_inc_a_c + cs_sw_a_c  + gl_sw_a_c + as_sw_a_c


    #### COVARIANCES ####

    # Between general factors #
    gen_v ~~ gen_a + gen_t
    gen_a ~~ gen_t

    # Between latent inhibition drift rate and shifting drift rate #
    common_v ~~ common_a

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

    common_v ~ child_dep + child_thr + sex
    common_a ~ child_dep + child_thr + sex
'

fit_expl <- lavaan::sem(
  model = mod_expl,
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

fit_expl_sum <- summary(fit_expl, standardized = TRUE, fit.measures = T)
fit_expl_fitstats <- fit_expl_sum$fit[c('chisq', 'df', 'pvalue', 'cfi.robust', 'rmsea.robust', 'rmsea.ci.lower.robust', 'rmsea.ci.upper.robust')]


# Extract model results ---------------------------------------------------

expl_factor_loadings <- parameterEstimates(fit_expl, standardized = T) |>
  filter(op == "=~", str_detect(lhs, "gen"))

expl_reg_coef <- standardizedsolution(fit_expl) |>
  as_tibble() |>
  filter(op == "~", rhs %in% c("child_dep", "child_thr")) |>
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

equivalence_test_ml = function(sesoi, ml_effect, ml_se){
  p1 = 1 - pnorm( ml_effect, mean = -sesoi, sd = ml_se)
  p2 =     pnorm( ml_effect, mean =  sesoi, sd = ml_se)
  return(max(p1, p2))
}

expl_eqtests <- standardizedSolution(fit_expl) |>
  as_tibble() |>
  filter(op == "~", rhs %in% c("child_dep", "child_thr")) |>
  select(lhs, rhs, est.std, se) |>
  mutate(
    eq_pvalue = pmap(list(lhs, rhs, est.std, se), function(lhs, rhs, est.std, se) {
      equivalence_test_ml(0.1, est.std, se)
    })
  ) |>
  unnest(eq_pvalue)

save(fit_expl_sum, expl_factor_loadings, expl_reg_coef, expl_eqtests, file = "analysis_objects/results_exploratory.RData")
