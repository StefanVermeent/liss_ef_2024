library(tidyverse)
library(glue)

set.seed(35845)

trials <- expand_grid(
  first  = c("A", "B", "F", "H", "Q", "a", "b", "f", "h", "q"),
  second = c("A", "B", "F", "H", "Q", "a", "b", "f", "h", "q")
) |>
  mutate(
    f_l  = str_to_lower(first),
    s_l = str_to_lower(second),
    condition = ifelse(str_to_lower(first) == str_to_lower(second), "same", "different"),
    key       = ifelse(condition == "same", "A", "L"),
    remove    = rep(c(0,1), times = 50)
  ) |>
  filter(condition == 'same' | (condition == 'different' & remove == 1))

trials <- trials |>
  bind_rows(trials |> filter(condition == "same")) |>
  mutate(rownum = sample(1:n(), size = n())) |>
  arrange(rownum) |>
  mutate(
    valid1 = ifelse(
      ((f_l == lag(f_l,1) | f_l == lag(s_l,1)) &
      (f_l == lag(f_l,2) | f_l == lag(s_l,2)) &
      (f_l == lag(f_l,3) | f_l == lag(s_l,3))),
      FALSE,
      TRUE
    ),
    valid2 = ifelse(
      ((s_l == lag(f_l,1) | s_l == lag(s_l,1)) &
       (s_l == lag(f_l,2) | s_l == lag(s_l,2)) &
       (s_l == lag(f_l,3) | s_l == lag(s_l,3))),
      FALSE,
      TRUE
    ),
    valid3 = ifelse(
      condition == lag(condition,1) &
      condition == lag(condition,2) &
      condition == lag(condition,3),
      FALSE,
      TRUE
    )
  )

while(any(c(trials$valid1, trials$valid2, trials$valid3) == FALSE, na.rm = T)) {
  trials <- trials |>
    mutate(rownum    = sample(1:n(), size = n())) |>
  arrange(rownum) |>
    mutate(
      valid1 = ifelse(
        ((f_l == lag(f_l,1) | f_l == lag(s_l,1)) &
           (f_l == lag(f_l,2) | f_l == lag(s_l,2)) &
           (f_l == lag(f_l,3) | f_l == lag(s_l,3))),
        FALSE,
        TRUE
      ),
      valid2 = ifelse(
        ((s_l == lag(f_l,1) | s_l == lag(s_l,1)) &
           (s_l == lag(f_l,2) | s_l == lag(s_l,2)) &
           (s_l == lag(f_l,3) | s_l == lag(s_l,3))),
        FALSE,
        TRUE
      ),
      valid3 = ifelse(
        condition == lag(condition,1) &
          condition == lag(condition,2) &
          condition == lag(condition,3),
        FALSE,
        TRUE
      )
    )
}

glue_data(
  trials,
  "{{stim1: '{first}', stim2: '{second}', condition: '{condition}', key: '{key}'}},"
)
