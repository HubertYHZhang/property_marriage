

use "${rawpath}/cfps2010/cfps2010adult_202008.dta",clear

rename qe1_best marry2010
replace marry2010 = . if marry2010 < 0
keep pid marry2010

save "${outpath}/temp/marriage/2010marriage.dta",replace