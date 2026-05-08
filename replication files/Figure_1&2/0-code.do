// Macros ---------
global DATA   = "/Figure_1&2"
// ------------------

use "$DATA/year_raw_data.dta", clear

keep if sex == "1" | sex == "2"

keep coeff refyear refweek intweek country sex age national countryb stapro nowkreas signisal supvisor sizefirm countryw ystartwk mstartwk ftpt ftptreas temp hwusual hwactual hwoverp hwoverpu wishmore hwwish lookoj exist2j

tab age
/*
        AGE |      Freq.     Percent        Cum.
------------+-----------------------------------
       0-14 |     17,907        0.11        0.11
         07 |      8,246        0.05        0.17
      15-24 |     14,689        0.09        0.26
         20 |  1,730,174       11.10       11.36
      25-39 |     23,759        0.15       11.51
         32 |  2,797,015       17.94       29.45
      40-54 |     25,262        0.16       29.61
         47 |  3,375,236       21.65       51.26
      55-74 |     40,493        0.26       51.52
         65 |  3,753,144       24.07       75.58
          7 |  2,258,081       14.48       90.07
         75 |  1,533,366        9.83       99.90
        75+ |     15,586        0.10      100.00
------------+-----------------------------------
      Total | 15,592,958      100.00
*/
drop if age == "0-14" | age =="07"  | age =="7"  | age =="75"  | age =="75+"
//11,761,739
tab stapro
/*
     STAPRO |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |  2,112,938        9.28        9.28
          5 | 10,079,290       44.28       53.56
          9 | 10,572,641       46.44      100.00
------------+-----------------------------------
      Total | 22,764,869      100.00
*/
keep if !missing(stapro)

drop if stapro == "9"

gen geo = country

merge m:1 geo using "$DATA/policy.dta"
/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                       612,650
        from master                   612,641  (_merge==1)
        from using                          9  (_merge==2)

    Matched                        11,579,587  (_merge==3)
    -----------------------------------------
*/
keep if _merge == 3
drop _merge
tab geo
replace Policy = "Control" if Year > 2013
gen control = (Year > 2013 | missing(Year))
gen teatment = 1 - control
destring refyear, replace
gen event = refyear - Year if Year <= 2013
replace event = -1 if missing(event)
tab event
//-9 to 6
replace event = event + 10
tab event
//1 to 16 (-1 is 9)
replace event = 0 if missing(event)
gen event_x_teat = event * teatment
tab event_x_teat
gen post = (refyear > Year)

destring coeff, replace

gen gender = (sex == "2")

