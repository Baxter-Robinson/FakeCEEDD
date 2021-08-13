
*Proportion of entreprenuers (Capital income)
clear all 

* Ali PATH
global   stem  `"C:\Users\Admin\Dropbox\Shared-Folder_Baxter-Ali"'
cd "${stem}\FakeCEEDD" 

use  Data_Cleaned/Cleaned.dta

preserve

collapse (mean) PropEntr=entrep_status , by(dec_cap_inc)

twoway (scatter PropEntr dec_cap_inc, connect(l)) , xtitle("Deciles of Capital Income")  ytitle("Proportion of Entrepreneurs") legend(off)  graphregion(color(white))
graph export Output/Graphs/Graph_CapIncDec_PropEntr.pdf,replace

restore

preserve

*Probability of transitioning into Entrepreneurship (Capital income)

collapse (mean) NewBusiness , by(dec_cap_inc)

twoway (scatter NewBusiness dec_cap_inc, connect(l)) , xtitle("Deciles of Capital Income")  ytitle("Probability of Transition into Entrepreneurship") legend(off)  graphregion(color(white))

graph export Output/Graphs/Graph_CapIncDec_TransProbEntr.pdf,replace

restore

preserve
*Average employment (Capital income)

collapse (mean) employment if entrep_status==1 , by(dec_cap_inc)

twoway (scatter employment dec_cap_inc, connect(l)) , xtitle("Deciles of Capital Income")  ytitle("Average employment") legend(off)  graphregion(color(white))

graph export Output/Graphs/Graph_CapIncDec_AvgEmp.pdf,replace

restore

preserve

*Survival rate-5years (Capital income)

collapse (mean) SurvivedFrim , by(dec_cap_inc)

twoway (scatter SurvivedFrim dec_cap_inc, connect(l)) , xtitle("Deciles of Capital Income")  ytitle("Average Survival rate") legend(off)  graphregion(color(white))

graph export Output/Graphs/Graph_CapIncDec_AvgSurvRate.pdf,replace



