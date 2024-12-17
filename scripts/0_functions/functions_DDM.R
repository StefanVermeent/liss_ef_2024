

# DDM fitting helpers -----------------------------------------------------

fast_dm_settings <- function(task, model_version = "", method = "ml", precision = 3, zr = 0.5, d = 0, szr = 0, sv = 0, st0 = 0, p = 0, depend = "", format) {

  depend = str_c(depend, collapse = "\n")

  spec <- tribble(
    ~param,        ~setting,                                           ~ command,
    "method",      method,                                             "{param} {setting}",
    "precision",   as.character(precision),                            "{param} {setting}",
    "set zr",      as.character(zr),                                   "{param} {setting}",
    "set d",       as.character(d),                                    "{param} {setting}",
    "set szr",     as.character(szr),                                  "{param} {setting}",
    "set sv",      as.character(sv),                                   "{param} {setting}",
    "set st0",     as.character(st0),                                  "{param} {setting}",
    "set p",       as.character(p),                                    "{param} {setting}",
    "",            depend,                                             "{param} {setting}",
    "format",      format,                                             "{param} {setting}",
    "",            "load *.dat",                                       "{param} {setting}",
    "",            glue("log ddm_results_{task}{model_version}.lst"),  "{param} {setting}"
  ) %>%
    filter(setting != "") %>%
    rowwise() %>%
    transmute(command = glue(command)) %>%
    glue_data("{command}")

  message("\nThe following model specification was written to the DDM folder:\n\n")
  print(spec)

  write_file(str_c(spec, collapse = "\n"), here('data', "1_pilot", "DDM", glue("{task}{model_version}_ml.ctl")))
}

write_DDM_files <- function(data, vars = c("rt", "correct"), task) {

  for (i in unique(data$id)) {
    # 1. Filter subject i and write individual data files to data folder
    change_DDM_i <- data %>%
      filter(id == i) %>%
      select(all_of(vars)) %>%
      write_delim(file = here("data", "1_pilot", "DDM", str_c(task, "_DDM_subject", i, ".dat")), col_names = FALSE)
  }
}


execute_fast_dm <- function(task, path, model_version = "") {
  # 2. Run DDM model
  path_to_files <- paste0("pushd ", file.path(path)) %>% str_replace_all(., pattern="/", replacement="\\\\")
  run_DDM <- str_glue(" && fast-dm.exe {task}{model_version}_ml.ctl")
  cmd <- paste0(path_to_files, run_DDM)

  shell(cmd)

  message("The following command was sent to the shell: ", cmd)
}


read_DDM <- function(task, path = "data", model_version = "") {
  results <- read_table(file.path(path, str_glue("ddm_results_{task}{model_version}.lst"))) %>%
    mutate(dataset = str_replace_all(dataset, str_c("^", task, "_DDM_subject"), "") %>% as.numeric(),
           task = task) %>%
    rename(id = dataset)

  return(results)
}


remove_DDM_files <- function(path) {
  file.remove(list.files(file.path(path), pattern = ".dat$|.lst$", full.names=TRUE))

  message("All individual data files were removed from the folder")
}


ddm_ml_bic <- function(fit, n_free_params, n_trials) {

  return(bic = (-2 * fit) + (n_free_params * log(n_trials)))

}


# DDM simulation helpers --------------------------------------------------

simulate_DDM_parameters <- function(data, nsim = 5000) {

  parameters <- data %>% select(starts_with(c("v", "a", "t0"))) %>% names
  means <- data %>% summarise(across(all_of(parameters), mean)) %>% unlist(., use.names = FALSE)
  sigma <- matrix(nrow = length(parameters), ncol = length(parameters),
                  dimnames=list(parameters, parameters))

  # Fill cells of Var-Covar matrix
  for (col in 1:ncol(sigma)) {
    for (row in 1:nrow(sigma)) {

      col_i = colnames(sigma)[col]
      row_i = rownames(sigma)[row]

      # Variances
      if(col_i == row_i) {
        sigma[col_i, row_i] <- sd(data[[col_i]], na.rm = T)^2
      } else {
        # Covariances
        param_col <- col_i
        param_row <- row_i

        sd_col <- sd(data[[param_col]], na.rm = T)
        sd_row <- sd(data[[param_row]], na.rm = T)
        r      <- cor(data[[param_col]],data[[param_row]])

        sigma[col_i, row_i] <- sd_col * sd_row * r
      }
    }
  }

  set.seed(42)
  sim_params <- rmvnorm(n=nsim, mean = means, sigma = sigma) %>%
    as_tibble() %>%
    setnames(old = names(.), new = parameters) %>%
    mutate(n=50, z = 0.5, row = 1:n()) %>%
    select(n, starts_with("a"), starts_with("t0"), z, starts_with("v"), row) %>%
    filter(across(starts_with(c("a", "t0")), ~. >= 0))

  if(nrow(sim_params) < nsim) warning(paste0(nsim - nrow(sim_params < nsim), " simulated driftrates or non-decision times were smaller than 0 and have been dropped!"))

  return(sim_params)
}


simulate_RTs <- function(sim_params, condition = "") {

  cueing_sim_params <- cueing_sim_params %>%
    setnames(old = names(.), new = c("n", "a", "t0", "z", "v", "row"))

  pmap(cueing_sim_params, function(n,a,t0,z,v, row) {

    print(a)
    rwiener(n,a,t0,z,v) %>%
       as_tibble() #%>%
       mutate(resp = ifelse(resp == "upper", 1, 0)) %>%
       write_delim(file = here("data", "1_pilot", "DDM", str_c("par_sim", row, ".dat")), col_names = FALSE)
  })

  }




































  # # If there are 2 task conditions,
  # if(!is.null(conditions)) {
  #
  #   params_condition1 <- sim_params %>%
  #     select(n, matches(str_c("a_", conditions[1])), matches(str_c("t0_", conditions[1])), z, matches(str_c("v_", conditions[1])), row) %>%
  #     rename_with(.cols = ends_with(conditions[1]), ~str_replace_all(., pattern = str_c("_",conditions[1]), ""))
  #
  #   params_condition2 <- sim_params %>%
  #     select(n, matches(str_c("a_", conditions[2])), matches(str_c("t0_", conditions[2])), z, matches(str_c("v_", conditions[2])), row) %>%
  #     rename_with(.cols = ends_with(conditions[2]), ~str_replace_all(., pattern = str_c("_",conditions[2]), ""))
  #
  #   # Simulate and save RTs
  #   bind_rows(
  #     pmap(params_condition1[1:10,], function(n,a,t0,z,v,row) {
  #       set.seed(42)
  #       rwiener(n,a,t0,z,v) %>%
  #         as_tibble() %>%
  #         mutate(resp = ifelse(resp == "upper", 1, 0),
  #                condition = conditions[1])
  #     }),
  #     pmap(params_condition2[1:10,], function(n,a,t0,z,v,row) {
  #       set.seed(42)
  #       rwiener(n=n,alpha=a,tau=t0,beta=z,delta=v) %>%
  #         as_tibble() %>%
  #         mutate(resp = ifelse(resp == "upper", 1, 0),
  #                condition = conditions[2])
  #     })
  #   )
  #
  #   rt_data <- bind_rows(rt_condition1 %>% mutate(condition = condition[1]),
  #             rt_condition2 %>% mutate(condition = condition[2])) %>%
  #     split()
  #
  #
  #   write_delim(file = here("data", "1_pilot", "DDM", str_c("par_sim", row, ".dat")), col_names = FALSE)
  #
  #   } else {

  # Simulate and save RTs

#}






