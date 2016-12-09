AEM Replication: 3
================
Maxwell Austensen
2016-12-08

``` r
sample3 <- read_feather(str_c(clean_, "sample3.feather")) %>% mutate(sample = "Sample 3")
```

``` r
first_stage_df <- 
  sample3 %>% 
  mutate(marr_ended = if_else(marst %in% c(3, 4) | marrno == 2, 1, 0),
         child_girl = if_else(sex_c == 2, 1, 0),
         educ_yrs = if_else(higrade < 4, 0, higrade - 3),
         `educ_<12 years` = if_else(educ_yrs < 12, 1, 0),
         `educ_12 years` = if_else(educ_yrs == 12, 1, 0),
         `educ_13-15 years` = if_else(between(educ_yrs, 13, 15), 1, 0),
         `educ_16+ years` = if_else(educ_yrs >= 16, 1, 0),
         `agemarr_<20 years old` = if_else(agemarr < 20, 1, 0),
         `agemarr_20+ years old` = if_else(agemarr >= 20, 1, 0),
         age_birth = age - age_c,
         `agebirth_<22 years old` = if_else(age_birth < 22, 1, 0),
         `agebirth_22+ years old` = if_else(age_birth >= 22, 1, 0))
```

``` r
make_table <- function(name, formula){
  if(name == "child_girl"){
    obs <- data_frame(Observations = nrow(first_stage_df))
    mod <- first_stage_df %>% lm(formula, data = .)
  } else {
    filtered <- first_stage_df %>% filter_(str_interp("`${name}` == 1"))
    obs <- data_frame(Observations = nrow(filtered))
    mod <- filtered %>% lm(formula, data = .)
  }
  
  label <- data_frame(label = str_replace(name, "educ_|agemarr_|agebirth_", ""))
  est <- mod %>% tidy() %>% filter(term == "child_girl") %>% select(Coefficient = estimate)
  f_stat <- mod %>% glance() %>% select(`F-Statistic` = statistic)
  
  df <- bind_cols(label, est, f_stat, obs)
  return(df)
}
```

``` r
cols <- c("child_girl", "educ_<12 years", "educ_12 years", "educ_13-15 years", 
          "educ_16+ years", "agemarr_<20 years old", "agemarr_20+ years old", 
          "agebirth_<22 years old", "agebirth_22+ years old")

adj_formula <- "marr_ended ~ child_girl + age + age_birth + agemarr + educ_yrs + age^2 + agemarr^2 + age_birth^2 + educ_yrs^2 + age*educ_yrs + agemarr*educ_yrs + age_birth*educ_yrs + metarea + factor(bpl) + factor(statefip)"

unadjusted <- map_df(cols, make_table, formula = "marr_ended ~ child_girl")
adjusted <- map_df(cols, make_table, formula = adj_formula)

table2 <- 
  unadjusted %>% 
  inner_join(adjusted, by = c("label", "Observations"), suffix = c("_unadj", "_adj")) %>% 
  select(label, contains("_unadj"), contains("_adj"), Observations)

knitr::kable(table2, digits = c(NA, 3, 1, 3, 1, 0), format.args = list(big.mark = ','))
```

| label            |  Coefficient\_unadj|  F-Statistic\_unadj|  Coefficient\_adj|  F-Statistic\_adj|  Observations|
|:-----------------|-------------------:|-------------------:|-----------------:|-----------------:|-------------:|
| child\_girl      |               0.008|                49.6|             0.008|             212.8|       463,819|
| &lt;12 years     |               0.020|                24.5|             0.018|              12.2|        51,053|
| 12 years         |               0.006|                13.4|             0.006|              83.7|       246,187|
| 13-15 years      |               0.010|                16.8|             0.009|              60.7|       102,010|
| 16+ years        |               0.005|                 4.0|             0.005|              46.9|        64,569|
| &lt;20 years old |               0.011|                34.2|             0.010|              63.7|       215,531|
| 20+ years old    |               0.006|                16.7|             0.005|              69.4|       248,288|
| &lt;22 years old |               0.012|                38.3|             0.011|              62.1|       206,050|
| 22+ years old    |               0.005|                11.9|             0.005|              74.8|       257,769|
