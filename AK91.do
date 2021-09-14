
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

*** Regression ***********************


capture program drop reg_Table

program define reg_Table
    args table 
	local years "YR20 YR21 YR22 YR23 YR24 YR25 YR26 YR27 YR28"
	local time "QTR120-QTR129 QTR220-QTR229 QTR320-QTR329 YR20-YR28"
	local controls "RACE MARRIED SMSA NEWENG MIDATL ENOCENT WNOCENT SOATL ESOCENT WSOCENT MT"

	** Col 1 3 5 7 ***
	reg  LWKLYWGE EDUC  `years' 
	est store m1
	reg  LWKLYWGE EDUC `years' AGEQ AGEQSQ 
	est store m3
	reg  LWKLYWGE EDUC  `controls' `years' 
	est store m5
	reg  LWKLYWGE EDUC  `controls' `years'  AGEQ AGEQSQ 
	est store m7
	** Col 2 4 6 8 ***

	ivregress 2sls LWKLYWGE `years' (EDUC = `time')
	est store m2
	ivregress 2sls LWKLYWGE `years'  AGEQ AGEQSQ (EDUC = `time')
	est store m4
	ivregress 2sls LWKLYWGE `years' `controls'  (EDUC = `time')
	est store m6
	ivregress 2sls LWKLYWGE `years' `controls' (EDUC = `time')
	est store m8

	estout m1 m2 m3 m4 m5 m6 m7 m8 using Task2c_3`table'.txt, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant) title (Regression Results) replace
end

preserve
keep if COHORT<20.30
reg_Table TableIV
restore

preserve
keep if COHORT>30.00 & COHORT <30.40
reg_Table TableV
restore

preserve
keep if COHORT>40.00
reg_Table TableVI
restore

*** Regression ***********************

capture program drop reg_Ak

program define reg_Ak
	local controls "RACE MARRIED SMSA NEWENG MIDATL ENOCENT WNOCENT SOATL ESOCENT WSOCENT MT"
	args table 
	reg  LWKLYWGE EDUC  YR20-YR28 
	outreg2 EDUC using Task2c_4`table',excel addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, No) se alpha(0.01,0.05,0.1) dec(4) nocons keep (EDUC RACE SMSA MARRIED) ctitle(OLS) replace
	reg  LWKLYWGE EDUC  YR20-YR28 AGEQ AGEQSQ 
	outreg2 EDUC using  Task2c_4`table',excel addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, No) se alpha(0.01,0.05,0.1) dec(4) nocons keep (EDUC RACE SMSA MARRIED) append ctitle(OLS)
	reg  LWKLYWGE EDUC  `controls' YR20-YR28  
	outreg2 EDUC using  Task2c_4`table',excel addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, No) se alpha(0.01,0.05,0.1) dec(4) nocons keep (EDUC RACE SMSA MARRIED) append ctitle(OLS)
	reg  LWKLYWGE EDUC  `controls' YR20-YR28 AGEQ AGEQSQ 
	outreg2 EDUC using  Task2c_4`table',excel addtext(9 Year-of-birth dummies, Yes, 8 Region of residence dummies, No) se alpha(0.01,0.05,0.1) dec(4) nocons keep (EDUC RACE SMSA MARRIED) append ctitle(OLS)
end

 
preserve
keep if COHORT<20.30
reg_Ak TableIV
restore

preserve
keep if COHORT>30.00 & COHORT <30.40
reg_Ak TableV
restore

preserve
keep if COHORT>40.00
reg_Ak TableVI
restore
