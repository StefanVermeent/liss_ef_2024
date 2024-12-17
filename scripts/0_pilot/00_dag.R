
# Read data ---------------------------------------------------------------

library(tidyverse)
library(dagitty)
library(haven)

load("analysis_objects/wm_study/confirmatory_results.RData")


liss_data <- read_csv("data/liss_data/wm_study_data.csv") |>
  mutate(
    inr_m = log(inr_m),
    inr_cv = log(inr_cv)
  ) |>
  mutate(
    across(c(ends_with('cap'), binding_number_acc, updating_number_acc), ~scale(x = .) |> as.numeric()),
    across(c(inr_m, inr_cv, threat_comp, p_scar_m, p_scar_cv), ~scale(x = .) |> as.numeric()),
    age = scale(age) |> as.numeric(),
    edu = scale(edu) |> as.numeric(),
   # noise = scale(noise) |> as.numeric(),
    interrupt = case_when(
      interrupt == 1 ~ 0,
      interrupt == 2 ~ 1,
      TRUE ~ interrupt
    ),
    leave = case_when(
      leave == 1 ~ 0,
      leave == 2 ~ 1,
      TRUE ~ leave
    ),
    age_sq = age^2
  )

wm_data <- read_sav("data/liss_data/L_Cognitieve_Vaardigheden_v2_1.0p.sav") |>
  select(nomem_encr, starts_with("VP"), starts_with("VC"), starts_with("PP"), starts_with("PC"), sex = geslacht, ospan_cap, rspan_cap, binding_number_acc, updating_number_acc) %>%
  mutate(across(c(VP1, VP3, PP1, PP2, PP3, PP4, VC1, VC3, PC1, PC2, PC3, PC4), ~ 8 - .)) |>
  mutate(
    VP_m = across(starts_with("VP")) |> rowMeans(na.rm = T),
    VC_m = across(starts_with("VC")) |> rowMeans(na.rm = T),
    PP_m = across(starts_with("PP")) |> rowMeans(na.rm = T),
    PC_m = across(starts_with("PC")) |> rowMeans(na.rm = T),
    child_adv = across(c(VP_m, PP_m)) |> rowMeans(na.rm = T),
    curr_adv = across(c(VC_m, PC_m)) |> rowMeans(na.rm = T)
  ) |>
  select(nomem_encr, VP_m, VC_m, PP_m, PC_m, child_adv, curr_adv, sex) |>
  mutate(sex = as.integer(sex)) |>
  left_join(
    lavaan::lavPredict(object = fit_struc01, newdata = liss_data) |> as_tibble() |> bind_cols(liss_data |> select(nomem_encr))
  )

liss_data <- liss_data |>
  left_join(wm_data) |>
  drop_na(child_adv, edu, wmc_l, p_scar_m, threat_comp, age, sex)|>
  select(sex, age, edu, child_adv, threat_comp, p_scar_m, wmc_l)

# Testing local dependencies in candidate DAGs ----------------------------

set.seed(36547654)

# The code of each dag can be pasted in the Model code section at https://www.dagitty.net/dags.html

# 1. Is it reasonable to assume independence between education and threat, conditional on material deprivation?

dag01 <- dagitty::dagitty(
  'dag {
age [pos="-0.189,-1.050"]
child_adv [pos="-1.433,-1.019"]
edu [pos="-1.429,1.343"]
p_scar_m [pos="-0.925,0.145"]
threat_comp [exposure,pos="-0.924,-0.421"]
wmc_l [outcome,pos="-0.044,-0.023"]
age -> p_scar_m
age -> threat_comp
age -> wmc_l
child_adv -> p_scar_m
child_adv -> threat_comp
child_adv -> wmc_l
child_adv <-> edu
edu -> p_scar_m
edu -> wmc_l
p_scar_m -> threat_comp
p_scar_m -> wmc_l
threat_comp -> wmc_l
}
'
)

