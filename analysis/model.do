*Model do file

*Import dataset into STATA
import delimited `c(pwd)'/output/input.csv, clear

cd  `c(pwd)'/analysis /*sets working directory to analysis folder*/
set more off 

***********************HOUSE-KEEPING*******************************************
* Create directories required 
capture mkdir output
capture mkdir log
capture mkdir tempdata
capture mkdir output\models


* Set globals that will print in programs and direct output
global outdir  	  "output" 
global logdir     "log"
global tempdir    "tempdata"

********************************************************************************

/*  Pre-analysis data manipulation  */
do "01_cr_analysis_dataset.do"

/*  Checks  */
do "02_an_data_checks.do"


*********************************************************************
*IF PARALLEL WORKING - FOLLOWING CAN BE RUN IN ANY ORDER/IN PARALLEL*
*       PROVIDING THE ABOVE CR_ FILE HAS BEEN RUN FIRST				*
*********************************************************************
do "03_an_descriptive_tables.do"

foreach outcome of any covid_tpp_prob covid_death_itu covid_tpp_prob_or_susp {
	do "04_an_descriptive_table_1.do" `outcome'
	}
	
do "05_an_descriptive_plots.do"


*Univariate models can be run in parallel Stata instances for speed
*Command is "do an_univariable_cox_models <OUTCOME> <VARIABLE(s) TO RUN>
*The following breaks down into 4 batches, 
*  which can be done in separate Stata instances
*Can be broken down further but recommend keeping in alphabetical order
*   because of the ways the resulting log files are named

*UNIVARIATE MODELS (these fit the models needed for age/sex adj col of Table 2)

foreach outcome of any covid_tpp_prob covid_death_itu covid_tpp_prob_or_susp {

	do "06_univariate_analysis.do" `outcome' ///
		kids_cat3  ///
		gp_number_kids

************************************************************
	*MULTIVARIATE MODELS (this fits the models needed for fully adj col of Table 2)
	do "07a_an_multivariable_cox_models_demogADJ.do" `outcome'
	do "07b_an_multivariable_cox_models_FULL.do" `outcome'

}	
	
	
************************************************************
*PARALLEL WORKING - THESE MUST BE RUN AFTER THE 
*MAIN AN_UNIVARIATE.. AND AN_MULTIVARIATE... 
*and AN_SENS... DO FILES HAVE FINISHED
*(THESE ARE VERY QUICK)*
************************************************************
foreach outcome of any covid_tpp_prob covid_tpp_prob_or_susp covid_death_itu  {
	do "08_an_tablecontent_HRtable_HRforest.do" `outcome'
	do "09_an_agesplinevisualisation.do" `outcome'
}	
	
*INTERACTIONS
*Create models
foreach outcome of any covid_tpp_prob covid_death_itu covid_tpp_prob_or_susp {
do "10_an_interaction_cox_models" `outcome'	
}

*Tabulate results
foreach outcome of any covid_tpp_prob covid_death_itu covid_tpp_prob_or_susp {
	do "11_an_interaction_HR_tables_forest.do" 	 `outcome'
}
