*-----------------------------------------------------------------------------
* Create Graphs and Tables from the Fake Dataset to Emulate CEED
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
if `"`c(os)'"' == "Windows"   global   stem  `"D:/Dropbox/"'
cd "${stem}Files/Economics-Research/Project-04_CDRE/Data_FakeCEEDD/"



* Ali PATH
*global   stem  `"D:/Dropbox/"'


use "Data_Cleaned/Cleaned.dta"

*----------------
* Graphs and Tables
*----------------

do Graphs_TotInc.do