localTest_dag01 <- localTests(x = dag01, data = liss_data, abbreviate.names = F, type = "cis.loess", R = 5000) |>
  as_tibble(rownames = 'vars') |>
  filter(vars == "edu _||_ threat_comp | age, child_adv, p_scar_m") %>%
  mutate(
    ci = paste0("[", formatC(`2.5%`, digits = 2, width = 2, format = 'f'), ", ", formatC(`97.5%`, digits = 2, width = 2, format = 'f'), "]"),
    across(c(estimate, std.error), ~formatC(x = ., digits = 2, width = 2, format = 'f'))
    )

localTest_plot_dag01 <- localTests(x = dag01, data = liss_data, abbreviate.names = F, type = "cis.loess", R = 5000) |>
  as_tibble(rownames = 'vars') |>
  filter(vars == "edu _||_ threat_comp | age, child_adv, p_scar_m") |>
  mutate(vars = ifelse(str_detect(vars, "^edu"), "")) |>
  ggplot(aes(vars, estimate)) +
  geom_point() +
  geom_errorbar(aes(ymin = `2.5%`, ymax = `97.5%`), width = 0.1) +
  geom_hline(aes(yintercept = 0), linetype = "dashed") +
  scale_y_continuous(breaks = seq(-0.20, 0.20, 0.20), limits = c(-0.20, 0.20)) +
  coord_flip() +
  theme_minimal() +
  theme(
    axis.title = element_blank()
  )


# 2. Is it reasonable to assume a conditional independence between age and deprivation?
dag02 <- dagitty::dagitty(
  'dag {
age [pos="-0.189,-1.050"]
child_adv [pos="-1.433,-1.019"]
edu [pos="-1.429,1.343"]
p_scar_m [exposure,pos="-0.925,0.145"]
threat_comp [pos="-0.924,-0.421"]
wmc_l [outcome,pos="-0.044,-0.023"]
age -> threat_comp
age -> wmc_l
child_adv -> p_scar_m
child_adv -> threat_comp
child_adv -> wmc_l
child_adv <-> edu
edu -> p_scar_m
edu -> wmc_l
p_scar_m -> threat_comp
p_scar_m -> wmc_l
threat_comp -> wmc_l
}'
)

localTest_dag02 <- localTests(x = dag02, data = liss_data, abbreviate.names = F, type = "cis.loess", R = 5000) |>
  as_tibble(rownames = 'vars') |>
  filter(vars == 'age _||_ p_scar_m') %>%
  mutate(
    ci = paste0("[", formatC(`2.5%`, digits = 2, width = 2, format = 'f'), ", ", formatC(`97.5%`, digits = 2, width = 2, format = 'f'), "]"),
    across(c(estimate, std.error), ~formatC(x = ., digits = 2, width = 2, format = 'f'))
  )

localTest_plot_dag02 <- localTests(x = dag02, data = liss_data, abbreviate.names = F, type = "cis.loess", R = 5000) |>
  as_tibble(rownames = 'vars') |>
  filter(vars == 'age _||_ p_scar_m') |>
  mutate(vars = ifelse(str_detect(vars, "^age"), "")) |>
  ggplot(aes(vars, estimate)) +
  geom_point() +
  geom_errorbar(aes(ymin = `2.5%`, ymax = `97.5%`), width = 0.1) +
  geom_hline(aes(yintercept = 0), linetype = "dashed") +
  #  ylim(c(-0.20, 0.20)) +
  scale_y_continuous(breaks = seq(-0.20, 0.20, 0.20), limits = c(-0.20, 0.20)) +
  coord_flip() +
  theme_minimal() +
  theme(
    axis.title = element_blank()
  )

# 3. Is it reasonable to assume a conditional independence between age and threat?

dag03 <- dagitty::dagitty(
  'dag {
age [pos="-0.189,-1.050"]
child_adv [pos="-1.433,-1.019"]
edu [pos="-1.429,1.343"]
p_scar_m [pos="-0.925,0.145"]
threat_comp [exposure,pos="-0.924,-0.421"]
wmc_l [outcome,pos="-0.044,-0.023"]
age -> p_scar_m
age -> wmc_l
child_adv -> p_scar_m
child_adv -> threat_comp
child_adv -> wmc_l
child_adv <-> edu
edu -> p_scar_m
edu -> wmc_l
p_scar_m -> threat_comp
p_scar_m -> wmc_l
threat_comp -> wmc_l
}

