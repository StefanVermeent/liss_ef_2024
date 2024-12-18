### Date: 2024-08-27 11:50:04

### Description: First time access to cognitive task data


### For more information on this commit, see the README file, or go to https://github.com/stefanvermeent/liss_ef_2024/commit/19cea5dd5cd24f7d6875416ff3ab67e30f0f3308

### Below is the full code that was used to access the data:


readr::read_delim('data/L_CognitiveAdversity_TASKDATA.csv', col_select = NULL,  delim = ';') |>
 dplyr::filter() |>
 shuffle(data = _, shuffle_vars = 'NULL', long_format = FALSE, seed = 35356)
