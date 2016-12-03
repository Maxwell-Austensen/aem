AEM Replication: 2
================
Maxwell Austensen
2016-12-03

``` r
sample1 <- read_feather(str_c(clean_, "sample1.feather")) %>% mutate(sample = "Sample 1")
sample2 <- read_feather(str_c(clean_, "sample2.feather")) %>% mutate(sample = "Sample 2")
sample3 <- read_feather(str_c(clean_, "sample3.feather")) %>% mutate(sample = "Sample 3")
```

``` r
format_sd <- function(x, digits = 2) {
  x %>% round(digits = digits) %>% str_c("(", ., ")")
}

format_mean <- function(val, digits = 2) {
  val %>% round(digits = digits) %>% as.character()
}
```

``` r
order_vec <- c("marr_ended_mean", "marr_ended_sd", "agemarr_mean", "agemarr_sd", "child_girl_mean", 
               "child_girl_sd", "chborn_mean", "chborn_sd", "age_birth_mean", "age_birth_sd", "age_mean", 
               "age_sd", "educ_yrs_mean", "educ_yrs_sd", "urban_mean", "urban_sd", "hhincome_std_mean", 
               "hhincome_std_sd", "poverty_status_mean", "poverty_status_sd", "nonwoman_inc_mean", 
               "nonwoman_inc_sd", "woman_inc_mean", "woman_inc_sd", "woman_earn_mean", "woman_earn_sd", 
               "obs_mean", "obs_sd")

bind_rows(sample1, sample2, sample3) %>% 
  group_by(sample) %>% 
  mutate(marr_ended = if_else(marst %in% c(3, 4) | marrno == 2, 1, 0),
         age_birth = age - age_c,
         child_girl = if_else(sex_c == 2, 1, 0),
         educ_yrs = if_else(higrade <= 3, 0, higrade - 3),
         urban = if_else(metarea == 0, 0, 1),
         poverty_status = if_else(is.na(poverty), NA_real_, if_else(poverty < 100, 1, 0)),
         nonwoman_inc = hhincome - inctot,
         woman_inc = inctot,
         woman_earn = incwage,
         obs = n()) %>% 
  select(marr_ended, agemarr, child_girl, chborn, age_birth, age, educ_yrs, urban, 
         hhincome_std, poverty_status, nonwoman_inc, woman_inc, woman_earn, obs) %>% 
  summarise_all(funs(mean, sd)) %>%
  mutate_at(vars(contains("_mean")), format_mean) %>%
  mutate_at(vars(contains("_sd")), format_sd) %>%
  gather("variable", "value", -sample) %>% 
  spread(sample, value) %>% 
  mutate(variable = ordered(variable, levels = order_vec)) %>% 
  arrange(variable) %>% 
  filter(variable != "obs_sd") %>% 
  mutate(variable = str_replace(variable, "_mean", ""),
         variable = if_else(str_detect(variable, "_sd"), "", variable)) %>% 
  knitr::kable()
```

| variable        | Sample 1    | Sample 2   | Sample 3   |
|:----------------|:------------|:-----------|:-----------|
| marr\_ended     | 0.25        | 0.21       | 0.2        |
|                 | (0.43)      | (0.4)      | (0.4)      |
| agemarr         | 19.94       | 20.11      | 20.03      |
|                 | (2.15)      | (2.14)     | (2.13)     |
| child\_girl     | NA          | 0.49       | 0.49       |
|                 | NA          | (0.5)      | (0.5)      |
| chborn          | 3.18        | 3.03       | 3.08       |
|                 | (1.08)      | (0.93)     | (0.94)     |
| age\_birth      | NA          | 22.63      | 22.18      |
|                 | NA          | (3.22)     | (2.68)     |
| age             | 31.41       | 30.64      | 30.55      |
|                 | (5.14)      | (4.84)     | (4.89)     |
| educ\_yrs       | 12.67       | 12.81      | 12.75      |
|                 | (2.1)       | (2.09)     | (2.01)     |
| urban           | 0.64        | 0.64       | 0.64       |
|                 | (0.48)      | (0.48)     | (0.48)     |
| hhincome\_std   | 18841.86    | 9743.95    | 9578.49    |
|                 | (300218.78) | (5531.71)  | (5394.4)   |
| poverty\_status | 0.08        | 0.08       | 0.08       |
|                 | (0.28)      | (0.27)     | (0.27)     |
| nonwoman\_inc   | 27441.2     | 18401.27   | 18327.18   |
|                 | (300075.22) | (12783.26) | (12745.22) |
| woman\_inc      | 4610.71     | 4388.72    | 4293.39    |
|                 | (5949.73)   | (5847.96)  | (5744.21)  |
| woman\_earn     | 4018.72     | 3838.23    | 3751.35    |
|                 | (5428.95)   | (5326.69)  | (5221.68)  |
| obs             | 660705      | 533901     | 463819     |
