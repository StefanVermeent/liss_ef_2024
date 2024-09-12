load("data/clean_data_long.RData")

library(runjags)

# 1. Models ---------------------------------------------------------------

## 1.1 Two conditions ----

model_2con <- "model {
 #likelihood function
 for (t in 1:nTrials) {
 y[t] ~ dwiener(alpha[condition[t], subject[t]],
 tau[condition[t], subject[t]],
 0.5,
 delta[condition[t], subject[t]])
 }
 for (s in 1:nSubjects) {
 for (c in 1:nCon) {
 tau[c, s] ~ dnorm(muTau[c], precTau) T(.0001, 1)
 delta[c, s] ~ dnorm(muDelta[c] , precDelta) T(-10, 10)
 alpha[c, s] ~ dnorm(muAlpha[c], precAlpha) T(.1, 5)
 }

 }
 #priors
 for (c in 1:nCon){
 muTau[c] ~ dunif(.0001, 1)
 muDelta[c] ~ dunif(-10, 10)
 muAlpha[c] ~ dunif(.1, 5)
 }

 precAlpha ~ dgamma(.001, .001)
 precTau ~ dgamma(.001, .001)
 precDelta ~ dgamma(.001, .001)
}"

initfunction_2con <- function(chain){
  return(list(
    muAlpha = runif(2, .2, 4.9),
    muTau = runif(2, .01, .05),
    muDelta = runif(2, -9.9, 9.9),
    precAlpha = runif(1, .01, 100),
    precTau = runif(1, .01, 100),
    precDelta = runif(1, .01, 100),
    y = yInit,
    .RNG.name = "lecuyer::RngStream",
    .RNG.seed = sample.int(1e10, 1, replace = F)))
}

## 1.2 One condition ----

model_1con <- "model {
 #likelihood function
 for (t in 1:nTrials) {
 y[t] ~ dwiener(alpha[subject[t]],
 tau[subject[t]],
 0.5,
 delta[subject[t]])
 }

 for (s in 1:nSubjects) {
 tau[s] ~ dnorm(muTau, precTau) T(.0001, 1)
 delta[s] ~ dnorm(muDelta, precDelta) T(-10, 10)
 alpha[s] ~ dnorm(muAlpha, precAlpha) T(.1, 5)
 }

 #priors
 muTau ~ dunif(.0001, 1)
 muDelta ~ dunif(-10, 10)
 muAlpha~ dunif(.1, 5)

 precAlpha ~ dgamma(.001, .001)
 precTau ~ dgamma(.001, .001)
 precDelta ~ dgamma(.001, .001)
}"

initfunction_1con <- function(chain){
  return(list(
    muAlpha = runif(1, .2, 4.9),
    muTau = runif(1, .01, .05),
    muDelta = runif(1, -9.9, 9.9),
    precAlpha = runif(1, .01, 100),
    precTau = runif(1, .01, 100),
    precDelta = runif(1, .01, 100),
    y = yInit,
    .RNG.name = "lecuyer::RngStream",
    .RNG.seed = sample.int(1e10, 1, replace = F)))
}


# 2. Flanker task ---------------------------------------------------------

## 2.1 Prepare data ----

flanker_id_matches <- flanker_clean |>
  distinct(nomem_encr) |>
  mutate(nomem_encr_num = 1:n())

flanker_clean <- flanker_clean |>
  left_join(flanker_id_matches)

# Store RTs and condition per trial (incorrect RTs are coded negatively)
flanker_y          <- round(ifelse(flanker_clean$correct == 0, (flanker_clean$rt*-1), flanker_clean$rt),3)
yInit              <- rep(NA, length(flanker_y))
flanker_condition  <- as.numeric(flanker_clean$condition)

#Create numbers for JAGS
flanker_nTrials    <- nrow(flanker_clean)
flanker_nSubjects  <- length(unique(flanker_clean$nomem_encr))
flanker_nCondition <- max(flanker_condition)

#Create a list of the data; this gets sent to JAGS
flanker_datalist <- list(y = flanker_y, subject = flanker_clean$nomem_encr_num, condition = flanker_condition,
                         nTrials = flanker_nTrials, nCon = flanker_nCondition,
                         nSubjects = flanker_nSubjects)

# JAGS Specifications

#Create list of parameters to be monitored
parameters <- c("alpha", "tau", "delta", "muAlpha",
                "muTau", "muDelta")

nUseSteps = 1000 # Specify number of steps to run
nChains = 3 # Specify number of chains to run (one per processor)

## 2.2 Run Model ----

