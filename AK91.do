
global rootdir "C:\Users\jili4163\Desktop\Second_Year\AE\AS2\AK91\"
cd $rootdir



*********************************************************************************
set mem 500m
use "Build\Input\NEW7080.dta",clear
ds
rename v1 AGE
rename v2 AGEQ
rename v4 EDUC
rename v5 ENOCENT
rename v6 ESOCENT
rename v9 LWKLYWGE
rename v10 MARRIED
rename v11 MIDATL
rename v12 MT
rename v13 NEWENG
rename v16 CENSUS
rename v18 QOB
rename v19 RACE
rename v20 SMSA
rename v21 SOATL
rename v24 WNOCENT
rename v25 WSOCENT
rename v27 YOB
drop v8

gen COHORT=20.29
replace COHORT=30.39 if YOB<=39 & YOB >=30
replace COHORT=40.49 if YOB<=49 & YOB >=40
replace AGEQ=AGEQ-1900 if CENSUS==80
gen AGEQSQ= AGEQ*AGEQ


** Generate YOB dummies **********
local years "YR20 YR21 YR22 YR23 YR24 YR25 YR26 YR27 YR28 YR29"
local i = 0

foreach y of local years {
    di "`y'"
	gen `y' = 0
	replace `y' = 1 if YOB ==1920 + `i'
	replace `y' = 1 if YOB ==30 + `i'
	replace `y' = 1 if YOB ==40 + `i'
	local i = `i'+ 1
}
** Generate QOB dummies ***********
local QTR "QTR1 QTR2 QTR3 QTR4 "
local i = 0

foreach y of local QTR {
    di "`y'"
	gen `y' = 0
	replace `y' = 1 if QOB ==1 + `i'
	local i = `i'+ 1
}

** Generate YOB*QOB dummies ********

local years "YR20 YR21 YR22 YR23 YR24 YR25 YR26 YR27 YR28 YR29"
local QTR "QTR1 QTR2 QTR3"
foreach var of local QTR {
	foreach y of local years {
		local dis = substr("`y'",3,2)
		gen `var'`dis' = `var'*`y'
}
}
