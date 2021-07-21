clear all
use Data_Cleaned/Cleaned.dta

* finds the desired time window around the formation of the business
sort individual_ID year
by individual_ID: gen obs_year=_n
by individual_ID: gen target=obs_year if firm_Age==1
egen td=min(target), by(individual_ID)
gen dif=obs_year-td
drop target

by individual_ID: gen event_window=1 if dif>=-3 & dif<=3
replace event_window=0 if event_window==.
preserve

* graphs the average labour income for each year in the event study period 
collapse (mean) event_LabInc = labour_Income if event_window==1 , by (dif)

twoway (scatter event_LabInc dif, connect(l)) , xtitle("Time around the foundation of business")  ytitle("Labour income") legend(off)  graphregion(color(white))

graph export Output/Graphs/Graph_TimeFormation_LabInc.pdf,replace

restore

preserve

* graphs the average capital income for each year in the event study period 

collapse (mean) event_CapInc = capital_income if event_window==1 , by (dif)

twoway (scatter event_CapInc dif, connect(l)) , xtitle("Time around the foundation of business")  ytitle("Capital income") legend(off)  graphregion(color(white))

graph export Output/Graphs/Graph_TimeFormation_CabInc.pdf,replace

restore

preserve

* graphs the average total income for each year in the event study period 

collapse (mean) event_TotInc = tot_inc if event_window==1 , by (dif)

twoway (scatter event_TotInc dif, connect(l)) , xtitle("Time around the foundation of business")  ytitle("Total income") legend(off)  graphregion(color(white))

graph export Output/Graphs/Graph_TimeFormation_TotInc.pdf,replace

restore

* graphs the average labour income for each year in the event study period 
preserve
by individual_ID: gen surv_5=0 if  dif==5 & firm_Age>=5 
replace surv_5[-5] = 1 if surv_5==0

collapse (mean) event_LabInc_5yearSurv = labour_Income if event_window==1 , by (dif)

twoway (scatter event_LabInc_5yearSurv dif, connect(l)) , xtitle("Time around the foundation of business")  ytitle("Labour income") legend(off)  graphregion(color(white))

graph export Output/Graphs/Graph_TimeFormation5YSurv_LabInc.pdf,replace

restore
