// Macros ---------
global results   = ""

import delimited "$results/Figure_3a/result.csv", clear
twoway (scatter coefficient event, mcolor(navy) msize(small)) ///
	   (line coefficient event, lcolor(navy) lwidth(thin)) ///
       (rcap ub lb event, lcolor(navy) lwidth(thin)), ///
       graphregion(color(white)) xsize(8) ysize(6) plotregion(lcolor(black) lwidth(thin)) ///
       ytitle(Effect on Female Share on Board) xtitle(Event Time(Year)) ///
       ylabel(, nogrid labsize(small)) xlabel(-5(1)5, labsize(small)) ///
	   legend(off) ///
	   xline(-0.5, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
	   yline(0, lcolor(gs12) lpattern(dash) lwidth(thin))
	   
graph export "$results/Figure_3a/figure_3a.pdf", as(pdf) replace


import delimited "$results/Figure_3b/result.csv", clear

twoway (scatter coefficient2 event, mcolor(green) msize(small) msymbol(diamond)) ///
	   (line coefficient2 event, lcolor(green) lwidth(thin) lpattern(dash)) ///
       (rcap ub2 lb2 event, lcolor(green) lwidth(thin)) ///
	   (scatter coefficient1 event, mcolor(orange) msize(small) msymbol(circle)) ///
	   (line coefficient1 event, lcolor(orange) lwidth(thin) lpattern(solid)) ///
       (rcap ub1 lb1 event, lcolor(orange) lwidth(thin)), ///
       graphregion(color(white)) xsize(8) ysize(6) plotregion(lcolor(black) lwidth(thin)) ///
       ytitle(Effect on Female Share on Board) xtitle(Event Time(Year)) ///
       ylabel(, nogrid labsize(small)) xlabel(-5(1)5, labsize(small)) ///
	   legend(order(5 2) label(5 "Quota") label(2 "Disclosure")) ///
	   xline(-0.5, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
	   yline(0, lcolor(gs12) lpattern(dash) lwidth(thin))	   
graph export "$results/Figure_3b/figure_3b.pdf", as(pdf) replace

import delimited "$results/Figure_4a/result.csv", clear

twoway (scatter coefficient2 event, mcolor(green) msize(small) msymbol(diamond)) ///
	   (line coefficient2 event, lcolor(green) lwidth(thin) lpattern(dash)) ///
       (rcap ub2 lb2 event, lcolor(green) lwidth(thin)) ///
	   (scatter coefficient1 event, mcolor(orange) msize(small) msymbol(circle)) ///
	   (line coefficient1 event, lcolor(orange) lwidth(thin) lpattern(solid)) ///
       (rcap ub1 lb1 event, lcolor(orange) lwidth(thin)), ///
       graphregion(color(white)) xsize(8) ysize(6) plotregion(lcolor(black) lwidth(thin)) ///
       ytitle(Effect on Full Employment Female Share) xtitle(Event Time(Quarter)) ///
       ylabel(, nogrid labsize(small)) xlabel(-20(1)20, labsize(tiny)) ///
	   legend(order(5 2) label(5 "Quota") label(2 "Disclosure")) ///
	   xline(-0.5, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
	   yline(0, lcolor(gs12) lpattern(dash) lwidth(thin))	   
graph export "$results/Figure_4a/figure_4a.pdf", as(pdf) replace


import delimited "$results/Figure_4b/result.csv", clear

twoway (scatter coefficient2 event, mcolor(green) msize(small) msymbol(diamond)) ///
	   (line coefficient2 event, lcolor(green) lwidth(thin) lpattern(dash)) ///
       (rcap ub2 lb2 event, lcolor(green) lwidth(thin)) ///
	   (scatter coefficient1 event, mcolor(orange) msize(small) msymbol(circle)) ///
	   (line coefficient1 event, lcolor(orange) lwidth(thin) lpattern(solid)) ///
       (rcap ub1 lb1 event, lcolor(orange) lwidth(thin)), ///
       graphregion(color(white)) xsize(8) ysize(6) plotregion(lcolor(black) lwidth(thin)) ///
       ytitle(Effect on Full Employment Female Share) xtitle(Event Time(Quarter)) ///
       ylabel(, nogrid labsize(small)) xlabel(-20(1)20, labsize(tiny)) ///
	   legend(order(5 2) label(5 "Quota") label(2 "Disclosure")) ///
	   xline(-0.5, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
	   yline(0, lcolor(gs12) lpattern(dash) lwidth(thin))	   
graph export "$results/Figure_4b/figure_4b.pdf", as(pdf) replace


import delimited "$results/Figure_5a/result.csv", clear

twoway (scatter coefficient2 event, mcolor(green) msize(small) msymbol(diamond)) ///
	   (line coefficient2 event, lcolor(green) lwidth(thin) lpattern(dash)) ///
       (rcap ub2 lb2 event, lcolor(green) lwidth(thin)) ///
	   (scatter coefficient1 event, mcolor(orange) msize(small) msymbol(circle)) ///
	   (line coefficient1 event, lcolor(orange) lwidth(thin) lpattern(solid)) ///
       (rcap ub1 lb1 event, lcolor(orange) lwidth(thin)), ///
       graphregion(color(white)) xsize(8) ysize(6) plotregion(lcolor(black) lwidth(thin)) ///
       ytitle(Effect on Female Working Hours) xtitle(Event Time(Quarter)) ///
       ylabel(-4(1)4, nogrid labsize(small)) xlabel(-11(1)11, labsize(small)) ///
	   legend(order(5 2) label(5 "Quota") label(2 "Disclosure")) ///
	   xline(-0.5, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
	   yline(0, lcolor(gs12) lpattern(dash) lwidth(thin))	   
graph export "$results/Figure_5a/figure_5a.pdf", as(pdf) replace


import delimited "$results/Figure_5b/result.csv", clear

twoway (scatter coefficient2 event, mcolor(green) msize(small) msymbol(diamond)) ///
	   (line coefficient2 event, lcolor(green) lwidth(thin) lpattern(dash)) ///
       (rcap ub2 lb2 event, lcolor(green) lwidth(thin)) ///
	   (scatter coefficient1 event, mcolor(orange) msize(small) msymbol(circle)) ///
	   (line coefficient1 event, lcolor(orange) lwidth(thin) lpattern(solid)) ///
       (rcap ub1 lb1 event, lcolor(orange) lwidth(thin)), ///
       graphregion(color(white)) xsize(8) ysize(6) plotregion(lcolor(black) lwidth(thin)) ///
       ytitle(Effect on Female Working Hours) xtitle(Event Time(Quarter)) ///
       ylabel(-4(1)4, nogrid labsize(small)) xlabel(-11(1)11, labsize(small)) ///
	   legend(order(5 2) label(5 "Quota") label(2 "Disclosure")) ///
	   xline(-0.5, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
	   yline(0, lcolor(gs12) lpattern(dash) lwidth(thin))	   
graph export "$results/Figure_5b/figure_5b.pdf", as(pdf) replace


import delimited "$results/Figure_3a/result.csv", clear
rename event event_time
tempfile main
save `main', replace

import delimited "$results/Figure_6/results_staggered_did.csv", clear
merge 1:1 event_time using `main', nogen keep(match)
sort event_time
twoway (scatter coefficient event_time, mcolor(green) msize(small) msymbol(diamond)) ///
	   (line coefficient event_time, lcolor(green) lwidth(thin) lpattern(dash)) ///
       (rcap ub lb event_time, lcolor(green) lwidth(thin)) ///
	   (scatter att event, mcolor(orange) msize(small) msymbol(circle)) ///
	   (line att event, lcolor(orange) lwidth(thin) lpattern(solid)) ///
       (rcap ci_upper ci_lower event, lcolor(orange) lwidth(thin)), ///
       graphregion(color(white)) xsize(8) ysize(6) plotregion(lcolor(black) lwidth(thin)) ///
       ytitle(Effect on Female Share on Board) xtitle(Event Time(Year)) ///
       ylabel(, nogrid labsize(small)) xlabel(-5(1)5, labsize(small)) ///
	   legend(order(5 2) label(5 "Staggered") label(2 "Synthetic")) ///
	   xline(-0.5, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
	   yline(0, lcolor(gs12) lpattern(dash) lwidth(thin))	   
graph export "$results/Figure_6/results_staggered_did.pdf", as(pdf) replace


import delimited "$results/Figure_3a/result.csv", clear
rename event event_time
tempfile main
save `main', replace

import delimited "$results/Figure_6/results_borusyak.csv", clear
drop v1
set obs `=_N+1'
replace event_time = -1 if missing(event_time)
replace att = 0 if event_time == -1
replace ci_upper = 0 if event_time == -1
replace ci_lower = 0 if event_time == -1
merge 1:1 event_time using `main', nogen keep(match)
sort event_time
twoway (scatter coefficient event_time, mcolor(green) msize(small) msymbol(diamond)) ///
	   (line coefficient event_time, lcolor(green) lwidth(thin) lpattern(dash)) ///
       (rcap ub lb event_time, lcolor(green) lwidth(thin)) ///
	   (scatter att event, mcolor(orange) msize(small) msymbol(circle)) ///
	   (line att event, lcolor(orange) lwidth(thin) lpattern(solid)) ///
       (rcap ci_upper ci_lower event, lcolor(orange) lwidth(thin)), ///
       graphregion(color(white)) xsize(8) ysize(6) plotregion(lcolor(black) lwidth(thin)) ///
       ytitle(Effect on Female Share on Board) xtitle(Event Time(Year)) ///
       ylabel(, nogrid labsize(small)) xlabel(-5(1)5, labsize(small)) ///
	   legend(order(5 2) label(5 "Borusyak") label(2 "Synthetic")) ///
	   xline(-0.5, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
	   yline(0, lcolor(gs12) lpattern(dash) lwidth(thin))	   
graph export "$results/Figure_6/results_borusyak.pdf", as(pdf) replace



import delimited "$results/Figure_7/result.csv", clear
twoway (scatter coefficient2 event, mcolor(green) msize(small) msymbol(diamond)) ///
	   (line coefficient2 event, lcolor(green) lwidth(thin) lpattern(dash)) ///
       (rcap ub2 lb2 event, lcolor(green) lwidth(thin)) ///
	   (scatter coefficient1 event, mcolor(orange) msize(small) msymbol(circle)) ///
	   (line coefficient1 event, lcolor(orange) lwidth(thin) lpattern(solid)) ///
       (rcap ub1 lb1 event, lcolor(orange) lwidth(thin)), ///
       graphregion(color(white)) xsize(8) ysize(6) plotregion(lcolor(black) lwidth(thin)) ///
       ytitle(Effect on Female Working Hours) xtitle(Event Time(Year)) ///
       ylabel(, nogrid labsize(small)) xlabel(-5(1)5, labsize(small)) ///
	   legend(order(5 2) label(5 "Closest Distance") label(2 "Further Distance")) ///
	   xline(-0.5, lcolor(gs12) lpattern(dash) lwidth(thin)) ///
	   yline(0, lcolor(gs12) lpattern(dash) lwidth(thin))	   
	   
graph export "$results/Figure_7/spillover.pdf", as(pdf) replace
