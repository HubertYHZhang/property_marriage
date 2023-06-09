*----------------------------------comm2010----------------------------------

use "${rawpath}/cfps2010/cfps2010comm_201906.dta",clear

clonevar local_price = cf3
replace local_price = . if local_price < 0

clonevar local_price_highest = cf2
replace local_price_highest = . if local_price_highest < 0

keep cid local_price local_price_highest

save "${outpath}/temp/comm_2010.dta",replace

*----------------------------------comm2010----------------------------------

*----------------------------------econ2010----------------------------------
use "${rawpath}/cfps2010/cfps2010famecon_202008.dta",clear

local counter = 1
foreach i in fd101_s_1 fd101_s_2 fd101_s_3{
	clonevar regis_`counter' = `i'
	replace regis_`counter' = . if regis_`counter' <0 | regis_`counter' > 70
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

replace purchase_y = build_y if purchase_y == .

clonevar square = fd2
replace square = . if square < 0

clonevar movein_y = fd3
replace movein_y = . if movein_y < 0

clonevar value_mkt = fd4
replace value_mkt = . if value_mkt < 0 | value_mkt > 10000
*筛选标准有待考虑，可以在分析的时候加对数

clonevar housetype = fd6

clonevar otherprop = fd7

save "${outpath}/temp/econ_2010.dta",replace

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

clonevar marry_y = qe210y
replace marry_y = . if marry_y < 0

clonevar first_mar = qe2
replace first_mar = . if first_mar < 0

clonevar male = gender

rename income income1
clonevar income = income1
replace income = . if income < 0

clonevar edu_s = tb4_a_s
replace edu_s = . if edu_s < 0

gen edu_s_y = .
replace edu_s_y = 0 if edu_s == 1
replace edu_s_y = 6 if edu_s == 2
replace edu_s_y = 9 if edu_s == 3
replace edu_s_y = 12 if edu_s == 4
replace edu_s_y = 15 if edu_s == 5
replace edu_s_y = 16 if edu_s == 6
replace edu_s_y = 18 if edu_s == 7
replace edu_s_y = 21 if edu_s == 8

clonevar edu = qc1
replace edu = . if edu < 0

gen edu_y = .
replace edu_y = 0 if edu == 1
replace edu_y = 6 if edu == 2
replace edu_y = 9 if edu == 3
replace edu_y = 12 if edu == 4
replace edu_y = 15 if edu == 5
replace edu_y = 16 if edu == 6
replace edu_y = 18 if edu == 7
replace edu_y = 21 if edu == 8

clonevar spouse_id = code_a_s
replace spouse_id = . if spouse_id < 0
gen spouse_id_lastdigit = spouse_id - 100 if inrange(spouse_id,101,199)

clonevar spouse_pid = pid_s
replace spouse_pid = . if spouse_pid < 0

*----------------------------------ind2010----------------------------------

merge m:1 fid using "${outpath}/temp/econ_2010.dta",keep(3) nogen
merge m:1 cid using "${outpath}/temp/comm_2010.dta",keep(1 3) nogen

gen year = 2010

preserve
use "${rawpath}/cfps2010/cfps2010famconf_202008.dta",clear
keep pid code_a_f code_a_m
save "${outpath}/temp/famconf_2010.dta",replace
restore

keep pid-urban age-spouse_pid regis_1-otherprop year local_price_highest local_price

merge 1:1 pid using "${outpath}/temp/famconf_2010.dta",keep(3) nogen
gen f_id_lastdigit = mod(code_a_f,10) if inrange(code_a_f,100,199)
gen m_id_lastdigit = mod(code_a_m,10) if inrange(code_a_m,100,199)

gen selfown = .
gen spouseown = .
gen coown = .
gen otherown = .
gen spouselisted = .
gen exist = .
gen parentown = .
gen parentlisted = .
foreach i in regis_1 regis_2 regis_3{
	replace spouseown = 1 if `i' == spouse_id_lastdigit & `i' != .
	replace selfown = 1 if `i' == indno & `i' !=.
	replace coown = 1 if spouseown == 1 & selfown == 1 & `i' != .
	replace spouseown = . if coown == 1
	replace selfown = . if coown == 1
	replace spouselisted = 1 if spouseown ==1 | coown == 1 
	replace parentown = 1 if (`i' == f_id_lastdigit | `i' == m_id_lastdigit) & selfown == . & spouseown == . & coown == . & `i' != .
	replace parentlisted = 1 if (`i' == f_id_lastdigit | `i' == m_id_lastdigit) & `i' != .
    replace exist = 1 if `i' >0 & `i' != .
}
replace otherown = 1 if spouseown == . & selfown == . & coown == . & parentown ==. & exist == 1

foreach i in selfown spouseown coown otherown spouselisted parentown parentlisted{
	replace `i' = 0 if `i' == .
}

count if selfown == 0 & spouseown == 0 & coown == 0 

save "${outpath}/temp/ind&econ_2010.dta",replace