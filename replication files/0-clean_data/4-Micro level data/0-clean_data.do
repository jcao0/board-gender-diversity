****************************************************
*Staggered Synthetic Control*
*Import and prepare board gender data*
*Data: EIGE board female ratio*
*Last updated 02/03/2026*
****************************************************

/*
Source: EIGE https://ec.europa.eu/eurostat/web/microdata/public-microdata/labour-force-survey
Purpose: append all yearly micro data 
*/

// Macros ---------
global db   = "/0-data clean"
// ------------------

*year data
cd "$db/4-Micro level data"
!find . -type f > files.txt
import delimited using files.txt, clear
keep if regexm(lower(v1), "_y")
replace v1 = regexr(v1, "^\./", "")
!rm "$db/4-Micro level data/files.txt"

levelsof v1, local(v1)

foreach file of local v1 {
    import delimited using "$db/4-Micro level data/`file'", stringcols(_all) clear
	if "`file'" != "AT_PUF_LFS/AT_LFS_2004_Y.csv"{
		append using "$db/4-Micro level data/year_raw_data.dta"
	}
	save "$db/4-Micro level data/year_raw_data.dta", replace
}


