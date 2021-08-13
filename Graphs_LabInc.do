
*Proportion of entreprenuers (Labour income)
clear all 

* Ali PATH
global   stem  `"C:\Users\Admin\Dropbox\Shared-Folder_Baxter-Ali"'
cd "${stem}\FakeCEEDD" 

use  Data_Cleaned/Cleaned.dta

preserve

collapse (mean) PropEntr=entrep_status , by(dec_lab_inc)

twoway (scatter PropEntr dec_lab_inc, connect(l)) , xtitle("Deciles of Labour Income")  ytitle("Proportion of Entrepreneurs") legend(off)  graphregion(color(white))
graph export Output/Graphs/Graph_LabIncDec_PropEntr.pdf,replace

restore

preserve

*Probability of transitioning into Entrepreneurship (Labour income)

collapse (mean) NewBusiness , by(dec_lab_inc)

twoway (scatter NewBusiness dec_lab_inc, connect(l)) , xtitle("Deciles of Labour Income")  ytitle("Probability of Transition into Entrepreneurship") legend(off)  graphregion(color(white))

graph export Output/Graphs/Graph_LabIncDec_TransProbEntr.pdf,replace

restore

preserve
*Average employment (Labour income)

collapse (mean) employment if entrep_status==1 , by(dec_lab_inc)

twoway (scatter employment dec_lab_inc, connect(l)) , xtitle("Deciles of Labour Income")  ytitle("Average employment") legend(off)  graphregion(color(white))

graph export Output/Graphs/Graph_LabIncDec_AvgEmp.pdf,replace

restore

preserve

*Survival rate-5years (Labour income)

collapse (mean) SurvivedFrim , by(dec_lab_inc)

twoway (scatter SurvivedFrim dec_lab_inc, connect(l)) , xtitle("Deciles of Labour Income")  ytitle("Average Survival rate") legend(off)  graphregion(color(white))

graph export Output/Graphs/Graph_LabIncDec_AvgSurvRate.pdf,replace
