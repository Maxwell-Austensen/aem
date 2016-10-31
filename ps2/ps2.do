
* sysuse auto
* ivreg price (mpg = displacement),first


use "C:\Users\austensen\Box Sync\aem\ps2\generateddata_20120221_sub.dta", clear

#delimit ;
rename 
	(NIC_io
	Total_worker
	Yearly_gva_production_real
	lnYearly_gva
	labor_reg_besley_flex2
	manufacturing_total
	allmanufacturing
	manshare)
	(nic_io
	workers_total
	gva_yearly
	gva_ln_yearly
	labor_reg
	manu_total
	manu_all
	manu_share);

keep 
	nic_io
	workers_total
	gva_yearly
	gva_ln_yearly
	labor_reg
	manu_total
	state
	round
	post
	labor_manu
	manu_post
	manu_post_share
	labor_manu_share
	manu_all
	manu_share;

#delimit cr;

* Summary stats
qui{
	matrix sum_full = J(2, 5, .)
	matrix colnames sum_full = gva_ln_yearly labor_reg manu_all manu_total manu_share
	matrix rownames sum_full = mean sd

	matrix sum_57 = sum_full
	matrix sum_63 = sum_full

	local sum_vars gva_ln_yearly labor_reg manu_all manu_total manu_share
	local i 1
	foreach var in `sum_vars' {
		sum `var'
		matrix sum_full[1,`i'] = r(mean)
		matrix sum_full[2,`i'] = r(sd)

		sum `var' if round==57
		matrix sum_57[1,`i'] = r(mean)
		matrix sum_57[2,`i'] = r(sd)

		sum `var' if round==63
		matrix sum_63[1,`i'] = r(mean)
		matrix sum_63[2,`i'] = r(sd)

		local i `i'+1
	}
}

di "Summary stats - Full Sample"
matrix list sum_full

di "Summary stats - Round 57"
matrix list sum_57

di "Summary stats - Round 63"
matrix list sum_63



qui{
	sum gva_yearly if round==57
	scalar mean_57 = r(mean)

	sum gva_yearly if round==63
	scalar mean_63 = r(mean)
}

di "Growth in GVA, round 57 to 63 = "(mean_63 - mean_57) / mean_57

qui{
	sum workers_total if round==57
	scalar mean_57 = r(mean)

	sum workers_total if round==63
	scalar mean_63 = r(mean)
}

di "Growth in employees, round 57 to 63 = "(mean_63 - mean_57) / mean_57



* a
reg gva_ln_yearly labor_reg if round==57

* b
reg gva_ln_yearly labor_reg if round==63

* c
reg gva_ln_yearly labor_reg

gen round_63 = 1 if round==63
recode round_63 missing = 0

gen labor_reg_round_63 = 1 if labor_reg==1 & round==63
recode labor_reg_round_63 missing = 0

* d
reg gva_ln_yearly labor_reg round_63 labor_reg_round_63

* e
xi: reg gva_ln_yearly labor_reg round_63 labor_reg_round_63 i.state i.nic_io