preserve
keep if ftpt == "1"
reghdfe gender 1.teatment#1.post [aw = coeff], absorb(geo refyear) vce(cluster geo)
restore
preserve
keep if ftpt == "1"
reghdfe gender ib9.event_x_teat [aw = coeff], absorb(geo refyear) vce(cluster geo)
matrix b = e(b)
matrix v = e(V)
gen variable = .    
gen coefficient = .    
gen se = .
forval i = 1/17{
	replace variable = `i'-1 if _n == `i'
	replace coefficient = b[1, `i'] if _n == `i'
	replace se = sqrt(v[`i', `i']) if _n == `i'
}
keep variable coefficient se
keep if _n <= 17 
drop if variable == 0
replace variable = variable - 10
gen ub = coefficient + 1.96 * se
gen lb = coefficient - 1.96 * se

twoway (scatter coefficient variable, mcolor(navy) msize(small)) ///
	   (line coefficient variable, lcolor(navy) lwidth(thin)) ///
       (rcap ub lb variable, lcolor(navy) lwidth(small)), ///
       graphregion(color(white)) xsize(8) ysize(6) plotregion(lcolor(black) lwidth(thin)) ///
       ytitle(Effect on Full Employed Female Share) xtitle(Event Time(Year)) ///
       ylabel(, nogrid labsize(small)) xlabel(-9(1)6, labsize(small)) ///
	   legend(off) ///
	   xline(-1, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
	   yline(0, lcolor(gs12) lpattern(dash) lwidth(thin))
	   
	   graph export "$DATA/figure_1a.pdf", as(pdf) replace
restore

preserve
keep if ftpt == "1"
keep if gender == 1
destring hwusual, replace
drop if hwusual == 0 | hwusual == 99
reghdfe hwusual ib9.event_x_teat [aw = coeff], absorb(geo refyear) vce(cluster geo)
matrix b = e(b)
matrix v = e(V)
gen variable = .    
gen coefficient = .    
gen se = .
forval i = 1/17{
	replace variable = `i'-1 if _n == `i'
	replace coefficient = b[1, `i'] if _n == `i'
	replace se = sqrt(v[`i', `i']) if _n == `i'
}
keep variable coefficient se
keep if _n <= 17 
drop if variable == 0
replace variable = variable - 10
gen ub = coefficient + 1.96 * se
gen lb = coefficient - 1.96 * se

twoway (scatter coefficient variable, mcolor(navy) msize(small)) ///
	   (line coefficient variable, lcolor(navy) lwidth(thin)) ///
       (rcap ub lb variable, lcolor(navy) lwidth(thin)), ///
       graphregion(color(white)) xsize(8) ysize(6) plotregion(lcolor(black) lwidth(thin)) ///
       ytitle(Effect on Female Working Hours) xtitle(Event Time(Year)) ///
       ylabel(, nogrid labsize(small)) xlabel(-9(1)6, labsize(small)) ///
	   legend(off) ///
	   xline(-1, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
	   yline(0, lcolor(gs12) lpattern(dash) lwidth(thin))
	   
	   graph export "$DATA/figure_2a.pdf", as(pdf) replace
restore

preserve
keep if ftpt == "1"
drop if Policy == "Disclosure"
reghdfe gender ib9.event_x_teat [aw = coeff], absorb(geo refyear) vce(cluster geo)
matrix b = e(b)
matrix v = e(V)
gen variable = .    
gen q_coefficient = .    
gen q_se = .
forval i = 1/15{
	replace variable = `i'+1 if _n == `i'
	replace q_coefficient = b[1, `i'] if _n == `i'
	replace q_se = sqrt(v[`i', `i']) if _n == `i'
}
keep variable q_coefficient q_se
keep if _n <= 15
drop if variable == 2
replace variable = variable - 10
gen q_ub = q_coefficient + 1.96 * q_se
gen q_lb = q_coefficient - 1.96 * q_se
tempfile qresults
save `qresults'
restore

preserve
keep if ftpt == "1"
drop if Policy == "Quota"
reghdfe gender ib9.event_x_teat [aw = coeff], absorb(geo refyear) vce(cluster geo)
matrix b = e(b)
matrix v = e(V)
gen variable = .    
gen d_coefficient = .    
gen d_se = .
forval i = 1/12{
	replace variable = `i'-1 if _n == `i'
	replace d_coefficient = b[1, `i'] if _n == `i'
	replace d_se = sqrt(v[`i', `i']) if _n == `i'
}
keep variable d_coefficient d_se
keep if _n <= 12
drop if variable == 0
replace variable = variable - 10
gen d_ub = d_coefficient + 1.96 * d_se
gen d_lb = d_coefficient - 1.96 * d_se
tempfile dresults
save `dresults'
restore

preserve
use `qresults', clear
merge 1:1 variable using `dresults', nogen keep(match)
sort variable
twoway (scatter d_coefficient variable, mcolor(green) msize(small) msymbol(diamond)) ///
	   (line d_coefficient variable, lcolor(green) lwidth(thin) lpattern(dash)) ///
       (rcap d_ub d_lb variable, lcolor(green) lwidth(thin)) ///
	   (scatter q_coefficient variable, mcolor(orange) msize(small) msymbol(circle)) ///
	   (line q_coefficient variable, lcolor(orange) lwidth(thin) lpattern(solid)) ///
       (rcap q_ub q_lb variable, lcolor(orange) lwidth(thin)), ///
       graphregion(color(white)) xsize(8) ysize(6) plotregion(lcolor(black) lwidth(thin)) ///
       ytitle(Effect on Full Employed Female Share) xtitle(Event Time(Year)) ///
       ylabel(, nogrid labsize(small)) xlabel(-7(1)1, labsize(small)) ///
	   legend(order(5 2) label(5 "Quota") label(2 "Disclosure")) ///
	   xline(-1, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
	   yline(0, lcolor(gs12) lpattern(dash) lwidth(thin))
	   
graph export "$DATA/figure_1b.pdf", as(pdf) replace
restore


preserve
keep if ftpt == "1"
keep if gender == 1
destring hwusual, replace
drop if hwusual == 0 | hwusual == 99
drop if Policy == "Disclosure"
reghdfe hwusual ib9.event_x_teat [aw = coeff], absorb(geo refyear) vce(cluster geo)
matrix b = e(b)
matrix v = e(V)
gen variable = .    
gen q_coefficient = .    
gen q_se = .
forval i = 1/15{
	replace variable = `i'+1 if _n == `i'
	replace q_coefficient = b[1, `i'] if _n == `i'
	replace q_se = sqrt(v[`i', `i']) if _n == `i'
}
keep variable q_coefficient q_se
keep if _n <= 15
drop if variable == 2
replace variable = variable - 10
gen q_ub = q_coefficient + 1.96 * q_se
gen q_lb = q_coefficient - 1.96 * q_se
tempfile qresults
save `qresults'
restore

preserve
keep if ftpt == "1"
keep if gender == 1
destring hwusual, replace
drop if hwusual == 0 | hwusual == 99
drop if Policy == "Quota"
reghdfe hwusual ib9.event_x_teat [aw = coeff], absorb(geo refyear) vce(cluster geo)
matrix b = e(b)
matrix v = e(V)
gen variable = .    
gen d_coefficient = .    
gen d_se = .
forval i = 1/12{
	replace variable = `i'-1 if _n == `i'
	replace d_coefficient = b[1, `i'] if _n == `i'
	replace d_se = sqrt(v[`i', `i']) if _n == `i'
}
keep variable d_coefficient d_se
keep if _n <= 12
drop if variable == 0
replace variable = variable - 10
gen d_ub = d_coefficient + 1.96 * d_se
gen d_lb = d_coefficient - 1.96 * d_se
tempfile dresults
save `dresults'
restore

preserve
use `qresults', clear
merge 1:1 variable using `dresults', nogen keep(match)
sort variable
twoway (scatter d_coefficient variable, mcolor(green) msize(small) msymbol(diamond)) ///
	   (line d_coefficient variable, lcolor(green) lwidth(thin) lpattern(dash)) ///
       (rcap d_ub d_lb variable, lcolor(green) lwidth(thin)) ///
	   (scatter q_coefficient variable, mcolor(orange) msize(small) msymbol(circle)) ///
	   (line q_coefficient variable, lcolor(orange) lwidth(thin) lpattern(solid)) ///
       (rcap q_ub q_lb variable, lcolor(orange) lwidth(thin)), ///
       graphregion(color(white)) xsize(8) ysize(6) plotregion(lcolor(black) lwidth(thin)) ///
       ytitle(Effect on Female Working Hours) xtitle(Event Time(Year)) ///
       ylabel(, nogrid labsize(small)) xlabel(-7(1)1, labsize(small)) ///
	   legend(order(5 2) label(5 "Quota") label(2 "Disclosure")) ///
	   xline(-1, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
	   yline(0, lcolor(gs12) lpattern(dash) lwidth(thin))
	   
graph export "$DATA/figure_2b.pdf", as(pdf) replace
restore