'
)

localTest_dag03 <- localTests(x = dag03, data = liss_data, abbreviate.names = F, type = "cis.loess", R = 5000) |>
  as_tibble(rownames = 'vars') |>
  filter(vars == 'age _||_ threat_comp | child_adv, p_scar_m') %>%
  mutate(
    ci = paste0("[", formatC(`2.5%`, digits = 2, width = 2, format = 'f'), ", ", formatC(`97.5%`, digits = 2, width = 2, format = 'f'), "]"),
    across(c(estimate, std.error), ~formatC(x = ., digits = 2, width = 2, format = 'f'))
  )

localTest_plot_dag03 <- localTests(x = dag03, data = liss_data, abbreviate.names = F, type = "cis.loess", R = 5000) |>
  as_tibble(rownames = 'vars') |>
  filter(vars == 'age _||_ threat_comp | child_adv, p_scar_m') |>
  mutate(vars = ifelse(str_detect(vars, "^age"), "", vars)) |>
  ggplot(aes(vars, estimate)) +
  geom_point() +
  geom_errorbar(aes(ymin = `2.5%`, ymax = `97.5%`), width = 0.1) +
  geom_hline(aes(yintercept = 0), linetype = "dashed") +
  scale_y_continuous(breaks = seq(-0.20, 0.20, 0.20), limits = c(-0.20, 0.20)) +
  coord_flip() +
  theme_minimal() +
  theme(
    axis.title = element_blank()
  )

# 4. Is it reasonable to assume independence between deprivation and threat, conditional on childhood adversity and age?

dag04 <- dagitty::dagitty(
  'dag {
age [pos="-0.189,-1.050"]
child_adv [pos="-1.433,-1.019"]
edu [pos="-1.429,1.343"]
p_scar_m [pos="-0.925,0.145"]
threat_comp [exposure,pos="-0.924,-0.421"]
wmc_l [outcome,pos="-0.044,-0.023"]
age -> p_scar_m
age -> threat_comp
age -> wmc_l
child_adv -> p_scar_m
child_adv -> threat_comp
child_adv -> wmc_l
child_adv <-> edu
edu -> p_scar_m
edu -> wmc_l
p_scar_m -> wmc_l
threat_comp -> wmc_l
}
'
)

localTest_dag04 <- localTests(x = dag04, data = liss_data, abbreviate.names = F, type = "cis.loess", R = 5000) |>
  as_tibble(rownames = 'vars') |>
  filter(vars == 'p_scar_m _||_ threat_comp | age, child_adv') %>%
  mutate(
    ci = paste0("[", formatC(`2.5%`, digits = 2, width = 2, format = 'f'), ", ", formatC(`97.5%`, digits = 2, width = 2, format = 'f'), "]"),
    across(c(estimate, std.error), ~formatC(x = ., digits = 2, width = 2, format = 'f'))
  )

localTest_plot_dag04 <- localTests(x = dag04, data = liss_data, abbreviate.names = F, type = "cis.loess", R = 5000) |>
  as_tibble(rownames = 'vars') |>
  filter(vars == 'p_scar_m _||_ threat_comp | age, child_adv') |>
  mutate(vars = ifelse(str_detect(vars, "^p_scar_m"), "", vars)) |>
  ggplot(aes(vars, estimate)) +
  geom_point() +
  geom_errorbar(aes(ymin = `2.5%`, ymax = `97.5%`), width = 0.1) +
  geom_hline(aes(yintercept = 0), linetype = "dashed") +
  scale_y_continuous(breaks = seq(-0.40, 0.40, 0.40), limits = c(-0.40, 0.40)) +
  coord_flip() +
  theme_minimal() +
  theme(
    axis.title = element_blank()
  )

localTest_plot_list <-
  list(
    localTest_plot_dag03,
    localTest_plot_dag01,
    NULL,
    NULL,
    localTest_plot_dag04
  )

save(localTest_dag01, localTest_dag02, localTest_dag03, localTest_dag04, localTest_plot_list, file = "analysis_objects/dag_localtests.RData")
