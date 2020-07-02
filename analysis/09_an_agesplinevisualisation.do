*an_agesplinevisualisation
*KB 1/5/2020

local outcome `1' 

use "$tempdir\cr_create_analysis_dataset_STSET_`outcome'.dta", clear

estimates use ./output/an_multivariate_cox_models_`outcome'_kids_cat3_MAINFULLYADJMODEL_agespline_bmicat_noeth

if _rc==0{

	bysort age: keep if _n==1

	for var male htdiag_or_highbp chronic_respiratory_disease ///
	chronic_cardiac_disease /// 
	chronic_liver_disease stroke_dementia other_neuro organ_trans ///
	asplenia ra_sle_psoriasis other_immuno: replace X = 0 

	for var obese4cat smoke_nomiss imd asthma diabetes cancer_exhaem_cat cancer_heam_cat  ///
	reduced_kidney_function_cat: replace X = 1 
	
	predict xb, xb
	summ xb if age==55
	gen xb_c = xb-r(mean)
	gen hrcf55 = exp(xb_c)
	*line xb_c age, sort xtitle(Age in years) ytitle("Log hazard ratio (reference age 55 years)") yline(0, lp(dash))
	
	line hrcf55 age, sort xtitle(Age in years) ytitle("Hazard ratio compared to age 55 years (log scale)") yscale(log) ylab( 0.01 0.1 1 10 100 20) yline(0, lp(dash))

	graph export ./output/an_agesplinevisualisation_`outcome'.svg, as(svg) replace

}