load("data/clean_data_long.RData")

# RT histograms

flanker_clean |>
  ggplot(aes(rt)) +
  geom_histogram() +
  facet_wrap(~condition, scales = 'free')

simon_clean |>
  ggplot(aes(rt)) +
  geom_histogram()+
  facet_wrap(~condition, scales = 'free')

colorshape_clean |>
  ggplot(aes(rt)) +
  geom_histogram()+
  facet_wrap(~condition, scales = 'free')

animacysize_clean |>
  ggplot(aes(rt)) +
  geom_histogram()+
  facet_wrap(~condition, scales = 'free')

globallocal_clean |>
  ggplot(aes(rt)) +
  geom_histogram()+
  facet_wrap(~condition, scales = 'free')

posner_clean |>
  ggplot(aes(rt)) +
  geom_histogram()+
  facet_wrap(~condition, scales = 'free')

# Accuracy histograms

flanker_clean |>
  group_by(nomem_encr, condition) |>
  summarise(acc = sum(correct)/n()*100) |>
  ggplot(aes(acc)) +
  geom_histogram() +
  facet_wrap(~condition, scales = 'free')

simon_clean |>
  group_by(nomem_encr, condition) |>
  summarise(acc = sum(correct)/n()*100) |>
  ggplot(aes(acc)) +
  geom_histogram() +
  facet_wrap(~condition, scales = 'free')

colorshape_clean |>
  group_by(nomem_encr, condition) |>
  summarise(acc = sum(correct)/n()*100) |>
  ggplot(aes(acc)) +
  geom_histogram() +
  facet_wrap(~condition, scales = 'free')

animacysize_clean |>
  group_by(nomem_encr, condition) |>
  summarise(acc = sum(correct)/n()*100) |>
  ggplot(aes(acc)) +
  geom_histogram() +
  facet_wrap(~condition, scales = 'free')

globallocal_clean |>
  group_by(nomem_encr, condition) |>
  summarise(acc = sum(correct)/n()*100) |>
  ggplot(aes(acc)) +
  geom_histogram() +
  facet_wrap(~condition, scales = 'free')

posner_clean |>
  group_by(nomem_encr) |>
  summarise(acc = sum(correct)/n()*100) |>
  ggplot(aes(acc)) +
  geom_histogram()
