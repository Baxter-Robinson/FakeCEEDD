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
if `"`c(os)'"' == "MacOSX"   global   stem    `"/Users/Baxter/Dropbox/"'
if `"`c(os)'"' == "Windows"   global   stem  `"D:/Dropbox/"'
cd "${stem}Files/Economics-Research/Project-04_CDRE/Data_FakeCEEDD/"

* Ali PATH
*global   stem  `"D:/Dropbox/"'


*----------------
* Clean Data
*----------------

import delimited using Data_Raw/FakeCEEDD_test.dat, clear