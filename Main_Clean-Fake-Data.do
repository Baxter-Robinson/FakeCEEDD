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

* saves the cleaned dataset 

save Data_Cleaned/Cleaned.dta, replace

* creates the detailed summary statistics tables 

summ entrep_status profits labour_Income firm_Age , detail

* finds the moving averages of different measures of income based on the prior three years incomes
sort individual_ID year
bysort individual_ID: gen avg_tot_inc_3=(tot_inc[_n-1] + tot_inc[_n-2] + tot_inc[_n-3])/3
bysort individual_ID: gen avg_cap_inc_3=(profits[_n-1] + profits[_n-2] + profits[_n-3])/3
bysort individual_ID: gen avg_lab_inc_3=(labour_Income[_n-1] + labour_Income[_n-2] + labour_Income[_n-3])/3

* computes the decile index of each observation (which decile each observation belongs to )

xtile dec_tot_inc = avg_tot_inc_3, nq(10)
xtile dec_cap_inc = avg_cap_inc_3, nq(10)
xtile dec_lab_inc = avg_lab_inc_3, nq(10)

* computes the fraction of entreprenuers in each decile of total income (proportion)

levelsof dec_tot_inc, local(levels) 

matrix A_prop = J(1,10,0)
matrix A_prob = J(1,10,0)

matrix A_x = J(1,10,0)

foreach x of local levels {

count if dec_tot_inc == `x' & entrep_status ==1

scalar entp_prop = r(N)

count if dec_tot_inc == `x' & entrep_status ==1 & firm_Age ==0 

scalar entp_prob = r(N)

count if dec_tot_inc == `x'

scalar tot_dec = r(N)

matrix A_prop[1,`x'] = entp_prop/tot_dec

matrix A_prob[1,`x'] = entp_prob/tot_dec


matrix A_x[1,`x'] = `x'

 }
 
matrix A1_prop =  A_prop'
matrix A1_prob =  A_prob'
matrix A1_x =  A_x'

svmat double A1_prop, name(entp_frac_tot)
svmat double A1_prob, name(entp_prob_tot)
svmat double A1_x, name(entp_frac_tot_x)

twoway scatter entp_frac_tot1 entp_frac_tot_x1 || line entp_frac_tot1 entp_frac_tot_x1 ,sort xtitle("total income deciles")  ytitle("entreprenuers proportion") title("Selection into entrepreneurship") legend(off)

graph export Output\Graphs\Graph_totalincomedeciles_entreprenuersproportion.pdf,replace

twoway scatter entp_prob_tot1 entp_frac_tot_x1 || line entp_prob_tot1 entp_frac_tot_x1 ,sort xtitle("total income deciles")  ytitle("entreprenuers probability") title("Selection into entrepreneurship") legend(off)

graph export Output\Graphs\Graph_totalincomedeciles_entreprenuersprobability.pdf,replace

* computes the fraction of entreprenuers in each decile of capital income (proportion)

levelsof dec_cap_inc, local(levels) 

matrix B = J(1,10,0)

foreach x of local levels {

count if dec_cap_inc == `x' & entrep_status == 1

scalar entp = r(N)

count if dec_cap_inc == `x'

scalar tot_dec = r(N)

matrix B[1,`x'] = entp/tot_dec

matrix A_x[1,`x'] = `x'

 }
 
matrix B1 =  B'
matrix A1_x =  A_x'

svmat double B1, name(entp_frac_cap)
svmat double A1_x, name(entp_frac_cap_x)


twoway scatter entp_frac_cap1 entp_frac_cap_x1 || line entp_frac_cap1 entp_frac_cap_x1 ,sort xtitle("capital income deciles")  ytitle("entreprenuers proportion") title("Selection into entrepreneurship") legend(off)

graph export Output\Graphs\Graph_capitalincomedeciles_entreprenuersproportion.pdf,replace


* computes the fraction of entreprenuers in each decile of labour income (proportion)

levelsof dec_lab_inc, local(levels) 

matrix C = J(1,10,0)

foreach x of local levels {

count if dec_lab_inc == `x' & entrep_status == 1

scalar entp = r(N)

count if dec_lab_inc == `x'

scalar tot_dec = r(N)

matrix C[1,`x'] = entp/tot_dec

matrix A_x[1,`x'] = `x'

 }
 
matrix C1 =  C'
matrix A1_x =  A_x'

svmat double C1, name(entp_frac_lab)
svmat double A1_x, name(entp_frac_lab_x)


twoway scatter entp_frac_lab1 entp_frac_lab_x1 || line entp_frac_lab1 entp_frac_lab_x1 ,sort xtitle("labour income deciles")  ytitle("entreprenuers proportion") title("Selection into entrepreneurship") legend(off)

graph export Output\Graphs\Graph_labourincomedeciles_entreprenuersproportion.pdf,replace










