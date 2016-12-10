2: Table 1 - Descriptives
================
Maxwell Austensen
2016-12-10

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
order_vec <- c("marriage_ended_mean", "marriage_ended_sd", "age_married_mean", "age_married_sd", "firstborn_girl_mean", 
               "firstborn_girl_sd", "n_children_mean", "n_children_sd", "age_birth_mean", "age_birth_sd", "age_mean", 
               "age_sd", "educ_yrs_mean", "educ_yrs_sd", "urban_mean", "urban_sd", "hhincome_std_mean", 
               "hhincome_std_sd", "poverty_status_mean", "poverty_status_sd", "nonwoman_inc_mean", 
               "nonwoman_inc_sd", "woman_inc_mean", "woman_inc_sd", "woman_earn_mean", "woman_earn_sd", 
               "observations_mean", "observations_sd")

bind_rows(sample1, sample2, sample3) %>% 
  group_by(sample) %>% 
  mutate(observations = n()) %>% 
  select(marriage_ended, age_married, firstborn_girl, n_children, age_birth, age, educ_yrs, urban, 
         hhincome_std, poverty_status, nonwoman_inc, woman_inc, woman_earn, observations) %>% 
  summarise_all(funs(mean, sd)) %>%
  mutate_at(vars(contains("_mean")), format_mean) %>%
  mutate_at(vars(contains("_sd")), format_sd) %>%
  gather("variable", "value", -sample) %>% 
  spread(sample, value) %>% 
  mutate(variable = ordered(variable, levels = order_vec)) %>% 
  arrange(variable) %>% 
  filter(variable != "observations_sd") %>% 
  mutate(variable = str_replace(variable, "_mean", ""),
         variable = if_else(str_detect(variable, "_sd"), "", variable)) %>% 
  knitr::kable()
```

| variable        | Sample 1    | Sample 2   | Sample 3   |
|:----------------|:------------|:-----------|:-----------|
| marriage\_ended | 0.25        | 0.21       | 0.2        |
|                 | (0.43)      | (0.4)      | (0.4)      |
| age\_married    | 19.94       | 20.11      | 20.03      |
|                 | (2.15)      | (2.14)     | (2.13)     |
| firstborn\_girl | NA          | 0.49       | 0.49       |
|                 | NA          | (0.5)      | (0.5)      |
| n\_children     | 2.18        | 2.03       | 2.08       |
|                 | (1.08)      | (0.93)     | (0.94)     |
| age\_birth      | NA          | 22.63      | 22.18      |
|                 | NA          | (3.22)     | (2.68)     |
| age             | 31.41       | 30.64      | 30.55      |
|                 | (5.14)      | (4.84)     | (4.89)     |
| educ\_yrs       | 12.67       | 12.81      | 12.75      |
|                 | (2.1)       | (2.09)     | (2.01)     |
| urban           | 0.64        | 0.64       | 0.64       |
|                 | (0.48)      | (0.48)     | (0.48)     |
| hhincome\_std   | 18841.86    | 9744.13    | 9578.69    |
|                 | (300218.78) | (5531.69)  | (5394.37)  |
| poverty\_status | 0.08        | 0.08       | 0.08       |
|                 | (0.28)      | (0.27)     | (0.27)     |
| nonwoman\_inc   | 27441.2     | 18401.09   | 18326.97   |
|                 | (300075.22) | (12782.94) | (12744.85) |
| woman\_inc      | 4610.71     | 4388.88    | 4293.56    |
|                 | (5949.73)   | (5848.02)  | (5744.27)  |
| woman\_earn     | 4018.72     | 3838.37    | 3751.51    |
|                 | (5428.95)   | (5326.74)  | (5221.74)  |
| observations    | 660705      | 533881     | 463799     |
