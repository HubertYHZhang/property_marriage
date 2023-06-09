
*To see behavioral differences between those who purchased houses before and after marriage.


*To compare people married in different years and their housing purchase. (To see what determines the change in housing registration)

*To see what kind of families will change their registration.
*To see only those who are married and self-own houses. We need a balanced panel.
use "${outpath}/data/ind&econ.dta",clear

keep if year <= 2012
keep if marry == 1
keep if selfown == 1 & year == 2010 | year == 2012

clonevar pid1 = pid
keep pid year pid1
reshape wide pid1, i(pid) j(year)

keep if pid12010!=. & pid12012!=.
keep pid

save "${outpath}/temp/10_12_selfown.dta",replace

use "${outpath}/data/ind&econ.dta",clear
keep if year <= 2012
merge m:1 pid using "${outpath}/temp/10_12_selfown.dta",keep(3) nogen
keep if year == 2012

mlogit owntype edu_y age lnincome edu_s_y lnhp marry_y purchase_y

*现在看看后面的每两年有没有类似的pattern
local year = 2010
use "${outpath}/data/ind&econ.dta",clear

keep if year == `year' | year == `year'+2
keep if marry == 1
keep if selfown == 1 & year == `year' | year == `year'

clonevar pid1 = pid
keep pid year pid1
reshape wide pid1, i(pid) j(year)

keep if pid1`year'!=. & pid1`year'!=.
keep pid

local j = `year'+2
save "${outpath}/temp/`year'_`j'_selfown.dta",replace

use "${outpath}/data/ind&econ.dta",clear
keep if inrange(year,`year',`year'+2)
merge m:1 pid using "${outpath}/temp/`year'_`j'_selfown.dta",keep(3) nogen
keep if year == `year'+2

mlogit owntype edu_y age lnincome edu_s_y marry_y purchase_y


*------------------------------spouselisted--------------------------------*
use "${outpath}/data/ind&econ.dta",clear

keep if marry == 1

gen post = 1 if year > 2011
replace post = 0 if year < 2011

reghdfe spouselisted c.post##c.lnhp edu_y edu_s_y lnincome,a(pid year)

outreg2 using "${outpath}/results/r2/r2.tex", tex(frag) replace keep(c.post#c.lnhp) bdec(3) sdec(3) addtext(Individual FE, Yes, Year FE, Yes)