AEM Replication: 3
================
Maxwell Austensen
2016-12-03

``` r
sample3 <- read_feather(str_c(clean_, "sample3.feather")) %>% mutate(sample = "Sample 3")
```

``` r
first_stage_df <- 
  sample3 %>% 
  transmute(marr_ended = if_else(marst %in% c(3, 4) | marrno == 2, 1, 0),
         child_girl = if_else(sex_c == 2, 1, 0),
         `educ_<12 years` = if_else(higrade < 15, 1, 0),
         `educ_12 years` = if_else(higrade == 15, 1, 0),
         `educ_13-15 years` = if_else(between(higrade, 16, 18), 1, 0),
         `educ_16+ years` = if_else(higrade >= 19, 1, 0),
         `agemarr_<20 years old` = if_else(agemarr < 20, 1, 0),
         `agemarr_20+ years old` = if_else(agemarr >= 20, 1, 0),
         `agebirth_<22 years old` = if_else((age - age_c) < 22, 1, 0),
         `agebirth_22+ years old` = if_else((age - age_c) >= 22, 1, 0))

glimpse(first_stage_df)
```

    ## Observations: 463,819
    ## Variables: 10
    ## $ marr_ended             <dbl> 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, ...
    ## $ child_girl             <dbl> 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, 0, ...
    ## $ educ_<12 years         <dbl> 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
    ## $ educ_12 years          <dbl> 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, ...
    ## $ educ_13-15 years       <dbl> 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, ...
    ## $ educ_16+ years         <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
    ## $ agemarr_<20 years old  <dbl> 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, ...
    ## $ agemarr_20+ years old  <dbl> 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, ...
    ## $ agebirth_<22 years old <dbl> 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, ...
    ## $ agebirth_22+ years old <dbl> 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, ...

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
cols <- first_stage_df %>% select(-marr_ended) %>% names()

unadjusted <- map(cols, make_table, formula = "marr_ended ~ child_girl") %>% bind_rows()

knitr::kable(unadjusted)
```

| label            |  Coefficient|  F-Statistic|  Observations|
|:-----------------|------------:|------------:|-------------:|
| child\_girl      |    0.0082223|    49.625318|        463819|
| &lt;12 years     |    0.0195991|    24.450216|         51053|
| 12 years         |    0.0059418|    13.390824|        246187|
| 13-15 years      |    0.0100534|    16.814023|        102010|
| 16+ years        |    0.0050863|     4.033588|         64569|
| &lt;20 years old |    0.0110897|    34.178420|        215531|
| 20+ years old    |    0.0056726|    16.697069|        248288|
| &lt;22 years old |    0.0120360|    38.313669|        206050|
| 22+ years old    |    0.0047494|    11.932880|        257769|