ddm_flanker_mod1 <- run.jags(method = "parallel",
                             model = model_2con,
                             monitor = parameters,
                             data = flanker_datalist,
                             inits = initfunction_2con,
                             n.chains = nChains,
                             # check.conv = TRUE,
                             # psrf.target = 1.10,
                             adapt = 1000, #how long the samplers "tune"
                             burnin = 2000, #how long of a burn in
                             sample = 1000,
                             summarise = FALSE,
                             thin = 10, #thin if high autocorrelation to avoid huge files
                             modules = c("wiener", "lecuyer"),
                             plots = F)

## 2.3 Extract results

# Extract Rhat
rhat_flanker_mod1 <- ddm_flanker_mod1$psrf$psrf |>
  unlist() |>
  as_tibble(rownames = "parameter")

save(rhat_flanker_mod1, file = "analysis_objects/rhat_flanker_mod1.RData")

#Convert the runjags object to a coda format
mcmc_flanker_mod1 <- as.matrix(as.mcmc.list(ddm_flanker_mod1), chains = F) |>
  as_tibble()

save(mcmc_flanker_mod1, ddm_flanker_mod1, file = "analysis_objects/ddm_flanker_mod1.RData")


# 3. Simon task ---------------------------------------------------------

## 3.1 Prepare data ----

simon_id_matches <- simon_clean |>
  distinct(nomem_encr) |>
  mutate(nomem_encr_num = 1:n())

simon_clean <- simon_clean |>
  left_join(simon_id_matches)

# Store RTs and condition per trial (incorrect RTs are coded negatively)
simon_y          <- round(ifelse(simon_clean$correct == 0, (simon_clean$rt*-1), simon_clean$rt),3)
yInit              <- rep(NA, length(simon_y))
simon_condition  <- as.numeric(simon_clean$condition)

#Create numbers for JAGS
simon_nTrials    <- nrow(simon_clean)
simon_nSubjects  <- length(unique(simon_clean$nomem_encr))
simon_nCondition <- max(simon_condition)

#Create a list of the data; this gets sent to JAGS
simon_datalist <- list(y = simon_y, subject = simon_clean$nomem_encr_num, condition = simon_condition,
                         nTrials = simon_nTrials, nCon = simon_nCondition,
                         nSubjects = simon_nSubjects)

# JAGS Specifications

#Create list of parameters to be monitored
parameters <- c("alpha", "tau", "delta", "muAlpha",
                "muTau", "muDelta")

nUseSteps = 1000 # Specify number of steps to run
nChains = 3 # Specify number of chains to run (one per processor)

## 3.2 Run Model ----

ddm_simon_mod1 <- run.jags(method = "parallel",
                             model = model_2con,
                             monitor = parameters,
                             data = simon_datalist,
                             inits = initfunction_2con,
                             n.chains = nChains,
                             # check.conv = TRUE,
                             # psrf.target = 1.10,
                             adapt = 1000, #how long the samplers "tune"
                             burnin = 2000, #how long of a burn in
                             sample = 1000,
                             summarise = FALSE,
                             thin = 10, #thin if high autocorrelation to avoid huge files
                             modules = c("wiener", "lecuyer"),
                             plots = F)

## 3.3 Extract results

# Extract Rhat
rhat_simon_mod1 <- ddm_simon_mod1$psrf$psrf |>
  unlist() |>
  as_tibble(rownames = "parameter")

save(rhat_simon_mod1, file = "analysis_objects/rhat_simon_mod1.RData")

#Convert the runjags object to a coda format
mcmc_simon_mod1 <- as.matrix(as.mcmc.list(ddm_simon_mod1), chains = F) |>
  as_tibble()

save(mcmc_simon_mod1, ddm_simon_mod1, file = "analysis_objects/ddm_simon_mod1.RData")



# 4. Color-shape task ---------------------------------------------------------

## 4.1 Prepare data ----

colorshape_id_matches <- colorshape_clean |>
  distinct(nomem_encr) |>
  mutate(nomem_encr_num = 1:n())

colorshape_clean <- colorshape_clean |>
  left_join(colorshape_id_matches)

# Store RTs and condition per trial (incorrect RTs are coded negatively)
colorshape_y          <- round(ifelse(colorshape_clean$correct == 0, (colorshape_clean$rt*-1), colorshape_clean$rt),3)
yInit              <- rep(NA, length(colorshape_y))
colorshape_condition  <- as.numeric(colorshape_clean$condition)

#Create numbers for JAGS
colorshape_nTrials    <- nrow(colorshape_clean)
colorshape_nSubjects  <- length(unique(colorshape_clean$nomem_encr))
colorshape_nCondition <- max(colorshape_condition)

#Create a list of the data; this gets sent to JAGS
colorshape_datalist <- list(y = colorshape_y, subject = colorshape_clean$nomem_encr_num, condition = colorshape_condition,
                         nTrials = colorshape_nTrials, nCon = colorshape_nCondition,
                         nSubjects = colorshape_nSubjects)

# JAGS Specifications

