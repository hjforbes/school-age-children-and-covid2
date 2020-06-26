*Model do file

*Import dataset into STATA
cd  `c(pwd)'/output /*sets working directory to analysis folder*/
import delimited input.csv, clear
set more off 

***********************HOUSE-KEEPING*******************************************
* Create directories required 
capture mkdir output
capture mkdir log
capture mkdir tempdata

* Set globals that will print in programs and direct output
global pri_outcome 	  "tpp_infec"
global sec_outcome 	  "comb_death_ITU"

global outdir  	  "output" 
global logdir     "log"
global tempdir    "tempdata"
global varlist 		i.obese4cat						///
					i.smoke_nomiss					///
					i.imd 							///
					i.asthma						///
					i.chronic_respiratory_disease 	///
					i.chronic_cardiac_disease		///
					i.diabetes 						///
					i.chronic_liver_disease  		///
					i.neurological_disease 			///
					i.ra_sle_psoriasis				///
					i.immunodef_any 				///
					i.cancer 						///
					i.ckd							///
					i.hypertension			 	
					
					
					
global table_pri_outcome "COVID-19 infection"
global table_sec_outcome "COVID-19 Death or ITU admission"

global ymax 0.005

********************************************************************************

/*  Pre-analysis data manipulation  */
do "01_cr_analysis_dataset.do"

/*  Checks  */
do "02_an_data_checks.do"
