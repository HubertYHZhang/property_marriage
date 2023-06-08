

use "${rawpath}/cfps2010/cfps2010adult_202008.dta",clear

rename qe1_best marry2010
replace marry2010 = . if marry2010 < 0
keep pid marry2010

save "${outpath}/temp/marriage/2010marriage.dta",replace

use "${outpath}/temp/ind_2012.dta",clear

keep pid marry_raw marry_y
rename marry_raw marry_raw2012
rename marry_y marry_y2012

save "${outpath}/temp/marriage/2012marriage.dta",replace

use "${outpath}/temp/ind_2014.dta",clear

keep pid marry_raw marry_y
rename marry_raw marry_raw2014
rename marry_y marry_y2014

save "${outpath}/temp/marriage/2014marriage.dta",replace

use "${outpath}/temp/ind_2016.dta",clear

keep pid marry_raw marry_y
rename marry_raw marry_raw2016
rename marry_y marry_y2016

save "${outpath}/temp/marriage/2016marriage.dta",replace