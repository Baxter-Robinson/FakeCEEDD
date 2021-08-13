*-----------------------------------------------------------------------------
* Clean Fake Dataset to Emulate CEED
*-----------------------------------------------------------------------------

*----------------
* Initial Set Up
*----------------
cls
clear all
version 15
set maxvar 10000
set type double
set more off

* nObservations
global nObs=5000


* Baxter PATH
*if `"`c(os)'"' == "MacOSX"   global   stem    `"/Users/Baxter/Dropbox/"'
*if `"`c(os)'"' == "Windows"   global   stem  `"D:/Dropbox/"'
*cd "${stem}Files/Economics-Research/Project-04_CDRE/Data_FakeCEEDD/"

* Ali PATH
global   stem  `"C:\Users\Admin\Dropbox\Shared-Folder_Baxter-Ali"'
cd "${stem}\FakeCEEDD" 

*----------------
* Clean Data
*----------------

* reads the dat dataset and splits the data into different variables 
import delimited using Data_Raw/FakeCEEDD.dat, clear

split v1 , destring 

drop v1

* renames the newly created variables with appropriate names 

rename v11 year 

rename v12 individual_ID 

rename v13 financial_Assets 

rename v14 capital_invested 

rename v15 firm_Age 

rename v16 entrep_status 

rename v17 tot_Revenue 

rename v18 profits 

rename v19 employment 

rename v110 labour_Income 

gen tot_inc = profits + labour_Income

gen capital_income = profits + 0.04 * financial_Assets

* finds the moving averages of different measures of income based on the prior three years incomes
sort individual_ID year
bysort individual_ID: gen avg_tot_inc_3=(tot_inc[_n-1] + tot_inc[_n-2] + tot_inc[_n-3])/3
bysort individual_ID: gen avg_cap_inc_3= (capital_income[_n-1] + capital_income[_n-2] + capital_income[_n-3]) /3 
bysort individual_ID: gen avg_lab_inc_3=(labour_Income[_n-1] + labour_Income[_n-2] + labour_Income[_n-3])/3

* computes the decile index of each observation (which decile each observation belongs to )

xtile dec_tot_inc = avg_tot_inc_3, nq(10)
xtile dec_cap_inc = avg_cap_inc_3, nq(10)
xtile dec_lab_inc = avg_lab_inc_3, nq(10)

* variable definitions for capital income, labour income and total income files

gen NewBusiness=0
replace NewBusiness=1 if firm_Age==1 & entrep_status==1

* surviving firms (5years) variables 

sort individual_ID year
gen SurvivedFrim=0 if firm_Age[_n]==1 
bysort individual_ID: replace SurvivedFrim=1 if firm_Age[_n]==1 & firm_Age[_n+5]==6


xtile pct_lab_inc = labour_Income, nq(100)

sort individual_ID year

bysort individual_ID: gen avg_lab_inc_pre_pct = (pct_lab_inc[_n-1] + pct_lab_inc[_n-2] + pct_lab_inc[_n-3])/3 if firm_Age==1
bysort individual_ID: gen avg_ent_inc_post_pct = (profits[_n+1] + profits[_n+2] + profits[_n+3])/3 if firm_Age==1

xtile pct_entrep_inc = avg_ent_inc_post_pct if entrep_status == 1 , nq(100) 

* time entry exit variables 

gen pre_1 = 1 if firm_Age[_n+1]==1
gen pre_2 = 1 if firm_Age[_n+2]==1
gen pre_3 = 1 if firm_Age[_n+3]==1
gen post_1 = 1 if firm_Age[_n-1] - firm_Age[_n-2] < 0 
gen post_2 = 1 if firm_Age[_n-2] - firm_Age[_n-3] < 0 
gen post_3 = 1 if firm_Age[_n-3] - firm_Age[_n-4] < 0 

* labour income around entry and exit

egen avg_lab_inc_pre_1 = mean(labour_Income) if pre_1==1 , by(pre_1)
egen avg_lab_inc_pre_2 = mean(labour_Income) if pre_2==1 , by(pre_2)
egen avg_lab_inc_pre_3 = mean(labour_Income) if pre_3==1 , by(pre_3)
egen avg_lab_inc_post_1 = mean(labour_Income) if post_1==1 , by(post_1)
egen avg_lab_inc_post_2 = mean(labour_Income) if post_2==1 , by(post_2)
egen avg_lab_inc_post_3 = mean(labour_Income) if post_3==1 , by(post_3)

* capital income outside of business around entry and exit

egen avg_capout_inc_pre_1 = mean(0.04*financial_Assets) if pre_1==1 , by(pre_1)
egen avg_capout_inc_pre_2 = mean(0.04*financial_Assets) if pre_2==1 , by(pre_2)
egen avg_capout_inc_pre_3 = mean(0.04*financial_Assets) if pre_3==1 , by(pre_3)
egen avg_capout_inc_post_1 = mean(0.04*financial_Assets) if post_1==1 , by(post_1)
egen avg_capout_inc_post_2 = mean(0.04*financial_Assets) if post_2==1 , by(post_2)
egen avg_capout_inc_post_3 = mean(0.04*financial_Assets) if post_3==1 , by(post_3)

* total income around entry and exit

egen avg_tot_inc_pre_1 = mean(tot_inc) if pre_1==1 , by(pre_1)
egen avg_tot_inc_pre_2 = mean(tot_inc) if pre_2==1 , by(pre_2)
egen avg_tot_inc_pre_3 = mean(tot_inc) if pre_3==1 , by(pre_3)
egen avg_tot_inc_post_1 = mean(tot_inc) if post_1==1 , by(post_1)
egen avg_tot_inc_post_2 = mean(tot_inc) if post_2==1 , by(post_2)
egen avg_tot_inc_post_3 = mean(tot_inc) if post_3==1 , by(post_3)

sort individual_ID year

gen ent_surv=0


replace ent_surv = 1 if firm_Age[_n]==1 & firm_Age[_n+5]==6 & individual_ID[_n +5]== individual_ID[_n] 


gen time_surv_ent=0

replace time_surv_ent=-3 if ent_surv[_n+3]==1 & individual_ID[_n +3]== individual_ID[_n]
replace time_surv_ent=-2 if time_surv_ent[_n-1] ==-3 & individual_ID[_n-1]== individual_ID[_n]
replace time_surv_ent=-1 if time_surv_ent[_n-2] ==-3 & individual_ID[_n-2]== individual_ID[_n]
		
gen ext_surv=0
		
		
forvalues i = 6/14 {

    replace ext_surv=1 if firm_Age[_n-`i']==1 & firm_Age[_n-`i'+5]==6 & individual_ID[_n-`i' +5]== individual_ID[_n-`i'] & time_surv[_n-`i'-1] ==-1 & firm_Age[_n+1]- firm_Age[_n] <=-1
	
}

