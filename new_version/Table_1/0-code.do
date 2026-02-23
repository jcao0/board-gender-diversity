****************************************************
*Staggered Synthetic Control*
*Table 1 Summary Stats*
*Last updated 02/23/2026*
****************************************************
/*
Purpose: to create summary stats in table 1
*/
set matsize 11000
global db "/Table_1"

*board female ratio data
use "$db/jasa_boardgendereige.dta", clear
su fratio 
local t_mean : display %9.2f r(mean)
local t_sd : display %9.2f r(sd)
local t_N = r(N)
su fratio if treat == 0
local pre_mean : display %9.2f r(mean)
local pre_sd : display %9.2f r(sd)
local pre_N = r(N)
su fratio if treat == 1
local post_mean : display %9.2f r(mean)
local post_sd : display %9.2f r(sd)
local post_N = r(N)

file open table1 using "$db/table_1.tex",  write replace
file write table1 ///	
"\begin{table}[H]" _n ///
"\centering" _n ///
"\renewcommand{\arraystretch}{1.2}" _n ///
"\caption{\emph{Summary Statistics: Labor Outcomes in Europe}}\label{table1}" _n ///
"\begin{tabular}{l*{7}{c}} " _n ///
"\hline" _n ///
"\hline" _n ///
"&\multicolumn{3}{c}{All Period}&\multicolumn{2}{c}{Pre Treatment}&\multicolumn{2}{c}{Post Treatment}\\"_n ///
"\hline" _n ///
"&\multicolumn{1}{c}{N}&\multicolumn{1}{c}{mean}&\multicolumn{1}{c}{sd}&\multicolumn{1}{c}{mean}&\multicolumn{1}{c}{sd}&\multicolumn{1}{c}{mean}&\multicolumn{1}{c}{sd}\\" _n ///
"\hline" _n ///
"\multicolumn{8}{l}{\textbf{Board data}}\\" _n ///
"Board female ratio (in percentage) & `t_N' & `t_mean' & `t_sd' & `pre_mean' & `pre_sd' & `post_mean' & `post_sd'\\" _n
file close table1
macro drop table1

*full time employment data
file open table1 using "$db/table_1.tex",  write append
file write table1 ///	
"\hline" _n ///
"\multicolumn{8}{l}{\textbf{Labor outcome individual level data}}\\" _n
file close table1
macro drop table1
use "$db/year_raw_data.dta", clear
keep if sex == "1" | sex == "2"
keep coeff refyear refweek intweek country sex age national countryb stapro nowkreas signisal supvisor sizefirm countryw ystartwk mstartwk ftpt ftptreas temp hwusual hwactual hwoverp hwoverpu wishmore hwwish lookoj exist2j
drop if age == "0-14" | age =="07"  | age =="7"  | age =="75"  | age =="75+"
keep if !missing(stapro)
drop if stapro == "9"
gen geo = country
merge m:1 geo using "$db/policy.dta"
keep if _merge == 3
drop _merge
destring refyear, replace
gen post = (refyear >= Year)
destring coeff, replace
keep if ftpt == "1"
gen gender = (sex == "2")
su gender
local t_mean : display %9.2f r(mean)
local t_sd : display %9.2f r(sd)
local t_N = r(N)
su gender if post == 0
local pre_mean : display %9.2f r(mean)
local pre_sd : display %9.2f r(sd)
local pre_N = r(N)
su gender if post == 1
local post_mean : display %9.2f r(mean)
local post_sd : display %9.2f r(sd)
local post_N = r(N)

file open table1 using "$db/table_1.tex",  write append
file write table1 ///	
"Full employed female ratio & `t_N' & `t_mean' & `t_sd' & `pre_mean' & `pre_sd' & `post_mean' & `post_sd'\\" _n
file close table1
macro drop table1

keep if gender == 1
destring hwusual, replace
drop if hwusual == 0 | hwusual == 99
su hwusual
local t_mean : display %9.2f r(mean)
local t_sd : display %9.2f r(sd)
local t_N = r(N)
su hwusual if post == 0
local pre_mean : display %9.2f r(mean)
local pre_sd : display %9.2f r(sd)
local pre_N = r(N)
su hwusual if post == 1
local post_mean : display %9.2f r(mean)
local post_sd : display %9.2f r(sd)
local post_N = r(N)
file open table1 using "$db/table_1.tex",  write append
file write table1 ///	
"Female weekly working hour & `t_N' & `t_mean' & `t_sd' & `pre_mean' & `pre_sd' & `post_mean' & `post_sd'\\" _n
file close table1
macro drop table1

*full time employment data
file open table1 using "$db/table_1.tex",  write append
file write table1 ///	
"\hline" _n ///
"\multicolumn{8}{l}{\textbf{Labor outcome aggregated level data}}\\" _n
file close table1
macro drop table1

foreach var in valuefratioOC2 valueFOC2 valuefratioOC9 valueFOC9{
	if "`var'" == "valuefratioOC2"{
		local text = "Professional female ratio (percentage)"
	}
	if "`var'" == "valueFOC2"{
		local text = "Professional female (thousands)"
	}
	if "`var'" == "valuefratioOC9"{
		local text = "Non-professional female ratio (percentage)"
	}
	if "`var'" == "valueFOC9"{
		local text = "Non-professional female (thousands)"
	}
use "$db/jasa_ft.dta", clear
su `var' 
local t_mean : display %9.2f r(mean)
local t_sd : display %9.2f r(sd)
local t_N = r(N)
su `var' if treat == 0
local pre_mean : display %9.2f r(mean)
local pre_sd : display %9.2f r(sd)
local pre_N = r(N)
su `var' if treat == 1
local post_mean : display %9.2f r(mean)
local post_sd : display %9.2f r(sd)
local post_N = r(N)

file open table1 using "$db/table_1.tex",  write append
file write table1 ///	
"`text' & `t_N' & `t_mean' & `t_sd' & `pre_mean' & `pre_sd' & `post_mean' & `post_sd'\\" _n
file close table1
macro drop table1
}

*work hours data
foreach var in valueFOC2 valueFOC9{
	if "`var'" == "valueFOC2"{
		local text = "Professional female working hours"
	}
	if "`var'" == "valueFOC9"{
		local text = "Non-professional female working hours"
	}
use "$db/jasa_hr", clear
su `var' 
local t_mean : display %9.2f r(mean)
local t_sd : display %9.2f r(sd)
local t_N = r(N)
su `var' if treat == 0
local pre_mean : display %9.2f r(mean)
local pre_sd : display %9.2f r(sd)
local pre_N = r(N)
su `var' if treat == 1
local post_mean : display %9.2f r(mean)
local post_sd : display %9.2f r(sd)
local post_N = r(N)

file open table1 using "$db/table_1.tex",  write append
file write table1 ///	
"`text' & `t_N' & `t_mean' & `t_sd' & `pre_mean' & `pre_sd' & `post_mean' & `post_sd'\\" _n
file close table1
macro drop table1
}



*end of table	
file open table1 using "$db/table_1.tex",  write append
file write table1 ///
"\hline" _n ///
"\end{tabular}" _n ///
"\begin{tablenotes}\footnotesize" _n ///
"\item NOTE: This table lists the summary statistics for key variables. All female ratios are presented in percent. The board female ratio is the percent of female directors in large listed companies in each European country from 2003 to 2019. Employment and weekly work hours are quarterly country-level variables from 2003 to 2019. " _n ///
"\end{tablenotes}" _n ///
"\end{table}" _n
file close table1
macro drop table1

