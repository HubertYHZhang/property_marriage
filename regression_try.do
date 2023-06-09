
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

mlogit owntype edu age income