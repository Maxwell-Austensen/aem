################################################################################
## NYU Wagner
## Advanced Empirical Methods
## Replication
## Maxwell Austensen
## September 22, 2016

## Program: GitHub/aem/replication/1_samples.R
## Input:   Box Sync/aem/replication/data/raw
## Ouput:   Box Sync/aem/replication/data/clean
## Purpose: Restrict to desired samples for analysis
################################################################################

# Utility functions -------------------------------------------------------

`%S%` <- function(x, y) {
  paste0(x, y)
}

`%notin%` <- Negate(`%in%`)

# Install packages if needed
package_list <- c("haven", "stringr", "tidyverse")
new_packages <- package_list[package_list %notin% installed.packages()[,"Package"]]
if(length(new_packages)) install.packages(new_packages)

library(haven)
library(stringr)
library(tidyverse)

# Set directories
github_ <- "H:/GitHub/"
# github_ <- "H:/GitHub/"

raw_ <- "C:/Users/austensen/Box Sync/aem/data/raw/"
clean_ <- "C:/Users/austensen/Box Sync/aem/data/clean/"

################################################################################


data <- read_stata(raw_ %S% "usa_00035.dta")





