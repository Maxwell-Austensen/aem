
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
	allmanufacturing)
	(nic_io
	workers_total
	gva_yearly
	gva_ln_yearly
	labor_reg
	manu_total
	manu_all);

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
	manu_all;
	

sum round gva_ln_yearly labor_reg manu_all manu_total, d;

qui sum gva_yearly if round==57;
scalar mean_57 = r(mean);

qui sum gva_yearly if round==63;
scalar mean_63 = r(mean);

di "Growth in GVA, round 57 to 63";
di (mean_63 - mean_57) / mean_57;


qui sum workers_total if round==57;
scalar mean_57 = r(mean);

qui sum workers_total if round==63;
scalar mean_63 = r(mean);

di "Growth in employees, round 57 to 63";
di (mean_63 - mean_57) / mean_57;



* a;
reg gva_ln_yearly labor_reg if round==57;

* b;
reg gva_ln_yearly labor_reg if round==63;

* c;
reg gva_ln_yearly labor_reg;

gen round_63 = 1 if round==63;
recode round_63 missing = 0;

gen labor_reg_round_63 = 1 if labor_reg==1 & round==63;
recode labor_reg_round_63 missing = 0;

* d;
reg gva_ln_yearly labor_reg round_63 labor_reg_round_63;

* e;
xi: reg gva_ln_yearly labor_reg round_63 labor_reg_round_63 i.state i.nic_io;


