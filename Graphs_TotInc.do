preserve


collapse (mean) PropEntr=entrep_status , by(dec_tot_inc)


twoway (scatter PropEntr dec_tot_inc, connect(l)) , xtitle("Deciles of Total Income")  ytitle("Proportion of Entrepreneurs") legend(off)  graphregion(color(white))
graph export Output/Graphs/Graph_TotIncDec_PropEntr.pdf,replace


restore