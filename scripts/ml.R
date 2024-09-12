
colorshape_clean <-
  colorshape_clean |>
  filter(rt > 0.425) |>
  select(id = nomem_encr, rt, correct, condition)

write_DDM_files(data = colorshape_clean, path = "data/cs", vars = c("rt", "correct", "condition"), task = "cs")


fast_dm_settings(task = "cs",
                 path = "data/cs",
                 model_version = "_mod1",
                 method = "ks",
                 depend = c("depends v condition", "depends t0 condition", "depends a condition"),
                 format = "TIME RESPONSE condition")

# Compute DDM parameters
execute_fast_dm(task = "cs", path = "data/cs", model_version = "_mod1")



# Read DDM results
colorshape_ddm_ml <- read_DDM(task = "cs", path = "data/cs", model_version = "_mod1") |>
  select(
    nomem_encr = id,
    cs_rep_v      = v_1,
    cs_sw_v       = v_2,
    cs_rep_a      = a_1,
    cs_sw_a       = a_2,
    cs_rep_t      = t0_1,
    cs_sw_t       = t0_2,
    )

save(colorshape_ddm_ml, file = "data/colorshape_ddm_ml.RData")

cs_ddm |>
  mutate(n = 1:n()) |>
  select(a_1, a_2, v_1, v_2, t0_1, t0_2) |>
  pivot_longer(everything(), names_to = 'parameter', values_to = "value") |>
  ggplot(aes(value)) +
  geom_histogram() +
  facet_wrap(~parameter, scales = 'free')

cs_ddm |>
  select(a_1, a_2, v_1, v_2, t0_1, t0_2) |>
  cor()