#Create list of parameters to be monitored
parameters <- c("alpha", "tau", "delta", "muAlpha",
                "muTau", "muDelta")

nUseSteps = 1000 # Specify number of steps to run
nChains = 3 # Specify number of chains to run (one per processor)

## 4.2 Run Model ----

ddm_colorshape_mod1 <- run.jags(method = "parallel",
                             model = model_2con,
                             monitor = parameters,
                             data = colorshape_datalist,
                             inits = initfunction_2con,
                             n.chains = nChains,
                             # check.conv = TRUE,
                             # psrf.target = 1.10,
                             adapt = 1000, #how long the samplers "tune"
                             burnin = 2000, #how long of a burn in
                             sample = 1000,
                             summarise = FALSE,
                             thin = 10, #thin if high autocorrelation to avoid huge files
                             modules = c("wiener", "lecuyer"),
                             plots = F)

## 4.3 Extract results

# Extract Rhat
rhat_colorshape_mod1 <- ddm_colorshape_mod1$psrf$psrf |>
  unlist() |>
  as_tibble(rownames = "parameter")

save(rhat_colorshape_mod1, file = "analysis_objects/rhat_colorshape_mod1.RData")

#Convert the runjags object to a coda format
mcmc_colorshape_mod1 <- as.matrix(as.mcmc.list(ddm_colorshape_mod1), chains = F) |>
  as_tibble()

save(mcmc_colorshape_mod1, ddm_colorshape_mod1, file = "analysis_objects/ddm_colorshape_mod1.RData")



# 5. Animacy-size task ---------------------------------------------------------

## 5.1 Prepare data ----

animacysize_id_matches <- animacysize_clean |>
  distinct(nomem_encr) |>
  mutate(nomem_encr_num = 1:n())

animacysize_clean <- animacysize_clean |>
  left_join(animacysize_id_matches)

# Store RTs and condition per trial (incorrect RTs are coded negatively)
animacysize_y          <- round(ifelse(animacysize_clean$correct == 0, (animacysize_clean$rt*-1), animacysize_clean$rt),3)
yInit              <- rep(NA, length(animacysize_y))
animacysize_condition  <- as.numeric(animacysize_clean$condition)

#Create numbers for JAGS
animacysize_nTrials    <- nrow(animacysize_clean)
animacysize_nSubjects  <- length(unique(animacysize_clean$nomem_encr))
animacysize_nCondition <- max(animacysize_condition)

#Create a list of the data; this gets sent to JAGS
animacysize_datalist <- list(y = animacysize_y, subject = animacysize_clean$nomem_encr_num, condition = animacysize_condition,
                         nTrials = animacysize_nTrials, nCon = animacysize_nCondition,
                         nSubjects = animacysize_nSubjects)

# JAGS Specifications

#Create list of parameters to be monitored
parameters <- c("alpha", "tau", "delta", "muAlpha",
                "muTau", "muDelta")

nUseSteps = 1000 # Specify number of steps to run
nChains = 3 # Specify number of chains to run (one per processor)

## 5.2 Run Model ----

ddm_animacysize_mod1 <- run.jags(method = "parallel",
                             model = model_2con,
                             monitor = parameters,
                             data = animacysize_datalist,
                             inits = initfunction_2con,
                             n.chains = nChains,
                             # check.conv = TRUE,
                             # psrf.target = 1.10,
                             adapt = 1000, #how long the samplers "tune"
                             burnin = 2000, #how long of a burn in
                             sample = 1000,
                             summarise = FALSE,
                             thin = 10, #thin if high autocorrelation to avoid huge files
                             modules = c("wiener", "lecuyer"),
                             plots = F)

## 5.3 Extract results

# Extract Rhat
rhat_animacysize_mod1 <- ddm_animacysize_mod1$psrf$psrf |>
  unlist() |>
  as_tibble(rownames = "parameter")

save(rhat_animacysize_mod1, file = "analysis_objects/rhat_animacysize_mod1.RData")

#Convert the runjags object to a coda format
mcmc_animacysize_mod1 <- as.matrix(as.mcmc.list(ddm_animacysize_mod1), chains = F) |>
  as_tibble()

save(mcmc_animacysize_mod1, ddm_animacysize_mod1, file = "analysis_objects/ddm_animacysize_mod1.RData")



# 6. Global-local task ---------------------------------------------------------

## 6.1 Prepare data ----

globallocal_id_matches <- globallocal_clean |>
  distinct(nomem_encr) |>
  mutate(nomem_encr_num = 1:n())

globallocal_clean <- globallocal_clean |>
  left_join(globallocal_id_matches)

# Store RTs and condition per trial (incorrect RTs are coded negatively)
globallocal_y          <- round(ifelse(globallocal_clean$correct == 0, (globallocal_clean$rt*-1), globallocal_clean$rt),3)
yInit              <- rep(NA, length(globallocal_y))
globallocal_condition  <- as.numeric(globallocal_clean$condition)