gen time_surv_ext=0
replace time_surv_ext=3 if ext_surv[_n-3]==1 & individual_ID[_n-3]== individual_ID[_n]
replace time_surv_ext=2 if time_surv_ext[_n+1] ==3 & individual_ID[_n+1]== individual_ID[_n]
replace time_surv_ext=1 if time_surv_ext[_n+2] ==3 & individual_ID[_n+2]== individual_ID[_n]


* labour income around entry and exit

egen avg_lab_inc_pre_EntExt_1 = mean(labour_Income) if time_surv_ent==-1 , by(time_surv_ent)
egen avg_lab_inc_pre_EntExt_2 = mean(labour_Income) if time_surv_ent==-2 , by(time_surv_ent)
egen avg_lab_inc_pre_EntExt_3 = mean(labour_Income) if time_surv_ent==-3 , by(time_surv_ent)
egen avg_lab_inc_post_EntExt_1 = mean(labour_Income) if time_surv_ext==1 , by(time_surv_ext)
egen avg_lab_inc_post_EntExt_2 = mean(labour_Income) if time_surv_ext==2 , by(time_surv_ext)
egen avg_lab_inc_post_EntExt_3 = mean(labour_Income) if time_surv_ext==3 , by(time_surv_ext)


* capital income outside of business around entry and exit

egen avg_capout_inc_pre_EntExt_1 = mean(0.04*financial_Assets) if time_surv_ent==-1 , by(time_surv_ent)
egen avg_capout_inc_pre_EntExt_2 = mean(0.04*financial_Assets) if time_surv_ent==-2 , by(time_surv_ent)
egen avg_capout_inc_pre_EntExt_3 = mean(0.04*financial_Assets) if time_surv_ent==-3 , by(time_surv_ent)
egen avg_capout_inc_post_EntExt_1 = mean(0.04*financial_Assets) if time_surv_ext==1 , by(time_surv_ext)
egen avg_capout_inc_post_EntExt_2 = mean(0.04*financial_Assets) if time_surv_ext==2 , by(time_surv_ext)
egen avg_capout_inc_post_EntExt_3 = mean(0.04*financial_Assets) if time_surv_ext==3 , by(time_surv_ext)


* total income around entry and exit

