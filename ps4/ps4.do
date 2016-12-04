cd "/Users/Maxwell/Box Sync/aem/ps4"

use "nsw_dw.dta", clear

drop if data_id == "Dehejia-Wahba Sample" & treat == 0

gen id = _n
gen index = _n

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

use "match_info", clear

keep if treat == 1


merge m:1 id using "treat", ///
	keepusing(age_1m education_1m black_1m hispanic_1m married_1m nodegree_1m) ///
	keep(master match) nogen


merge m:1 index using "comparison", ///
	keepusing(age_0m education_0m black_0m hispanic_0m married_0m nodegree_0m) ///
	keep(master match) nogen

	
	
collapse (mean) re74_* re75_* education_* index, by(id)

twoway scatter re74_0m re74_1m  || function y = x, ra(re74_0m) clpat(dash)

reg re74_0m re74_1m

twoway scatter re75_0m re75_1m  || function y = x, ra(re75_0m) clpat(dash)

reg re75_0m re75_1m


reshape

graph box education

