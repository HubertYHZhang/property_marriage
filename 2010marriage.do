global rawpath "/Users/hubertcheung/Desktop/parental retirement and labor time/"
global outpath "/Users/hubertcheung/Desktop/The last dance/人口经济学论文/"

use "${rawpath}/cfps2010/cfps2010adult_202008.dta",clear

rename qe1_best marry2010
replace marry2010 = . if marry2010 < 0
keep pid marry2010

save "${outpath}/temp/2010marriage.dta",replace