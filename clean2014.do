
*----------------------------------comm2014----------------------------------
use "${rawpath}/cfps2014/cfps2014comm_201906.dta",clear

clonevar local_price_highest = cf2
replace local_price_highest = . if local_price_highest < 0

clonevar local_price = cf3
replace local_price = . if local_price < 0

keep cid14 local_price_highest local_price

save "${outpath}/temp/comm_2014.dta",replace

*----------------------------------comm2014----------------------------------

*----------------------------------econ2014----------------------------------
use "${rawpath}/cfps2014/cfps2014famecon_201906.dta",clear

clonevar propwhethersame = fq1

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
replace value_mkt = (fq6_max + fq6_min)/2 if fq6 < 0 & fq6_max > 0 & fq6_min > 0

*连面积都要参考上次……

clonevar square_new = fq801
replace square_new = . if square_new < 0

merge m:1 fid12 using "${outpath}/temp/housing/housing_2012.dta",keep(1 3) nogen

replace square = square_new if (((fq8 == 2 |fq8 == 3) & fq1 == 1) | fq1 == 0 | fq1 < 0) & square_new != .

clonevar otherprop = fr1
replace otherprop = . if otherprop < 0

clonevar othernumber = fr101
replace othernumber = . if othernumber < 0
replace othernumber = 0 if otherprop == 0

clonevar othervalue = fr2_best
replace othervalue = . if othervalue < 0
replace othervalue = (fr2_max + fr2_min)/2 if othervalue == . & fr2_max > 0 & fr2_min > 0

clonevar lease = fr5
replace lease = . if lease < 0
*是否应该把缺失当作0？

clonevar total_rent = fr501
replace total_rent = . if total_rent < 0
replace total_rent = 0 if lease == 0

save "${outpath}/temp/econ_2014.dta",replace
*----------------------------------econ2014----------------------------------

*----------------------------------ind2014----------------------------------
use "${rawpath}/cfps2014/cfps2014adult_201906.dta",clear

clonevar age = cfps2014_age
replace age = . if age < 0

clonevar marry_raw = qea0
gen marry = .
replace marry = 1 if marry_raw == 2
replace marry = 0 if marry_raw !=2 & marry_raw >0

*大部分人的婚姻时间都要参考上一次的调查

clonevar first_mar_new = qea2071
replace first_mar_new = . if first_mar_new < 0

merge 1:1 pid using "${outpath}/temp/marriage/2012marriage.dta",keep(1 3) nogen

gen marry_y = .
replace marry_y = qea205y if qea2 == 2 & qea205y > 0
replace marry_y = marry_y2012 if cfps2012_marriage == 2 & marry_y2012 > 0 & marry_y == .

clonevar male = cfps_gender

clonevar edu = cfps2014edu
replace edu = . if edu < 0

rename urban14 urban

save "${outpath}/temp/ind_2014.dta",replace

merge m:1 fid14 using "${outpath}/temp/econ_2014.dta",keep(3) nogen
merge m:1 cid14 using "${outpath}/temp/comm_2014.dta",keep(1 3) nogen

*----------------------------------HIGHLIGHT----------------------------------
keep pid-urban age-edu propwhethersame-total_rent code_a_s pid_s local_price_highest local_price

clonevar spouse_id = code_a_s
replace spouse_id = . if spouse_id < 0
gen spouse_id_lastdigit = spouse_id - 100 if inrange(spouse_id,100,199)

clonevar spouse_pid = pid_s
replace spouse_pid = . if spouse_pid < 0

/* gen indno = mod(pid, 1n000) */

gen selfown = .
gen spouseown = .
gen coown = .
gen otherown = .
gen spouselisted = .
gen exist = .
foreach i in regis_1 regis_2 regis_3 regis_4 regis_5 regis_6 regis_7 regis_8{
	replace spouseown = 1 if `i' == spouse_pid
	replace selfown = 1 if `i' == pid
	replace coown = 1 if spouseown == 1 & selfown == 1
	replace spouseown = . if coown == 1
	replace selfown = . if coown == 1
    replace spouselisted = 1 if spouseown == 1 | coown == 1
	replace exist = 1 if `i' >0 & `i' != .
}
replace otherown = 1 if spouseown == . & selfown == . & coown == . & exist == 1
foreach i in spouseown selfown coown otherown spouselisted{
    replace `i' = 0 if `i' == .
}

gen year = 2014

merge 1:1 pid using "${outpath}/temp/check2010.dta",keep(1 3) nogen
gen isin2010 = 1 if pid10 != .
replace isin2010 = 0 if pid10 == .

save "${outpath}/temp/ind&econ_2014.dta",replace