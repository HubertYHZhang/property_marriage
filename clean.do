global rawpath "/Users/hubertcheung/Desktop/parental retirement and labor time/"
global outpath "/Users/hubertcheung/Desktop/The last dance/人口经济学论文/"

use "${rawpath}/cfps2010/cfps2010famecon_202008.dta",clear

*----------------------------------econ2010----------------------------------

local counter = 1
foreach i in fd101_s_1 fd101_s_2 fd101_s_3{
	clonevar regis_`counter' = `i'
	replace regis_`counter' = . if regis_`counter' <0
	local counter = `counter'+1
}

clonevar propertytype = fd1

clonevar propertytype_self = fd102

clonevar value_buy = fd106
replace value_buy = . if value_buy < 0 | value_buy >1000
*有那么几个超过千万的，比较离谱，暂时丢掉

clonevar value_build = fd104
replace value_build = . if value_build < 0 | value_build > 1000

generate value_past = .
*这个变量是房子的过去价值，等下再写

clonevar purchase_y = fd105
replace purchase_y = . if purchase_y < 0 

clonevar build_y = fd103
replace build_y = . if build_y < 0

clonevar square = fd2
replace square = . if square < 0

clonevar movein_y = fd3
replace movein_y = . if movein_y < 0

clonevar value_mkt = fd4
replace value_mkt = . if value_mkt < 0 | value_mkt > 10000
*筛选标准有待考虑，可以在分析的时候加对数

clonevar housetype = fd6

local varlist fid regis* propertytype* value* purchase_y square movein_y housetype

keep `varlist'

save "${outpath}/temp/econ_needed.dta",replace

*----------------------------------econ2010----------------------------------


*妈的这个2012数据有问题我不想用了
use "${rawpath}/cfps2010/cfps2010adult_202008.dta",clear

*----------------------------------ind2010----------------------------------

clonevar age = qa1age
replace age = . if age <0

clonevar marry_raw = qe1_best
gen marry = .
replace marry = 1 if marry_raw == 2
replace marry = 0 if marry_raw !=2 & marry_raw >0

clonevar marry_year = qe210y
replace marry_year = . if marry_year < 0

clonevar first_mar = qe2
replace first_mar = . if first_mar < 0

clonevar male = gender

clonevar edu = qc1
replace edu = . if edu < 0

*----------------------------------ind2010----------------------------------

merge m:1 fid using "${outpath}/temp/econ_needed.dta",keep(3) nogen


*----------------------------------econ2012----------------------------------
use "${rawpath}/cfps2012/cfps2012famecon_201906.dta",clear



local varlist fid12 fid10
keep `varlist'

*----------------------------------econ2012----------------------------------

*----------------------------------econ2014----------------------------------
use "${rawpath}/cfps2014/cfps2014famecon_201906.dta",clear

clonevar whethersame = fq1

clonevar propertytype = fq2

local counter = 1
foreach var in fq3pid_a_1 fq3pid_a_2 fq3pid_a_3 fq3pid_a_4 fq3pid_a_5 fq3pid_a_6 fq3pid_a_7 fq3pid_a_8{
	clonevar regis_`counter' = `var'
	replace regis_`counter' = . if regis_`counter' <0
	local counter = `counter'+1
}

clonevar purchasebuild_y = fq4
replace purchasebuild_y = . if purchasebuild_y < 0

clonevar value_past = fq5
replace value_past = . if value_past < 0

clonevar value_mkt = fq6
replace value_mkt = . if value_mkt < 0

