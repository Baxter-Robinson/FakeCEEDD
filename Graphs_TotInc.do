
*Proportion of entreprenuers (total income)
clear all 

* Ali PATH
global   stem  `"C:\Users\Admin\Dropbox\Shared-Folder_Baxter-Ali"'
cd "${stem}\FakeCEEDD" 

use  Data_Cleaned/Cleaned.dta

preserve

collapse (mean) PropEntr=entrep_status , by(dec_tot_inc)

twoway (scatter PropEntr dec_tot_inc, connect(l)) , xtitle("Deciles of Total Income")  ytitle("Proportion of Entrepreneurs") legend(off)  graphregion(color(white))
graph export Output/Graphs/Graph_TotIncDec_PropEntr.pdf,replace

restore

preserve

*Probability of transitioning into Entrepreneurship (total income)
gen NewBusiness=0
replace NewBusiness=1 if firm_Age==1 & entrep_status==1

collapse (mean) NewBusiness , by(dec_tot_inc)

twoway (scatter NewBusiness dec_tot_inc, connect(l)) , xtitle("Deciles of Total Income")  ytitle("Probability of Transition into Entrepreneurship") legend(off)  graphregion(color(white))

graph export Output/Graphs/Graph_TotIncDec_TransProbEntr.pdf,replace

restore

preserve
*Average employment (total income)

collapse (mean) employment , by(dec_tot_inc)

twoway (scatter employment dec_tot_inc, connect(l)) , xtitle("Deciles of Total Income")  ytitle("Average employment") legend(off)  graphregion(color(white))

graph export Output/Graphs/Graph_TotIncDec_AvgEmp.pdf,replace

restore

preserve

*Survival rate-5years (total income)
sort individual_ID year

gen SurvivedFrim=0

bysort individual_ID: replace SurvivedFrim=1 if firm_Age[_n]==1 & firm_Age[_n+5]==6

collapse (mean) SurvivedFrim , by(dec_tot_inc)

twoway (scatter SurvivedFrim dec_tot_inc, connect(l)) , xtitle("Deciles of Total Income")  ytitle("Average Survival rate") legend(off)  graphregion(color(white))

graph export Output/Graphs/Graph_TotIncDec_AvgSurvRate.pdf,replace