egen avg_tot_inc_pre_EntExt_1 = mean(tot_inc) if time_surv_ent==-1 , by(time_surv_ent)
egen avg_tot_inc_pre_EntExt_2 = mean(tot_inc) if time_surv_ent==-2 , by(time_surv_ent)
egen avg_tot_inc_pre_EntExt_3 = mean(tot_inc) if time_surv_ent==-3 , by(time_surv_ent)
egen avg_tot_inc_post_EntExt_1 = mean(tot_inc) if time_surv_ext==1 , by(time_surv_ext)
egen avg_tot_inc_post_EntExt_2 = mean(tot_inc) if time_surv_ext==2 , by(time_surv_ext)
egen avg_tot_inc_post_EntExt_3 = mean(tot_inc) if time_surv_ext==3 , by(time_surv_ext)

* finds the desired time window around the formation of the business
sort individual_ID year
by individual_ID: gen obs_year=_n
by individual_ID: gen target=obs_year if firm_Age==1
gen dif=obs_year-target

forvalues i=1/3{

gen pre_form_`i'=1 if dif[_n+`i']==0 & individual_ID[_n+`i'] == individual_ID[_n]
gen post_form_`i'=1 if dif[_n-`i']==0 & individual_ID[_n-`i'] == individual_ID[_n]

}

gen time_form = .

*pinpooints the entry years that have a balanced three year before and after panels

gen new_balanced_entry = 1 if pre_form_1[_n-1] + pre_form_2[_n-2] + pre_form_3[_n-3] + post_form_1[_n+1] + post_form_2[_n+2] + post_form_3[_n+3]==6

* finds the income measures around the "balanced" years of entry

gen lab_inc_pre_1 = labour_Income if new_balanced_entry[_n+1]==1
gen lab_inc_pre_2 = labour_Income if new_balanced_entry[_n+2]==1
gen lab_inc_pre_3 = labour_Income if new_balanced_entry[_n+3]==1
gen lab_inc_post_1 = labour_Income if new_balanced_entry[_n-1]==1
gen lab_inc_post_2 = labour_Income if new_balanced_entry[_n-2]==1
gen lab_inc_post_3 = labour_Income if new_balanced_entry[_n-3]==1

gen cap_inc_pre_1 = capital_income if new_balanced_entry[_n+1]==1
gen cap_inc_pre_2 = capital_income if new_balanced_entry[_n+2]==1
gen cap_inc_pre_3 = capital_income if new_balanced_entry[_n+3]==1
gen cap_inc_post_1 = capital_income if new_balanced_entry[_n-1]==1
gen cap_inc_post_2 = capital_income if new_balanced_entry[_n-2]==1
gen cap_inc_post_3 = capital_income if new_balanced_entry[_n-3]==1

gen tot_inc_pre_1 = tot_inc if new_balanced_entry[_n+1]==1
gen tot_inc_pre_2 = tot_inc if new_balanced_entry[_n+2]==1
gen tot_inc_pre_3 = tot_inc if new_balanced_entry[_n+3]==1
gen tot_inc_post_1 = tot_inc if new_balanced_entry[_n-1]==1
gen tot_inc_post_2 = tot_inc if new_balanced_entry[_n-2]==1
gen tot_inc_post_3 = tot_inc if new_balanced_entry[_n-3]==1

* saves the cleaned dataset 

save Data_Cleaned/Cleaned.dta, replace

* creates the detailed summary statistics tables 

estpost summ entrep_status profits labour_Income firm_Age
esttab  using Output/Tables/Entstat_Profit_Labinc_FirmAge_Summ.tex, cells("mean(fmt(2)) sd(fmt(2)) min max") nomtitle nonumber label    ///
title(Summary Statistics)  replace

* calls the do files producing the first set of graphs ( proportion of entreprenuers, probability of transition into entreprenuership, average employment and 5 year survival rates)

do Graphs_TotInc
do Graphs_CapInc
do Graphs_LabInc

* produces the event study graphs

do Graphs_TimeFormation

* produces the labour income vs. conditional post-entreprenuerial income graphs

do Graphs_LabInc_PreEntrep

* tabulates what entreprenuers do after exiting
clear all
use Data_Cleaned/Cleaned.dta
sort individual_ID year
by individual_ID: gen exit_yr = 0 if firm_Age[_n] - firm_Age[_n-1] < 0 

estpost tabulate entrep_status if exit_yr == 0
esttab using Output/Tables/What_do_after_exit.tex, cells("b(label(freq)) pct(fmt(2)) cumpct(fmt(2))") nonumber nomtitle noobs title(What entreprenuers do after exit)  replace   

* produces income around entry and exit periods' graphs

do Graphs_TimeEntExt

* produces Lalonde et al. style regression graphs
do Graphs_TotIncReg

