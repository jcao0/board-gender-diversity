****************************************************
*Staggered Synthetic Control*
*Import and prepare board gender data*
*Data: EIGE board female ratio*
*Last updated 03/08/2020*
****************************************************

/*
Source: EIGE https://eige.europa.eu/gender-statistics/dgs/indicator/wmidm_bus_bus__wmid_comp_compbm/datatable
Purpose: clean data and format for matlab
*/

set more off
clear
global db "/0-data clean"

**step 1
clear
import excel "$db/1-EIGE board gender data/wmidm_bus_bus__wmid_comp_compbm.xlsx", sheet("stata") firstrow
rename GeographicregionTime country
*keep only B2, which is year end
keep country *B2

**step 2
*reshape
reshape long Y, i(country) j(temp) string
rename Y fratio
gen year=substr(temp,1,4)
destring year, replace
drop temp

**step 3
*bring in policy
merge m:1 country using "$db/1-EIGE board gender data/policy.dta"
keep if _merge==3
drop _merge

**step 4
*check which countries to drop due to missing data
tab country if missing(fratio)
tab year
/*
       year |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |         30        5.88        5.88
       2004 |         30        5.88       11.76
       2005 |         30        5.88       17.65
       2006 |         30        5.88       23.53
       2007 |         30        5.88       29.41
       2008 |         30        5.88       35.29
       2009 |         30        5.88       41.18
       2010 |         30        5.88       47.06
       2011 |         30        5.88       52.94
       2012 |         30        5.88       58.82
       2013 |         30        5.88       64.71
       2014 |         30        5.88       70.59
       2015 |         30        5.88       76.47
       2016 |         30        5.88       82.35
       2017 |         30        5.88       88.24
       2018 |         30        5.88       94.12
       2019 |         30        5.88      100.00
------------+-----------------------------------
      Total |        510      100.00
*/
*after browsing, no missing data: 0 is truly 0%

**step 5
*clean up
*all drop 4 too early adopt
drop if inlist(country,"Norway","Spain","Finland","Iceland")
// spill over effect?

**step 6
*create treatment variables
gen t=year-Year
gen t_quota=year-Year if Policy=="Quota"
gen t_disclosure=year-Year if Policy=="Disclosure"

gen treat=year>=Year 
gen treatq=treat if Policy=="Quota"
replace treatq=0 if missing(treatq)
gen treatd=treat if Policy=="Disclosure"
replace treatd=0 if missing(treatd)

egen id=group(country)
tempfile jasa_boardgendereige
save `jasa_boardgendereige'

**step 7
use `jasa_boardgendereige', clear
preserve
gen time=year
gen unit=country
sort id time
keep  id unit time treat treatq treatd fratio
order  id unit time treat treatq treatd fratio
export delimited using "$db/1-EIGE board gender data/data_boardgendereige.csv", replace
restore

save "$db/1-EIGE board gender data/jasa_boardgendereige.dta", replace