#Create numbers for JAGS
globallocal_nTrials    <- nrow(globallocal_clean)
globallocal_nSubjects  <- length(unique(globallocal_clean$nomem_encr))
globallocal_nCondition <- max(globallocal_condition)

#Create a list of the data; this gets sent to JAGS
globallocal_datalist <- list(y = globallocal_y, subject = globallocal_clean$nomem_encr_num, condition = globallocal_condition,
                         nTrials = globallocal_nTrials, nCon = globallocal_nCondition,
                         nSubjects = globallocal_nSubjects)

# JAGS Specifications

#Create list of parameters to be monitored
parameters <- c("alpha", "tau", "delta", "muAlpha",
                "muTau", "muDelta")

nUseSteps = 1000 # Specify number of steps to run
nChains = 3 # Specify number of chains to run (one per processor)

## 6.2 Run Model ----

ddm_globallocal_mod1 <- run.jags(method = "parallel",
                             model = model_2con,
                             monitor = parameters,
                             data = globallocal_datalist,
                             inits = initfunction_2con,
                             n.chains = nChains,
                             # check.conv = TRUE,
                             # psrf.target = 1.10,
                             adapt = 1000, #how long the samplers "tune"
                             burnin = 2000, #how long of a burn in
                             sample = 1000,
                             summarise = FALSE,
                             thin = 10, #thin if high autocorrelation to avoid huge files
                             modules = c("wiener", "lecuyer"),
                             plots = F)

## 6.3 Extract results

# Extract Rhat
rhat_globallocal_mod1 <- ddm_globallocal_mod1$psrf$psrf |>
  unlist() |>
  as_tibble(rownames = "parameter")

save(rhat_globallocal_mod1, file = "analysis_objects/rhat_globallocal_mod1.RData")

#Convert the runjags object to a coda format
mcmc_globallocal_mod1 <- as.matrix(as.mcmc.list(ddm_globallocal_mod1), chains = F) |>
  as_tibble()

save(mcmc_globallocal_mod1, ddm_globallocal_mod1, file = "analysis_objects/ddm_globallocal_mod1.RData")



# 7. Posner task ---------------------------------------------------------

## 7.1 Prepare data ----

posner_id_matches <- posner_clean |>
  distinct(nomem_encr) |>
  mutate(nomem_encr_num = 1:n())

posner_clean <- posner_clean |>
  left_join(posner_id_matches)

# Store RTs and condition per trial (incorrect RTs are coded negatively)
posner_y          <- round(ifelse(posner_clean$correct == 0, (posner_clean$rt*-1), posner_clean$rt),3)
yInit              <- rep(NA, length(posner_y))
posner_condition  <- as.numeric(posner_clean$condition)

#Create numbers for JAGS
posner_nTrials    <- nrow(posner_clean)
posner_nSubjects  <- length(unique(posner_clean$nomem_encr))
posner_nCondition <- max(posner_condition)

#Create a list of the data; this gets sent to JAGS
posner_datalist <- list(y = posner_y, subject = posner_clean$nomem_encr_num, condition = posner_condition,
                         nTrials = posner_nTrials, nCon = posner_nCondition,
                         nSubjects = posner_nSubjects)

# JAGS Specifications

#Create list of parameters to be monitored
parameters <- c("alpha", "tau", "delta", "muAlpha",
                "muTau", "muDelta")

nUseSteps = 1000 # Specify number of steps to run
nChains = 3 # Specify number of chains to run (one per processor)

## 7.2 Run Model ----

ddm_posner_mod1 <- run.jags(method = "parallel",
                             model = model_2con,
                             monitor = parameters,
                             data = posner_datalist,
                             inits = initfunction_2con,
                             n.chains = nChains,
                             # check.conv = TRUE,
                             # psrf.target = 1.10,
                             adapt = 1000, #how long the samplers "tune"
                             burnin = 2000, #how long of a burn in
                             sample = 1000,
                             summarise = FALSE,
                             thin = 10, #thin if high autocorrelation to avoid huge files
                             modules = c("wiener", "lecuyer"),
                             plots = F)

## 7.3 Extract results

# Extract Rhat
rhat_posner_mod1 <- ddm_posner_mod1$psrf$psrf |>
  unlist() |>
  as_tibble(rownames = "parameter")

save(rhat_posner_mod1, file = "analysis_objects/rhat_posner_mod1.RData")

#Convert the runjags object to a coda format
mcmc_posner_mod1 <- as.matrix(as.mcmc.list(ddm_posner_mod1), chains = F) |>
  as_tibble()

save(mcmc_posner_mod1, ddm_posner_mod1, file = "analysis_objects/ddm_posner_mod1.RData")
