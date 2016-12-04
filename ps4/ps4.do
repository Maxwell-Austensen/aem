cd "/Users/Maxwell/Box Sync/aem/ps4"

use "nsw_dw.dta", clear

drop if data_id == "Dehejia-Wahba Sample" & treat == 0

* create id and index vars to allow merging covariates back after matching
gen id = _n
gen index = _n

* rename variables to accomdate wide format created by matching
preserve
rename * *_1m
rename id_1m id
save "treat", replace
restore

preserve
rename * *_0m
rename index_0m index
save "comparison", replace
restore


nnmatch re78 treat re74 re75, keep(match_info) replace

*        re78 |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
*-------------+----------------------------------------------------------------
*        SATE |  -10475.37   3936.875    -2.66   0.008     -18191.5   -2759.233

********************************************************************************

use "match_info", clear

keep if treat == 1

* merge back in other covariates dropped in matching process
merge m:1 id using "treat", ///
	keepusing(age_1m education_1m black_1m hispanic_1m married_1m nodegree_1m) ///
	keep(master match) nogen

merge m:1 index using "comparison", ///
	keepusing(age_0m education_0m black_0m hispanic_0m married_0m nodegree_0m) ///
	keep(master match) nogen

* get one row per observation (from tie matches)
collapse (mean) re74_* re75_* education_* index, by(id)

* check quality of matching for re74
twoway (scatter re74_0m re74_1m) (lfit re74_0m re74_1m) || ///
	function y = x, ra(re74_0m) clpat(dash)

reg re74_0m re74_1m
	* R-squared     =  0.9977

* check quality of matching for re74
twoway (scatter re75_0m re75_1m) (lfit re75_0m re75_1m)  || ///
	function y = x, ra(re75_0m) clpat(dash)

reg re75_0m re75_1m
	* R-squared     =  0.9929
	
* check balance of education treatment and matched comparison
twoway (scatter education_0m education_1m) (lfit education_0m education_1m) || ///
	function y = x, ra(education_0m) clpat(dash)

ttest education_1m ==  education_0m
	* mean(diff) -.9477146   (se) .2238233


********************************************************************************
* Q 4
*******

use "nsw_dw.dta", clear

drop if data_id == "Dehejia-Wahba Sample" & treat == 0

gen re74_sq = re74 ^ 2
gen re75_sq = re75 ^ 2

local covariates "age education black hispanic married re74 re75 re74_sq re75_sq"

nnmatch re78 treat `covariates', keep(match_info2) replace

*        re78 |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
*-------------+----------------------------------------------------------------
*        SATE |  -12233.25   3664.994    -3.34   0.001    -19416.51   -5049.993


use "match_info2", clear

local collapse_vars = "treat re78 age education black hispanic married re74 re75 re74_sq re75_sq km index dist re78_0 re78_1 age_0m education_0m black_0m hispanic_0m married_0m re74_0m re75_0m re74_sq_0m re75_sq_0m age_1m education_1m black_1m hispanic_1m married_1m re74_1m re75_1m re74_sq_1m re75_sq_1m"

collapse (mean) `collapse_vars', by(id) 

local vars "age education black hispanic married re74 re75"

matrix table1 = J(3, 7, .)
matrix colnames table1 = `vars'
matrix rownames table1 = trt_mean comp_mean diff_se

matrix list table1 

local i = 1
foreach var in age education black hispanic married re74 re75 {

	qui ttest `var'_0m == `var'_1m, unpaired
	
	matrix table1[1, `i'] = r(mu_2)
	matrix table1[2, `i'] = r(mu_1)
	matrix table1[3, `i'] = r(se)
	
	local i = `i'+1
}

* Assess the quality of the matches for each covariate
matrix list table1


use "nsw_dw.dta", clear

drop if data_id == "Dehejia-Wahba Sample" & treat == 0

ttest re78, by(treat)

* Group |              Mean    Std. Err. 
* diff  |            15204.78    1154.614
 
********************************************************************************











